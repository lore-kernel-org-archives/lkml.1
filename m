Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYGLKQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYGLKQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 06:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGLKQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 06:16:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:63320 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYGLKQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 06:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e5Z+49x6yzR/WHJthXBcp/YgwOvVDgW+ltWWADcgjRsGOVx6d+uI3IwIWoZ6U+iNuy
         EZgIxjwp/cohmLxViW+aHkA+XDItvXmONwOObTQ6EPPQlyA1qjSEfvnlkv6gznXtiAeG
         q+ts9XKPYmVtJGv7D7a3xoNq5VMNMGL3FrrPo=
Message-ID: <520f0cf10807120316n699fd6e1q6544b7bef82c6f37@mail.gmail.com>
Date: Sat, 12 Jul 2008 12:16:27 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Elias Oltmanns" <eo@nebensachen.de>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jon Masters" <jonathan@jonmasters.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20080711153740.b86acadd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
	 <87zlop7bp6.fsf@denkblock.local>
	 <20080710132832.38cc5048.randy.dunlap@oracle.com>
	 <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
	 <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
	 <20080711121655.05810822.akpm@linux-foundation.org>
	 <Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
	 <20080711153740.b86acadd.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 12:37 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 11 Jul 2008 16:59:53 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
>
> >
> > > > +
> > > > +  tracing_cpumask : This is a mask that lets the user only trace
> > > > +         on specified CPUS. The format is a hex string
> > > > +         representing the CPUS.
> > >
> > > Why is this feature useful?  (I'd have asked this prior to merging, if I'd
> > > known it existed!)
> >
> > I can't comment on this. I didn't write that code, I just added it to
> > the document because I saw it existed. This was added by Ingo and Thomas,
> > without much description to why. I think it allows you to limit which
> > CPUS to perform the trace on.
>
> Information such as "why this code exists" seems fairly important ;)
> It's surprising how often people forget to mention it (in comments, and
> changelogs).
>
> > >
> > > > +  preemptirqsoff - Similar to irqsoff and preemptoff, but traces and
> > > > +          records the largest time irqs and/or preemption is
> > > > +          disabled.
> > >
> > > s/time/time for which/
> > >
> > > This interface has a strange mix of wordsruntogether and
> > > words_separated_by_underscores.  Oh well - another consequence of
> > > post-facto changelogging.
> >
> > I should make sched_switch to schedswitch and that way we have the files
> > having underscores and the tracers without them. Or should I add
> > underscores to all of them?
>
> Adding underscores is better, but it might not be worth the churn now, dunno.
>
> > > > +
> > > > +Here's an example of the output format of the file "trace"
> > > > +
> > > > +                             --------
> > > > +# tracer: ftrace
> > > > +#
> > > > +#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> > > > +#              | |      |          |         |
> > > > +            bash-4251  [01] 10152.583854: path_put <-path_walk
> > > > +            bash-4251  [01] 10152.583855: dput <-path_put
> > > > +            bash-4251  [01] 10152.583855: _atomic_dec_and_lock <-dput
> > > > +                             --------
> > >
> > > pids are no longer unique system-wide, and any part of the kernel ABI which
> > > exports them to userspace is, basically, broken.  Oh well.
> >
> > What should be used instead?  Of course we're not using a kernel ABI, we
> > are using an API (text based ;-) But more on that later.
>
> Well that's an interesting question and it has come up before.  There
> are times when the kernel wants to display a process identifier at
> least in a printk.  Oopses are one prominent example.
>
> Perhaps we do need a way of doing this in a post-pid-namespace-world.
> Presumably it would be of the form "pidns-identifier:pid", and just
> plain old "pid" if no pid namespaces are in operation, for some
> back-compatibility where possible.
>
> Eric, any thoughts?
>
> > > > +# tracer: irqsoff
> > > > +#
> > > > +irqsoff latency trace v1.1.5 on 2.6.26-rc8
> > > > +--------------------------------------------------------------------
> > > > + latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> > > > +    -----------------
> > > > +    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
> > > > +    -----------------
> > > > + => started at: apic_timer_interrupt
> > > > + => ended at:   do_softirq
> > > > +
> > > > +#                _------=> CPU#
> > > > +#               / _-----=> irqs-off
> > > > +#              | / _----=> need-resched
> > > > +#              || / _---=> hardirq/softirq
> > > > +#              ||| / _--=> preempt-depth
> > > > +#              |||| /
> > > > +#              |||||     delay
> > > > +#  cmd     pid ||||| time  |   caller
> > > > +#     \   /    |||||   \   |   /
> > > > +  <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
> > > > +  <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
> > > > +  <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
> > >
> > > The kernel prints all that stuff out of a debugfs file?
> > >
> > > What have we done? :(
> >
> > This is very helpful on embedded systems.
>
> Well...  why?  embedded platforms can run userspace programs too.  But
> the ornate nature of this kernel->userspace interface has gone and made
> implementation of userspace parsers hard.
>
> > If you are suggesting that the kernel comes with its own user land app
> > (in scripts/ ?) to handle all the new tracers, then maybe it would be
> > OK.
>
> This also comes up again and again.  Kernel programmers have no
> convenient route for delivering userspace code to users, so they end up
> putting userspace functionality into the kernel.
>
> getdelays.c is a counter-example.  We've maintained that as new
> taskstats capabilities have come along and as it turned out, this was
> quite easy and people find geydelays.c to be quite useful.  Its name is
> outdated though.
>
> >
> > > > +first followed by the next task or task waking up. The format for both
> > > > +of these is PID:KERNEL-PRIO:TASK-STATE. Remember that the KERNEL-PRIO
> > > > +is the inverse of the actual priority with zero (0) being the highest
> > > > +priority and the nice values starting at 100 (nice -20). Below is
> > > > +a quick chart to map the kernel priority to user land priorities.
> > > > +
> > > > +  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
> > > > +  Kernel priority: 100 to 139 ==> user nice -20 to 19
> > > > +  Kernel priority: 140        ==> idle task priority
> > > > +
> > > > +The task states are:
> > > > +
> > > > + R - running : wants to run, may not actually be running
> > > > + S - sleep   : process is waiting to be woken up (handles signals)
> > > > + D - deep sleep : process must be woken up (ignores signals)
> > >
> > > "uninterruptible sleep", please.  no need to invent new (and hence
> > > unfamilar) terms!
> >
> > This is my own ignorance.  I didn't know the best way to say it. Why do
> > we use 'D' for "uninterruptible sleep"? I don't see a 'D' in there? But
> > "deep sleep" is more obvious. OK, I'll shut up and change it to
> > "uniterruptible sleep".
> >
>
> Heh.  Maybe "D" does indeed refer to "deep sleep".  That's all before
> my time.  But yes, "uninterruptible sleep" is the well-known term for
> this state.
----SNIP----
According to array.c in the kernel, 'D' stands for disk sleep

static const char *task_state_array[] = {
	"R (running)",		/*  0 */
	"M (running-mutex)",	/*  1 */
	"S (sleeping)",		/*  2 */
	"D (disk sleep)",	/*  4 */
	"T (stopped)",		/*  8 */
	"T (tracing stop)",	/* 16 */
	"Z (zombie)",		/* 32 */
	"X (dead)"		/* 64 */
};
