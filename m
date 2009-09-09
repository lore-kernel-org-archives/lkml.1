Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZIIP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZIIP6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZIIP6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:58:17 -0400
Received: from fifo99.com ([67.223.236.141]:33707 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbZIIP6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:58:16 -0400
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
From: Daniel Walker <dwalker@fifo99.com>
To: rostedt@goodmis.org
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
In-Reply-To: <1252509551.27001.21.camel@gandalf.stny.rr.com>
References: <4AA70198.9070500@cn.fujitsu.com>  <4AA701B3.704@cn.fujitsu.com>
	 <1252459241.14793.40.camel@desktop>  <4AA70451.6050307@cn.fujitsu.com>
	 <1252472376.14793.85.camel@desktop>
	 <1252496788.27001.0.camel@gandalf.stny.rr.com>
	 <1252505528.14793.93.camel@desktop>
	 <1252509551.27001.21.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 08:58:41 -0700
Message-Id: <1252511921.14793.122.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 11:19 -0400, Steven Rostedt wrote:
> On Wed, 2009-09-09 at 07:12 -0700, Daniel Walker wrote:
> > On Wed, 2009-09-09 at 07:46 -0400, Steven Rostedt wrote:
> > > On Tue, 2009-09-08 at 21:59 -0700, Daniel Walker wrote:
> > > > On Wed, 2009-09-09 at 09:26 +0800, Li Zefan wrote:
> > > > > Daniel Walker wrote:
> > > > > > On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
> > > > > >> +       TP_STRUCT__entry(
> > > > > >> +               __string(       msg,    msg     )
> > > > > >> +       ),
> > > > > > 
> > > > > > Why the funny spacing here?
> > > > > > 
> > > > > 
> > > > > To make the code better-looking.
> > > > > 
> > > > > This is the coding-style we use for the code in
> > > > > include/trace/events/*.
> > > > 
> > > > It's part of Linux right? We already have a coding style ..
> > > 
> > > It's a special macro. What are you now, part of the style police?
> > 
> > I'm just like everyone else, someone who asks questions and makes
> > comments .. By using a different style than what the rest of Linux uses
> > your putting yourself at a disadvantage since you can't easily use
> > checkpatch on that code (even the stuff that is compliant) ..
> 
> I'm fine with questions, but yours sounded a bit more cynical

I'm never cynical (not on purpose anyway). I was just saying it like it
is .. 

> And here's that same code with normal Linux style:
> 
> TRACE_EVENT(sched_wait_task,
> 	TP_PROTO(struct rq *rq, struct task_struct *p),
> 	TP_ARGS(rq, p),
> 	TP_STRUCT__entry(__array(char, comm, TASK_COMM_LEN)
> 		__field(pid_t, pid)
> 		__field(int, prio)),
> 	TP_fast_assign(memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> 		__entry->pid	= p->pid;
> 		__entry->prio	= p->prio;
> 	),
> 	TP_printk("task %s:%d [%d]",
> 		  __entry->comm, __entry->pid, __entry->prio));


The below is checkpatch clean ..

TRACE_EVENT(sched_wait_task,

        TP_PROTO(struct rq *rq, struct task_struct *p),

        TP_ARGS(rq, p),

        TP_STRUCT__entry(
                __array(char,   comm,   TASK_COMM_LEN)
                __field(pid_t,  pid)
                __field(int,    prio)
        ),

        TP_fast_assign(
                memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
                __entry->pid    = p->pid;
                __entry->prio   = p->prio;
        ),

        TP_printk("task %s:%d [%d]",
                  __entry->comm, __entry->pid, __entry->prio)
);


That's not radically different from what you currently have .. You could
still align the fields with tabs. You just have to remove the
starting/ending tabs..

Daniel

