create database GoTraining

use [GoTraining]

create table Teacher(
	Teacher_Id varchar(5) primary key check(Teacher_Id like 'TE[0-9][0-9][0-9]'),
	First_Name varchar(25) not null,
	Last_Name varchar(25) not null,
	Languange1 varchar(25) not null,
	Languange2 varchar(25) not null,
	Dob date,
	PhoneNumber varchar(25) not null,
	Address varchar(25) not null,
	Email varchar(25) not null check(Email like '%@gmail.com')
	)

create table Client(
	Client_Id varchar(5) primary key check(Client_Id like 'CL[0-9][0-9][0-9]'),
	Company_Name varchar(25) not null,
	Com_Address varchar(25) not null,
	Com_TelpNumber varchar(25) not null,
	Industry varchar(25) not null
	)

create table Participant(
	Participant_Id varchar(5) primary key check(Participant_Id like 'PA[0-9][0-9][0-9]'),
	PFirst_Name varchar(25) not null,
	PLast_Name varchar(25) not null,
	Phone_Number varchar(25) not null,
	Participant_Email varchar(25) not null,
	Client_Id varchar(5) foreign key references Client(Client_Id) on update cascade on delete cascade
	)

create table Course(
	Course_Id varchar(5) primary key check (Course_Id like 'CO[0-9][0-9][0-9]'),
	Course_Name varchar(25) not null,
	Languange varchar(25) not null,
	Level varchar(5) not null,
	Course_length_hours varchar(25) not null,
	Course_length_weeks varchar(25) not null,
	Start_date date,
	End_date date,
	Location varchar(25) not null,
	Teacher_Id varchar(5) foreign key references Teacher(Teacher_Id) on update cascade on delete cascade,
	Client_Id varchar(5) foreign key references Client(Client_Id) on update cascade on delete cascade
	)

create table OnGoingCourse(
	primary key(Course_Id, Participant_Id),
	Course_Id varchar(5) foreign key references Course(Course_Id),
	Participant_Id varchar(5) foreign key references Participant(Participant_Id),
	Status varchar(25) not null
)


--1.
select p.PFirst_Name, p.PLast_Name, c.Course_Name, c.Level
from Participant p join OnGoingCourse ogc on p.Participant_Id = ogc.Participant_Id join Course c on ogc.Course_Id = c.Course_Id
where c.Course_Name like 'SQL Server' and c.Level like 'Advanced'

--2.
select t.First_Name, t.Last_Name, c.Course_Name
from Teacher t join Course c on t.Teacher_Id = c.Teacher_Id
where c.Course_Name in (
	select First_Name
	from Teacher t join Course c on t.Teacher_Id = c.Teacher_Id
	where c.Course_Name like 'Project Management dan Leadership'
)

--3.
create view [Active Participant and Courses During January 2022]
as
select p.PFirst_Name, p.PLast_Name, c.Course_Name
from Participant p join OnGoingCourse ogc on p.Participant_Id = ogc.Participant_Id join Course c on c.Course_Id = ogc.Course_Id
where ogc.Status like 'Active' and month(c.Start_date) like '1' and year(c.Start_date) like '2022'

--4.
create trigger [datarecorded]
on Participant
after insert
as
begin
print 'Data has been recorded'
end