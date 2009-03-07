Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZCGPeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZCGPeq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 10:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZCGPeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 10:34:37 -0500
Received: from mail-ew0-f164.google.com ([209.85.219.164]:52526 "EHLO
	mail-ew0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZCGPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 10:34:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vKVzNM7xEMTkxW8qkWAN0jgaBoOzNbqvxzkyESkhS/DRWdu87oNJjOGUhaymXLM30B
         pttJGmuchey/xFXM8y9PJt6ZKBwttu3HaFDZJWmL5Klmtx5l+JbBysG7eyzdR9CUuMsd
         my0vIjF29jjJdUatK1N18x5GziP3cpXqiSXoo=
Date: Sat, 7 Mar 2009 16:34:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for tip] ftrace: remove latency_trace document
Message-ID: <20090307153427.GA6075@nowhere>
References: <20090307235209.5A84.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307235209.5A84.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 11:53:40PM +0900, KOSAKI Motohiro wrote:
> Subject: [PATCH] remove latency_trace document
> 
> Currently, there aren't "Latency tracer" and latency_trace file.
> Then, its documentation is removed too.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---


Hi,

The latency_trace file has been removed but the latency tracing stil exists.
It has become an option instead of a file now:

echo latency-format > /debugfs/tracing/trace_options

There are even some tracers that default enable it (irqsoff, preemptoff...)
IMO, the documentation about latency tracing shouldn't be removed but
just updated a bit to reflect this change.

Frederic.


