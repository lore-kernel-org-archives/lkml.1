Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZILLNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZILLNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZILLNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:13:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZILLNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:13:12 -0400
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree
 build warning)
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090912073906.GA3972@elte.hu>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	 <1249403089.4634.139.camel@localhost.localdomain>
	 <20090912165300.9d257283.sfr@canb.auug.org.au>
	 <20090912073906.GA3972@elte.hu>
Content-Type: text/plain
Date: Sat, 12 Sep 2009 16:42:37 +0530
Message-Id: <1252753957.12217.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 09:39 +0200, Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Steve,
> > 
> > On Tue, 04 Aug 2009 12:24:49 -0400 Steven Rostedt <srostedt@redhat.com> wrote:
> > >
> > > On Tue, 2009-08-04 at 16:16 +1000, Stephen Rothwell wrote:
> > > > 
> > > > Today's linux-next build (powerpc ppc64_defconfig) produced these warnings:
> > > > 
> > > > kernel/trace/ring_buffer.c: In function 'rb_head_page_set':
> > > > kernel/trace/ring_buffer.c:704: warning: initialization makes pointer from integer without a cast
> > > > kernel/trace/ring_buffer.c:704: warning: initialization makes pointer from integer without a cast
> > > > kernel/trace/ring_buffer.c: In function 'rb_head_page_replace':
> > > > kernel/trace/ring_buffer.c:797: warning: initialization makes integer from pointer without a cast
> > > > 
> > > > Introduced by commit 77ae365eca895061c8bf2b2e3ae1d9ea62869739
> > > > ("ring-buffer: make lockless").
> > > 
> > > Thanks, I'll take a look at it.
> > 
> > Now that this is in Linus' tree, can we have a fix for the waning, 
> > please?
> 
> The first warning got fixed 1.5 months ago - the second one at line 
> 797 is still there but harmless - you can ignore it for now, it will 
> be fixed.
> 

Here are some more trace related warnings in current linus (as well as
-tip) tree :

  CHECK   arch/x86/kernel/ptrace.c
include/trace/events/syscalls.h:18:1: warning: symbol 'ftrace_raw_output_sys_enter' was not declared. Should it be static?
include/trace/events/syscalls.h:42:1: warning: symbol 'ftrace_raw_output_sys_exit' was not declared. Should it be static?
include/trace/events/syscalls.h:18:1: warning: symbol 'ftrace_define_fields_sys_enter' was not declared. Should it be static?
include/trace/events/syscalls.h:42:1: warning: symbol 'ftrace_define_fields_sys_exit' was not declared. Should it be static?
include/trace/events/syscalls.h:18:1: error: bad constant expression
include/trace/events/syscalls.h:42:1: error: bad constant expression

  CHECK   kernel/sched.c
