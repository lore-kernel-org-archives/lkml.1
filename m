Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbZCQBkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbZCQBkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 21:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZCQBkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 21:40:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49947 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZCQBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 21:40:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=BIyOhzv6Kb5g44oP+/mSHJgpS6Bt/EnhVburqJif2Jyt1hrA9MVBrvJ/XIbhffYpT
	Fgm+VJg2NTKxjiTr4yndQ==
MIME-Version: 1.0
In-Reply-To: <20090317000138.GA19848@Krystal>
References: <5df78e1d0902231610y615bcfb5hdbbc44736ecfce00@mail.gmail.com>
	 <20090313170415.GE3354@Krystal>
	 <5df78e1d0903161623s1d5d2a04h946668ac0c6a69f7@mail.gmail.com>
	 <20090317000138.GA19848@Krystal>
Date: Mon, 16 Mar 2009 18:40:10 -0700
Message-ID: <5df78e1d0903161840o50becebcxe2378805049fee77@mail.gmail.com>
Subject: Re: [RFC PATCH] Propose a new kernel tracing framework
From: Jiaying Zhang <jiayingz@google.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>,
       Michael Davidson <md@google.com>, ltt-dev@lists.casi.polymtl.ca,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 5:01 PM, Mathieu Desnoyers
<mathieu.desnoyers@polymtl.ca> wrote:
> * Jiaying Zhang (jiayingz@google.com) wrote:
>> Hi Mathieu,
>>
>> First, I apologize that I did not forward you my original email. I assumed
>> that the email would be noticed by interested people when it was sent
>> to lkml. Now I see that is a mistake.
>>
>
> Hi Jiaying,
>
> Apologies accepted, no hard feeling :) I have just been surprised when I
> found out about the numbers you posted.
>
>> On Fri, Mar 13, 2009 at 10:04 AM, Mathieu Desnoyers
>> <mathieu.desnoyers@polymtl.ca> wrote:
>> > Hi Jiaying,
>> >
>> > I'm very interested to hear about the details of your test-case, because
>> > what you are talking about here, and the numbers that you get, are, at
>> > the very least, not representative of the current LTTng. Perharps you
>> > used a version right after the kernel summit and stopped following the
>> > improvements we have done since then ? I also wonder about the instrumentation
>> > set you enabled in your tests, and whether it's exactly the same in the ktrace
>> > and LTTng runs (especially system call tracing). Please note that following the
>> > Kernel Summit 2008, a more active development cycle began, and the time was not
>> > right for optimisation. But since then a lot of improvement has been done on
>> > this side.
>>
>> Sorry that I omitted a lot of details in my test description. I did use an old
>> version of LTTng in my tests. The LTTng version I used was the 0.21 lttng
>> patches for 2.6.27 kernel. I used 2.6.26 kernel in my tests, with the ported
>> lttng-2.6.27-rc6-0.21 patches.
>>
>> I enabled the same set of trace events in ktrace and LTTng runs. Here is
>> the list of enabled events: syscall entry/exit, irq entry/exit, trap
>> entry/exit,
>> kernel_sched_switch, kernel_process_fork, kernel_process_wait,
>> kernel_process_free, kernel_process_exit.
>>
>> We are glad to see the improvements coming from the LTTng community.
>> I haven't got time to sync with the latest LTTng code and re-run my tests.
>> I will let you know when I have such data available.
>>
>
> On my side, with flight recorder activated, same instrumentation you
> use, with LTTng 0.111 :
>
> arm-google script :
>
> #!/bin/sh
>
> DIR=/mnt/debugfs/ltt/markers
>
> for a in \
>        syscall_entry syscall_exit \
>        irq_entry irq_exit \
>        trap_entry trap_exit \
>        page_fault_entry page_fault_exit \
>        page_fault_nosem_entry page_fault_nosem_exit \
>        page_fault_get_user_entry page_fault_get_user_exit \
>        sched_schedule process_fork process_wait \
>        process_free process_exit;
> do
>        echo 1 > ${DIR}/kernel/$a/enable
> done
>
> running tbench -t 200 8
>
> Vanilla kernel :  2070 MB/sec
> Flight recorder : 1693 MB/sec   Performance impact : 18.2 %
> Normal :          1620 MB/sec   Performance impact : 21.7 % (8 lttd threads)
>
> So now we are comparing apples with apples :-)
Looks like the performance of LTTng has improved a lot over the past
few months. I will run some tests with the latest LTTng patches and
let you know if I see any difference. Did you use 2.6.29-rc7 kernel in
your tests?

>
>> >
>> > First I'd like to express my concern about the way you posted your
>> > numbers :
>> >
>> > 1 - You did not CC anyone from the LTTng project.
>> > 2 - You did not tell which LTTng version you used as a comparison basis.
>> > 3 - You did not look at the current state of code before posting your
>> >    comparison. (as shows the comment in your patch header)
>> That is indeed my mistake.
>>
>> > 4 - You did not tell the instrumentation set that you enabled from LTTng. Is it
>> >    the default instrumentation ? Did you also enable system call tracing
>> >    with your tracer using set_kernel_trace_flag_all_tasks() ? If not, this
>> >    makes a huge difference on the amount of information gathered.
>> Yes. We also enable syscall tracing via set_kernel_trace_flag_all_tasks().
>>
>> >
>> > So let's have a close look at them. I'm re-doing the benchmarks based on
>> > the current LTTng version below.
>> >
>> >> Hello All,
>> >>
>> >> We have been working on building a kernel tracer for a production environment.
>> >> We first considered to use the existing markers code, but found it a bit
>> >> heavyweight.
>> >
>> > Have you looked at :
>> >
>> > 1 - The tracepoints currently in the kernel
>> > 2 - The _current_ version of markers in the LTTng tree ?
>>
>> I looked at the tracepoints currently in the kernel. It is great to see that
>> some trace instrumentation code is finally available in the mainline kernel.
>> But I still don't like an additional tracepoint layer on top of the
>> actual tracing
>> (ktrace or markers or ftrace) layer. That seems to add unnecessary overhead.
>> The markers code I referred to in my email is the current code in the mainline
>> kernel. I had a look at the LTTng markers code but still saw that va_list
>> argument is used in marker_probe_func. It sounds a nice improvement
>> if the LTTng markers avoids the use of va_arg whenever possible.
>>
>
> Yes, vs_args is only there as a commodity for slow paths.
>
>> >
>> >>  So we developed a new kernel tracing prototype that shares
>> >> many similarities as markers but also includes several simplifications that
>> >> give us considerable performance benefits. For example, we pass the size of
>> >> trace event directly to the probe function instead of using va_arg as that
>> >> used in markers, which saves us the overhead of variable passing.
>> >
>> > The markers in the LTTng tree only use va_args for "debug-style"
>> > tracing. All the tracing fast paths are now done with custom probe
>> > functions which takes the arguments from the tracepoint and write them
>> > in the trace buffers directly in C. When the event payload size is already
>> > known statically, there is no dynamic computation cost at all : it's
>> > simply passed to the ltt-relay write function.
>> But this raises another concern that sub-system developers may need
>> to write a bunch of custom probe functions to avoid the argument parsing
>> overhead. Can you instead have a general probe function or macro that
>> does this work?
>>
>
> Well, considering the amount of care we have to take when we consider
> adding a tracepoint in the mainline kernel, I think it's even a *good*
> thing that someone has to stop and write a small callback to deal with
> the information he wants to export. I think debug-style tracing should
> be very, very quick and easy to add, but tracepoints meant to make it
> into the mainline does not share this requirement.
I agree that we need to be careful when adding tracepoints into the kernel,
but I still think it is good to simplify the process of adding/maintaining
tracepoints so sub-system maintainers don't feel it is a big burden.

