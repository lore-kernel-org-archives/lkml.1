Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYGJUaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYGJUaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYGJUaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:30:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61018 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYGJUaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:30:01 -0400
Date: Thu, 10 Jul 2008 13:28:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] ftrace: Documentation
Message-Id: <20080710132832.38cc5048.randy.dunlap@oracle.com>
In-Reply-To: <87zlop7bp6.fsf@denkblock.local>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
	<87zlop7bp6.fsf@denkblock.local>
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

On Thu, 10 Jul 2008 21:59:01 +0200 Elias Oltmanns wrote:

> Steven Rostedt <rostedt@goodmis.org> wrote:
> > This is the long awaited ftrace.txt. It explains in quite detail how to
> > use ftrace and the various tracers.
> >
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> Exactly what I've just been looking for. Very nice.
> 
> As I read through this enlightening peace, I took the liberty to make
> some comments where I thought I'd spotted some mistake. Note that I'm
> not a native English speaker nor familiar with all the terminology.
> Also, I didn't exactly scratch my head when I had a bad feeling about
> something but couldn't come up with a better idea straight away.
> Basically, I just skimmed through the lines because im interested in the
> matter.
> 
> Anyway, here it goes:


[I'm dropping good comments, just making more comments.]

> > +  set_ftrace_notrace: This has the opposite effect that
> > +		set_ftrace_filter has. Any function that is added
> > +		here will not be traced. If a function exists
> > +		in both set_ftrace_filter and set_ftrace_notrace
> 
>                                                                 (comma)
> 
> > +		the function will _not_ bet traced.

		                        be

> > +  stacktrace - This is one of the options that changes the trace itself.
> 
>                                                   change

	                                            changes :)  [subject is "This", singular]

> 
> > +		When a trace is recorded, so is the stack of functions.
> > +		This allows for back traces of trace sites.
> > +
> > +sched_switch
> > +------------
> > +
> > +This tracer simply records schedule switches. Here's an example
> > +on how to implement it.

     of

> 
>              use?
> 
> [...]
> > +Here we traced a 50 microsecond latency. But we also see all the
> > +functions that were called during that time. Note that enabling
> 
>                                                           by enabling?
> 
> > +function tracing we endure an added overhead. This overhead may
> 
>                    (comma)
> 
> > +extend the latency times. But never the less, this trace has provided

                                   nevertheless,

> > +some very helpful debugging.
> 
>                      debugging information?
> 
> > +
> > +
> > +preemptoff
> > +----------
> > +
> > +When preemption is disabled we may be able to receive interrupts but
> 
>                               (comma)
> 
> > +the task can not be preempted and a higher priority task must wait

              cannot

> > +for preemption to be enabled again before it can preempt a lower
> > +priority task.
> > +
> > +The preemptoff tracer traces the places that disables preemption.
> 
>                                                 disable
> 
> > +Like the irqsoff, it records the maximum latency that preemption
> > +was disabled. The control of preemptoff is much like the irqsoff.


> > +Since this tracer only deals with RT tasks, we will run this slightly
> > +different than we did with the previous tracers. Instead of performing

     differently

> > +an 'ls' we will run 'sleep 1' under 'chrt' which changes the
> 
>           (comma)
> 
> > +priority of the task.

> [...]
> > +Where as the setting of the NEED_RESCHED bit happens on the

     Whereas

> > +task's stack. But because we are in a hard interrupt, the test

                 ^?  That's not a complete sentence.

> > +is with the interrupts stack which has that to be false. We don't

                 interrupt
> 
>                                           ^^^^
> Superfluous that? Don't understand that sentence.
> 
> > +see the 'N' until we switch back to the task's stack.
> [...]
> > +When dynamic ftrace is initialized, it calls kstop_machine to make it

                                                                        ^^ what is "it"?

> > +act like a uniprocessor so that it can freely modify code without
> > +worrying about other processors executing that same code.  At
> > +initialization, the mcount calls are change to call a "record_ip"
> 
>                                         changed
> 
> > +function.  After this, the first time a kernel function is called,
> > +it has the calling address saved in a hash table.
> [...]
> > +Two files that contain to the enabling and disabling of recorded
> > +functions are:
> 
> Can this be expressed somewhat differently?

  or drop "to".

> 
> > +
> > +  set_ftrace_filter
> > +
> > +and
> > +
> > +  set_ftrace_notrace
> > +
> > +A list of available functions that you can add to this files is listed
> 
>                                                      these
> 
> > +in:
> > +
> > +   available_filter_functions
> [...]
> > +Perhaps this isn't enough. The filters also allow simple wild cards.
> > +Only the following is currently available

     Only the following are currently available:

> > +
> > +  <match>*  - will match functions that begins with <match>
> 
>                                            begin
> 
> > +  *<match>  - will match functions that end with <match>
> > +  *<match>* - will match functions that have <match> in it


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