include/trace/events/sched.h:152:1: warning: symbol 'flags' shadows an earlier one
include/trace/events/sched.h:152:1: originally declared here
include/trace/events/sched.h:13:1: warning: symbol 'ftrace_raw_output_sched_kthread_stop' was not declared. Should it be static?
include/trace/events/sched.h:35:1: warning: symbol 'ftrace_raw_output_sched_kthread_stop_ret' was not declared. Should it be static?
include/trace/events/sched.h:58:1: warning: symbol 'ftrace_raw_output_sched_wait_task' was not declared. Should it be static?
include/trace/events/sched.h:86:1: warning: symbol 'ftrace_raw_output_sched_wakeup' was not declared. Should it be static?
include/trace/events/sched.h:119:1: warning: symbol 'ftrace_raw_output_sched_wakeup_new' was not declared. Should it be static?
include/trace/events/sched.h:152:1: warning: symbol 'ftrace_raw_output_sched_switch' was not declared. Should it be static?
include/trace/events/sched.h:192:1: warning: symbol 'ftrace_raw_output_sched_migrate_task' was not declared. Should it be static?
include/trace/events/sched.h:222:1: warning: symbol 'ftrace_raw_output_sched_process_free' was not declared. Should it be static?
include/trace/events/sched.h:247:1: warning: symbol 'ftrace_raw_output_sched_process_exit' was not declared. Should it be static?
include/trace/events/sched.h:272:1: warning: symbol 'ftrace_raw_output_sched_process_wait' was not declared. Should it be static?
include/trace/events/sched.h:297:1: warning: symbol 'ftrace_raw_output_sched_process_fork' was not declared. Should it be static?
include/trace/events/sched.h:325:1: warning: symbol 'ftrace_raw_output_sched_signal_send' was not declared. Should it be static?
include/trace/events/sched.h:356:1: warning: symbol 'ftrace_raw_output_sched_stat_wait' was not declared. Should it be static?
include/trace/events/sched.h:386:1: warning: symbol 'ftrace_raw_output_sched_stat_sleep' was not declared. Should it be static?
include/trace/events/sched.h:416:1: warning: symbol 'ftrace_raw_output_sched_stat_iowait' was not declared. Should it be static?
include/trace/events/sched.h:13:1: warning: symbol 'ftrace_define_fields_sched_kthread_stop' was not declared. Should it be static?
include/trace/events/sched.h:35:1: warning: symbol 'ftrace_define_fields_sched_kthread_stop_ret' was not declared. Should it be static?
include/trace/events/sched.h:58:1: warning: symbol 'ftrace_define_fields_sched_wait_task' was not declared. Should it be static?
include/trace/events/sched.h:86:1: warning: symbol 'ftrace_define_fields_sched_wakeup' was not declared. Should it be static?
include/trace/events/sched.h:119:1: warning: symbol 'ftrace_define_fields_sched_wakeup_new' was not declared. Should it be static?
include/trace/events/sched.h:152:1: warning: symbol 'ftrace_define_fields_sched_switch' was not declared. Should it be static?
include/trace/events/sched.h:192:1: warning: symbol 'ftrace_define_fields_sched_migrate_task' was not declared. Should it be static?
include/trace/events/sched.h:222:1: warning: symbol 'ftrace_define_fields_sched_process_free' was not declared. Should it be static?
include/trace/events/sched.h:247:1: warning: symbol 'ftrace_define_fields_sched_process_exit' was not declared. Should it be static?
include/trace/events/sched.h:272:1: warning: symbol 'ftrace_define_fields_sched_process_wait' was not declared. Should it be static?
include/trace/events/sched.h:297:1: warning: symbol 'ftrace_define_fields_sched_process_fork' was not declared. Should it be static?
include/trace/events/sched.h:325:1: warning: symbol 'ftrace_define_fields_sched_signal_send' was not declared. Should it be static?
include/trace/events/sched.h:356:1: warning: symbol 'ftrace_define_fields_sched_stat_wait' was not declared. Should it be static?
include/trace/events/sched.h:386:1: warning: symbol 'ftrace_define_fields_sched_stat_sleep' was not declared. Should it be static?
include/trace/events/sched.h:416:1: warning: symbol 'ftrace_define_fields_sched_stat_iowait' was not declared. Should it be static?
include/trace/events/sched.h:13:1: error: bad constant expression
include/trace/events/sched.h:35:1: error: bad constant expression
include/trace/events/sched.h:58:1: error: bad constant expression
include/trace/events/sched.h:86:1: error: bad constant expression
include/trace/events/sched.h:119:1: error: bad constant expression
include/trace/events/sched.h:152:1: error: bad constant expression
include/trace/events/sched.h:192:1: error: bad constant expression
include/trace/events/sched.h:222:1: error: bad constant expression
include/trace/events/sched.h:247:1: error: bad constant expression
include/trace/events/sched.h:272:1: error: bad constant expression
include/trace/events/sched.h:297:1: error: bad constant expression
include/trace/events/sched.h:325:1: error: bad constant expression
include/trace/events/sched.h:356:1: error: bad constant expression
include/trace/events/sched.h:386:1: error: bad constant expression
include/trace/events/sched.h:416:1: error: bad constant expression

  CHECK   kernel/softirq.c