>
>> >
>> >>  Also, we
>> >> associate a single probe function to each event, so we can directly call the
>> >> probe function when tracing is enabled.
>> >
>> > You seem to imply that being stuck with a single probe function is
>> > somehow superior to have tiny per-event callbacks which then call into a
>> > buffer write function ? Why ?
>> That is indeed my thinking, because we saw that some platforms are
>> very sensitive to function call overhead and we haven't seen use cases
>> where multi probe functions prove necessary.
>>
>
> Hrm, so your plan is to embed the tracing code at the caller site, or to
> keep one single function call ?
We do have a general probe function that is called when tracing is enabled.
Other than that, the main tracing code is defined as an inline function that is
embed at the caller site.


Jiaying

>
>> >
>> >>  Our measurements show that our
>> >> current tracing prototype introduces much lower overhead compared with
>> >> lttng (we use lttng as a comparison because markers does not provide the
>> >> implementation to record trace data).
>> >
>> > Why LTTng version, kernel version, LTTng config and runtime options do
>> > you use ?
>> See above for LTTng and kernel versions. I was using the default LTTng
>> config options and 'normal' recorder mode.
>>
>> >
>> >> E.g., with dbench, lttng introduces
>> >> 20~80% overhead on our testing platforms while the overhead with our
>> >> kernel tracer is within 10%; with tbench, lttng usually adds more than 30%
>> >> overhead while the overhead added by our kernel tracer is usually within
>> >> 15%; with kernbench (time to compile a Linux kernel), the overhead
>> >> added by lttng is around 4%~18% while the overhead added by our
>> >> kernel tracer is within 2.5%.
>> >>
>> >
>> > I'm re-running the dbench and tbench tests :
>> >
>> > With LTTng 0.106, kernel 2.6.29-rc7
>> > 8-cores Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz, 16GB ram
>> >
>> > Arming all the default LTTng instrumentation (168 tracepoints),
>> > Tracing in flight recorder mode, including system call entry/exit
>> > tracing and block I/O tracing (blktrace instrumentation), I get :
>> >
>> > Test / config    |  Vanilla kernel  |  LTTng 0.106  |  slowdown
>> > dbench 8 -t 200  |       1361 MB/s  |   1193 MB/s   |    12.3 %
>> >
>> > As an example of the effect of custom probe vs va_args based probes,
>> > let's take the tbench example
>> >
>> >                 |     Vanilla      |  LTTng 0.106  |  slowdown
>> > tbench 8 -t 200  |       2074 MB/s  |     997 MB/s  |      52 %
>> >
>> > The LTTng trace statistics shows the top high event rate events :
>> >
>> > Some are usual (therefore lttng already implements custom probes for them) :
>> >
>> > 42004 sched_try_wakeup
>> > 79754 timer_set
>> > 83973 sched_schedule
>> > 84317 softirq_exit
>> > 84318 softirq_entry
>> > 95370 page_free
>> > 95412 page_alloc
>> > 267247 syscall_entry
>> > 267247 syscall_exit
>> >
>> > Some are more tbench workload-specific :
>> >
>> > 16915 socket_sendmsg
>> > 18911 napi_complete
>> > 18911 napi_schedule
>> > 18912 dev_receive
>> > 18914 dev_xmit
>> > 18920 napi_poll
>> > 33831 socket_recvmsg
>> > 59860 read
>> >
>> >
>> > So let's see what happens if I implement those as custom probes and do a bit of
>> > tuning in the tracer hot path :
>> Could you give more details about the custom probe you used?
>
> They are available in the lttng tree on git.kernel.org in
> ltt/probes/*-trace.c. Their API is in include/linux/ltt-type-serialize.h
>
>> Do you need to write a custom probe for each tracepoint?
>>
>
> Yes. But it's not such a big deal. It looks a bit like Steve's
> TRACE_EVENT macro-fu, but written in a simple C callback :
>
> void probe_sched_switch(struct rq *rq, struct task_struct *prev,
>                struct task_struct *next);
>
> DEFINE_MARKER_TP(kernel, sched_schedule, sched_switch, probe_sched_switch,
>        "prev_pid %d next_pid %d prev_state #2d%ld");
>
> notrace void probe_sched_switch(struct rq *rq, struct task_struct *prev,
>                struct task_struct *next)
> {
>        struct marker *marker;
>        struct serialize_int_int_short data;
>
>        data.f1 = prev->pid;
>        data.f2 = next->pid;
>        data.f3 = prev->state;
>
>        marker = &GET_MARKER(kernel, sched_schedule);
>        ltt_specialized_trace(marker, marker->single.probe_private,
>                &data, serialize_sizeof(data), sizeof(int));
> }
>
> Best regards,
>
> Mathieu
>
>> Jiaying
>>
>> >
>> >                 |     Vanilla      |  LTTng 0.107  |  slowdown
>> > Custom probes :
>> > tbench 8 -t 200  |       2074 MB/s  |    1275 MB/s  |    38.5 %
>> >
>> > With tracer hot path tuning (inline hot path, function calls for slow path, will
>> > be in 0.108) :
>> > tbench 8 -t 200  |       2074 MB/s  |    1335 MB/s  |    35.6 %
>> >
>> > kernbench :
>> > Average Optimal load -j 32 Run
>> >
>> > Vanilla 2.6.29-rc7 :
>> > Elapsed Time 48.238 (0.117346)
>> >
>> > With flight recorder tracing, default lttng instrumentation, lttng 0.108 :
>> > Elapsed Time 50.226 (0.0750333)
>> >
>> > Slowdown : 4.1 %
>> >
>> > So except the tbench workload on LTTng 0.106, which still had a 52% performance
>> > impact (brought it down to 35 % for the next LTTng release) due to
>> > specific workload and not having specialized probes implemented, the
>> > dbench impact is well below your results (12.3 % vs 20-80%)
>> >
>> > So given the huge result discrepancies between your tests and mine, could you
>> > give us more detail about your benchmarks ? Especially knowing the enabled
>> > instrumentation set, and the amount of MB/s generated by both ktrace and LTTng
>> > runs (to make sure we are comparing the same traffic) and the LTTng versions you
>> > are using as a comparison basis would be good.
>> >
>> > Thanks,
>> >
>> > Mathieu
>> >
>> >
>> >> The patch below is the current prototype we have implemented. It uses
>> >> Steve's unified trace buffer code with some small extensions to support
>> >> buffer mmap. The patch is probably still buggy, but we would like to get
>> >> some early feedback from the community.
>> >>
>> >> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>> >>
>> >> Index: git-linux/init/Kconfig
>> >> ===================================================================
>> >> --- git-linux.orig/init/Kconfig 2009-02-19 14:58:37.000000000 -0800
>> >> +++ git-linux/init/Kconfig      2009-02-19 15:50:15.000000000 -0800
>> >> @@ -950,6 +950,15 @@
>> >>          Place an empty function call at each marker site. Can be
>> >>          dynamically changed for a probe function.
>> >>
>> >> +config KTRACE
>> >> +       bool "Enable ktrace support"
>> >> +       select DEBUG_FS
>> >> +       select TRACING
>> >> +       select RING_BUFFER
>> >> +       help
>> >> +         Ktrace is a kernel tracing tool that allows you to trace
>> >> +         kernel events by inserting trace points at proper places.
>> >> +
>> >>  source "arch/Kconfig"
>> >>
>> >>  endmenu                # General setup
>> >> Index: git-linux/kernel/Makefile
>> >> ===================================================================
>> >> --- git-linux.orig/kernel/Makefile      2009-02-19 14:58:37.000000000 -0800
>> >> +++ git-linux/kernel/Makefile   2009-02-19 14:58:39.000000000 -0800
>> >> @@ -86,6 +86,7 @@
>> >>  obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
>> >>  obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
>> >>  obj-$(CONFIG_MARKERS) += marker.o
>> >> +obj-$(CONFIG_KTRACE) += ktrace.o
>> >>  obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
>> >>  obj-$(CONFIG_LATENCYTOP) += latencytop.o
>> >>  obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
>> >> Index: git-linux/include/asm-generic/vmlinux.lds.h
>> >> ===================================================================
>> >> --- git-linux.orig/include/asm-generic/vmlinux.lds.h    2009-02-19
>> >> 14:58:37.000000000 -0800
>> >> +++ git-linux/include/asm-generic/vmlinux.lds.h 2009-02-19
>> >> 14:58:39.000000000 -0800
>> >> @@ -73,6 +73,9 @@
>> >>        MEM_KEEP(init.data)                                             \
>> >>        MEM_KEEP(exit.data)                                             \
>> >>        . = ALIGN(8);                                                   \
>> >> +       VMLINUX_SYMBOL(__start___ktraces) = .;                          \
>> >> +       *(__ktrace)                                                     \
>> >> +       VMLINUX_SYMBOL(__stop___ktraces) = .;                           \
>> >>        VMLINUX_SYMBOL(__start___markers) = .;                          \
>> >>        *(__markers)                                                    \
>> >>        VMLINUX_SYMBOL(__stop___markers) = .;                           \
>> >> @@ -89,6 +92,7 @@
>> >>                VMLINUX_SYMBOL(__start_rodata) = .;                     \
>> >>                *(.rodata) *(.rodata.*)                                 \
>> >>                *(__vermagic)           /* Kernel version magic */      \
>> >> +               *(__ktrace_strings)     /* Ktrace: strings */           \
>> >>                *(__markers_strings)    /* Markers: strings */          \
>> >>                *(__tracepoints_strings)/* Tracepoints: strings */      \
>> >>        }                                                               \
>> >> Index: git-linux/kernel/module.c
>> >> ===================================================================
>> >> --- git-linux.orig/kernel/module.c      2009-02-19 14:58:37.000000000 -0800
>> >> +++ git-linux/kernel/module.c   2009-02-19 14:58:39.000000000 -0800
>> >> @@ -50,6 +50,7 @@
>> >>  #include <asm/sections.h>
>> >>  #include <linux/tracepoint.h>
>> >>  #include <linux/ftrace.h>
>> >> +#include <linux/ktrace.h>
>> >>  #include <linux/async.h>
>> >>
>> >>  #if 0
>> >> @@ -2145,6 +2146,10 @@
>> >>                                        sizeof(*mod->tracepoints),
>> >>                                        &mod->num_tracepoints);
>> >>  #endif
>> >> +#ifdef CONFIG_KTRACE
>> >> +       mod->ktrace = section_objs(hdr, sechdrs, secstrings, "__ktrace",
>> >> +                               sizeof(*mod->ktrace), &mod->num_ktrace);
>> >> +#endif
>> >>
>> >>  #ifdef CONFIG_MODVERSIONS
>> >>        if ((mod->num_syms && !mod->crcs)
>> >> Index: git-linux/include/linux/module.h
>> >> ===================================================================
>> >> --- git-linux.orig/include/linux/module.h       2009-02-19
>> >> 14:58:37.000000000 -0800
>> >> +++ git-linux/include/linux/module.h    2009-02-19 14:58:39.000000000 -0800
>> >> @@ -44,6 +44,7 @@
>> >>  };
>> >>
>> >>  struct module;
>> >> +struct kernel_trace;
>> >>
>> >>  struct module_attribute {
>> >>         struct attribute attr;
>> >> @@ -347,6 +348,11 @@
>> >>        /* Reference counts */
>> >>        struct module_ref ref[NR_CPUS];
>> >>  #endif
>> >> +#ifdef CONFIG_KTRACE
>> >> +       struct kernel_trace *ktrace;
>> >> +       unsigned int num_ktrace;
>> >> +#endif
>> >> +
>> >>  };
>> >>  #ifndef MODULE_ARCH_INIT
>> >>  #define MODULE_ARCH_INIT {}
>> >> Index: git-linux/include/linux/ktrace.h
>> >> ===================================================================
>> >> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
>> >> +++ git-linux/include/linux/ktrace.h    2009-02-19 15:36:39.000000000 -0800
>> >> @@ -0,0 +1,83 @@
>> >> +#ifndef _LINUX_KTRACE_H
>> >> +#define _LINUX_KTRACE_H
>> >> +
>> >> +#include <linux/types.h>
>> >> +
>> >> +struct kernel_trace;
>> >> +
>> >> +typedef void ktrace_probe_func(struct kernel_trace *, void *, size_t);
>> >> +
>> >> +struct kernel_trace {
>> >> +       const char      *name;
>> >> +       const char      *format;  /* format string describing variable list */
>> >> +       size_t          *stroff;  /* offsets of string variables */
>> >> +       /* 31 bit event_id is converted to 16 bit when entering to the buffer */
>> >> +       u32             enabled:1, event_id:31;
>> >> +       ktrace_probe_func *func;  /* probe function */
>> >> +       struct list_head list;  /* list head linked to the hash table entry */
>> >> +} __attribute__((aligned(8)));
>> >> +
>> >> +extern int ktrace_enabled;
>> >> +
>> >> +/*
>> >> + * Make sure the alignment of the structure in the __ktrace section will
>> >> + * not add unwanted padding between the beginning of the section and the
>> >> + * structure. Force alignment to the same alignment as the section start.
>> >> + */
>> >> +
>> >> +#define DEFINE_KTRACE_STRUCT(name)                     \
>> >> +       struct __attribute__((packed)) ktrace_struct_##name
>> >> +
>> >> +#ifdef CONFIG_KTRACE
>> >> +/*
>> >> + * DO_TRACE is the macro that is called from each trace point. Each trace
>> >> + * point is associated with a static ktrace object that is located in a
>> >> + * special __ktrace section and is uniquely identified by the event name and
>> >> + * event format. Take a look at the files under include/trace for example
>> >> + * usage. Note that we call the trace probe function only if the global
>> >> + * tracing is enabled and the tracing for the associated event is enabled,
>> >> + * so we only introduce the overhead of a predicted condition judge when
>> >> + * tracing is disabled.
>> >> + */
>> >> +#define DO_TRACE(name, format, args...)
>> >>          \
>> >> +       do {                                                            \
>> >> +               static const char __kstrtab_##name[]                    \
>> >> +               __attribute__((section("__ktrace_strings")))            \
>> >> +               = #name "\0" format;                                    \
>> >> +               static struct kernel_trace __ktrace_##name              \
>> >> +               __attribute__((section("__ktrace"), aligned(8))) =      \
>> >> +               { __kstrtab_##name, &__kstrtab_##name[sizeof(#name)],   \
>> >> +               NULL, 0, 0, NULL, LIST_HEAD_INIT(__ktrace_##name.list) }; \
>> >> +               __ktrace_check_format(format, ## args);                 \
>> >> +               if (unlikely(ktrace_enabled) &&                         \
>> >> +                               unlikely(__ktrace_##name.enabled)) {    \
>> >> +                       struct ktrace_struct_##name karg = { args };    \
>> >> +                       (*__ktrace_##name.func)                         \
>> >> +                       (&__ktrace_##name, &karg, sizeof(karg));        \
>> >> +               }                                                       \
>> >> +       } while (0)
>> >> +
>> >> +#else /* !CONFIG_KTRACE */
>> >> +#define DO_TRACE(name, format, args...)
>> >> +#endif
>> >> +
>> >> +/* To be used for string format validity checking with gcc */
>> >> +static inline void __printf(1, 2) ___ktrace_check_format(const char *fmt, ...)
>> >> +{
>> >> +}
>> >> +
>> >> +#define __ktrace_check_format(format, args...)                         \
>> >> +       do {                                                            \
>> >> +               if (0)                                                  \
>> >> +                       ___ktrace_check_format(format, ## args);        \
>> >> +       } while (0)
>> >> +
>> >> +
>> >> +/* get the trace buffer information */
>> >> +#define KTRACE_BUF_GET_SIZE     _IOR(0xF5, 0x00, __u32)
>> >> +#define KTRACE_BUF_GET_PRODUCED _IOR(0xF5, 0x01, __u32)
>> >> +#define KTRACE_BUF_GET_CONSUMED _IOR(0xF5, 0x02, __u32)
>> >> +#define KTRACE_BUF_PUT_PRODUCED _IOW(0xF5, 0x03, __u32)
>> >> +#define KTRACE_BUF_PUT_CONSUMED _IOW(0xF5, 0x04, __u32)
>> >> +
>> >> +#endif
>> >> Index: git-linux/kernel/ktrace.c
>> >> ===================================================================
>> >> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
>> >> +++ git-linux/kernel/ktrace.c   2009-02-19 15:45:20.000000000 -0800
>> >> @@ -0,0 +1,872 @@
>> >> +/*
>> >> + * kernel/ktrace.c
>> >> + *
>> >> + * Implementation of the kernel tracing for linux kernel 2.6.
>> >> + *
>> >> + * Copyright 2008- Google Inc.
>> >> + * Original Author: Jiaying Zhang
>> >> + */
>> >> +
>> >> +#include <linux/module.h>
>> >> +#include <linux/kernel.h>
>> >> +#include <linux/bitmap.h>
>> >> +#include <linux/poll.h>
>> >> +#include <linux/errno.h>
>> >> +#include <linux/sched.h>
>> >> +#include <linux/linkage.h>
>> >> +#include <linux/debugfs.h>
>> >> +#include <linux/timer.h>
>> >> +#include <linux/delay.h>
>> >> +#include <linux/jhash.h>
>> >> +#include <linux/ctype.h>
>> >> +#include <linux/namei.h>
>> >> +#include <linux/ktrace.h>
>> >> +#include <linux/ring_buffer.h>
>> >> +
>> >> +static char *ktrace_version = "1.0.0";
>> >> +int ktrace_enabled;
>> >> +EXPORT_SYMBOL(ktrace_enabled);
>> >> +static uint16_t ktrace_next_id;
>> >> +
>> >> +extern struct kernel_trace __start___ktraces[];
>> >> +extern struct kernel_trace __stop___ktraces[];
>> >> +
>> >> +static DEFINE_MUTEX(ktrace_mutex);
>> >> +
>> >> +/* ktrace hash table entry structure and variables */
>> >> +struct ktrace_entry {
>> >> +       struct hlist_node       hlist;
>> >> +       char                    *name;
>> >> +       char                    *format;
>> >> +       size_t                  *stroff;
>> >> +       ktrace_probe_func       *func;
>> >> +       u32                     enabled:1, event_id:31;
>> >> +       struct list_head        klist;  /* list of loaded ktraces */
>> >> +};
>> >> +
>> >> +#define KTRACE_HASH_BITS 6
>> >> +#define KTRACE_HASH_SIZE (1 << KTRACE_HASH_BITS)
>> >> +static struct hlist_head ktrace_table[KTRACE_HASH_SIZE];
>> >> +
>> >> +/* debugfs directory variables */
>> >> +static struct dentry *tracedir;
>> >> +static struct dentry *eventdir;
>> >> +typedef void tracecontrol_handle_func(struct file *, unsigned long, size_t *);
>> >> +
>> >> +/* ring buffer code */
>> >> +static unsigned long trace_buf_size = 65536UL;
>> >> +struct ring_buffer *trace_buffer;
>> >> +static DECLARE_WAIT_QUEUE_HEAD(trace_wait); /* waitqueue for trace_data_poll */
>> >> +static struct timer_list trace_timer; /* reader wake-up timer */
>> >> +#define TRACEREAD_WAKEUP_INTERVAL      1000  /* time interval in jiffies */
>> >> +static struct kref ktrace_kref;
>> >> +
>> >> +static void
>> >> +ring_buffer_probe(struct kernel_trace *kt, void *data, size_t event_size)
>> >> +{
>> >> +       struct ring_buffer_event *event;
>> >> +       void *trace_event;
>> >> +       unsigned long flag;
>> >> +
>> >> +       event = ring_buffer_lock_reserve(trace_buffer,
>> >> +                       sizeof(uint16_t) + event_size, &flag);
>> >> +       if (!event)
>> >> +               return;
>> >> +       trace_event = ring_buffer_event_data(event);
>> >> +       *(uint16_t *) trace_event = (uint16_t) kt->event_id;
>> >> +       memcpy(trace_event + sizeof(uint16_t), data, event_size);
>> >> +       ring_buffer_unlock_commit(trace_buffer, event, flag);
>> >> +}
>> >> +
>> >> +/* special probe function for events that contain string arguments */
>> >> +static void
>> >> +string_probe(struct kernel_trace *kt, void *data, size_t event_size)
>> >> +{
>> >> +       struct ring_buffer_event *event;
>> >> +       void *trace_event, *p;
>> >> +       unsigned long flag;
>> >> +       size_t *offset, scanned;
>> >> +       char *string;
>> >> +
>> >> +       /*
>> >> +        * Get the real length of the event, i.e., we use stroff array to
>> >> +        * locate string variables in the passed-in trace data and use their
>> >> +        * length to replace the size of the string pointers.
>> >> +        */
>> >> +       for (offset = kt->stroff; *offset != -1; offset++) {
>> >> +               string = *(char **) (data + *offset);
>> >> +               event_size += strlen(string) + 1 - sizeof(char *);
>> >> +       }
>> >> +       event = ring_buffer_lock_reserve(trace_buffer,
>> >> +                       sizeof(uint16_t) + event_size, &flag);
>> >> +       if (!event)
>> >> +               return;
>> >> +       trace_event = ring_buffer_event_data(event);
>> >> +       *(uint16_t *) trace_event = (uint16_t) kt->event_id;
>> >> +       p = trace_event + sizeof(uint16_t);
>> >> +       /*
>> >> +        * Copy the trace data into buffer. For string variables, we enter the
>> >> +        * string into the buffer. Otherwise, the passed in data is copied.
>> >> +        */
>> >> +       for (offset = kt->stroff, scanned = 0; *offset != -1; offset++) {
>> >> +               memcpy(p, data + scanned, *offset - scanned);
>> >> +               p += *offset - scanned;
>> >> +               string = *(char **) (data + *offset);
>> >> +               memcpy(p, string, strlen(string) + 1);
>> >> +               p += strlen(string) + 1;
>> >> +               scanned = *offset + sizeof(char *);
>> >> +       }
>> >> +       memcpy(p, data + scanned,
>> >> +                       trace_event + sizeof(uint16_t) + event_size - p);
>> >> +       ring_buffer_unlock_commit(trace_buffer, event, flag);
>> >> +}
>> >> +
>> >> +/* timer function used to defer ring buffer reader waking */
>> >> +static void wakeup_readers(unsigned long data)
>> >> +{
>> >> +       if (trace_buffer && !ring_buffer_empty(trace_buffer))
>> >> +               wake_up_interruptible(&trace_wait);
>> >> +       mod_timer(&trace_timer, jiffies + TRACEREAD_WAKEUP_INTERVAL);
>> >> +}
>> >> +
>> >> +/* function for reading ktrace metadata info */
>> >> +static void *tracing_info_start(struct seq_file *seq, loff_t *pos)
>> >> +{
>> >> +       seq_printf(seq, "version %s\n", ktrace_version);
>> >> +       return (*pos >= KTRACE_HASH_SIZE) ? NULL : &ktrace_table[*pos];
>> >> +}
>> >> +
>> >> +static void *tracing_info_next(struct seq_file *seq, void *v, loff_t *pos)
>> >> +{
>> >> +       ++*pos;
>> >> +       return (*pos >= KTRACE_HASH_SIZE) ? NULL : &ktrace_table[*pos];
>> >> +}
>> >> +
>> >> +static int tracing_info_show(struct seq_file *seq, void *v)
>> >> +{
>> >> +       struct hlist_head *head = v;
>> >> +       struct hlist_node *node;
>> >> +       struct ktrace_entry *entry;
>> >> +       hlist_for_each_entry(entry, node, head, hlist)
>> >> +               seq_printf(seq, "name '%s' format '%s' id %u %s\n",
>> >> +                       entry->name, entry->format, entry->event_id,
>> >> +                       entry->enabled ? "enabled" : "disabled");
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static void tracing_info_stop(struct seq_file *seq, void *v)
>> >> +{
>> >> +}
>> >> +
>> >> +static const struct seq_operations tracing_info_seq_ops = {
>> >> +       .start  = tracing_info_start,
>> >> +       .next   = tracing_info_next,
>> >> +       .show   = tracing_info_show,
>> >> +       .stop   = tracing_info_stop,
>> >> +};
>> >> +
>> >> +static int tracing_info_open(struct inode *inode, struct file *file)
>> >> +{
>> >> +       return seq_open(file, &tracing_info_seq_ops);
>> >> +}
>> >> +
>> >> +static const struct file_operations traceinfo_file_operations = {
>> >> +       .open   = tracing_info_open,
>> >> +       .read   = seq_read,
>> >> +       .llseek = seq_lseek,
>> >> +       .release = seq_release,
>> >> +};
>> >> +
>> >> +/*
>> >> + * wrapper function used by debugfs write operation.
>> >> + * func: handling function that does real work
>> >> + */
>> >> +static ssize_t trace_debugfs_write(struct file *filp, const char __user *ubuf,
>> >> +               size_t cnt, loff_t *ppos, tracecontrol_handle_func *func)
>> >> +{
>> >> +       int ret;
>> >> +       char buf[64];
>> >> +       unsigned long val;
>> >> +
>> >> +       if (cnt >= sizeof(buf))
>> >> +               return -EINVAL;
>> >> +       if (copy_from_user(&buf, ubuf, cnt))
>> >> +               return -EFAULT;
>> >> +       buf[cnt] = 0;
>> >> +
>> >> +       ret = strict_strtoul(buf, 10, &val);
>> >> +       if (ret < 0)
>> >> +               return ret;
>> >> +       val = !!val;
>> >> +
>> >> +       func(filp, val, &cnt);
>> >> +
>> >> +       filp->f_pos += cnt;
>> >> +       return cnt;
>> >> +}
>> >> +
>> >> +/* functions for reading/writing the global 'enabled' control file */
>> >> +static ssize_t tracing_control_read(struct file *filp, char __user *ubuf,
>> >> +               size_t cnt, loff_t *ppos)
>> >> +{
>> >> +       int ret;
>> >> +       char buf[64];
>> >> +       ret = snprintf(buf, 64, "%u\n", ktrace_enabled);
>> >> +       return simple_read_from_buffer(ubuf, cnt, ppos, buf, ret);
>> >> +}
>> >> +
>> >> +static void __tracing_control_write(struct file *filp,
>> >> +               unsigned long val, size_t *cnt)
>> >> +{
>> >> +       if (val ^ ktrace_enabled) {
>> >> +               if (val) {
>> >> +                       trace_timer.expires =
>> >> +                               jiffies + TRACEREAD_WAKEUP_INTERVAL;
>> >> +                       add_timer(&trace_timer);
>> >> +                       ktrace_enabled = 1;
>> >> +               } else {
>> >> +                       ktrace_enabled = 0;
>> >> +                       del_timer_sync(&trace_timer);
>> >> +                       if (trace_buffer && !ring_buffer_empty(trace_buffer))
>> >> +                               wake_up_interruptible(&trace_wait);
>> >> +               }
>> >> +       }
>> >> +}
>> >> +
>> >> +static ssize_t tracing_control_write(struct file *filp, const char
>> >> __user *ubuf,
>> >> +               size_t cnt, loff_t *ppos)
>> >> +{
>> >> +       return trace_debugfs_write(filp, ubuf, cnt, ppos,
>> >> +                       __tracing_control_write);
>> >> +}
>> >> +
>> >> +static const struct file_operations tracecontrol_file_operations = {
>> >> +       .read   = tracing_control_read,
>> >> +       .write  = tracing_control_write,
>> >> +};
>> >> +
>> >> +/* functions for reading/writing a trace event file */
>> >> +static int update_ktrace(struct ktrace_entry *entry,
>> >> +               ktrace_probe_func *func, int enabled)
>> >> +{
>> >> +       struct kernel_trace *iter;
>> >> +       /* no need to update the list if the tracing is not initialized */
>> >> +       if (!tracedir)
>> >> +               return 0;
>> >> +       entry->enabled = enabled;
>> >> +       entry->func = func;
>> >> +       list_for_each_entry(iter, &entry->klist, list) {
>> >> +               iter->stroff = entry->stroff;
>> >> +               iter->func = func;
>> >> +               iter->enabled = enabled;
>> >> +       }
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static int ktrace_probe_register(struct ktrace_entry *entry,
>> >> +               ktrace_probe_func *probefunc)
>> >> +{
>> >> +       return update_ktrace(entry, probefunc, 1);
>> >> +}
>> >> +
>> >> +static int ktrace_probe_unregister(struct ktrace_entry *entry)
>> >> +{
>> >> +       return update_ktrace(entry, NULL, 0);
>> >> +}
>> >> +
>> >> +static int ktrace_control_open(struct inode *inode, struct file *filp)
>> >> +{
>> >> +       filp->private_data = inode->i_private;
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static ssize_t ktrace_control_read(struct file *filp, char __user *ubuf,
>> >> +               size_t cnt, loff_t *ppos)
>> >> +{
>> >> +       int ret;
>> >> +       char buf[64];
>> >> +       struct ktrace_entry *entry = filp->private_data;
>> >> +
>> >> +       ret = snprintf(buf, 64, "%u\n", entry->enabled);
>> >> +       return simple_read_from_buffer(ubuf, cnt, ppos, buf, ret);
>> >> +}
>> >> +
>> >> +/*
>> >> + * Check whether the event contains string arguments. Return 0 if not;
>> >> + * otherwise record the offsets of the string arguments in the ktrace
>> >> + * structure according to the event format and return 1.
>> >> + * The offset info is later used to store the string arguments into
>> >> + * the trace buffer during trace probe.
>> >> + */
>> >> +static int contain_string_arguments(struct ktrace_entry *entry)
>> >> +{
>> >> +       int count = 0;
>> >> +       char *fmt;
>> >> +       int qualifier;          /* 'h', 'l', or 'L' for integer fields */
>> >> +       size_t offset = 0;
>> >> +
>> >> +       for (fmt = strstr(entry->format, "%s"); fmt; fmt = strstr(++fmt, "%s"))
>> >> +               count++;
>> >> +       if (!count)
>> >> +               return 0;
>> >> +       entry->stroff = kmalloc(sizeof(size_t) * (count + 1), GFP_KERNEL);
>> >> +       if (!entry->stroff)
>> >> +               return -ENOMEM;
>> >> +
>> >> +       for (fmt = entry->format, count = 0; *fmt ; ++fmt) {
>> >> +               if (*fmt != '%')
>> >> +                       continue;
>> >> +repeat:
>> >> +               ++fmt;
>> >> +               switch (*fmt) {
>> >> +               case '-':
>> >> +               case '+':
>> >> +               case ' ':
>> >> +               case '#':
>> >> +               case '0':
>> >> +                       ++fmt;
>> >> +                       goto repeat;
>> >> +               }
>> >> +
>> >> +               while (isdigit(*fmt))
>> >> +                       fmt++;
>> >> +
>> >> +               /* get the conversion qualifier */
>> >> +               qualifier = -1;
>> >> +               if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
>> >> +                       qualifier = *fmt;
>> >> +                       ++fmt;
>> >> +                       if (qualifier == 'l' && *fmt == 'l') {
>> >> +                               qualifier = 'L';
>> >> +                               ++fmt;
>> >> +                       }
>> >> +               }
>> >> +
>> >> +               switch (*fmt) {
>> >> +               case 'c':
>> >> +                       offset += sizeof(char);
>> >> +                       continue;
>> >> +               case 's':
>> >> +                       entry->stroff[count] = offset;
>> >> +                       count++;
>> >> +                       offset += sizeof(char *);
>> >> +                       continue;
>> >> +               case 'p':
>> >> +                       offset += sizeof(void *);
>> >> +                       continue;
>> >> +               case 'd':
>> >> +               case 'i':
>> >> +               case 'o':
>> >> +               case 'u':
>> >> +               case 'x':
>> >> +               case 'X':
>> >> +                       switch (qualifier) {
>> >> +                       case 'L':
>> >> +                               offset += sizeof(long long);
>> >> +                               break;
>> >> +                       case 'l':
>> >> +                               offset += sizeof(long);
>> >> +                               break;
>> >> +                       case 'h':
>> >> +                               offset += sizeof(short);
>> >> +                               break;
>> >> +                       default:
>> >> +                               offset += sizeof(int);
>> >> +                               break;
>> >> +                       }
>> >> +                       break;
>> >> +               default:
>> >> +                       printk(KERN_WARNING "unknown format '%c'", *fmt);
>> >> +                       continue;
>> >> +               }
>> >> +       }
>> >> +       entry->stroff[count] = -1;
>> >> +       return 1;
>> >> +}
>> >> +
>> >> +static void __ktrace_control_write(struct file *filp,
>> >> +               unsigned long val, size_t *cnt)
>> >> +{
>> >> +       struct ktrace_entry *entry = filp->private_data;
>> >> +       int ret;
>> >> +
>> >> +       mutex_lock(&ktrace_mutex);
>> >> +       if (val ^ entry->enabled) {
>> >> +               if (val) {
>> >> +                       ret = contain_string_arguments(entry);
>> >> +                       if (ret == 0)
>> >> +                               ktrace_probe_register(entry, ring_buffer_probe);
>> >> +                       else if (ret > 0)
>> >> +                               ktrace_probe_register(entry, string_probe);
>> >> +                       else
>> >> +                               *cnt = ret;
>> >> +               } else
>> >> +                       ktrace_probe_unregister(entry);
>> >> +       }
>> >> +       mutex_unlock(&ktrace_mutex);
>> >> +}
>> >> +
>> >> +static ssize_t ktrace_control_write(struct file *filp, const char __user *ubuf,
>> >> +               size_t cnt, loff_t *ppos)
>> >> +{
>> >> +       return trace_debugfs_write(filp, ubuf, cnt, ppos,
>> >> +                       __ktrace_control_write);
>> >> +}
>> >> +
>> >> +static const struct file_operations ktracecontrol_file_operations = {
>> >> +       .open   = ktrace_control_open,
>> >> +       .read   = ktrace_control_read,
>> >> +       .write  = ktrace_control_write,
>> >> +};
>> >> +
>> >> +/* functions for adding/removing a trace event. Protected by mutex lock.
>> >> + * Called during initialization or after loading a module */
>> >> +static struct ktrace_entry *add_ktrace(struct kernel_trace *ktrace)
>> >> +{
>> >> +       struct ktrace_entry *entry;
>> >> +       size_t name_len = strlen(ktrace->name) + 1;
>> >> +       u32 hash = jhash(ktrace->name, name_len-1, 0);
>> >> +       struct hlist_head *head;
>> >> +       struct hlist_node *node;
>> >> +       struct dentry *dentry;
>> >> +
>> >> +       if (!tracedir)
>> >> +               return 0;
>> >> +       head = &ktrace_table[hash & ((1 << KTRACE_HASH_BITS)-1)];
>> >> +       hlist_for_each_entry(entry, node, head, hlist) {
>> >> +               if (!strcmp(ktrace->name, entry->name)) {
>> >> +                       if (strcmp(ktrace->format, entry->format)) {
>> >> +                               printk(KERN_WARNING "the format of tracepoint "
>> >> +                                       "\'%s\' changes from \'%s\' to \'%s\'."
>> >> +                                       "Dynamic changing of trace format is "
>> >> +                                       "not supported yet!\n",
>> >> +                                       ktrace->name, entry->format,
>> >> +                                       ktrace->format);
>> >> +                               return ERR_PTR(-EINVAL);
>> >> +                       }
>> >> +                       ktrace->enabled = entry->enabled;
>> >> +                       ktrace->func = entry->func;
>> >> +                       ktrace->event_id = entry->event_id;
>> >> +                       if (list_empty(&entry->klist))
>> >> +                               goto add_head;
>> >> +                       list_add_tail(&ktrace->list, &entry->klist);
>> >> +                       return entry;
>> >> +               }
>> >> +       }
>> >> +       entry = kmalloc(sizeof(struct ktrace_entry), GFP_KERNEL);
>> >> +       if (!entry)
>> >> +               return ERR_PTR(-ENOMEM);
>> >> +       entry->name = kmalloc(name_len, GFP_KERNEL);
>> >> +       if (!entry->name) {
>> >> +               kfree(entry);
>> >> +               return ERR_PTR(-ENOMEM);
>> >> +       }
>> >> +       memcpy(entry->name, ktrace->name, name_len);
>> >> +       if (ktrace->format) {
>> >> +               size_t format_len = strlen(ktrace->format) + 1;
>> >> +               entry->format = kmalloc(format_len, GFP_KERNEL);
>> >> +               if (!entry->format) {
>> >> +                       kfree(entry->name);
>> >> +                       kfree(entry);
>> >> +                       return ERR_PTR(-ENOMEM);
>> >> +               }
>> >> +               memcpy(entry->format, ktrace->format, format_len);
>> >> +       } else
>> >> +               entry->format = NULL;
>> >> +       entry->func = ktrace->func;
>> >> +       entry->enabled = 0;
>> >> +       ktrace->event_id = entry->event_id = ktrace_next_id++;
>> >> +       entry->stroff = NULL;
>> >> +       INIT_LIST_HEAD(&entry->klist);
>> >> +       hlist_add_head(&entry->hlist, head);
>> >> +add_head:
>> >> +       list_add(&ktrace->list, &entry->klist);
>> >> +       dentry = debugfs_create_file(entry->name, 0660, eventdir,
>> >> +                               entry, &ktracecontrol_file_operations);
>> >> +       if (!dentry)
>> >> +               printk(KERN_WARNING "Couldn't create debugfs '%s' entry\n",
>> >> +                                                       entry->name);
>> >> +       return entry;
>> >> +}
>> >> +
>> >> +static int remove_ktrace(struct kernel_trace *ktrace, int free)
>> >> +{
>> >> +       struct ktrace_entry *entry;
>> >> +       size_t name_len = strlen(ktrace->name) + 1;
>> >> +       u32 hash = jhash(ktrace->name, name_len-1, 0);
>> >> +       struct hlist_head *head;
>> >> +       struct hlist_node *node, *temp;
>> >> +       struct dentry *dentry;
>> >> +
>> >> +       if (!tracedir)
>> >> +               return 0;
>> >> +       list_del(&ktrace->list);
>> >> +       head = &ktrace_table[hash & ((1 << KTRACE_HASH_BITS)-1)];
>> >> +       hlist_for_each_entry_safe(entry, node, temp, head, hlist)
>> >> +               if (!strcmp(ktrace->name, entry->name)) {
>> >> +                       if (list_empty(&entry->klist)) {
>> >> +                               dentry = lookup_one_len(entry->name,
>> >> +                                       eventdir, strlen(entry->name));
>> >> +                               if (dentry && !IS_ERR(dentry)) {
>> >> +                                       debugfs_remove(dentry);
>> >> +                                       dput(dentry);
>> >> +                               }
>> >> +                               entry->enabled = 0;
>> >> +                               if (free) {
>> >> +                                       hlist_del(&entry->hlist);
>> >> +                                       kfree(entry->name);
>> >> +                                       kfree(entry->format);
>> >> +                                       kfree(entry->stroff);
>> >> +                                       kfree(entry);
>> >> +                               }
>> >> +                       }
>> >> +                       return 0;
>> >> +               }
>> >> +       return -1;
>> >> +}
>> >> +
>> >> +/* Add/remove tracepoints contained in a module to the ktrace hash table.
>> >> + * Called at the end of module load/unload. */
>> >> +static int ktrace_module_notify(struct notifier_block *self,
>> >> +               unsigned long val, void *data)
>> >> +{
>> >> +#ifdef CONFIG_MODULES
>> >> +       struct kernel_trace *iter;
>> >> +       struct module *mod = data;
>> >> +
>> >> +       if (val != MODULE_STATE_COMING && val != MODULE_STATE_GOING)
>> >> +               return 0;
>> >> +       mutex_lock(&ktrace_mutex);
>> >> +       for (iter = mod->ktrace; iter < mod->ktrace + mod->num_ktrace; iter++)
>> >> +               if (val == MODULE_STATE_COMING)
>> >> +                       add_ktrace(iter);
>> >> +               else
>> >> +                       remove_ktrace(iter, 0);
>> >> +       mutex_unlock(&ktrace_mutex);
>> >> +#endif
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static struct notifier_block ktrace_module_nb = {
>> >> +       .notifier_call  = ktrace_module_notify,
>> >> +};
>> >> +
>> >> +/* functions for user-space programs to read data from tracing buffer */
>> >> +static int trace_data_open(struct inode *inode, struct file *filp)
>> >> +{
>> >> +       filp->private_data = inode->i_private;
>> >> +       kref_get(&ktrace_kref);
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static void release_trace_buffer(struct kref *kref)
>> >> +{
>> >> +       ring_buffer_free(trace_buffer);
>> >> +       trace_buffer = NULL;
>> >> +}
>> >> +
>> >> +static int trace_data_release(struct inode *inode, struct file *filp)
>> >> +{
>> >> +       kref_put(&ktrace_kref, release_trace_buffer);
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static unsigned int trace_data_poll(struct file *filp, poll_table *poll_table)
>> >> +{
>> >> +       struct ring_buffer_per_cpu *cpu_buffer = filp->private_data;
>> >> +       if (filp->f_mode & FMODE_READ) {
>> >> +               if (!ring_buffer_per_cpu_empty(cpu_buffer))
>> >> +                       return POLLIN | POLLRDNORM;
>> >> +               poll_wait(filp, &trace_wait, poll_table);
>> >> +               if (!ring_buffer_per_cpu_empty(cpu_buffer))
>> >> +                       return POLLIN | POLLRDNORM;
>> >> +       }
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static int trace_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>> >> +{
>> >> +       struct ring_buffer_per_cpu *cpu_buffer = vma->vm_private_data;
>> >> +       pgoff_t pgoff = vmf->pgoff;
>> >> +       struct page *page;
>> >> +
>> >> +       if (!trace_buffer)
>> >> +               return VM_FAULT_OOM;
>> >> +       page = ring_buffer_get_page(cpu_buffer, pgoff);
>> >> +       if (page == NULL)
>> >> +               return VM_FAULT_SIGBUS;
>> >> +       get_page(page);
>> >> +       vmf->page = page;
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static struct vm_operations_struct trace_data_mmap_ops = {
>> >> +       .fault = trace_buf_fault,
>> >> +};
>> >> +
>> >> +static int trace_data_mmap(struct file *filp, struct vm_area_struct *vma)
>> >> +{
>> >> +       struct ring_buffer_per_cpu *cpu_buffer = filp->private_data;
>> >> +
>> >> +       vma->vm_ops = &trace_data_mmap_ops;
>> >> +       vma->vm_flags |= VM_DONTEXPAND;
>> >> +       vma->vm_private_data = cpu_buffer;
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static int trace_data_ioctl(struct inode *inode, struct file *filp,
>> >> +               unsigned int cmd, unsigned long arg)
>> >> +{
>> >> +       u32 __user *argp = (u32 __user *)arg;
>> >> +       struct ring_buffer_per_cpu *cpu_buffer = filp->private_data;
>> >> +
>> >> +       if (!trace_buffer || !tracedir)
>> >> +               return -EINVAL;
>> >> +       switch (cmd) {
>> >> +       case KTRACE_BUF_GET_SIZE:
>> >> +       {
>> >> +               unsigned long bufsize;
>> >> +               bufsize = ring_buffer_size(trace_buffer);
>> >> +               return put_user((u32)bufsize, argp);
>> >> +       }
>> >> +       case KTRACE_BUF_GET_PRODUCED:
>> >> +               return put_user(ring_buffer_get_produced(cpu_buffer), argp);
>> >> +       case KTRACE_BUF_GET_CONSUMED:
>> >> +               return put_user(ring_buffer_get_consumed(cpu_buffer), argp);
>> >> +       case KTRACE_BUF_PUT_CONSUMED:
>> >> +       {
>> >> +               u32 consumed, consumed_old;
>> >> +               int ret;
>> >> +
>> >> +               ret = get_user(consumed, argp);
>> >> +               if (ret) {
>> >> +                       printk(KERN_WARNING
>> >> +                               "error getting consumed value: %d\n", ret);
>> >> +                       return ret;
>> >> +               }
>> >> +               consumed_old = ring_buffer_get_consumed(cpu_buffer);
>> >> +               if (consumed == consumed_old)
>> >> +                       return 0;
>> >> +               ring_buffer_advance_reader(cpu_buffer, consumed - consumed_old);
>> >> +               return 0;
>> >> +       }
>> >> +       default:
>> >> +               return -ENOIOCTLCMD;
>> >> +       }
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static const struct file_operations tracedata_file_operations = {
>> >> +       .open           = trace_data_open,
>> >> +       .poll           = trace_data_poll,
>> >> +       .mmap           = trace_data_mmap,
>> >> +       .ioctl          = trace_data_ioctl,
>> >> +       .release        = trace_data_release,
>> >> +};
>> >> +
>> >> +/* function to report the number of lost events due to buffer overflow */
>> >> +static ssize_t trace_overflow_read(struct file *filp, char __user *ubuf,
>> >> +               size_t cnt, loff_t *ppos)
>> >> +{
>> >> +       int ret;
>> >> +       char buf[64];
>> >> +       ret = snprintf(buf, 64, "%lu\n", ring_buffer_overruns(trace_buffer));
>> >> +       return simple_read_from_buffer(ubuf, cnt, ppos, buf, ret);
>> >> +}
>> >> +
>> >> +static const struct file_operations traceoverflow_file_operations = {
>> >> +       .read           = trace_overflow_read,
>> >> +};
>> >> +
>> >> +/* function to re-initialize trace buffer */
>> >> +static void __trace_buffer_reset(struct file *filp,
>> >> +               unsigned long val, size_t *cnt)
>> >> +{
>> >> +       if (val && trace_buffer)
>> >> +               ring_buffer_reset(trace_buffer);
>> >> +}
>> >> +
>> >> +static ssize_t trace_buffer_reset(struct file *filp, const char __user *ubuf,
>> >> +               size_t cnt, loff_t *ppos)
>> >> +{
>> >> +       return trace_debugfs_write(filp, ubuf, cnt, ppos,
>> >> +                       __trace_buffer_reset);
>> >> +}
>> >> +
>> >> +static const struct file_operations tracereset_file_operations = {
>> >> +       .write          = trace_buffer_reset,
>> >> +};
>> >> +
>> >> +/*
>> >> + * We use debugfs for kernel-user communication. All of the control/info
>> >> + * files are under debugfs/ktrace directory.
>> >> + */
>> >> +static int create_debugfs(void)
>> >> +{
>> >> +       struct dentry *entry, *bufdir;
>> >> +       struct ring_buffer_per_cpu *cpu_buffer;
>> >> +       char *tmpname;
>> >> +       int cpu;
>> >> +
>> >> +       tracedir = debugfs_create_dir("ktrace", NULL);
>> >> +       if (!tracedir) {
>> >> +               printk(KERN_WARNING "Couldn't create debugfs directory\n");
>> >> +               return -ENOMEM;
>> >> +       }
>> >> +
>> >> +       /* 'buffers' is the directory that holds trace buffer debugfs files */
>> >> +       bufdir = debugfs_create_dir("buffers", tracedir);
>> >> +       if (!bufdir) {
>> >> +               printk(KERN_WARNING "Couldn't create 'buffers' directory\n");
>> >> +               return -ENOMEM;
>> >> +       }
>> >> +
>> >> +       tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
>> >> +       if (!tmpname)
>> >> +               return -ENOMEM;
>> >> +       /* create a debugfs file for each cpu buffer */
>> >> +       for_each_possible_cpu(cpu) {
>> >> +               snprintf(tmpname, NAME_MAX, "%s%d", "cpu", cpu);
>> >> +               cpu_buffer = ring_buffer_cpu(trace_buffer, cpu);
>> >> +               entry = debugfs_create_file(tmpname, 0440, bufdir, cpu_buffer,
>> >> +                       &tracedata_file_operations);
>> >> +               if (!entry) {
>> >> +                       printk(KERN_WARNING
>> >> +                               "Couldn't create debugfs \'%s\' entry\n",
>> >> +                                       tmpname);
>> >> +                       return -ENOMEM;
>> >> +               }
>> >> +       }
>> >> +       kfree(tmpname);
>> >> +
>> >> +       /* the control file for users to enable/disable global tracing. */
>> >> +       entry = debugfs_create_file("enabled", 0664, tracedir, NULL,
>> >> +                       &tracecontrol_file_operations);
>> >> +       if (!entry) {
>> >> +               printk(KERN_WARNING
>> >> +                       "Couldn't create debugfs 'enabled' entry\n");
>> >> +               return -ENOMEM;
>> >> +       }
>> >> +
>> >> +       /*
>> >> +        * the debugfs file that displays the name, format etc. of every
>> >> +        * supported trace event. The file is to be used by the user-space
>> >> +        * trace parser to analyze the collected trace data.
>> >> +        */
>> >> +       entry = debugfs_create_file("info", 0444, tracedir, NULL,
>> >> +                       &traceinfo_file_operations);
>> >> +       if (!entry) {
>> >> +               printk(KERN_WARNING "Couldn't create debugfs 'info' entry\n");
>> >> +               return -ENOMEM;
>> >> +       }
>> >> +
>> >> +       /*
>> >> +        * the debugfs file that reports the number of events
>> >> +        * lost due to buffer overflow
>> >> +        */
>> >> +       entry = debugfs_create_file("overflow", 0444, tracedir, NULL,
>> >> +                       &traceoverflow_file_operations);
>> >> +       if (!entry) {
>> >> +               printk(KERN_WARNING
>> >> +                       "Couldn't create debugfs 'overflow' entry\n");
>> >> +               return -ENOMEM;
>> >> +       }
>> >> +
>> >> +       /* the debugfs file that resets trace buffer upon write */
>> >> +       entry = debugfs_create_file("reset", 0220, tracedir, NULL,
>> >> +                       &tracereset_file_operations);
>> >> +       if (!entry) {
>> >> +               printk(KERN_WARNING "Couldn't create debugfs 'reset' entry\n");
>> >> +               return -ENOMEM;
>> >> +       }
>> >> +
>> >> +       /* create the directory that holds the control files for every event */
>> >> +       eventdir = debugfs_create_dir("events", tracedir);
>> >> +       if (!eventdir) {
>> >> +               printk(KERN_WARNING "Couldn't create 'events' directory\n");
>> >> +               return -ENOMEM;
>> >> +       }
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static void remove_debugfs_file(struct dentry *dir, char *name)
>> >> +{
>> >> +       struct dentry *dentry;
>> >> +       dentry = lookup_one_len(name, dir, strlen(name));
>> >> +       if (dentry && !IS_ERR(dentry)) {
>> >> +               debugfs_remove(dentry);
>> >> +               dput(dentry);
>> >> +       }
>> >> +}
>> >> +
>> >> +static int remove_debugfs(void)
>> >> +{
>> >> +       struct dentry *bufdir;
>> >> +       char *tmpname;
>> >> +       int cpu;
>> >> +
>> >> +       bufdir = lookup_one_len("buffers", tracedir, strlen("buffers"));
>> >> +       if (!bufdir || IS_ERR(bufdir))
>> >> +               return -EIO;
>> >> +       tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
>> >> +       if (!tmpname)
>> >> +               return -ENOMEM;
>> >> +       for_each_possible_cpu(cpu) {
>> >> +               snprintf(tmpname, NAME_MAX, "%s%d", "cpu", cpu);
>> >> +               remove_debugfs_file(bufdir, tmpname);
>> >> +       }
>> >> +       kfree(tmpname);
>> >> +       debugfs_remove(bufdir);
>> >> +
>> >> +       remove_debugfs_file(tracedir, "enabled");
>> >> +       remove_debugfs_file(tracedir, "info");
>> >> +       debugfs_remove(eventdir);
>> >> +       debugfs_remove(tracedir);
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static int __init init_ktrace(void)
>> >> +{
>> >> +       struct kernel_trace *iter;
>> >> +       int i, err;
>> >> +
>> >> +       ktrace_next_id = 0;
>> >> +       kref_set(&ktrace_kref, 1);
>> >> +       trace_buffer = ring_buffer_alloc(trace_buf_size, RB_FL_OVERWRITE);
>> >> +       if (trace_buffer == NULL)
>> >> +               return -ENOMEM;
>> >> +       setup_timer(&trace_timer, wakeup_readers, 0);
>> >> +       for (i = 0; i < KTRACE_HASH_SIZE; i++)
>> >> +               INIT_HLIST_HEAD(&ktrace_table[i]);
>> >> +
>> >> +       mutex_lock(&ktrace_mutex);
>> >> +       err = create_debugfs();
>> >> +       if (err != 0)
>> >> +               goto out;
>> >> +       for (iter = __start___ktraces; iter < __stop___ktraces; iter++)
>> >> +               add_ktrace(iter);
>> >> +       err = register_module_notifier(&ktrace_module_nb);
>> >> +out:
>> >> +       mutex_unlock(&ktrace_mutex);
>> >> +       return err;
>> >> +}
>> >> +module_init(init_ktrace);
>> >> +
>> >> +static void __exit exit_ktrace(void)
>> >> +{
>> >> +       struct kernel_trace *iter;
>> >> +
>> >> +       if (ktrace_enabled) {
>> >> +               ktrace_enabled = 0;
>> >> +               del_timer_sync(&trace_timer);
>> >> +       }
>> >> +       mutex_lock(&ktrace_mutex);
>> >> +       for (iter = __start___ktraces; iter < __stop___ktraces; iter++)
>> >> +               remove_ktrace(iter, 1);
>> >> +       unregister_module_notifier(&ktrace_module_nb);
>> >> +       remove_debugfs();
>> >> +       mutex_unlock(&ktrace_mutex);
>> >> +
>> >> +       kref_put(&ktrace_kref, release_trace_buffer);
>> >> +}
>> >
>> > --
>> > Mathieu Desnoyers
>> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
>> >
>
> --
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
>
