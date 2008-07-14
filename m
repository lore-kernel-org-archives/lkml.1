Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbYGNV0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbYGNV0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbYGNV0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:26:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55141 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbYGNV0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:26:06 -0400
Date: Mon, 14 Jul 2008 14:24:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] ftrace: document updates
Message-Id: <20080714142447.538d282d.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.58.0807141637460.30575@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807141637460.30575@gandalf.stny.rr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 16:41:12 -0400 (EDT) Steven Rostedt wrote:

a few more...

> The following updates were recommended by Elias Oltmanns and Randy Dunlap.
> 
> [ updates based on Andrew Morton's comments are still to come. ]
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  Documentation/ftrace.txt |  134 ++++++++++++++++++++++++-----------------------
>  1 file changed, 71 insertions(+), 63 deletions(-)
> 
> Index: linus.git/Documentation/ftrace.txt
> ===================================================================
> --- linus.git.orig/Documentation/ftrace.txt	2008-07-14 11:22:26.000000000 -0400
> +++ linus.git/Documentation/ftrace.txt	2008-07-14 16:07:13.000000000 -0400
> @@ -2,8 +2,11 @@
>  		========================
> 
>  Copyright 2008 Red Hat Inc.
> -Author: Steven Rostedt <srostedt@redhat.com>
> +   Author:   Steven Rostedt <srostedt@redhat.com>
> +  License:   The GNU Free Documentation License, Version 1.2
> +Reviewers:   Elias Oltmanns and Randy Dunlap
> 
> +Writen for: 2.6.26-rc8 linux-2.6-tip.git tip/tracing/ftrace branch
> 
>  Introduction
>  ------------
> @@ -297,13 +302,13 @@ explains which is which.
> 
>  The above is mostly meaningful for kernel developers.
> 
> -  time: This differs from the trace output where as the trace output
> -	contained a absolute timestamp. This timestamp is relative
> -	to the start of the first entry in the the trace.
> +  time: This differs from the trace file output. The trace file output
> +	included an absolute timestamp. The timestamp used by the

	includes

> +	latency_trace file is relative to the start of the trace.
> 
>    delay: This is just to help catch your eye a bit better. And
>  	needs to be fixed to be only relative to the same CPU.
> -	The marks is determined by the difference between this
> +	The marks are determined by the difference between this
>  	current trace and the next trace.
>  	 '!' - greater than preempt_mark_thresh (default 100)
>  	 '+' - greater than 1 microsecond
> @@ -570,21 +575,21 @@ vim:ft=help
> 
> 
>  preemptoff
>  ----------
> 
> -When preemption is disabled we may be able to receive interrupts but
> -the task can not be preempted and a higher priority task must wait
> +When preemption is disabled, we may be able to receive interrupts but
> +the task cannot be preempted and a higher priority task must wait
>  for preemption to be enabled again before it can preempt a lower
>  priority task.
> 
> -The preemptoff tracer traces the places that disables preemption.
> +The preemptoff tracer traces the places that disable preemption.
>  Like the irqsoff, it records the maximum latency that preemption

   Like the irqsoff tracer,

>  was disabled. The control of preemptoff is much like the irqsoff.
> 
> @@ -992,12 +997,15 @@ ksoftirq-7     1d..4   50us : schedule (
> 
>  The interrupt went off while running ksoftirqd. This task runs at
>  SCHED_OTHER. Why didn't we see the 'N' set early? This may be
> -a harmless bug with x86_32 and 4K stacks. The need_reched() function
> -that tests if we need to reschedule looks on the actual stack.
> -Where as the setting of the NEED_RESCHED bit happens on the
> -task's stack. But because we are in a hard interrupt, the test
> -is with the interrupts stack which has that to be false. We don't
> -see the 'N' until we switch back to the task's stack.
> +a harmless bug with x86_32 and 4K stacks. On x86_32 with 4K stacks
> +configured, the interrupt and softirq runs with their own stack.

                                         run

> +Some information is held on the top of the task's stack (need_resched
> +and preempt_count are both stored there). The setting of the NEED_RESCHED
> +bit is done directly to the task's stack, but the reading of the
> +NEED_RESCHED is done by looking at the current stack, which in this case
> +is the stack for the hard interrupt. This hides the fact that NEED_RESCHED
> +has been set. We don't see the 'N' until we switch back to the task's
> +assigned stack.
> 
>  ftrace
>  ------


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