include/trace/events/irq.h:34:1: warning: symbol 'ftrace_raw_output_irq_handler_entry' was not declared. Should it be static?
include/trace/events/irq.h:64:1: warning: symbol 'ftrace_raw_output_irq_handler_exit' was not declared. Should it be static?
include/trace/events/irq.h:95:1: warning: symbol 'ftrace_raw_output_softirq_entry' was not declared. Should it be static?
include/trace/events/irq.h:124:1: warning: symbol 'ftrace_raw_output_softirq_exit' was not declared. Should it be static?
include/trace/events/irq.h:34:1: warning: symbol 'ftrace_define_fields_irq_handler_entry' was not declared. Should it be static?
include/trace/events/irq.h:64:1: warning: symbol 'ftrace_define_fields_irq_handler_exit' was not declared. Should it be static?
include/trace/events/irq.h:95:1: warning: symbol 'ftrace_define_fields_softirq_entry' was not declared. Should it be static?
include/trace/events/irq.h:124:1: warning: symbol 'ftrace_define_fields_softirq_exit' was not declared. Should it be static?
include/trace/events/irq.h:34:1: error: bad constant expression
include/trace/events/irq.h:64:1: error: bad constant expression
include/trace/events/irq.h:95:1: error: bad constant expression
include/trace/events/irq.h:124:1: error: bad constant expression

  CHECK   kernel/ptrace.c
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:532:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:538:32: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:543:33: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
kernel/ptrace.c:653:9: warning: cast adds address space to expression (<asn:1>)
include/linux/sched.h:2192:2: warning: context problem in 'ptrace_getsiginfo': '_spin_unlock_irqrestore' expected different context
include/linux/sched.h:2192:2:    context 'lock': wanted >= 1, got 0
include/linux/sched.h:2192:2: warning: context problem in 'ptrace_setsiginfo': '_spin_unlock_irqrestore' expected different context
include/linux/sched.h:2192:2:    context 'lock': wanted >= 1, got 0

  CHECK   kernel/workqueue.c
include/trace/events/workqueue.h:11:1: warning: symbol 'ftrace_raw_output_workqueue_insertion' was not declared. Should it be static?
include/trace/events/workqueue.h:33:1: warning: symbol 'ftrace_raw_output_workqueue_execution' was not declared. Should it be static?
include/trace/events/workqueue.h:56:1: warning: symbol 'ftrace_raw_output_workqueue_creation' was not declared. Should it be static?
include/trace/events/workqueue.h:78:1: warning: symbol 'ftrace_raw_output_workqueue_destruction' was not declared. Should it be static?
include/trace/events/workqueue.h:11:1: error: incompatible types for operation (<)
include/trace/events/workqueue.h:11:1:    left side has type void ( *[usertype] <noident> )( ... )
include/trace/events/workqueue.h:11:1:    right side has type int
include/trace/events/workqueue.h:33:1: error: incompatible types for operation (<)
include/trace/events/workqueue.h:33:1:    left side has type void ( *[usertype] <noident> )( ... )
include/trace/events/workqueue.h:33:1:    right side has type int
include/trace/events/workqueue.h:11:1: error: bad constant expression
include/trace/events/workqueue.h:33:1: error: bad constant expression
include/trace/events/workqueue.h:56:1: error: bad constant expression
include/trace/events/workqueue.h:78:1: error: bad constant expression

  CHECK   kernel/trace/ring_buffer.c
kernel/trace/ring_buffer.c:1752:2: warning: do-while statement is not a compound statement
kernel/trace/ring_buffer.c:1917:2: warning: do-while statement is not a compound statement
kernel/trace/ring_buffer.c:1752:2: error: bad constant expression
kernel/trace/ring_buffer.c:1752:2: error: cannot size expression
kernel/trace/ring_buffer.c:1917:2: error: bad constant expression
kernel/trace/ring_buffer.c:1917:2: error: cannot size expression

  CHECK   kernel/trace/trace.c
kernel/trace/trace.c:3721:16: warning: symbol 'd_tracer' shadows an earlier one
kernel/trace/trace.c:3693:22: originally declared here
kernel/trace/trace.c:3744:16: warning: symbol 'd_percpu' shadows an earlier one
kernel/trace/trace.c:3716:22: originally declared here
kernel/trace/trace.c:3937:16: warning: symbol 'd_tracer' shadows an earlier one
kernel/trace/trace.c:3693:22: originally declared here
kernel/trace/trace.c:4051:16: warning: symbol 'd_tracer' shadows an earlier one
kernel/trace/trace.c:3693:22: originally declared here
kernel/trace/trace.c:2492:30: error: bad constant expression
kernel/trace/trace.c:2642:30: error: bad constant expression

  CHECK   kernel/trace/trace_events.c
kernel/trace/trace_events.c:1190:23: warning: symbol 'trace_module_nb' was not declared. Should it be static?

  CHECK   kernel/trace/trace_export.c
