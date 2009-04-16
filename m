Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZDPNwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZDPNwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZDPNwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:52:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43939 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZDPNwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:52:11 -0400
Date: Thu, 16 Apr 2009 09:52:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip
In-Reply-To: <20090416095135.GA18620@elte.hu>
Message-ID: <alpine.DEB.2.00.0904160950340.5262@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416095135.GA18620@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > Please pull the latest tip/tracing/core tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/tracing/core
> > 
> > 
> > Avadh Patel (1):
> >       tracing: add saved_cmdlines file to show cached task comms
> > 
> > Steven Rostedt (4):
> >       ftrace: use module notifier for function tracer
> >       tracing/events: add startup tests for events
> >       tracing/events: add rcu locking around trace event prints
> >       tracing/events/ring-buffer: expose format of ring buffer headers to users
> > 
> > ----
> >  include/linux/ftrace.h      |    7 --
> >  include/linux/module.h      |    4 +
> >  include/linux/ring_buffer.h |    5 +
> >  include/trace/ftrace.h      |    4 +
> >  kernel/module.c             |   19 ++---
> >  kernel/trace/ftrace.c       |   90 +++++++++++++-----
> >  kernel/trace/ring_buffer.c  |   44 +++++++++
> >  kernel/trace/trace.c        |   53 +++++++++++
> >  kernel/trace/trace_events.c |  214 +++++++++++++++++++++++++++++++++++++++++++
> >  9 files changed, 395 insertions(+), 45 deletions(-)
> 
> Pulled, thanks Steve!
> 
> I see one particular self-test failure - i've attached config and 
> dmesg snippet.
> 
> One thing becomes apparent from a quick glance at the dmesg: it's 
> not entirely obvious to see which event test failed. Here:
> 
>         sysname = kmalloc(4, GFP_KERNEL);
>         if (WARN_ON(!sysname)) {
>                 pr_warning("Can't allocate memory, giving up!\n");
>                 return 0;
>         }
>         memcpy(sysname, "*:*", 4);
>         ret = ftrace_set_clr_event(sysname, 1);
>         if (WARN_ON_ONCE(ret)) {
>                 kfree(sysname);
>                 pr_warning("error enabling all events\n");
>                 return 0;
>         }
> 
>         event_test_stuff();
> 
> we should probably print "sysname" in that failure path, right? 
> 
> This:
> 
> 	if (WARN_ONCE(KERN_CONT "%s: failed! ret: %d\n", sysname, ret)) {
> 		...
> 	}
> 
> would suffice, right?

The sysname is simply "*:*" to try to enable all calls. That was just me 
using the short cut to get it working, instead of enabling them all by 
hand.

I'm not sure showing "*:*" to the user would help in any way. There exists 
only one "all" case. We do print the system name for each system enable 
run though.

-- Steve
