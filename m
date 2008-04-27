Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYD0Gaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYD0Gaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 02:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYD0Gac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 02:30:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57145 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYD0Gaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 02:30:30 -0400
Date: Sun, 27 Apr 2008 08:30:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: [patch] ftrace, v15
Message-ID: <20080427063019.GA23295@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the current/latest ftrace tree can be pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

the full diffs are too large to be included here, but the shortlog and 
the diffstat is below. Not much changed in the fundamentals since the 
last lkml posting - but many small details were refined.

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      ftrace: annotate core code that should not be traced
      ftrace: add basic support for gcc profiler instrumentation

Dmitry Adamushko (1):
      latencytop: optimize LT_BACKTRACEDEPTH loops a bit

Guillaume Chazarain (2):
      sched: fix rq->clock overflows detection with CONFIG_NO_HZ
      sched: make sure jiffies is up to date before calling __update_rq_clock()

Ingo Molnar (34):
      sched: add latency tracer callbacks to the scheduler
      tracing: add notrace to linkage.h
      ftrace: fix kexec
      ftrace: cleanups, #1
      ftrace: add readme
      ftrace: fix #2
      ftrace: fix
      ftrace: cleanups
      ftrace: timestamp syncing, prepare
      ftrace: fast, scalable, synchronized timestamps
      ftrace: remove-idx-sync
      ftrace: clean-up-pipe-iteration
      ftrace: add raw output
      ftrace: bin-output
      ftrace: add sysprof plugin
      time: add ns_to_ktime()
      ftrace: extend-sysprof-plugin
      ftrace: add-special-trace
      ftrace: extend-sysprof-plugin2
      ftrace: sysprof-plugin, #3
      x86: patches/ftrace-sysprof-plugin4.patch
      ftrace, fix #5
      x86: patches/ftrace-fix6.patch
      ftrace: sysprof fix
      sched: make cpu_clock() globally synchronous
      x86: patches/ftrace-use-cpu-clock-again.patch
      x86: spinlocks-always-inlined
      ftrace: cpu_clock & ftrace fix
      ftrace: fix #8
      ftrace: introduce the "hex" output method
      x86: ../../patches/ftrace-fix10.patch
      ftrace: fix #11
      x86: patches/ftrace-fix12.patch
      sched: add sched-devel.git tag

Jan Kiszka (1):
      printk: don't prefer unsuited consoles on registration

Paul E. McKenney (2):
      rcupreempt: fix hibernate/resume in presence of PREEMPT_RCU and hotplug
      rcupreempt: remove never-migrates assumption from rcu_process_callbacks()

Peter Zijlstra (9):
      sched: revert load_balance_monitor() changes
      sched: rt-group: synchonised bandwidth period
      sched: rt-group: smp balancing
      sched: cleanup old and rarely used 'debug' features.
      sched: fix regression with sched yield
      sched: remove isolcpus
      cpuset: system sets
      genirq: system set irq affinities
      kthread: system set kthread affinities

Srivatsa Vaddagiri (1):
      sched: group scheduler fix

Steven Rostedt (34):
      ftrace: add preempt_enable/disable notrace macros
      ftrace: make the task state char-string visible to all
      x86: add notrace annotations to vsyscall.
      ftrace: latency tracer infrastructure
      ftrace: function tracer
      ftrace: add tracing of context switches
      ftrace: tracer for scheduler wakeup latency
      ftrace: trace irq disabled critical timings
      ftrace: trace preempt off critical timings
      ftrace: dynamic enabling/disabling of function calls
      ftrace: add ftrace_enabled sysctl to disable mcount function
      ftrace: use nops instead of jmp
      ftrace: move memory management out of arch code
      ftrace: use dynamic patching for updating mcount calls
      ftrace: add filter select functions to trace
      ftrace: convert single large buffer into single pages.
      ftrace: debug smp_processor_id, use notrace preempt disable
      ftrace: irqs off smp_processor_id() fix
      ftrace: lockdep notrace annotations
      ftrace: don't use raw_local_irq_save/restore
      ftrace: fix updates to max trace
      ftrace: fix max latency
      ftrace: force recording
      ftrace: self-tests
      ftrace: startup tester on dynamic tracing.
      ftrace: disable all tracers on corrupted buffer
      ftrace: reset selftests
      ftrace: change buffers to producer consumer
      trace - add a buffer for output
      ftrace: user run time file reading
      ftrace: pipe fixes
      ftrace - fix dynamic ftrace memory leak
      ftrace: disable tracing on failure
      ftrace: enabled tracing by default

