Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYAVF0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYAVF0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYAVF0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:26:08 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:20570 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751072AbYAVF0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:26:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=QcUWERSwiAkltzg0+purr/Qq2wJEEvZqWTXi7O0eXEGCGOFDQmFY1RkN5n98cyLnuz6mxr3wcjJC44ezY7oOft+RNYU/qyqnCjne5VMCNtIQ4ZwAOKjUJbtVkCVEptPWHSfYHXB5NGbIs68zyUI2/1fyrWgg+WwwUu1DoaZiDwc=  ;
X-YMail-OSG: AC8P6swVM1l0Dy9Lj0DmNxs0T5gEsjzD4frH0G9D.zIM5jX9DG1bipnLnwvwnf3DdKgTVfvZEQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Date: Tue, 22 Jan 2008 16:25:58 +1100
User-Agent: KMail/1.9.5
Cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
References: <1200949086.6648.19.camel@Anastacia> <200801221105.11413.nickpiggin@yahoo.com.au> <1200978207.3944.8.camel@homer.simson.net>
In-Reply-To: <1200978207.3944.8.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_m5XlHBQWgOZ5zXF"
Message-Id: <200801221625.58615.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_m5XlHBQWgOZ5zXF
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 22 January 2008 16:03, Mike Galbraith wrote:
> On Tue, 2008-01-22 at 11:05 +1100, Nick Piggin wrote:
> > On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> > > With Linux 2.6.24-rc8 I often have the problem that the pan usenet
> > > reader starts using 100% of CPU time after some time. When this
> > > happens, kill -9 does not work, and strace just hangs when trying to
> > > attach to the process. The same with gdb. =EF=BB=BFps shows the proce=
ss as
> > > being in the R state.
> > >
> > > I pressed Ctrl-Alt-SysRq-T, and this was shown for pan:
> > > Jan 21 21:45:01 Anastacia kernel: pan           R  running task      =
=20
> > > 0
> >
> > Well I've twice tried to submit a patch to print stacks for running
> > tasks as well, but nobody seems interested. It would at least give a
> > chance to see something.
>
> I've hit same twice recently (not pan, and not repeatable).

Nasty. The attached patch is something really simple that can sometimes hel=
p.
sysrq+p is also an option, if you're on a UP system.

Any luck getting traces?


--Boundary-00=_m5XlHBQWgOZ5zXF
Content-Type: text/x-diff;
  charset="utf-8";
  name="show-task-running-stack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="show-task-running-stack.patch"

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4920,8 +4920,7 @@ static void show_task(struct task_struct
 	printk(KERN_CONT "%5lu %5d %6d\n", free,
 		task_pid_nr(p), task_pid_nr(p->real_parent));
 
-	if (state != TASK_RUNNING)
-		show_stack(p, NULL);
+	show_stack(p, NULL);
 }
 
 void show_state_filter(unsigned long state_filter)

--Boundary-00=_m5XlHBQWgOZ5zXF--