>  Documentation/ftrace.txt |  550 +--------------------------------------------
>  1 files changed, 13 insertions(+), 537 deletions(-)
> 
> diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
> index 22614be..d124e6a 100644
> --- a/Documentation/ftrace.txt
> +++ b/Documentation/ftrace.txt
> @@ -29,7 +29,7 @@ means that the list of tracers can always grow).
>  
>  The File System
>  ---------------
> -
> +1
>  Ftrace uses the debugfs file system to hold the control files as
>  well as the files to display output.
>  
> @@ -73,26 +73,19 @@ of ftrace. Here is a list of some of the key files:
>  	This file holds the output of the trace in a human
>  	readable format (described below).
>  
> -  latency_trace:
> -
> -	This file shows the same trace but the information
> -	is organized more to display possible latencies
> -	in the system (described below).
> -
>    trace_pipe:
>  
>  	The output is the same as the "trace" file but this
>  	file is meant to be streamed with live tracing.
>  	Reads from this file will block until new data
> -	is retrieved. Unlike the "trace" and "latency_trace"
> -	files, this file is a consumer. This means reading
> -	from this file causes sequential reads to display
> -	more current data. Once data is read from this
> -	file, it is consumed, and will not be read
> -	again with a sequential read. The "trace" and
> -	"latency_trace" files are static, and if the
> -	tracer is not adding more data, they will display
> -	the same information every time they are read.
> +	is retrieved. Unlike the "trace" file, this file
> +	is a consumer. This means reading from this file 
> +	causes sequential reads to display more current data. 
> +	Once data is read from this file, it is consumed, 
> +	and will not be read again with a sequential read. 
> +	The "trace" files is static, and if the tracer is not 
> +	adding more data, they will display the same information 
> +	every time they are read.
>  
>    trace_options:
>  
> @@ -105,10 +98,10 @@ of ftrace. Here is a list of some of the key files:
>  	Some of the tracers record the max latency.
>  	For example, the time interrupts are disabled.
>  	This time is saved in this file. The max trace
> -	will also be stored, and displayed by either
> -	"trace" or "latency_trace".  A new max trace will
> -	only be recorded if the latency is greater than
> -	the value in this file. (in microseconds)
> +	will also be stored, and displayed by "trace".
> +	A new max trace will only be recorded if the 
> +	latency is greater than the value in this file. 
> +	(in microseconds)
>  
>    buffer_size_kb:
>  
> @@ -192,25 +185,6 @@ Here is the list of current tracers that may be configured.
>  
>  	Traces the context switches and wakeups between tasks.
>  
> -  "irqsoff"
> -
> -	Traces the areas that disable interrupts and saves
> -	the trace with the longest max latency.
> -	See tracing_max_latency. When a new max is recorded,
> -	it replaces the old trace. It is best to view this
> -	trace via the latency_trace file.
> -
> -  "preemptoff"
> -
> -	Similar to irqsoff but traces and records the amount of
> -	time for which preemption is disabled.
> -
> -  "preemptirqsoff"
> -
> -	Similar to irqsoff and preemptoff, but traces and
> -	records the largest time for which irqs and/or preemption
> -	is disabled.
> -
>    "wakeup"
>  
>  	Traces and records the max latency that it takes for
> @@ -292,97 +266,6 @@ nice 19. The prio "140" is reserved for the idle task which is
>  the lowest priority thread (pid 0).
>  
>  
> -Latency trace format
> ---------------------
> -
> -For traces that display latency times, the latency_trace file
> -gives somewhat more information to see why a latency happened.
> -Here is a typical trace.
> -
> -# tracer: irqsoff
> -#
> -irqsoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: apic_timer_interrupt
> - => ended at:   do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -  <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
> -  <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
> -  <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
> -
> -
> -This shows that the current tracer is "irqsoff" tracing the time
> -for which interrupts were disabled. It gives the trace version
> -and the version of the kernel upon which this was executed on
> -(2.6.26-rc8). Then it displays the max latency in microsecs (97
> -us). The number of trace entries displayed and the total number
> -recorded (both are three: #3/3). The type of preemption that was
> -used (PREEMPT). VP, KP, SP, and HP are always zero and are
> -reserved for later use. #P is the number of online CPUS (#P:2).
> -
> -The task is the process that was running when the latency
> -occurred. (swapper pid: 0).
> -
> -The start and stop (the functions in which the interrupts were
> -disabled and enabled respectively) that caused the latencies:
> -
> -  apic_timer_interrupt is where the interrupts were disabled.
> -  do_softirq is where they were enabled again.
> -
> -The next lines after the header are the trace itself. The header
> -explains which is which.
> -
> -  cmd: The name of the process in the trace.
> -
> -  pid: The PID of that process.
> -
> -  CPU#: The CPU which the process was running on.
> -
> -  irqs-off: 'd' interrupts are disabled. '.' otherwise.
> -	    Note: If the architecture does not support a way to
> -		  read the irq flags variable, an 'X' will always
> -		  be printed here.
> -
> -  need-resched: 'N' task need_resched is set, '.' otherwise.
> -
> -  hardirq/softirq:
> -	'H' - hard irq occurred inside a softirq.
> -	'h' - hard irq is running
> -	's' - soft irq is running
> -	'.' - normal context.
> -
> -  preempt-depth: The level of preempt_disabled
> -
> -The above is mostly meaningful for kernel developers.
> -
> -  time: This differs from the trace file output. The trace file output
> -	includes an absolute timestamp. The timestamp used by the
> -	latency_trace file is relative to the start of the trace.
> -
> -  delay: This is just to help catch your eye a bit better. And
> -	 needs to be fixed to be only relative to the same CPU.
> -	 The marks are determined by the difference between this
> -	 current trace and the next trace.
> -	  '!' - greater than preempt_mark_thresh (default 100)
> -	  '+' - greater than 1 microsecond
> -	  ' ' - less than or equal to 1 microsecond.
> -
> -  The rest is the same as the 'trace' file.
> -
> -
>  trace_options
>  -------------
>  
> @@ -556,413 +439,6 @@ functions that are within the trace. The descriptions of the
>  tracers will also show an example with ftrace enabled.
>  
>  
> -irqsoff
> --------
> -
> -When interrupts are disabled, the CPU can not react to any other
> -external event (besides NMIs and SMIs). This prevents the timer
> -interrupt from triggering or the mouse interrupt from letting
> -the kernel know of a new mouse event. The result is a latency
> -with the reaction time.
> -
> -The irqsoff tracer tracks the time for which interrupts are
> -disabled. When a new maximum latency is hit, the tracer saves
> -the trace leading up to that latency point so that every time a
> -new maximum is reached, the old saved trace is discarded and the
> -new trace is saved.
> -
> -To reset the maximum, echo 0 into tracing_max_latency. Here is
> -an example:
> -
> - # echo irqsoff > /debug/tracing/current_tracer
> - # echo 0 > /debug/tracing/tracing_max_latency
> - # echo 1 > /debug/tracing/tracing_enabled
> - # ls -ltr
> - [...]
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/latency_trace
> -# tracer: irqsoff
> -#
> -irqsoff latency trace v1.1.5 on 2.6.26
> ---------------------------------------------------------------------
> - latency: 12 us, #3/3, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: bash-3730 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: sys_setpgid
> - => ended at:   sys_setpgid
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -    bash-3730  1d...    0us : _write_lock_irq (sys_setpgid)
> -    bash-3730  1d..1    1us+: _write_unlock_irq (sys_setpgid)
> -    bash-3730  1d..2   14us : trace_hardirqs_on (sys_setpgid)
> -
> -
> -Here we see that that we had a latency of 12 microsecs (which is
> -very good). The _write_lock_irq in sys_setpgid disabled
> -interrupts. The difference between the 12 and the displayed
> -timestamp 14us occurred because the clock was incremented
> -between the time of recording the max latency and the time of
> -recording the function that had that latency.
> -
> -Note the above example had ftrace_enabled not set. If we set the
> -ftrace_enabled, we get a much larger output:
> -
> -# tracer: irqsoff
> -#
> -irqsoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 50 us, #101/101, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: ls-4339 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: __alloc_pages_internal
> - => ended at:   __alloc_pages_internal
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -      ls-4339  0...1    0us+: get_page_from_freelist (__alloc_pages_internal)
> -      ls-4339  0d..1    3us : rmqueue_bulk (get_page_from_freelist)
> -      ls-4339  0d..1    3us : _spin_lock (rmqueue_bulk)
> -      ls-4339  0d..1    4us : add_preempt_count (_spin_lock)
> -      ls-4339  0d..2    4us : __rmqueue (rmqueue_bulk)
> -      ls-4339  0d..2    5us : __rmqueue_smallest (__rmqueue)
> -      ls-4339  0d..2    5us : __mod_zone_page_state (__rmqueue_smallest)
> -      ls-4339  0d..2    6us : __rmqueue (rmqueue_bulk)
> -      ls-4339  0d..2    6us : __rmqueue_smallest (__rmqueue)
> -      ls-4339  0d..2    7us : __mod_zone_page_state (__rmqueue_smallest)
> -      ls-4339  0d..2    7us : __rmqueue (rmqueue_bulk)
> -      ls-4339  0d..2    8us : __rmqueue_smallest (__rmqueue)
> -[...]
> -      ls-4339  0d..2   46us : __rmqueue_smallest (__rmqueue)
> -      ls-4339  0d..2   47us : __mod_zone_page_state (__rmqueue_smallest)
> -      ls-4339  0d..2   47us : __rmqueue (rmqueue_bulk)
> -      ls-4339  0d..2   48us : __rmqueue_smallest (__rmqueue)
> -      ls-4339  0d..2   48us : __mod_zone_page_state (__rmqueue_smallest)
> -      ls-4339  0d..2   49us : _spin_unlock (rmqueue_bulk)
> -      ls-4339  0d..2   49us : sub_preempt_count (_spin_unlock)
> -      ls-4339  0d..1   50us : get_page_from_freelist (__alloc_pages_internal)
> -      ls-4339  0d..2   51us : trace_hardirqs_on (__alloc_pages_internal)
> -
> -
> -
> -Here we traced a 50 microsecond latency. But we also see all the
> -functions that were called during that time. Note that by
> -enabling function tracing, we incur an added overhead. This
> -overhead may extend the latency times. But nevertheless, this
> -trace has provided some very helpful debugging information.
> -
> -
> -preemptoff
> -----------
> -
> -When preemption is disabled, we may be able to receive
> -interrupts but the task cannot be preempted and a higher
> -priority task must wait for preemption to be enabled again
> -before it can preempt a lower priority task.
> -
> -The preemptoff tracer traces the places that disable preemption.
> -Like the irqsoff tracer, it records the maximum latency for
> -which preemption was disabled. The control of preemptoff tracer
> -is much like the irqsoff tracer.
> -
> - # echo preemptoff > /debug/tracing/current_tracer
> - # echo 0 > /debug/tracing/tracing_max_latency
> - # echo 1 > /debug/tracing/tracing_enabled
> - # ls -ltr
> - [...]
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/latency_trace
> -# tracer: preemptoff
> -#
> -preemptoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 29 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: do_IRQ
> - => ended at:   __do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -    sshd-4261  0d.h.    0us+: irq_enter (do_IRQ)
> -    sshd-4261  0d.s.   29us : _local_bh_enable (__do_softirq)
> -    sshd-4261  0d.s1   30us : trace_preempt_on (__do_softirq)
> -
> -
> -This has some more changes. Preemption was disabled when an
> -interrupt came in (notice the 'h'), and was enabled while doing
> -a softirq. (notice the 's'). But we also see that interrupts
> -have been disabled when entering the preempt off section and
> -leaving it (the 'd'). We do not know if interrupts were enabled
> -in the mean time.
> -
> -# tracer: preemptoff
> -#
> -preemptoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 63 us, #87/87, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: remove_wait_queue
> - => ended at:   __do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -    sshd-4261  0d..1    0us : _spin_lock_irqsave (remove_wait_queue)
> -    sshd-4261  0d..1    1us : _spin_unlock_irqrestore (remove_wait_queue)
> -    sshd-4261  0d..1    2us : do_IRQ (common_interrupt)
> -    sshd-4261  0d..1    2us : irq_enter (do_IRQ)
> -    sshd-4261  0d..1    2us : idle_cpu (irq_enter)
> -    sshd-4261  0d..1    3us : add_preempt_count (irq_enter)
> -    sshd-4261  0d.h1    3us : idle_cpu (irq_enter)
> -    sshd-4261  0d.h.    4us : handle_fasteoi_irq (do_IRQ)
> -[...]
> -    sshd-4261  0d.h.   12us : add_preempt_count (_spin_lock)
> -    sshd-4261  0d.h1   12us : ack_ioapic_quirk_irq (handle_fasteoi_irq)
> -    sshd-4261  0d.h1   13us : move_native_irq (ack_ioapic_quirk_irq)
> -    sshd-4261  0d.h1   13us : _spin_unlock (handle_fasteoi_irq)
> -    sshd-4261  0d.h1   14us : sub_preempt_count (_spin_unlock)
> -    sshd-4261  0d.h1   14us : irq_exit (do_IRQ)
> -    sshd-4261  0d.h1   15us : sub_preempt_count (irq_exit)
> -    sshd-4261  0d..2   15us : do_softirq (irq_exit)
> -    sshd-4261  0d...   15us : __do_softirq (do_softirq)
> -    sshd-4261  0d...   16us : __local_bh_disable (__do_softirq)
> -    sshd-4261  0d...   16us+: add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s4   20us : add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s4   21us : sub_preempt_count (local_bh_enable)
> -    sshd-4261  0d.s5   21us : sub_preempt_count (local_bh_enable)
> -[...]
> -    sshd-4261  0d.s6   41us : add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s6   42us : sub_preempt_count (local_bh_enable)
> -    sshd-4261  0d.s7   42us : sub_preempt_count (local_bh_enable)
> -    sshd-4261  0d.s5   43us : add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s5   43us : sub_preempt_count (local_bh_enable_ip)
> -    sshd-4261  0d.s6   44us : sub_preempt_count (local_bh_enable_ip)
> -    sshd-4261  0d.s5   44us : add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s5   45us : sub_preempt_count (local_bh_enable)
> -[...]
> -    sshd-4261  0d.s.   63us : _local_bh_enable (__do_softirq)
> -    sshd-4261  0d.s1   64us : trace_preempt_on (__do_softirq)
> -
> -
> -The above is an example of the preemptoff trace with
> -ftrace_enabled set. Here we see that interrupts were disabled
> -the entire time. The irq_enter code lets us know that we entered
> -an interrupt 'h'. Before that, the functions being traced still
> -show that it is not in an interrupt, but we can see from the
> -functions themselves that this is not the case.
> -
> -Notice that __do_softirq when called does not have a
> -preempt_count. It may seem that we missed a preempt enabling.
> -What really happened is that the preempt count is held on the
> -thread's stack and we switched to the softirq stack (4K stacks
> -in effect). The code does not copy the preempt count, but
> -because interrupts are disabled, we do not need to worry about
> -it. Having a tracer like this is good for letting people know
> -what really happens inside the kernel.
> -
> -
> -preemptirqsoff
> ---------------
> -
> -Knowing the locations that have interrupts disabled or
> -preemption disabled for the longest times is helpful. But
> -sometimes we would like to know when either preemption and/or
> -interrupts are disabled.
> -
> -Consider the following code:
> -
> -    local_irq_disable();
> -    call_function_with_irqs_off();
> -    preempt_disable();
> -    call_function_with_irqs_and_preemption_off();
> -    local_irq_enable();
> -    call_function_with_preemption_off();
> -    preempt_enable();
> -
> -The irqsoff tracer will record the total length of
> -call_function_with_irqs_off() and
> -call_function_with_irqs_and_preemption_off().
> -
> -The preemptoff tracer will record the total length of
> -call_function_with_irqs_and_preemption_off() and
> -call_function_with_preemption_off().
> -
> -But neither will trace the time that interrupts and/or
> -preemption is disabled. This total time is the time that we can
> -not schedule. To record this time, use the preemptirqsoff
> -tracer.
> -
> -Again, using this trace is much like the irqsoff and preemptoff
> -tracers.
> -
> - # echo preemptirqsoff > /debug/tracing/current_tracer
> - # echo 0 > /debug/tracing/tracing_max_latency
> - # echo 1 > /debug/tracing/tracing_enabled
> - # ls -ltr
> - [...]
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/latency_trace
> -# tracer: preemptirqsoff
> -#
> -preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 293 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: ls-4860 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: apic_timer_interrupt
> - => ended at:   __do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -      ls-4860  0d...    0us!: trace_hardirqs_off_thunk (apic_timer_interrupt)
> -      ls-4860  0d.s.  294us : _local_bh_enable (__do_softirq)
> -      ls-4860  0d.s1  294us : trace_preempt_on (__do_softirq)
> -
> -
> -
> -The trace_hardirqs_off_thunk is called from assembly on x86 when
> -interrupts are disabled in the assembly code. Without the
> -function tracing, we do not know if interrupts were enabled
> -within the preemption points. We do see that it started with
> -preemption enabled.
> -
> -Here is a trace with ftrace_enabled set:
> -
> -
> -# tracer: preemptirqsoff
> -#
> -preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 105 us, #183/183, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: write_chan
> - => ended at:   __do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -      ls-4473  0.N..    0us : preempt_schedule (write_chan)
> -      ls-4473  0dN.1    1us : _spin_lock (schedule)
> -      ls-4473  0dN.1    2us : add_preempt_count (_spin_lock)
> -      ls-4473  0d..2    2us : put_prev_task_fair (schedule)
> -[...]
> -      ls-4473  0d..2   13us : set_normalized_timespec (ktime_get_ts)
> -      ls-4473  0d..2   13us : __switch_to (schedule)
> -    sshd-4261  0d..2   14us : finish_task_switch (schedule)
> -    sshd-4261  0d..2   14us : _spin_unlock_irq (finish_task_switch)
> -    sshd-4261  0d..1   15us : add_preempt_count (_spin_lock_irqsave)
> -    sshd-4261  0d..2   16us : _spin_unlock_irqrestore (hrtick_set)
> -    sshd-4261  0d..2   16us : do_IRQ (common_interrupt)
> -    sshd-4261  0d..2   17us : irq_enter (do_IRQ)
> -    sshd-4261  0d..2   17us : idle_cpu (irq_enter)
> -    sshd-4261  0d..2   18us : add_preempt_count (irq_enter)
> -    sshd-4261  0d.h2   18us : idle_cpu (irq_enter)
> -    sshd-4261  0d.h.   18us : handle_fasteoi_irq (do_IRQ)
> -    sshd-4261  0d.h.   19us : _spin_lock (handle_fasteoi_irq)
> -    sshd-4261  0d.h.   19us : add_preempt_count (_spin_lock)
> -    sshd-4261  0d.h1   20us : _spin_unlock (handle_fasteoi_irq)
> -    sshd-4261  0d.h1   20us : sub_preempt_count (_spin_unlock)
> -[...]
> -    sshd-4261  0d.h1   28us : _spin_unlock (handle_fasteoi_irq)
> -    sshd-4261  0d.h1   29us : sub_preempt_count (_spin_unlock)
> -    sshd-4261  0d.h2   29us : irq_exit (do_IRQ)
> -    sshd-4261  0d.h2   29us : sub_preempt_count (irq_exit)
> -    sshd-4261  0d..3   30us : do_softirq (irq_exit)
> -    sshd-4261  0d...   30us : __do_softirq (do_softirq)
> -    sshd-4261  0d...   31us : __local_bh_disable (__do_softirq)
> -    sshd-4261  0d...   31us+: add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s4   34us : add_preempt_count (__local_bh_disable)
> -[...]
> -    sshd-4261  0d.s3   43us : sub_preempt_count (local_bh_enable_ip)
> -    sshd-4261  0d.s4   44us : sub_preempt_count (local_bh_enable_ip)
> -    sshd-4261  0d.s3   44us : smp_apic_timer_interrupt (apic_timer_interrupt)
> -    sshd-4261  0d.s3   45us : irq_enter (smp_apic_timer_interrupt)
> -    sshd-4261  0d.s3   45us : idle_cpu (irq_enter)
> -    sshd-4261  0d.s3   46us : add_preempt_count (irq_enter)
> -    sshd-4261  0d.H3   46us : idle_cpu (irq_enter)
> -    sshd-4261  0d.H3   47us : hrtimer_interrupt (smp_apic_timer_interrupt)
> -    sshd-4261  0d.H3   47us : ktime_get (hrtimer_interrupt)
> -[...]
> -    sshd-4261  0d.H3   81us : tick_program_event (hrtimer_interrupt)
> -    sshd-4261  0d.H3   82us : ktime_get (tick_program_event)
> -    sshd-4261  0d.H3   82us : ktime_get_ts (ktime_get)
> -    sshd-4261  0d.H3   83us : getnstimeofday (ktime_get_ts)
> -    sshd-4261  0d.H3   83us : set_normalized_timespec (ktime_get_ts)
> -    sshd-4261  0d.H3   84us : clockevents_program_event (tick_program_event)
> -    sshd-4261  0d.H3   84us : lapic_next_event (clockevents_program_event)
> -    sshd-4261  0d.H3   85us : irq_exit (smp_apic_timer_interrupt)
> -    sshd-4261  0d.H3   85us : sub_preempt_count (irq_exit)
> -    sshd-4261  0d.s4   86us : sub_preempt_count (irq_exit)
> -    sshd-4261  0d.s3   86us : add_preempt_count (__local_bh_disable)
> -[...]
> -    sshd-4261  0d.s1   98us : sub_preempt_count (net_rx_action)
> -    sshd-4261  0d.s.   99us : add_preempt_count (_spin_lock_irq)
> -    sshd-4261  0d.s1   99us+: _spin_unlock_irq (run_timer_softirq)
> -    sshd-4261  0d.s.  104us : _local_bh_enable (__do_softirq)
> -    sshd-4261  0d.s.  104us : sub_preempt_count (_local_bh_enable)
> -    sshd-4261  0d.s.  105us : _local_bh_enable (__do_softirq)
> -    sshd-4261  0d.s1  105us : trace_preempt_on (__do_softirq)
> -
> -
> -This is a very interesting trace. It started with the preemption
> -of the ls task. We see that the task had the "need_resched" bit
> -set via the 'N' in the trace.  Interrupts were disabled before
> -the spin_lock at the beginning of the trace. We see that a
> -schedule took place to run sshd.  When the interrupts were
> -enabled, we took an interrupt. On return from the interrupt
> -handler, the softirq ran. We took another interrupt while
> -running the softirq as we see from the capital 'H'.
> -
> -
>  wakeup
>  ------
>  
> -- 
> 1.6.0.6
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