Tejun Heo (1):
      printk: clean up recursion check related static variables

 Makefile                           |    4 +
 arch/alpha/kernel/irq.c            |    2 +-
 arch/x86/Kconfig                   |    1 +
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/alternative.c      |    4 +-
 arch/x86/kernel/entry_32.S         |   68 +
 arch/x86/kernel/entry_64.S         |  102 ++
 arch/x86/kernel/ftrace.c           |  159 +++
 arch/x86/kernel/machine_kexec_32.c |    4 +
 arch/x86/kernel/machine_kexec_64.c |    4 +
 arch/x86/kernel/process_32.c       |    3 +
 arch/x86/kernel/process_64.c       |    3 +
 arch/x86/kernel/vsyscall_64.c      |    3 +-
 arch/x86/lib/Makefile              |    1 +
 arch/x86/lib/thunk_32.S            |   47 +
 arch/x86/lib/thunk_64.S            |   19 +-
 arch/x86/vdso/vclock_gettime.c     |   15 +-
 arch/x86/vdso/vgetcpu.c            |    3 +-
 include/asm-x86/alternative.h      |    2 +
 include/asm-x86/irqflags.h         |   24 +-
 include/asm-x86/spinlock.h         |   12 +-
 include/asm-x86/vsyscall.h         |    3 +-
 include/linux/cpumask.h            |    5 +
 include/linux/cpuset.h             |    2 +
 include/linux/ftrace.h             |  121 ++
 include/linux/irq.h                |    7 -
 include/linux/irqflags.h           |   13 +-
 include/linux/ktime.h              |    6 +
 include/linux/linkage.h            |    2 +
 include/linux/preempt.h            |   34 +-
 include/linux/sched.h              |   39 +-
 kernel/Makefile                    |    2 +
 kernel/cpuset.c                    |  115 ++-
 kernel/fork.c                      |    2 +-
 kernel/irq/manage.c                |   64 +
 kernel/kthread.c                   |   50 +-
 kernel/latencytop.c                |   27 +-
 kernel/lockdep.c                   |   46 +-
 kernel/printk.c                    |   31 +-
 kernel/rcupreempt.c                |    9 +-
 kernel/sched.c                     |  748 ++++++-----
 kernel/sched_fair.c                |  131 +--
 kernel/sched_rt.c                  |  186 +++-
 kernel/spinlock.c                  |    2 +-
 kernel/sysctl.c                    |   33 +-
 kernel/time/tick-sched.c           |    5 -
 kernel/trace/Kconfig               |  128 ++
 kernel/trace/Makefile              |   11 +
 kernel/trace/ftrace.c              | 1395 +++++++++++++++++++++
 kernel/trace/trace.c               | 2434 ++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h               |  255 ++++
 kernel/trace/trace_functions.c     |   76 ++
 kernel/trace/trace_irqsoff.c       |  499 ++++++++
 kernel/trace/trace_sched_switch.c  |  119 ++
 kernel/trace/trace_sched_wakeup.c  |  307 +++++
 kernel/trace/trace_selftest.c      |  554 ++++++++
 kernel/trace/trace_sysprof.c       |  284 +++++
 kernel/user.c                      |   28 +
 lib/Kconfig.debug                  |    2 +
 lib/smp_processor_id.c             |    6 +-
 localversion-sched-devel.git       |    1 +
 61 files changed, 7665 insertions(+), 598 deletions(-)
 create mode 100644 arch/x86/kernel/ftrace.c
 create mode 100644 arch/x86/lib/thunk_32.S
 create mode 100644 include/linux/ftrace.h
 create mode 100644 kernel/trace/Kconfig
 create mode 100644 kernel/trace/Makefile
 create mode 100644 kernel/trace/ftrace.c
 create mode 100644 kernel/trace/trace.c
 create mode 100644 kernel/trace/trace.h
 create mode 100644 kernel/trace/trace_functions.c
 create mode 100644 kernel/trace/trace_irqsoff.c
 create mode 100644 kernel/trace/trace_sched_switch.c
 create mode 100644 kernel/trace/trace_sched_wakeup.c
 create mode 100644 kernel/trace/trace_selftest.c
 create mode 100644 kernel/trace/trace_sysprof.c
 create mode 100644 localversion-sched-devel.git