kernel/trace/trace_event_types.h:63:1: warning: symbol 'event_special' was not declared. Should it be static?
kernel/trace/trace_event_types.h:108:1: error: incompatible types for operation (<)
kernel/trace/trace_event_types.h:108:1:    left side has type char *<noident>
kernel/trace/trace_event_types.h:108:1:    right side has type int
kernel/trace/trace_event_types.h:155:1: error: incompatible types for operation (<)
kernel/trace/trace_event_types.h:155:1:    left side has type void const *<noident>
kernel/trace/trace_event_types.h:155:1:    right side has type int
kernel/trace/trace_event_types.h:169:1: error: incompatible types for operation (<)
kernel/trace/trace_event_types.h:169:1:    left side has type void const *<noident>
kernel/trace/trace_event_types.h:169:1:    right side has type int

  CHECK   kernel/trace/trace_event_profile.c
kernel/trace/trace_event_profile.c:10:5: warning: symbol 'ftrace_profile_enable' was not declared. Should it be static?
kernel/trace/trace_event_profile.c:27:6: warning: symbol 'ftrace_profile_disable' was not declared. Should it be static?

  CHECK   kernel/trace/trace_events_filter.c
kernel/trace/trace_events_filter.c:634:44: warning: incorrect type in argument 3 (different signedness)
kernel/trace/trace_events_filter.c:634:44:    expected long long *<noident>
kernel/trace/trace_events_filter.c:634:44:    got unsigned long long *<noident>

  CHECK   kernel/lockdep.c
include/trace/events/lockdep.h:12:1: warning: symbol 'ftrace_raw_output_lock_acquire' was not declared. Should it be static?
include/trace/events/lockdep.h:35:1: warning: symbol 'ftrace_raw_output_lock_release' was not declared. Should it be static?
include/trace/events/lockdep.h:54:1: warning: symbol 'ftrace_raw_output_lock_contended' was not declared. Should it be static?
include/trace/events/lockdep.h:71:1: warning: symbol 'ftrace_raw_output_lock_acquired' was not declared. Should it be static?
include/trace/events/lockdep.h:12:1: warning: symbol 'ftrace_define_fields_lock_acquire' was not declared. Should it be static?
include/trace/events/lockdep.h:35:1: warning: symbol 'ftrace_define_fields_lock_release' was not declared. Should it be static?
include/trace/events/lockdep.h:54:1: warning: symbol 'ftrace_define_fields_lock_contended' was not declared. Should it be static?
include/trace/events/lockdep.h:71:1: warning: symbol 'ftrace_define_fields_lock_acquired' was not declared. Should it be static?
include/trace/events/lockdep.h:12:1: error: bad constant expression
include/trace/events/lockdep.h:35:1: error: bad constant expression
include/trace/events/lockdep.h:54:1: error: bad constant expression
include/trace/events/lockdep.h:71:1: error: bad constant expression

  CHECK   kernel/module.c
include/trace/events/module.h:18:1: warning: symbol 'flags' shadows an earlier one
include/trace/events/module.h:18:1: originally declared here
kernel/module.c:247:20: warning: symbol 'arr' shadows an earlier one
kernel/module.c:224:25: originally declared here
kernel/module.c:2281:14: warning: symbol 'strtab' shadows an earlier one
kernel/module.c:1948:38: originally declared here
include/trace/events/module.h:98:1: error: cannot size expression
include/trace/events/module.h:98:1: error: cannot size expression
include/trace/events/module.h:18:1: error: bad constant expression
include/trace/events/module.h:37:1: error: bad constant expression
include/trace/events/module.h:54:1: error: bad constant expression
include/trace/events/module.h:76:1: error: bad constant expression
include/trace/events/module.h:98:1: error: bad constant expression

  CHECK   kernel/tracepoint.c
kernel/tracepoint.c:559:5: warning: symbol 'tracepoint_module_notify' was not declared. Should it be static?
kernel/tracepoint.c:574:23: warning: symbol 'tracepoint_module_nb' was not declared. Should it be static?
kernel/tracepoint.c:592:6: warning: symbol 'syscall_regfunc' was not declared. Should it be static?
kernel/tracepoint.c:609:6: warning: symbol 'syscall_unregfunc' was not declared. Should it be static?

And some includecheck warnings in -tip :

arch/x86/kernel/dumpstack.c: linux/ftrace.h is included more than once.
arch/x86/kernel/syscall_64.c: asm/unistd_64.h is included more than once.
arch/x86/kernel/traps.c: asm/traps.h is included more than once.
arch/x86/kvm/mmu.c: paging_tmpl.h is included more than once.
arch/x86/mm/kmemcheck/shadow.c: linux/module.h is included more than once.
arch/x86/vdso/vma.c: vextern.h is included more than once.

I have send various patches to fix some of these warnings but no action taken.

Thanks,
--
JSR

