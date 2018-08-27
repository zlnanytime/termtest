/*1/////如果NIIT数据库不存在，则创建NIIT数据库，数据库的字符集为UTF-8；
如果数据库表stu不存在，则创建stu表，数据库引擎为innodb，表中字段信息为：
rollno 学号列 主键列 自动增长
stu_name 非空
gender 默认为M
tel 唯一
创建课程表course，表中字段信息如下所示：
course_id 主键
course_name

创建成绩表mark，表中字段信息如下所示：
mark_id
stu_id 外键
course_id 外键
score 

stu表中插入5位学生记录，course表中插入3门课程记录，mark表中每个同学至少插入两门成绩。


上午计划：
回顾知识点之前，结合老师开发经验，简单说一下公司工作时常用的数据库标识符命名规范，并在后面根据此规范进行回顾，练习。
table:STU_xxxx, TEA_XXXX, SCH_xxxxx
constraint:PK_TABLENAME_COLUMNNAME
FK_
CK_
DF_
VIEW :V_
PROCEDURE:PRO_
TRRIGER:TRG_


1、回顾数据库、表、约束、索引基础知识

2、学生做练习：
如果NIIT数据库不存在，则创建NIIT数据库，数据库的字符集为UTF-8；
如果数据库表stu不存在，则创建stu表，数据库引擎为innodb，表中字段信息为：
rollno 学号列 主键列 自动增长
stu_name 非空
gender 默认为M
tel 唯一

创建课程表course，表中字段信息如下所示：
course_id 主键
course_name

创建成绩表mark，表中字段信息如下所示：
mark_id
stu_id 外键
course_id 外键
score 

stu表中插入5位学生记录，course表中插入3门课程记录，mark表中每个同学至少插入两门成绩。

3、回顾用户账户知识点

4、学生练习：
创建用户账户，用户名niit，可以访问任何主机，密码为niit，具有对NIIT数据库的 操作权限

5、回顾数据查询，联接和子查询

下午计划：
6、学生做练习：
（1）查询有考试成绩的学生的学号，姓名和考试成绩
（2）查询所有学生所有课程的学号，姓名，课程，考试成绩，若没有考试成绩，则显示NULL值
（3）查询获得最高分的学生的学号，姓名
（4）查询每门课程最高分的学生信息

7、结合sqlserver讲解select语句各子句的执行顺序

8、回顾复合语句，存储例程，触发器

9、学生练习：
（1）创建一个存储过程，根据学生学号，显示学生平均成绩所对应的等级：85以上显示优秀，70分-80分，显示良好，60-70分显示一般，60分一下显示不及格；
调用此存储过程，查询一个学生的平均分等级。

（2）创建一个函数，根据课程编号，显示该课程的平均分；
调用此函数，获取一门课程的平均分

（3）创建一个触发器，删除stu表中记录时，如果该学生在mark表有成绩，则不允许删除，撤销删除操作，并提示需要先删除成绩再删除学生。
*/
create database if not exists NIIT default character set utf8;
use NIIT;
CREATE TABLE IF NOT EXISTS stu (
    rollno INT AUTO_INCREMENT PRIMARY KEY,
    stu_name VARCHAR(20) NOT NULL,
    gender VARCHAR(5) DEFAULT 'M',
    tel VARCHAR(11) UNIQUE
)  ENGINE=INNODB;

CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(20)
);
CREATE TABLE mark (
    mark_id INT PRIMARY KEY,
    stu_id INT,
    score INT,
    course_id INT,
    CONSTRAINT FK_stu_id FOREIGN KEY (stu_id)
        REFERENCES stu (rollno),
    CONSTRAINT FK_course_id FOREIGN KEY (course_id)
        REFERENCES course (course_id)
);

insert into stu (stu_name,gender,tel) values('Paul','M','11111111111');

insert into stu (stu_name,gender,tel) values('Jason','M','2222222222'),
('Jesse','M','3333333333'),
('Tony','M','4444444444'),
('Walker','M','55555555555');

insert into stu (stu_name,gender,tel) values ('zz','M','68686765768');

insert into course (course_id,course_name) values
('3','Eng'),
('4','PE');
SELECT 
    *
FROM
    course;


insert into mark values
('1','1','89','1'),
('2','1','20','2'),
('3','2','33','3'),
('4','2','55','4'),
('5','3','66','2'),
('6','3','77','1'),
('7','4','99','4'),
('8','4','34','3'),
('9','5','67','2'),
('10','5','32','1');
insert into mark (mark_id,stu_id,course_id) value('11','1','2');

grant select,insert,update,delete on NIIT.* to test1@localhost Identified by "abcdfe";


SELECT 
    *
FROM
    mark;
SELECT 
    *
FROM
    course;
SELECT 
    *
FROM
    mark
WHERE
    score IS NOT NULL;



SELECT 
    s.rollno, s.stu_name, c.course_name, m.score
FROM
    stu s
        LEFT JOIN
    mark m ON s.rollno = m.stu_id
        LEFT JOIN
    course c ON c.course_id = m.course_id;

SELECT 
    s.rollno, s.stu_name, MAX(m.score) AS score
FROM
    stu s
        JOIN
    mark m ON s.rollno = m.stu_id;


SELECT 
    s.rollno, c.course_name, s.stu_name, MAX(m.score) AS score
FROM
    stu s
        LEFT JOIN
    mark m ON s.rollno = m.stu_id
        LEFT JOIN
    course c ON c.course_id = m.course_id
GROUP BY c.course_name;

SELECT 
    s.rollno, s.stu_name, c.course_name, m.score
FROM
    stu s
        LEFT JOIN
    mark m ON s.rollno = m.stu_id
        LEFT JOIN
    course c ON c.course_id = m.course_id;


SELECT 
    s.stu_name, s.gender, s.tel, m.score
FROM
    stu s,
    mark m,
    (SELECT 
        MAX(m.score) AS score, m.course_id
    FROM
        mark m
    LEFT JOIN stu s ON m.stu_id = s.rollno
    GROUP BY m.course_id) t
WHERE
    s.rollno = m.stu_id
        AND m.course_id = t.course_id
        AND t.score = m.score;





delimiter //
create procedure average1(IN id int)
begin
	declare avg float;
    declare level varchar(20);
	select sum(score)/2 into avg from mark where stu_id = id;
	if avg between 0 and 60 then
		set level = '不及格';
    else if avg between 61 and 70 then
		set level = '一般';
    else if avg between 71 and 80 then
		set level = '良好';
	else 
		set level = '优秀';
    end if;
    end if;
    end if;
    select level as '等级';
end
// 
delimiter ;
drop procedure average1;
call average1(3);

delimiter //
create procedure course_avg(IN id int)
begin
 declare c_count int;
 declare c_avg float;
 select count(stu_id) into C_count from mark where course_id = id;
 select sum(score)/c_count into c_avg from mark where course_id = id;
 select c_avg as '平均分';
end
//
delimiter ;
call course_avg(2);





/* 最后一个问题不会做。。。。。*/

delimiter //
 create trigger before_delete before delete on stu for each row
 begin
	insert into stu (stu_name,gender,tel) values(old.stu_name,old.gender,old.tel);
 end;
//
delimiter ;




go
delimiter //
 create trigger before_delete_pre before delete on stu for each row PRECEDES before_delete
 begin
	declare d_count int;
	SELECT 
    COUNT(score)
INTO d_count FROM
    mark
WHERE
    stu_id = old.stu_id;
    if d_count=0 then
	signal sqlstate '45000'
    set message_text = '禁止删除数据';
    else
    delete from stu where rollno = mark.stu_id;
    end if;
 end;
//
delimiter ;










