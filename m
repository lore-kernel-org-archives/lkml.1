Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZCUUDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZCUUDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZCUUDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:03:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:51047 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZCUUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ve0289owfGZpN9LTI6lZlUem6xngeTlLqUnPTB2OgW5417cbyj1S+CSc5k3fx+31Wy
         fZpfmi1lzmM0l4YF7MuGuklgpaPAvim9vMOaPAtU1Qhl56Jj1i3+3+CLEHp1FXhA7YY9
         IJ27pU/k3PN716E2pY7Gqzwa4m+ZpaFrcaIAM=
Date: Sat, 21 Mar 2009 21:03:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090321200328.GD5956@nowhere>
References: <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <20090321173206.GB5956@nowhere> <alpine.DEB.2.00.0903211341460.13615@gandalf.stny.rr.com> <20090321175316.GC5956@nowhere> <alpine.DEB.2.00.0903211415290.13615@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903211415290.13615@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 02:17:23PM -0400, Steven Rostedt wrote:
> 
> 
> On Sat, 21 Mar 2009, Frederic Weisbecker wrote:
> 
> > On Sat, Mar 21, 2009 at 01:44:07PM -0400, Steven Rostedt wrote:
> > > 
> > > On Sat, 21 Mar 2009, Frederic Weisbecker wrote:
> > > > > Testing tracer sched_switch: PASSED
> > > > > initcall init_sched_switch_trace+0x0/0x12 returned 0 after 99609 usecs
> > > > > calling  init_stack_trace+0x0/0x12 @ 1
> > > > > Testing tracer sysprof: .. no entries found ..FAILED!
> > > > > initcall init_stack_trace+0x0/0x12 returned -1 after 101562 usecs
> > > > > initcall init_stack_trace+0x0/0x12 returned with error code -1 
> > > > > calling  init_function_trace+0x0/0x12 @ 1
> > > > > Testing tracer function: PASSED
> > > > > initcall init_function_trace+0x0/0x12 returned 0 after 104492 usecs
> > > > > calling  init_irqsoff_tracer+0x0/0x2c @ 1
> > > > > Testing tracer irqsoff: .. no entries found ..FAILED!
> > > > > Testing tracer preemptoff: .. no entries found ..FAILED!
> > > > > Testing tracer preemptirqsoff: .. no entries found ..FAILED!
> > > > 
> > > > 
> > > > It's strange that the {*}_off tracers have failed.
> > > 
> > > Does this have your changes in it?  The ones that solved this before.
> > 
> > 
> > You mean Lai's patch for RCU?
> > I haven't seen such tracers failures since it has been merged.
> > I don't think it's related.
> 
> No, I mean your patches for the selftest (tracing_stop).



Ah, yes they are on latest -tip.


 
> > 
> >  
> > > > 
> > > > 
> > > > > initcall init_irqsoff_tracer+0x0/0x2c returned 0 after 8789 usecs
> > > > > calling  init_wakeup_tracer+0x0/0x58 @ 1
> > > > > Testing tracer wakeup: .. no entries found ..FAILED!
> > > > 
> > > > 
> > > > This one too. (sysprof doesn't count, it fails for some weeks, I think
> > > > it's not a hard deal to fix).
> > > > 
> > > > 
> > > > > initcall init_wakeup_tracer+0x0/0x58 returned -1 after 298828 usecs
> > > > > initcall init_wakeup_tracer+0x0/0x58 returned with error code -1 
> > > > > calling  stack_trace_init+0x0/0xc7 @ 1
> > > > > initcall stack_trace_init+0x0/0xc7 returned 0 after 0 usecs
> > > > > calling  init_mmio_trace+0x0/0x12 @ 1
> > > > > initcall init_mmio_trace+0x0/0x12 returned 0 after 0 usecs
> > > > > calling  init_graph_trace+0x0/0x12 @ 1
> > > > > Testing tracer function_graph: <3>INFO: RCU detected CPU 0 stall (t=4294678940/10000 jiffies)
> > > > > Pid: 1, comm: swapper Not tainted 2.6.29-rc8-tip-02752-g47b1aea-dirty #3264
> > > > > Call Trace:
> > > > >  <IRQ>  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff80211150>] print_context_stack+0xa0/0xd3
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff8020fb26>] dump_trace+0x22d/0x2cc
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff80211008>] show_trace_log_lvl+0x51/0x5d
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff80211029>] show_trace+0x15/0x17
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff802111fa>] dump_stack+0x77/0x81
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff8029e6dd>] print_cpu_stall+0x40/0xa4
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff8029e8be>] check_cpu_stall+0x49/0x76
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff8029e902>] __rcu_pending+0x17/0xfc
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff8029ea13>] rcu_pending+0x2c/0x5e
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff8026abef>] update_process_times+0x3c/0x77
> > > > >  [<ffffffff8020c79d>] return_to_handler+0x0/0x73
> > > > >  [<ffffffff802875dd>] tick_periodic+0x6e/0x70
> > > > 
> > > > 
> > > > Still hanging in the timer interrupt.
> > > > I guess it makes the timer interrupt servicing too slow and then
> > > > once it is serviced, another one is raised.
> > > > 
> > > > But the cause is perhaps more complex
> > > > 
> > > > I think you have had too much hanging of this type.
> > > > I'm preparing a fix that checks periodically if the function graph
> > > > tracer is spending too much time in an interrupt.
> > > > 
> > > > I guess I could count the number of function executed between the irq entry
> > > > and its exit.
> > > > 
> > > > That's the best: if we are hanging in an interrupt, it could be whatever
> > > > interrupt and the jiffies could not be progressing so I can't rely
> > > > on time but only on number of functions executed.
> > > > 
> > > > May be 10000 calls is a good threshold before killing the function graph
> > > > inside an interrupt?
> > > > 
> > > > Let's try, I will also provide a way to dump the function graph traces from
> > > > the ring-buffer on the screen, it could help to debug it in this case.
> > > 
> > > I was thinking the same thing. All you need to do is add a "ftrace_dump()" 
> > > in the print_cpu_stall() function in kernel/rcuclassic.c.
> > 
> > 
> > Perhaps not relying on rcu cpu ctall detector, because it could perhaps
> > hang without it.
> > I think I should directly call ftrace_dump() from the tracer and not
> > rely on CONFIG that might not be enabled.
> 
> Have we seen the hang without it?


I don't know.

 
> And where would you call ftrace_dump? Note, once ftrace_dump is called,
> tracing is permantently disabled.


>From the tracer, ie: in  prepare_ftrace_return.
May be we have a helper like ftrace_dump() (and
which could rely on it) which doesn't disable tracing.

May be a simple parameter?


> -- Steve
> 
> > 
> > 
> > > You would need to add "#include <linux/ftrace.h>" too.
> > > 
> > > /me wonders if we should add ftrace_dump() to kernel.h to remove that 
> > > requirement?
> > > 
> > > -- Steve
> > > 
> > 
> > 

