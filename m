Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbZCUQLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbZCUQLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZCUQLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:11:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZCUQLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:11:07 -0400
Date: Sat, 21 Mar 2009 17:10:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [tree] Performance Counters for Linux, v7
Message-ID: <20090321161021.GA9826@elte.hu>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com> <20090321055252.eb0673ea.akpm@linux-foundation.org> <20090321155442.GB6356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321155442.GB6356@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


The latest perfcounters/core git tree can be found at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core

There have been lots of updates since the last release:

 - enhanced PowerPC support
 - support for software event profiling
 - enhanced x86 support (support for AMD CPUs)
 - lots of finetuning to the ABI details to make it PAPI capable

There's also been lots of updates to the userspace tools (kerneltop 
and perfstat):

   http://redhat.com/~mingo/perfcounters/kerneltop.c
   http://redhat.com/~mingo/perfcounters/perfstat.c

	Ingo

------------------>
Ingo Molnar (52):
      performance counters: documentation
      performance counters: x86 support
      x86, perfcounters: read out MSR_CORE_PERF_GLOBAL_STATUS with counters disabled
      perfcounters: select ANON_INODES
      perfcounters, x86: simplify disable/enable of counters
      perfcounters, x86: clean up debug code
      perfcounters: consolidate global-disable codepaths
      perf counters: restructure the API
      perf counters: add support for group counters
      perf counters: group counter, fixes
      perf counters: hw driver API
      perf counters: implement PERF_COUNT_CPU_CLOCK
      perf counters: consolidate hw_perf save/restore APIs
      perf counters: implement PERF_COUNT_TASK_CLOCK
      perf counters: add prctl interface to disable/enable counters
      perf counters: clean up state transitions
      perf counters: update docs
      x86: implement atomic64_t on 32-bit
      perfcounters: restructure x86 counter math
      perfcounters: implement "counter inheritance"
      perfcounters: fix task clock counter
      perfcounters: add context switch counter
      perfcounters: add task migrations counter
      perfcounters: add nr-of-faults counter
      perfcounters: fix non-intel-perfmon CPUs
      perfcounters, x86: fix sw counters on non-PMC CPUs
      perfcounters: fix lapic initialization
      perfcounters: release CPU context when exiting task counters
      perfcounters: flush on setuid exec
      perfcounters: use hw_event.disable flag
      perfcounters: remove warnings
      perfcounters: tweak group scheduling
      x86, perfcounters: rename intel_arch_perfmon.h => perf_counter.h
      x86, perfcounters: prepare for fixed-mode PMCs
      perfcounters: add fixed-mode PMC enumeration
      x86, perfcounters: refactor code for fixed-function PMCs
      perfcounters: hw ops rename
      perfcounters: fix task clock counter
      perfcounters: pull inherited counters
      perfcounters: fix init context lock
      perfcounters: enable lowlevel pmc code to schedule counters
      x86, perfcounters: print out the ->used bitmask
      perfcounters: remove ->nr_inherited
      perfcounters: generalize the counter scheduler
      perfcounters: add PERF_COUNT_BUS_CYCLES
      x86, perfcounters: add support for fixed-function pmcs
      perfcounters: include asm/perf_counter.h only if CONFIG_PERF_COUNTERS=y
      perfcounters: fix "perf counters kills oprofile" bug, v2
      perfcounters: remove duplicate definition of LOCAL_PERF_VECTOR
      perfcounters: fix acpi_idle_do_entry() workaround
      perfcounters: fix reserved bits sizing
      perfcounters: fix crash on perfmon v1 systems

Jaswinder Singh (1):
      x86: perf_counter.c intel_perfmon_event_map and max_intel_perfmon_events should be static

Jaswinder Singh Rajput (7):
      x86: perf_counter remove unwanted hw_perf_enable_all
      x86: irqinit_32.c fix compilation warning
      x86: prepare perf_counter to add more cpus
      x86: AMD Support for perf_counter
      x86: decent declarations in perf_counter.c
      x86: use pr_info in perf_counter.c
      x86: perf_counter cleanup

Mike Galbraith (7):
      perfcounters: throttle on too high IRQ rates
      perfcounters: ratelimit performance counter interrupts
      perfcounters fix section mismatch warning in perf_counter.c::perf_counters_lapic_init()
      perfcounters: fix refcounting bug
      perfcounters: fix "perf counters kill oprofile" bug
      perf_counters: account NMI interrupts
      perfcounters: fix use after free in perf_release()

Paul Mackerras (27):
      perf_counter: Fix return value from dummy hw_perf_counter_init
      perf_counter: Fix the cpu_clock software counter
      perf_counter: Add optional hw_perf_group_sched_in arch function
      perf_counter: Add dummy perf_counter_print_debug function
      powerpc/perf_counter: Add perf_counter system call on powerpc
      powerpc: Provide a way to defer perf counter work until interrupts are enabled
      powerpc/perf_counter: Add generic support for POWER-family PMU hardware
      powerpc/perf_counter: Add support for PPC970 family
      powerpc/perf_counter: Add support for POWER6
      perf_counter: Always schedule all software counters in
      powerpc/perf_counter: Make sure PMU gets enabled properly
      perf_counter: Add support for pinned and exclusive counter groups
      perf_counter: Add counter enable/disable ioctls
      perf_counters: make software counters work as per-cpu counters
      perf_counters: allow users to count user, kernel and/or hypervisor events
      perfcounters: fix refcounting bug, take 2
      perfcounters: make context switch and migration software counters work again
      perfcounters/powerpc: Make exclude_kernel bit work on Apple G5 processors
      perfcounters/powerpc: Add support for POWER5 processors
      perfcounters: fix a few minor cleanliness issues
      perfcounters: provide expansion room in the ABI
      perfcounters/powerpc: fix oops with multiple counters in a group
      perfcounters/powerpc: add support for POWER5+ processors
      perfcounters/powerpc: add support for POWER4 processors
      perfcounters: abstract wakeup flag setting in core to fix powerpc build
      perf_counter: powerpc: clean up perc_counter_interrupt
      perfcounters: fix type/event_id layout on big-endian systems

Peter Zijlstra (19):
      perfcounters: IRQ and NMI support on AMD CPUs
      perfcounters: IRQ and NMI support on AMD CPUs, fix
      x86: perf_counter cleanup
      perf_counter: x86: fix 32-bit irq_period assumption
      perf_counter: use list_move_tail()
      perf_counter: add comment to barrier
      perf_counter: x86: use ULL postfix for 64bit constants
      perf_counter: software counter event infrastructure
      perf_counter: provide pagefault software events
      perf_counter: provide major/minor page fault software events
      perf_counter: hrtimer based sampling for software time events
      perf_counter: add an event_list
      perf_counter: fix hrtimer sampling
      perf_counter: fix uninitialized usage of event_list
      perf_counter: generic context switch event
      perf_counter: fix up counter free paths
      perf_counter: hook up the tracepoint events
      perf_counter: revamp syscall input ABI
      perf_counter: unify irq output code

Thomas Gleixner (4):
      performance counters: core code
      perf counters: protect them against CSTATE transitions
      perf counters: clean up 'raw' type API
      perf counters: expand use of counter->event

Tim Blechmann (1):
      perf_counter: include missing header

Yinghai Lu (2):
      perf_counter: more barrier in blank weak function
      x86: make irqinit_32.c more like irqinit_64.c, v2


 Documentation/perf-counters.txt           |  147 ++
 arch/powerpc/include/asm/hw_irq.h         |   39 +
 arch/powerpc/include/asm/paca.h           |    1 +
 arch/powerpc/include/asm/perf_counter.h   |   72 +
 arch/powerpc/include/asm/systbl.h         |    1 +
 arch/powerpc/include/asm/unistd.h         |    3 +-
 arch/powerpc/kernel/Makefile              |    2 +
 arch/powerpc/kernel/asm-offsets.c         |    1 +
 arch/powerpc/kernel/entry_64.S            |    9 +
 arch/powerpc/kernel/irq.c                 |    5 +
 arch/powerpc/kernel/perf_counter.c        |  822 ++++++++++
 arch/powerpc/kernel/power4-pmu.c          |  557 +++++++
 arch/powerpc/kernel/power5+-pmu.c         |  452 ++++++
 arch/powerpc/kernel/power5-pmu.c          |  475 ++++++
 arch/powerpc/kernel/power6-pmu.c          |  283 ++++
 arch/powerpc/kernel/ppc970-pmu.c          |  375 +++++
 arch/powerpc/mm/fault.c                   |    8 +-
 arch/powerpc/platforms/Kconfig.cputype    |    1 +
 arch/x86/Kconfig                          |    1 +
 arch/x86/ia32/ia32entry.S                 |    3 +-
 arch/x86/include/asm/atomic_32.h          |  218 +++
 arch/x86/include/asm/hardirq.h            |    1 +
 arch/x86/include/asm/hw_irq.h             |    2 +
 arch/x86/include/asm/intel_arch_perfmon.h |   31 -
 arch/x86/include/asm/perf_counter.h       |   98 ++
 arch/x86/include/asm/thread_info.h        |    4 +-
 arch/x86/include/asm/unistd_32.h          |    1 +
 arch/x86/include/asm/unistd_64.h          |    3 +-
 arch/x86/kernel/apic/apic.c               |    4 +
 arch/x86/kernel/cpu/Makefile              |   12 +-
 arch/x86/kernel/cpu/amd.c                 |    4 +
 arch/x86/kernel/cpu/common.c              |    2 +
 arch/x86/kernel/cpu/perf_counter.c        |  989 ++++++++++++
 arch/x86/kernel/cpu/perfctr-watchdog.c    |    4 +-
 arch/x86/kernel/entry_64.S                |    5 +
 arch/x86/kernel/irq.c                     |    5 +
 arch/x86/kernel/irqinit_32.c              |   59 +-
 arch/x86/kernel/irqinit_64.c              |   12 +-
 arch/x86/kernel/signal.c                  |    7 +-
 arch/x86/kernel/syscall_table_32.S        |    1 +
 arch/x86/kernel/traps.c                   |   15 +-
 arch/x86/mm/fault.c                       |   10 +-
 arch/x86/oprofile/nmi_int.c               |    7 +-
 arch/x86/oprofile/op_model_ppro.c         |   10 +-
 drivers/acpi/processor_idle.c             |    4 +
 drivers/char/sysrq.c                      |    2 +
 fs/exec.c                                 |    8 +
 include/linux/init_task.h                 |   13 +
 include/linux/kernel_stat.h               |    8 +
 include/linux/perf_counter.h              |  367 +++++
 include/linux/prctl.h                     |    3 +
 include/linux/sched.h                     |   13 +-
 include/linux/syscalls.h                  |    5 +
 init/Kconfig                              |   35 +
 kernel/Makefile                           |    1 +
 kernel/exit.c                             |   13 +-
 kernel/fork.c                             |    1 +
 kernel/perf_counter.c                     | 2438 +++++++++++++++++++++++++++++
 kernel/sched.c                            |   87 +-
 kernel/sys.c                              |    7 +
 kernel/sys_ni.c                           |    3 +
 61 files changed, 7676 insertions(+), 93 deletions(-)

diff --git a/Documentation/perf-counters.txt b/Documentation/perf-counters.txt
new file mode 100644
index 0000000..fddd321
--- /dev/null
+++ b/Documentation/perf-counters.txt
@@ -0,0 +1,147 @@
+
+Performance Counters for Linux
+------------------------------
+
+Performance counters are special hardware registers available on most modern
+CPUs. These registers count the number of certain types of hw events: such
+as instructions executed, cachemisses suffered, or branches mis-predicted -
+without slowing down the kernel or applications. These registers can also
+trigger interrupts when a threshold number of events have passed - and can
+thus be used to profile the code that runs on that CPU.
+
+The Linux Performance Counter subsystem provides an abstraction of these
+hardware capabilities. It provides per task and per CPU counters, counter
+groups, and it provides event capabilities on top of those.
+
+Performance counters are accessed via special file descriptors.
+There's one file descriptor per virtual counter used.
+
+The special file descriptor is opened via the perf_counter_open()
+system call:
+
+   int sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr,
+			     pid_t pid, int cpu, int group_fd);
+
+The syscall returns the new fd. The fd can be used via the normal
+VFS system calls: read() can be used to read the counter, fcntl()
+can be used to set the blocking mode, etc.
+
+Multiple counters can be kept open at a time, and the counters
+can be poll()ed.
+
+When creating a new counter fd, 'perf_counter_hw_event' is:
+
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_hw_event {
+	s64			type;
+
+	u64			irq_period;
+	u32			record_type;
+
+	u32			disabled     :  1, /* off by default */
+				nmi	     :  1, /* NMI sampling   */
+				raw	     :  1, /* raw event type */
+				__reserved_1 : 29;
+
+	u64			__reserved_2;
+};
+
+/*
+ * Generalized performance counter event types, used by the hw_event.type
+ * parameter of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_types {
+	/*
+	 * Common hardware events, generalized by the kernel:
+	 */
+	PERF_COUNT_CYCLES		=  0,
+	PERF_COUNT_INSTRUCTIONS		=  1,
+	PERF_COUNT_CACHE_REFERENCES	=  2,
+	PERF_COUNT_CACHE_MISSES		=  3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
+	PERF_COUNT_BRANCH_MISSES	=  5,
+
+	/*
+	 * Special "software" counters provided by the kernel, even if
+	 * the hardware does not support performance counters. These
+	 * counters measure various physical and sw events of the
+	 * kernel (and allow the profiling of them as well):
+	 */
+	PERF_COUNT_CPU_CLOCK		= -1,
+	PERF_COUNT_TASK_CLOCK		= -2,
+	/*
+	 * Future software events:
+	 */
+	/* PERF_COUNT_PAGE_FAULTS	= -3,
+	   PERF_COUNT_CONTEXT_SWITCHES	= -4, */
+};
+
+These are standardized types of events that work uniformly on all CPUs
+that implements Performance Counters support under Linux. If a CPU is
+not able to count branch-misses, then the system call will return
+-EINVAL.
+
+More hw_event_types are supported as well, but they are CPU
+specific and are enumerated via /sys on a per CPU basis. Raw hw event
+types can be passed in under hw_event.type if hw_event.raw is 1.
+For example, to count "External bus cycles while bus lock signal asserted"
+events on Intel Core CPUs, pass in a 0x4064 event type value and set
+hw_event.raw to 1.
+
+'record_type' is the type of data that a read() will provide for the
+counter, and it can be one of:
+
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_counter_record_type {
+	PERF_RECORD_SIMPLE		=  0,
+	PERF_RECORD_IRQ			=  1,
+	PERF_RECORD_GROUP		=  2,
+};
+
+a "simple" counter is one that counts hardware events and allows
+them to be read out into a u64 count value. (read() returns 8 on
+a successful read of a simple counter.)
+
+An "irq" counter is one that will also provide an IRQ context information:
+the IP of the interrupted context. In this case read() will return
+the 8-byte counter value, plus the Instruction Pointer address of the
+interrupted context.
+
+The parameter 'hw_event_period' is the number of events before waking up
+a read() that is blocked on a counter fd. Zero value means a non-blocking
+counter.
+
+The 'pid' parameter allows the counter to be specific to a task:
+
+ pid == 0: if the pid parameter is zero, the counter is attached to the
+ current task.
+
+ pid > 0: the counter is attached to a specific task (if the current task
+ has sufficient privilege to do so)
+
+ pid < 0: all tasks are counted (per cpu counters)
+
+The 'cpu' parameter allows a counter to be made specific to a full
+CPU:
+
+ cpu >= 0: the counter is restricted to a specific CPU
+ cpu == -1: the counter counts on all CPUs
+
+(Note: the combination of 'pid == -1' and 'cpu == -1' is not valid.)
+
+A 'pid > 0' and 'cpu == -1' counter is a per task counter that counts
+events of that task and 'follows' that task to whatever CPU the task
+gets schedule to. Per task counters can be created by any user, for
+their own tasks.
+
+A 'pid == -1' and 'cpu == x' counter is a per CPU counter that counts
+all events on CPU-x. Per CPU counters need CAP_SYS_ADMIN privilege.
+
+Group counters are created by passing in a group_fd of another counter.
+Groups are scheduled at once and can be used with PERF_RECORD_GROUP
+to record multi-dimensional timestamps.
+
diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index f75a5fc..94361c0 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -131,5 +131,44 @@ static inline int irqs_disabled_flags(unsigned long flags)
  */
 struct hw_interrupt_type;
 
+#ifdef CONFIG_PERF_COUNTERS
+static inline unsigned long get_perf_counter_pending(void)
+{
+	unsigned long x;
+
+	asm volatile("lbz %0,%1(13)"
+		: "=r" (x)
+		: "i" (offsetof(struct paca_struct, perf_counter_pending)));
+	return x;
+}
+
+static inline void set_perf_counter_pending(void)
+{
+	asm volatile("stb %0,%1(13)" : :
+		"r" (1),
+		"i" (offsetof(struct paca_struct, perf_counter_pending)));
+}
+
+static inline void clear_perf_counter_pending(void)
+{
+	asm volatile("stb %0,%1(13)" : :
+		"r" (0),
+		"i" (offsetof(struct paca_struct, perf_counter_pending)));
+}
+
+extern void perf_counter_do_pending(void);
+
+#else
+
+static inline unsigned long get_perf_counter_pending(void)
+{
+	return 0;
+}
+
+static inline void set_perf_counter_pending(void) {}
+static inline void clear_perf_counter_pending(void) {}
+static inline void perf_counter_do_pending(void) {}
+#endif /* CONFIG_PERF_COUNTERS */
+
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_HW_IRQ_H */
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 082b3ae..6ef0557 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -99,6 +99,7 @@ struct paca_struct {
 	u8 soft_enabled;		/* irq soft-enable flag */
 	u8 hard_enabled;		/* set if irqs are enabled in MSR */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
+	u8 perf_counter_pending;	/* PM interrupt while soft-disabled */
 
 	/* Stuff for accurate time accounting */
 	u64 user_time;			/* accumulated usermode TB ticks */
diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
new file mode 100644
index 0000000..9d7ff6d
--- /dev/null
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -0,0 +1,72 @@
+/*
+ * Performance counter support - PowerPC-specific definitions.
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/types.h>
+
+#define MAX_HWCOUNTERS		8
+#define MAX_EVENT_ALTERNATIVES	8
+
+/*
+ * This struct provides the constants and functions needed to
+ * describe the PMU on a particular POWER-family CPU.
+ */
+struct power_pmu {
+	int	n_counter;
+	int	max_alternatives;
+	u64	add_fields;
+	u64	test_adder;
+	int	(*compute_mmcr)(unsigned int events[], int n_ev,
+				unsigned int hwc[], u64 mmcr[]);
+	int	(*get_constraint)(unsigned int event, u64 *mskp, u64 *valp);
+	int	(*get_alternatives)(unsigned int event, unsigned int alt[]);
+	void	(*disable_pmc)(unsigned int pmc, u64 mmcr[]);
+	int	n_generic;
+	int	*generic_events;
+};
+
+extern struct power_pmu *ppmu;
+
+/*
+ * The power_pmu.get_constraint function returns a 64-bit value and
+ * a 64-bit mask that express the constraints between this event and
+ * other events.
+ *
+ * The value and mask are divided up into (non-overlapping) bitfields
+ * of three different types:
+ *
+ * Select field: this expresses the constraint that some set of bits
+ * in MMCR* needs to be set to a specific value for this event.  For a
+ * select field, the mask contains 1s in every bit of the field, and
+ * the value contains a unique value for each possible setting of the
+ * MMCR* bits.  The constraint checking code will ensure that two events
+ * that set the same field in their masks have the same value in their
+ * value dwords.
+ *
+ * Add field: this expresses the constraint that there can be at most
+ * N events in a particular class.  A field of k bits can be used for
+ * N <= 2^(k-1) - 1.  The mask has the most significant bit of the field
+ * set (and the other bits 0), and the value has only the least significant
+ * bit of the field set.  In addition, the 'add_fields' and 'test_adder'
+ * in the struct power_pmu for this processor come into play.  The
+ * add_fields value contains 1 in the LSB of the field, and the
+ * test_adder contains 2^(k-1) - 1 - N in the field.
+ *
+ * NAND field: this expresses the constraint that you may not have events
+ * in all of a set of classes.  (For example, on PPC970, you can't select
+ * events from the FPU, ISU and IDU simultaneously, although any two are
+ * possible.)  For N classes, the field is N+1 bits wide, and each class
+ * is assigned one bit from the least-significant N bits.  The mask has
+ * only the most-significant bit set, and the value has only the bit
+ * for the event's class set.  The test_adder has the least significant
+ * bit set in the field.
+ *
+ * If an event is not subject to the constraint expressed by a particular
+ * field, then it will have 0 in both the mask and value for that field.
+ */
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 72353f6..d312eec 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -322,3 +322,4 @@ SYSCALL_SPU(epoll_create1)
 SYSCALL_SPU(dup3)
 SYSCALL_SPU(pipe2)
 SYSCALL(inotify_init1)
+SYSCALL_SPU(perf_counter_open)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index e07d0c7..7cef5af 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -341,10 +341,11 @@
 #define __NR_dup3		316
 #define __NR_pipe2		317
 #define __NR_inotify_init1	318
+#define __NR_perf_counter_open	319
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		319
+#define __NR_syscalls		320
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 8d1a419..8e5e2c7 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -94,6 +94,8 @@ obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_PERF_COUNTERS)	+= perf_counter.o power4-pmu.o ppc970-pmu.o \
+				   power5-pmu.o power5+-pmu.o power6-pmu.o
 
 obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
 
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 19ee491..3734973 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -131,6 +131,7 @@ int main(void)
 	DEFINE(PACAKMSR, offsetof(struct paca_struct, kernel_msr));
 	DEFINE(PACASOFTIRQEN, offsetof(struct paca_struct, soft_enabled));
 	DEFINE(PACAHARDIRQEN, offsetof(struct paca_struct, hard_enabled));
+	DEFINE(PACAPERFPEND, offsetof(struct paca_struct, perf_counter_pending));
 	DEFINE(PACASLBCACHE, offsetof(struct paca_struct, slb_cache));
 	DEFINE(PACASLBCACHEPTR, offsetof(struct paca_struct, slb_cache_ptr));
 	DEFINE(PACACONTEXTID, offsetof(struct paca_struct, context.id));
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 383ed6e..f30b4e5 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -526,6 +526,15 @@ ALT_FW_FTR_SECTION_END_IFCLR(FW_FEATURE_ISERIES)
 2:
 	TRACE_AND_RESTORE_IRQ(r5);
 
+#ifdef CONFIG_PERF_COUNTERS
+	/* check paca->perf_counter_pending if we're enabling ints */
+	lbz	r3,PACAPERFPEND(r13)
+	and.	r3,r3,r5
+	beq	27f
+	bl	.perf_counter_do_pending
+27:
+#endif /* CONFIG_PERF_COUNTERS */
+
 	/* extract EE bit and use it to restore paca->hard_enabled */
 	ld	r3,_MSR(r1)
 	rldicl	r4,r3,49,63		/* r0 = (r3 >> 15) & 1 */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 1b55ffd..26204a4 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -135,6 +135,11 @@ notrace void raw_local_irq_restore(unsigned long en)
 			iseries_handle_interrupts();
 	}
 
+	if (get_perf_counter_pending()) {
+		clear_perf_counter_pending();
+		perf_counter_do_pending();
+	}
+
 	/*
 	 * if (get_paca()->hard_enabled) return;
 	 * But again we need to take care that gcc gets hard_enabled directly
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
new file mode 100644
index 0000000..6413d9c
--- /dev/null
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -0,0 +1,822 @@
+/*
+ * Performance counter support - powerpc architecture code
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/perf_counter.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <asm/reg.h>
+#include <asm/pmc.h>
+#include <asm/machdep.h>
+#include <asm/firmware.h>
+
+struct cpu_hw_counters {
+	int n_counters;
+	int n_percpu;
+	int disabled;
+	int n_added;
+	struct perf_counter *counter[MAX_HWCOUNTERS];
+	unsigned int events[MAX_HWCOUNTERS];
+	u64 mmcr[3];
+	u8 pmcs_enabled;
+};
+DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
+
+struct power_pmu *ppmu;
+
+/*
+ * Normally, to ignore kernel events we set the FCS (freeze counters
+ * in supervisor mode) bit in MMCR0, but if the kernel runs with the
+ * hypervisor bit set in the MSR, or if we are running on a processor
+ * where the hypervisor bit is forced to 1 (as on Apple G5 processors),
+ * then we need to use the FCHV bit to ignore kernel events.
+ */
+static unsigned int freeze_counters_kernel = MMCR0_FCS;
+
+void perf_counter_print_debug(void)
+{
+}
+
+/*
+ * Read one performance monitor counter (PMC).
+ */
+static unsigned long read_pmc(int idx)
+{
+	unsigned long val;
+
+	switch (idx) {
+	case 1:
+		val = mfspr(SPRN_PMC1);
+		break;
+	case 2:
+		val = mfspr(SPRN_PMC2);
+		break;
+	case 3:
+		val = mfspr(SPRN_PMC3);
+		break;
+	case 4:
+		val = mfspr(SPRN_PMC4);
+		break;
+	case 5:
+		val = mfspr(SPRN_PMC5);
+		break;
+	case 6:
+		val = mfspr(SPRN_PMC6);
+		break;
+	case 7:
+		val = mfspr(SPRN_PMC7);
+		break;
+	case 8:
+		val = mfspr(SPRN_PMC8);
+		break;
+	default:
+		printk(KERN_ERR "oops trying to read PMC%d\n", idx);
+		val = 0;
+	}
+	return val;
+}
+
+/*
+ * Write one PMC.
+ */
+static void write_pmc(int idx, unsigned long val)
+{
+	switch (idx) {
+	case 1:
+		mtspr(SPRN_PMC1, val);
+		break;
+	case 2:
+		mtspr(SPRN_PMC2, val);
+		break;
+	case 3:
+		mtspr(SPRN_PMC3, val);
+		break;
+	case 4:
+		mtspr(SPRN_PMC4, val);
+		break;
+	case 5:
+		mtspr(SPRN_PMC5, val);
+		break;
+	case 6:
+		mtspr(SPRN_PMC6, val);
+		break;
+	case 7:
+		mtspr(SPRN_PMC7, val);
+		break;
+	case 8:
+		mtspr(SPRN_PMC8, val);
+		break;
+	default:
+		printk(KERN_ERR "oops trying to write PMC%d\n", idx);
+	}
+}
+
+/*
+ * Check if a set of events can all go on the PMU at once.
+ * If they can't, this will look at alternative codes for the events
+ * and see if any combination of alternative codes is feasible.
+ * The feasible set is returned in event[].
+ */
+static int power_check_constraints(unsigned int event[], int n_ev)
+{
+	u64 mask, value, nv;
+	unsigned int alternatives[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 amasks[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 avalues[MAX_HWCOUNTERS][MAX_EVENT_ALTERNATIVES];
+	u64 smasks[MAX_HWCOUNTERS], svalues[MAX_HWCOUNTERS];
+	int n_alt[MAX_HWCOUNTERS], choice[MAX_HWCOUNTERS];
+	int i, j;
+	u64 addf = ppmu->add_fields;
+	u64 tadd = ppmu->test_adder;
+
+	if (n_ev > ppmu->n_counter)
+		return -1;
+
+	/* First see if the events will go on as-is */
+	for (i = 0; i < n_ev; ++i) {
+		alternatives[i][0] = event[i];
+		if (ppmu->get_constraint(event[i], &amasks[i][0],
+					 &avalues[i][0]))
+			return -1;
+		choice[i] = 0;
+	}
+	value = mask = 0;
+	for (i = 0; i < n_ev; ++i) {
+		nv = (value | avalues[i][0]) + (value & avalues[i][0] & addf);
+		if ((((nv + tadd) ^ value) & mask) != 0 ||
+		    (((nv + tadd) ^ avalues[i][0]) & amasks[i][0]) != 0)
+			break;
+		value = nv;
+		mask |= amasks[i][0];
+	}
+	if (i == n_ev)
+		return 0;	/* all OK */
+
+	/* doesn't work, gather alternatives... */
+	if (!ppmu->get_alternatives)
+		return -1;
+	for (i = 0; i < n_ev; ++i) {
+		n_alt[i] = ppmu->get_alternatives(event[i], alternatives[i]);
+		for (j = 1; j < n_alt[i]; ++j)
+			ppmu->get_constraint(alternatives[i][j],
+					     &amasks[i][j], &avalues[i][j]);
+	}
+
+	/* enumerate all possibilities and see if any will work */
+	i = 0;
+	j = -1;
+	value = mask = nv = 0;
+	while (i < n_ev) {
+		if (j >= 0) {
+			/* we're backtracking, restore context */
+			value = svalues[i];
+			mask = smasks[i];
+			j = choice[i];
+		}
+		/*
+		 * See if any alternative k for event i,
+		 * where k > j, will satisfy the constraints.
+		 */
+		while (++j < n_alt[i]) {
+			nv = (value | avalues[i][j]) +
+				(value & avalues[i][j] & addf);
+			if ((((nv + tadd) ^ value) & mask) == 0 &&
+			    (((nv + tadd) ^ avalues[i][j])
+			     & amasks[i][j]) == 0)
+				break;
+		}
+		if (j >= n_alt[i]) {
+			/*
+			 * No feasible alternative, backtrack
+			 * to event i-1 and continue enumerating its
+			 * alternatives from where we got up to.
+			 */
+			if (--i < 0)
+				return -1;
+		} else {
+			/*
+			 * Found a feasible alternative for event i,
+			 * remember where we got up to with this event,
+			 * go on to the next event, and start with
+			 * the first alternative for it.
+			 */
+			choice[i] = j;
+			svalues[i] = value;
+			smasks[i] = mask;
+			value = nv;
+			mask |= amasks[i][j];
+			++i;
+			j = -1;
+		}
+	}
+
+	/* OK, we have a feasible combination, tell the caller the solution */
+	for (i = 0; i < n_ev; ++i)
+		event[i] = alternatives[i][choice[i]];
+	return 0;
+}
+
+/*
+ * Check if newly-added counters have consistent settings for
+ * exclude_{user,kernel,hv} with each other and any previously
+ * added counters.
+ */
+static int check_excludes(struct perf_counter **ctrs, int n_prev, int n_new)
+{
+	int eu, ek, eh;
+	int i, n;
+	struct perf_counter *counter;
+
+	n = n_prev + n_new;
+	if (n <= 1)
+		return 0;
+
+	eu = ctrs[0]->hw_event.exclude_user;
+	ek = ctrs[0]->hw_event.exclude_kernel;
+	eh = ctrs[0]->hw_event.exclude_hv;
+	if (n_prev == 0)
+		n_prev = 1;
+	for (i = n_prev; i < n; ++i) {
+		counter = ctrs[i];
+		if (counter->hw_event.exclude_user != eu ||
+		    counter->hw_event.exclude_kernel != ek ||
+		    counter->hw_event.exclude_hv != eh)
+			return -EAGAIN;
+	}
+	return 0;
+}
+
+static void power_perf_read(struct perf_counter *counter)
+{
+	long val, delta, prev;
+
+	if (!counter->hw.idx)
+		return;
+	/*
+	 * Performance monitor interrupts come even when interrupts
+	 * are soft-disabled, as long as interrupts are hard-enabled.
+	 * Therefore we treat them like NMIs.
+	 */
+	do {
+		prev = atomic64_read(&counter->hw.prev_count);
+		barrier();
+		val = read_pmc(counter->hw.idx);
+	} while (atomic64_cmpxchg(&counter->hw.prev_count, prev, val) != prev);
+
+	/* The counters are only 32 bits wide */
+	delta = (val - prev) & 0xfffffffful;
+	atomic64_add(delta, &counter->count);
+	atomic64_sub(delta, &counter->hw.period_left);
+}
+
+/*
+ * Disable all counters to prevent PMU interrupts and to allow
+ * counters to be added or removed.
+ */
+u64 hw_perf_save_disable(void)
+{
+	struct cpu_hw_counters *cpuhw;
+	unsigned long ret;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+
+	ret = cpuhw->disabled;
+	if (!ret) {
+		cpuhw->disabled = 1;
+		cpuhw->n_added = 0;
+
+		/*
+		 * Check if we ever enabled the PMU on this cpu.
+		 */
+		if (!cpuhw->pmcs_enabled) {
+			if (ppc_md.enable_pmcs)
+				ppc_md.enable_pmcs();
+			cpuhw->pmcs_enabled = 1;
+		}
+
+		/*
+		 * Set the 'freeze counters' bit.
+		 * The barrier is to make sure the mtspr has been
+		 * executed and the PMU has frozen the counters
+		 * before we return.
+		 */
+		mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) | MMCR0_FC);
+		mb();
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Re-enable all counters if disable == 0.
+ * If we were previously disabled and counters were added, then
+ * put the new config on the PMU.
+ */
+void hw_perf_restore(u64 disable)
+{
+	struct perf_counter *counter;
+	struct cpu_hw_counters *cpuhw;
+	unsigned long flags;
+	long i;
+	unsigned long val;
+	s64 left;
+	unsigned int hwc_index[MAX_HWCOUNTERS];
+
+	if (disable)
+		return;
+	local_irq_save(flags);
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	cpuhw->disabled = 0;
+
+	/*
+	 * If we didn't change anything, or only removed counters,
+	 * no need to recalculate MMCR* settings and reset the PMCs.
+	 * Just reenable the PMU with the current MMCR* settings
+	 * (possibly updated for removal of counters).
+	 */
+	if (!cpuhw->n_added) {
+		mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+		mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
+		mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+		if (cpuhw->n_counters == 0)
+			get_lppaca()->pmcregs_in_use = 0;
+		goto out;
+	}
+
+	/*
+	 * Compute MMCR* values for the new set of counters
+	 */
+	if (ppmu->compute_mmcr(cpuhw->events, cpuhw->n_counters, hwc_index,
+			       cpuhw->mmcr)) {
+		/* shouldn't ever get here */
+		printk(KERN_ERR "oops compute_mmcr failed\n");
+		goto out;
+	}
+
+	/*
+	 * Add in MMCR0 freeze bits corresponding to the
+	 * hw_event.exclude_* bits for the first counter.
+	 * We have already checked that all counters have the
+	 * same values for these bits as the first counter.
+	 */
+	counter = cpuhw->counter[0];
+	if (counter->hw_event.exclude_user)
+		cpuhw->mmcr[0] |= MMCR0_FCP;
+	if (counter->hw_event.exclude_kernel)
+		cpuhw->mmcr[0] |= freeze_counters_kernel;
+	if (counter->hw_event.exclude_hv)
+		cpuhw->mmcr[0] |= MMCR0_FCHV;
+
+	/*
+	 * Write the new configuration to MMCR* with the freeze
+	 * bit set and set the hardware counters to their initial values.
+	 * Then unfreeze the counters.
+	 */
+	get_lppaca()->pmcregs_in_use = 1;
+	mtspr(SPRN_MMCRA, cpuhw->mmcr[2]);
+	mtspr(SPRN_MMCR1, cpuhw->mmcr[1]);
+	mtspr(SPRN_MMCR0, (cpuhw->mmcr[0] & ~(MMCR0_PMC1CE | MMCR0_PMCjCE))
+				| MMCR0_FC);
+
+	/*
+	 * Read off any pre-existing counters that need to move
+	 * to another PMC.
+	 */
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		if (counter->hw.idx && counter->hw.idx != hwc_index[i] + 1) {
+			power_perf_read(counter);
+			write_pmc(counter->hw.idx, 0);
+			counter->hw.idx = 0;
+		}
+	}
+
+	/*
+	 * Initialize the PMCs for all the new and moved counters.
+	 */
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		if (counter->hw.idx)
+			continue;
+		val = 0;
+		if (counter->hw_event.irq_period) {
+			left = atomic64_read(&counter->hw.period_left);
+			if (left < 0x80000000L)
+				val = 0x80000000L - left;
+		}
+		atomic64_set(&counter->hw.prev_count, val);
+		counter->hw.idx = hwc_index[i] + 1;
+		write_pmc(counter->hw.idx, val);
+	}
+	mb();
+	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
+	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+
+ out:
+	local_irq_restore(flags);
+}
+
+static int collect_events(struct perf_counter *group, int max_count,
+			  struct perf_counter *ctrs[], unsigned int *events)
+{
+	int n = 0;
+	struct perf_counter *counter;
+
+	if (!is_software_counter(group)) {
+		if (n >= max_count)
+			return -1;
+		ctrs[n] = group;
+		events[n++] = group->hw.config;
+	}
+	list_for_each_entry(counter, &group->sibling_list, list_entry) {
+		if (!is_software_counter(counter) &&
+		    counter->state != PERF_COUNTER_STATE_OFF) {
+			if (n >= max_count)
+				return -1;
+			ctrs[n] = counter;
+			events[n++] = counter->hw.config;
+		}
+	}
+	return n;
+}
+
+static void counter_sched_in(struct perf_counter *counter, int cpu)
+{
+	counter->state = PERF_COUNTER_STATE_ACTIVE;
+	counter->oncpu = cpu;
+	if (is_software_counter(counter))
+		counter->hw_ops->enable(counter);
+}
+
+/*
+ * Called to enable a whole group of counters.
+ * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
+ * Assumes the caller has disabled interrupts and has
+ * frozen the PMU with hw_perf_save_disable.
+ */
+int hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu)
+{
+	struct cpu_hw_counters *cpuhw;
+	long i, n, n0;
+	struct perf_counter *sub;
+
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	n0 = cpuhw->n_counters;
+	n = collect_events(group_leader, ppmu->n_counter - n0,
+			   &cpuhw->counter[n0], &cpuhw->events[n0]);
+	if (n < 0)
+		return -EAGAIN;
+	if (check_excludes(cpuhw->counter, n0, n))
+		return -EAGAIN;
+	if (power_check_constraints(cpuhw->events, n + n0))
+		return -EAGAIN;
+	cpuhw->n_counters = n0 + n;
+	cpuhw->n_added += n;
+
+	/*
+	 * OK, this group can go on; update counter states etc.,
+	 * and enable any software counters
+	 */
+	for (i = n0; i < n0 + n; ++i)
+		cpuhw->counter[i]->hw.config = cpuhw->events[i];
+	cpuctx->active_oncpu += n;
+	n = 1;
+	counter_sched_in(group_leader, cpu);
+	list_for_each_entry(sub, &group_leader->sibling_list, list_entry) {
+		if (sub->state != PERF_COUNTER_STATE_OFF) {
+			counter_sched_in(sub, cpu);
+			++n;
+		}
+	}
+	ctx->nr_active += n;
+
+	return 1;
+}
+
+/*
+ * Add a counter to the PMU.
+ * If all counters are not already frozen, then we disable and
+ * re-enable the PMU in order to get hw_perf_restore to do the
+ * actual work of reconfiguring the PMU.
+ */
+static int power_perf_enable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuhw;
+	unsigned long flags;
+	u64 pmudis;
+	int n0;
+	int ret = -EAGAIN;
+
+	local_irq_save(flags);
+	pmudis = hw_perf_save_disable();
+
+	/*
+	 * Add the counter to the list (if there is room)
+	 * and check whether the total set is still feasible.
+	 */
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	n0 = cpuhw->n_counters;
+	if (n0 >= ppmu->n_counter)
+		goto out;
+	cpuhw->counter[n0] = counter;
+	cpuhw->events[n0] = counter->hw.config;
+	if (check_excludes(cpuhw->counter, n0, 1))
+		goto out;
+	if (power_check_constraints(cpuhw->events, n0 + 1))
+		goto out;
+
+	counter->hw.config = cpuhw->events[n0];
+	++cpuhw->n_counters;
+	++cpuhw->n_added;
+
+	ret = 0;
+ out:
+	hw_perf_restore(pmudis);
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Remove a counter from the PMU.
+ */
+static void power_perf_disable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuhw;
+	long i;
+	u64 pmudis;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	pmudis = hw_perf_save_disable();
+
+	power_perf_read(counter);
+
+	cpuhw = &__get_cpu_var(cpu_hw_counters);
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		if (counter == cpuhw->counter[i]) {
+			while (++i < cpuhw->n_counters)
+				cpuhw->counter[i-1] = cpuhw->counter[i];
+			--cpuhw->n_counters;
+			ppmu->disable_pmc(counter->hw.idx - 1, cpuhw->mmcr);
+			write_pmc(counter->hw.idx, 0);
+			counter->hw.idx = 0;
+			break;
+		}
+	}
+	if (cpuhw->n_counters == 0) {
+		/* disable exceptions if no counters are running */
+		cpuhw->mmcr[0] &= ~(MMCR0_PMXE | MMCR0_FCECE);
+	}
+
+	hw_perf_restore(pmudis);
+	local_irq_restore(flags);
+}
+
+struct hw_perf_counter_ops power_perf_ops = {
+	.enable = power_perf_enable,
+	.disable = power_perf_disable,
+	.read = power_perf_read
+};
+
+const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	unsigned long ev;
+	struct perf_counter *ctrs[MAX_HWCOUNTERS];
+	unsigned int events[MAX_HWCOUNTERS];
+	int n;
+
+	if (!ppmu)
+		return NULL;
+	if ((s64)counter->hw_event.irq_period < 0)
+		return NULL;
+	if (!counter->hw_event.raw_type) {
+		ev = counter->hw_event.event_id;
+		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
+			return NULL;
+		ev = ppmu->generic_events[ev];
+	} else {
+		ev = counter->hw_event.raw_event_id;
+	}
+	counter->hw.config_base = ev;
+	counter->hw.idx = 0;
+
+	/*
+	 * If we are not running on a hypervisor, force the
+	 * exclude_hv bit to 0 so that we don't care what
+	 * the user set it to.
+	 */
+	if (!firmware_has_feature(FW_FEATURE_LPAR))
+		counter->hw_event.exclude_hv = 0;
+	
+	/*
+	 * If this is in a group, check if it can go on with all the
+	 * other hardware counters in the group.  We assume the counter
+	 * hasn't been linked into its leader's sibling list at this point.
+	 */
+	n = 0;
+	if (counter->group_leader != counter) {
+		n = collect_events(counter->group_leader, ppmu->n_counter - 1,
+				   ctrs, events);
+		if (n < 0)
+			return NULL;
+	}
+	events[n] = ev;
+	ctrs[n] = counter;
+	if (check_excludes(ctrs, n, 1))
+		return NULL;
+	if (power_check_constraints(events, n + 1))
+		return NULL;
+
+	counter->hw.config = events[n];
+	atomic64_set(&counter->hw.period_left, counter->hw_event.irq_period);
+	return &power_perf_ops;
+}
+
+/*
+ * Handle wakeups.
+ */
+void perf_counter_do_pending(void)
+{
+	int i;
+	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
+	struct perf_counter *counter;
+
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		if (counter && counter->wakeup_pending) {
+			counter->wakeup_pending = 0;
+			wake_up(&counter->waitq);
+		}
+	}
+}
+
+/*
+ * A counter has overflowed; update its count and record
+ * things if requested.  Note that interrupts are hard-disabled
+ * here so there is no possibility of being interrupted.
+ */
+static void record_and_restart(struct perf_counter *counter, long val,
+			       struct pt_regs *regs)
+{
+	s64 prev, delta, left;
+	int record = 0;
+
+	/* we don't have to worry about interrupts here */
+	prev = atomic64_read(&counter->hw.prev_count);
+	delta = (val - prev) & 0xfffffffful;
+	atomic64_add(delta, &counter->count);
+
+	/*
+	 * See if the total period for this counter has expired,
+	 * and update for the next period.
+	 */
+	val = 0;
+	left = atomic64_read(&counter->hw.period_left) - delta;
+	if (counter->hw_event.irq_period) {
+		if (left <= 0) {
+			left += counter->hw_event.irq_period;
+			if (left <= 0)
+				left = counter->hw_event.irq_period;
+			record = 1;
+		}
+		if (left < 0x80000000L)
+			val = 0x80000000L - left;
+	}
+	write_pmc(counter->hw.idx, val);
+	atomic64_set(&counter->hw.prev_count, val);
+	atomic64_set(&counter->hw.period_left, left);
+
+	/*
+	 * Finally record data if requested.
+	 */
+	if (record)
+		perf_counter_output(counter, 1, regs);
+}
+
+/*
+ * Performance monitor interrupt stuff
+ */
+static void perf_counter_interrupt(struct pt_regs *regs)
+{
+	int i;
+	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
+	struct perf_counter *counter;
+	long val;
+	int need_wakeup = 0, found = 0;
+
+	for (i = 0; i < cpuhw->n_counters; ++i) {
+		counter = cpuhw->counter[i];
+		val = read_pmc(counter->hw.idx);
+		if ((int)val < 0) {
+			/* counter has overflowed */
+			found = 1;
+			record_and_restart(counter, val, regs);
+		}
+	}
+
+	/*
+	 * In case we didn't find and reset the counter that caused
+	 * the interrupt, scan all counters and reset any that are
+	 * negative, to avoid getting continual interrupts.
+	 * Any that we processed in the previous loop will not be negative.
+	 */
+	if (!found) {
+		for (i = 0; i < ppmu->n_counter; ++i) {
+			val = read_pmc(i + 1);
+			if ((int)val < 0)
+				write_pmc(i + 1, 0);
+		}
+	}
+
+	/*
+	 * Reset MMCR0 to its normal value.  This will set PMXE and
+	 * clear FC (freeze counters) and PMAO (perf mon alert occurred)
+	 * and thus allow interrupts to occur again.
+	 * XXX might want to use MSR.PM to keep the counters frozen until
+	 * we get back out of this interrupt.
+	 */
+	mtspr(SPRN_MMCR0, cpuhw->mmcr[0]);
+
+	/*
+	 * If we need a wakeup, check whether interrupts were soft-enabled
+	 * when we took the interrupt.  If they were, we can wake stuff up
+	 * immediately; otherwise we'll have do the wakeup when interrupts
+	 * get soft-enabled.
+	 */
+	if (get_perf_counter_pending() && regs->softe) {
+		irq_enter();
+		clear_perf_counter_pending();
+		perf_counter_do_pending();
+		irq_exit();
+	}
+}
+
+void hw_perf_counter_setup(int cpu)
+{
+	struct cpu_hw_counters *cpuhw = &per_cpu(cpu_hw_counters, cpu);
+
+	memset(cpuhw, 0, sizeof(*cpuhw));
+	cpuhw->mmcr[0] = MMCR0_FC;
+}
+
+extern struct power_pmu power4_pmu;
+extern struct power_pmu ppc970_pmu;
+extern struct power_pmu power5_pmu;
+extern struct power_pmu power5p_pmu;
+extern struct power_pmu power6_pmu;
+
+static int init_perf_counters(void)
+{
+	unsigned long pvr;
+
+	if (reserve_pmc_hardware(perf_counter_interrupt)) {
+		printk(KERN_ERR "Couldn't init performance monitor subsystem\n");
+		return -EBUSY;
+	}
+
+	/* XXX should get this from cputable */
+	pvr = mfspr(SPRN_PVR);
+	switch (PVR_VER(pvr)) {
+	case PV_POWER4:
+	case PV_POWER4p:
+		ppmu = &power4_pmu;
+		break;
+	case PV_970:
+	case PV_970FX:
+	case PV_970MP:
+		ppmu = &ppc970_pmu;
+		break;
+	case PV_POWER5:
+		ppmu = &power5_pmu;
+		break;
+	case PV_POWER5p:
+		ppmu = &power5p_pmu;
+		break;
+	case 0x3e:
+		ppmu = &power6_pmu;
+		break;
+	}
+
+	/*
+	 * Use FCHV to ignore kernel events if MSR.HV is set.
+	 */
+	if (mfmsr() & MSR_HV)
+		freeze_counters_kernel = MMCR0_FCHV;
+
+	return 0;
+}
+
+arch_initcall(init_perf_counters);
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
new file mode 100644
index 0000000..1407b19
--- /dev/null
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -0,0 +1,557 @@
+/*
+ * Performance counter support for POWER4 (GP) and POWER4+ (GQ) processors.
+ *
+ * Copyright 2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/perf_counter.h>
+#include <asm/reg.h>
+
+/*
+ * Bits in event code for POWER4
+ */
+#define PM_PMC_SH	12	/* PMC number (1-based) for direct events */
+#define PM_PMC_MSK	0xf
+#define PM_UNIT_SH	8	/* TTMMUX number and setting - unit select */
+#define PM_UNIT_MSK	0xf
+#define PM_LOWER_SH	6
+#define PM_LOWER_MSK	1
+#define PM_LOWER_MSKS	0x40
+#define PM_BYTE_SH	4	/* Byte number of event bus to use */
+#define PM_BYTE_MSK	3
+#define PM_PMCSEL_MSK	7
+
+/*
+ * Unit code values
+ */
+#define PM_FPU		1
+#define PM_ISU1		2
+#define PM_IFU		3
+#define PM_IDU0		4
+#define PM_ISU1_ALT	6
+#define PM_ISU2		7
+#define PM_IFU_ALT	8
+#define PM_LSU0		9
+#define PM_LSU1		0xc
+#define PM_GPS		0xf
+
+/*
+ * Bits in MMCR0 for POWER4
+ */
+#define MMCR0_PMC1SEL_SH	8
+#define MMCR0_PMC2SEL_SH	1
+#define MMCR_PMCSEL_MSK		0x1f
+
+/*
+ * Bits in MMCR1 for POWER4
+ */
+#define MMCR1_TTM0SEL_SH	62
+#define MMCR1_TTC0SEL_SH	61
+#define MMCR1_TTM1SEL_SH	59
+#define MMCR1_TTC1SEL_SH	58
+#define MMCR1_TTM2SEL_SH	56
+#define MMCR1_TTC2SEL_SH	55
+#define MMCR1_TTM3SEL_SH	53
+#define MMCR1_TTC3SEL_SH	52
+#define MMCR1_TTMSEL_MSK	3
+#define MMCR1_TD_CP_DBG0SEL_SH	50
+#define MMCR1_TD_CP_DBG1SEL_SH	48
+#define MMCR1_TD_CP_DBG2SEL_SH	46
+#define MMCR1_TD_CP_DBG3SEL_SH	44
+#define MMCR1_DEBUG0SEL_SH	43
+#define MMCR1_DEBUG1SEL_SH	42
+#define MMCR1_DEBUG2SEL_SH	41
+#define MMCR1_DEBUG3SEL_SH	40
+#define MMCR1_PMC1_ADDER_SEL_SH	39
+#define MMCR1_PMC2_ADDER_SEL_SH	38
+#define MMCR1_PMC6_ADDER_SEL_SH	37
+#define MMCR1_PMC5_ADDER_SEL_SH	36
+#define MMCR1_PMC8_ADDER_SEL_SH	35
+#define MMCR1_PMC7_ADDER_SEL_SH	34
+#define MMCR1_PMC3_ADDER_SEL_SH	33
+#define MMCR1_PMC4_ADDER_SEL_SH	32
+#define MMCR1_PMC3SEL_SH	27
+#define MMCR1_PMC4SEL_SH	22
+#define MMCR1_PMC5SEL_SH	17
+#define MMCR1_PMC6SEL_SH	12
+#define MMCR1_PMC7SEL_SH	7
+#define MMCR1_PMC8SEL_SH	2	/* note bit 0 is in MMCRA for GP */
+
+static short mmcr1_adder_bits[8] = {
+	MMCR1_PMC1_ADDER_SEL_SH,
+	MMCR1_PMC2_ADDER_SEL_SH,
+	MMCR1_PMC3_ADDER_SEL_SH,
+	MMCR1_PMC4_ADDER_SEL_SH,
+	MMCR1_PMC5_ADDER_SEL_SH,
+	MMCR1_PMC6_ADDER_SEL_SH,
+	MMCR1_PMC7_ADDER_SEL_SH,
+	MMCR1_PMC8_ADDER_SEL_SH
+};
+
+/*
+ * Bits in MMCRA
+ */
+#define MMCRA_PMC8SEL0_SH	17	/* PMC8SEL bit 0 for GP */
+
+/*
+ * Layout of constraint bits:
+ * 6666555555555544444444443333333333222222222211111111110000000000
+ * 3210987654321098765432109876543210987654321098765432109876543210
+ *        |[  >[  >[   >|||[  >[  ><  ><  ><  ><  ><><><><><><><><>
+ *        | UC1 UC2 UC3 ||| PS1 PS2 B0  B1  B2  B3 P1P2P3P4P5P6P7P8
+ * 	  \SMPL	        ||\TTC3SEL
+ * 		        |\TTC_IFU_SEL
+ * 		        \TTM2SEL0
+ *
+ * SMPL - SAMPLE_ENABLE constraint
+ *     56: SAMPLE_ENABLE value 0x0100_0000_0000_0000
+ *
+ * UC1 - unit constraint 1: can't have all three of FPU/ISU1/IDU0|ISU2
+ *     55: UC1 error 0x0080_0000_0000_0000
+ *     54: FPU events needed 0x0040_0000_0000_0000
+ *     53: ISU1 events needed 0x0020_0000_0000_0000
+ *     52: IDU0|ISU2 events needed 0x0010_0000_0000_0000
+ *
+ * UC2 - unit constraint 2: can't have all three of FPU/IFU/LSU0
+ *     51: UC2 error 0x0008_0000_0000_0000
+ *     50: FPU events needed 0x0004_0000_0000_0000
+ *     49: IFU events needed 0x0002_0000_0000_0000
+ *     48: LSU0 events needed 0x0001_0000_0000_0000
+ *
+ * UC3 - unit constraint 3: can't have all four of LSU0/IFU/IDU0|ISU2/ISU1
+ *     47: UC3 error 0x8000_0000_0000
+ *     46: LSU0 events needed 0x4000_0000_0000
+ *     45: IFU events needed 0x2000_0000_0000
+ *     44: IDU0|ISU2 events needed 0x1000_0000_0000
+ *     43: ISU1 events needed 0x0800_0000_0000
+ *
+ * TTM2SEL0
+ *     42: 0 = IDU0 events needed
+ *     	   1 = ISU2 events needed 0x0400_0000_0000
+ *
+ * TTC_IFU_SEL
+ *     41: 0 = IFU.U events needed
+ *     	   1 = IFU.L events needed 0x0200_0000_0000
+ *
+ * TTC3SEL
+ *     40: 0 = LSU1.U events needed
+ *     	   1 = LSU1.L events needed 0x0100_0000_0000
+ *
+ * PS1
+ *     39: PS1 error 0x0080_0000_0000
+ *     36-38: count of events needing PMC1/2/5/6 0x0070_0000_0000
+ *
+ * PS2
+ *     35: PS2 error 0x0008_0000_0000
+ *     32-34: count of events needing PMC3/4/7/8 0x0007_0000_0000
+ *
+ * B0
+ *     28-31: Byte 0 event source 0xf000_0000
+ *     	   1 = FPU
+ * 	   2 = ISU1
+ * 	   3 = IFU
+ * 	   4 = IDU0
+ * 	   7 = ISU2
+ * 	   9 = LSU0
+ * 	   c = LSU1
+ * 	   f = GPS
+ *
+ * B1, B2, B3
+ *     24-27, 20-23, 16-19: Byte 1, 2, 3 event sources
+ *
+ * P8
+ *     15: P8 error 0x8000
+ *     14-15: Count of events needing PMC8
+ *
+ * P1..P7
+ *     0-13: Count of events needing PMC1..PMC7
+ *
+ * Note: this doesn't allow events using IFU.U to be combined with events
+ * using IFU.L, though that is feasible (using TTM0 and TTM2).  However
+ * there are no listed events for IFU.L (they are debug events not
+ * verified for performance monitoring) so this shouldn't cause a
+ * problem.
+ */
+
+static struct unitinfo {
+	u64	value, mask;
+	int	unit;
+	int	lowerbit;
+} p4_unitinfo[16] = {
+	[PM_FPU]  = { 0x44000000000000ull, 0x88000000000000ull, PM_FPU, 0 },
+	[PM_ISU1] = { 0x20080000000000ull, 0x88000000000000ull, PM_ISU1, 0 },
+	[PM_ISU1_ALT] =
+		    { 0x20080000000000ull, 0x88000000000000ull, PM_ISU1, 0 },
+	[PM_IFU]  = { 0x02200000000000ull, 0x08820000000000ull, PM_IFU, 41 },
+	[PM_IFU_ALT] =
+		    { 0x02200000000000ull, 0x08820000000000ull, PM_IFU, 41 },
+	[PM_IDU0] = { 0x10100000000000ull, 0x80840000000000ull, PM_IDU0, 1 },
+	[PM_ISU2] = { 0x10140000000000ull, 0x80840000000000ull, PM_ISU2, 0 },
+	[PM_LSU0] = { 0x01400000000000ull, 0x08800000000000ull, PM_LSU0, 0 },
+	[PM_LSU1] = { 0x00000000000000ull, 0x00010000000000ull, PM_LSU1, 40 },
+	[PM_GPS]  = { 0x00000000000000ull, 0x00000000000000ull, PM_GPS, 0 }
+};
+
+static unsigned char direct_marked_event[8] = {
+	(1<<2) | (1<<3),	/* PMC1: PM_MRK_GRP_DISP, PM_MRK_ST_CMPL */
+	(1<<3) | (1<<5),	/* PMC2: PM_THRESH_TIMEO, PM_MRK_BRU_FIN */
+	(1<<3),			/* PMC3: PM_MRK_ST_CMPL_INT */
+	(1<<4) | (1<<5),	/* PMC4: PM_MRK_GRP_CMPL, PM_MRK_CRU_FIN */
+	(1<<4) | (1<<5),	/* PMC5: PM_MRK_GRP_TIMEO */
+	(1<<3) | (1<<4) | (1<<5),
+		/* PMC6: PM_MRK_ST_GPS, PM_MRK_FXU_FIN, PM_MRK_GRP_ISSUED */
+	(1<<4) | (1<<5),	/* PMC7: PM_MRK_FPU_FIN, PM_MRK_INST_FIN */
+	(1<<4),			/* PMC8: PM_MRK_LSU_FIN */
+};
+
+/*
+ * Returns 1 if event counts things relating to marked instructions
+ * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
+ */
+static int p4_marked_instr_event(unsigned int event)
+{
+	int pmc, psel, unit, byte, bit;
+	unsigned int mask;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	psel = event & PM_PMCSEL_MSK;
+	if (pmc) {
+		if (direct_marked_event[pmc - 1] & (1 << psel))
+			return 1;
+		if (psel == 0)		/* add events */
+			bit = (pmc <= 4)? pmc - 1: 8 - pmc;
+		else if (psel == 6)	/* decode events */
+			bit = 4;
+		else
+			return 0;
+	} else
+		bit = psel;
+
+	byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+	unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+	mask = 0;
+	switch (unit) {
+	case PM_LSU1:
+		if (event & PM_LOWER_MSKS)
+			mask = 1 << 28;		/* byte 7 bit 4 */
+		else
+			mask = 6 << 24;		/* byte 3 bits 1 and 2 */
+		break;
+	case PM_LSU0:
+		/* byte 3, bit 3; byte 2 bits 0,2,3,4,5; byte 1 */
+		mask = 0x083dff00;
+	}
+	return (mask >> (byte * 8 + bit)) & 1;
+}
+
+static int p4_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+{
+	int pmc, byte, unit, lower, sh;
+	u64 mask = 0, value = 0;
+	int grp = -1;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc) {
+		if (pmc > 8)
+			return -1;
+		sh = (pmc - 1) * 2;
+		mask |= 2 << sh;
+		value |= 1 << sh;
+		grp = ((pmc - 1) >> 1) & 1;
+	}
+	unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+	byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+	if (unit) {
+		lower = (event >> PM_LOWER_SH) & PM_LOWER_MSK;
+
+		/*
+		 * Bus events on bytes 0 and 2 can be counted
+		 * on PMC1/2/5/6; bytes 1 and 3 on PMC3/4/7/8.
+		 */
+		if (!pmc)
+			grp = byte & 1;
+
+		if (!p4_unitinfo[unit].unit)
+			return -1;
+		mask  |= p4_unitinfo[unit].mask;
+		value |= p4_unitinfo[unit].value;
+		sh = p4_unitinfo[unit].lowerbit;
+		if (sh > 1)
+			value |= (u64)lower << sh;
+		else if (lower != sh)
+			return -1;
+		unit = p4_unitinfo[unit].unit;
+
+		/* Set byte lane select field */
+		mask  |= 0xfULL << (28 - 4 * byte);
+		value |= (u64)unit << (28 - 4 * byte);
+	}
+	if (grp == 0) {
+		/* increment PMC1/2/5/6 field */
+		mask  |= 0x8000000000ull;
+		value |= 0x1000000000ull;
+	} else {
+		/* increment PMC3/4/7/8 field */
+		mask  |= 0x800000000ull;
+		value |= 0x100000000ull;
+	}
+
+	/* Marked instruction events need sample_enable set */
+	if (p4_marked_instr_event(event)) {
+		mask  |= 1ull << 56;
+		value |= 1ull << 56;
+	}
+
+	/* PMCSEL=6 decode events on byte 2 need sample_enable clear */
+	if (pmc && (event & PM_PMCSEL_MSK) == 6 && byte == 2)
+		mask  |= 1ull << 56;
+
+	*maskp = mask;
+	*valp = value;
+	return 0;
+}
+
+static unsigned int ppc_inst_cmpl[] = {
+	0x1001, 0x4001, 0x6001, 0x7001, 0x8001
+};
+
+static int p4_get_alternatives(unsigned int event, unsigned int alt[])
+{
+	int i, j, na;
+
+	alt[0] = event;
+	na = 1;
+
+	/* 2 possibilities for PM_GRP_DISP_REJECT */
+	if (event == 0x8003 || event == 0x0224) {
+		alt[1] = event ^ (0x8003 ^ 0x0224);
+		return 2;
+	}
+
+	/* 2 possibilities for PM_ST_MISS_L1 */
+	if (event == 0x0c13 || event == 0x0c23) {
+		alt[1] = event ^ (0x0c13 ^ 0x0c23);
+		return 2;
+	}
+
+	/* several possibilities for PM_INST_CMPL */
+	for (i = 0; i < ARRAY_SIZE(ppc_inst_cmpl); ++i) {
+		if (event == ppc_inst_cmpl[i]) {
+			for (j = 0; j < ARRAY_SIZE(ppc_inst_cmpl); ++j)
+				if (j != i)
+					alt[na++] = ppc_inst_cmpl[j];
+			break;
+		}
+	}
+
+	return na;
+}
+
+static int p4_compute_mmcr(unsigned int event[], int n_ev,
+			   unsigned int hwc[], u64 mmcr[])
+{
+	u64 mmcr0 = 0, mmcr1 = 0, mmcra = 0;
+	unsigned int pmc, unit, byte, psel, lower;
+	unsigned int ttm, grp;
+	unsigned int pmc_inuse = 0;
+	unsigned int pmc_grp_use[2];
+	unsigned char busbyte[4];
+	unsigned char unituse[16];
+	unsigned int unitlower = 0;
+	int i;
+
+	if (n_ev > 8)
+		return -1;
+
+	/* First pass to count resource use */
+	pmc_grp_use[0] = pmc_grp_use[1] = 0;
+	memset(busbyte, 0, sizeof(busbyte));
+	memset(unituse, 0, sizeof(unituse));
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			if (pmc_inuse & (1 << (pmc - 1)))
+				return -1;
+			pmc_inuse |= 1 << (pmc - 1);
+			/* count 1/2/5/6 vs 3/4/7/8 use */
+			++pmc_grp_use[((pmc - 1) >> 1) & 1];
+		}
+		unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+		byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+		lower = (event[i] >> PM_LOWER_SH) & PM_LOWER_MSK;
+		if (unit) {
+			if (!pmc)
+				++pmc_grp_use[byte & 1];
+			if (unit == 6 || unit == 8)
+				/* map alt ISU1/IFU codes: 6->2, 8->3 */
+				unit = (unit >> 1) - 1;
+			if (busbyte[byte] && busbyte[byte] != unit)
+				return -1;
+			busbyte[byte] = unit;
+			lower <<= unit;
+			if (unituse[unit] && lower != (unitlower & lower))
+				return -1;
+			unituse[unit] = 1;
+			unitlower |= lower;
+		}
+	}
+	if (pmc_grp_use[0] > 4 || pmc_grp_use[1] > 4)
+		return -1;
+
+	/*
+	 * Assign resources and set multiplexer selects.
+	 *
+	 * Units 1,2,3 are on TTM0, 4,6,7 on TTM1, 8,10 on TTM2.
+	 * Each TTMx can only select one unit, but since
+	 * units 2 and 6 are both ISU1, and 3 and 8 are both IFU,
+	 * we have some choices.
+	 */
+	if (unituse[2] & (unituse[1] | (unituse[3] & unituse[9]))) {
+		unituse[6] = 1;		/* Move 2 to 6 */
+		unituse[2] = 0;
+	}
+	if (unituse[3] & (unituse[1] | unituse[2])) {
+		unituse[8] = 1;		/* Move 3 to 8 */
+		unituse[3] = 0;
+		unitlower = (unitlower & ~8) | ((unitlower & 8) << 5);
+	}
+	/* Check only one unit per TTMx */
+	if (unituse[1] + unituse[2] + unituse[3] > 1 ||
+	    unituse[4] + unituse[6] + unituse[7] > 1 ||
+	    unituse[8] + unituse[9] > 1 ||
+	    (unituse[5] | unituse[10] | unituse[11] |
+	     unituse[13] | unituse[14]))
+		return -1;
+
+	/* Set TTMxSEL fields.  Note, units 1-3 => TTM0SEL codes 0-2 */
+	mmcr1 |= (u64)(unituse[3] * 2 + unituse[2]) << MMCR1_TTM0SEL_SH;
+	mmcr1 |= (u64)(unituse[7] * 3 + unituse[6] * 2) << MMCR1_TTM1SEL_SH;
+	mmcr1 |= (u64)unituse[9] << MMCR1_TTM2SEL_SH;
+
+	/* Set TTCxSEL fields. */
+	if (unitlower & 0xe)
+		mmcr1 |= 1ull << MMCR1_TTC0SEL_SH;
+	if (unitlower & 0xf0)
+		mmcr1 |= 1ull << MMCR1_TTC1SEL_SH;
+	if (unitlower & 0xf00)
+		mmcr1 |= 1ull << MMCR1_TTC2SEL_SH;
+	if (unitlower & 0x7000)
+		mmcr1 |= 1ull << MMCR1_TTC3SEL_SH;
+
+	/* Set byte lane select fields. */
+	for (byte = 0; byte < 4; ++byte) {
+		unit = busbyte[byte];
+		if (!unit)
+			continue;
+		if (unit == 0xf) {
+			/* special case for GPS */
+			mmcr1 |= 1ull << (MMCR1_DEBUG0SEL_SH - byte);
+		} else {
+			if (!unituse[unit])
+				ttm = unit - 1;		/* 2->1, 3->2 */
+			else
+				ttm = unit >> 2;
+			mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2*byte);
+		}
+	}
+
+	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+		byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+		psel = event[i] & PM_PMCSEL_MSK;
+		if (!pmc) {
+			/* Bus event or 00xxx direct event (off or cycles) */
+			if (unit)
+				psel |= 0x10 | ((byte & 2) << 2);
+			for (pmc = 0; pmc < 8; ++pmc) {
+				if (pmc_inuse & (1 << pmc))
+					continue;
+				grp = (pmc >> 1) & 1;
+				if (unit) {
+					if (grp == (byte & 1))
+						break;
+				} else if (pmc_grp_use[grp] < 4) {
+					++pmc_grp_use[grp];
+					break;
+				}
+			}
+			pmc_inuse |= 1 << pmc;
+		} else {
+			/* Direct event */
+			--pmc;
+			if (psel == 0 && (byte & 2))
+				/* add events on higher-numbered bus */
+				mmcr1 |= 1ull << mmcr1_adder_bits[pmc];
+			else if (psel == 6 && byte == 3)
+				/* seem to need to set sample_enable here */
+				mmcra |= MMCRA_SAMPLE_ENABLE;
+			psel |= 8;
+		}
+		if (pmc <= 1)
+			mmcr0 |= psel << (MMCR0_PMC1SEL_SH - 7 * pmc);
+		else
+			mmcr1 |= psel << (MMCR1_PMC3SEL_SH - 5 * (pmc - 2));
+		if (pmc == 7)	/* PMC8 */
+			mmcra |= (psel & 1) << MMCRA_PMC8SEL0_SH;
+		hwc[i] = pmc;
+		if (p4_marked_instr_event(event[i]))
+			mmcra |= MMCRA_SAMPLE_ENABLE;
+	}
+
+	if (pmc_inuse & 1)
+		mmcr0 |= MMCR0_PMC1CE;
+	if (pmc_inuse & 0xfe)
+		mmcr0 |= MMCR0_PMCjCE;
+
+	mmcra |= 0x2000;	/* mark only one IOP per PPC instruction */
+
+	/* Return MMCRx values */
+	mmcr[0] = mmcr0;
+	mmcr[1] = mmcr1;
+	mmcr[2] = mmcra;
+	return 0;
+}
+
+static void p4_disable_pmc(unsigned int pmc, u64 mmcr[])
+{
+	/*
+	 * Setting the PMCxSEL field to 0 disables PMC x.
+	 * (Note that pmc is 0-based here, not 1-based.)
+	 */
+	if (pmc <= 1) {
+		mmcr[0] &= ~(0x1fUL << (MMCR0_PMC1SEL_SH - 7 * pmc));
+	} else {
+		mmcr[1] &= ~(0x1fUL << (MMCR1_PMC3SEL_SH - 5 * (pmc - 2)));
+		if (pmc == 7)
+			mmcr[2] &= ~(1UL << MMCRA_PMC8SEL0_SH);
+	}
+}
+
+static int p4_generic_events[] = {
+	[PERF_COUNT_CPU_CYCLES] = 7,
+	[PERF_COUNT_INSTRUCTIONS] = 0x1001,
+	[PERF_COUNT_CACHE_REFERENCES] = 0x8c10,		/* PM_LD_REF_L1 */
+	[PERF_COUNT_CACHE_MISSES] = 0x3c10,		/* PM_LD_MISS_L1 */
+	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x330,	/* PM_BR_ISSUED */
+	[PERF_COUNT_BRANCH_MISSES] = 0x331,		/* PM_BR_MPRED_CR */
+};
+
+struct power_pmu power4_pmu = {
+	.n_counter = 8,
+	.max_alternatives = 5,
+	.add_fields = 0x0000001100005555ull,
+	.test_adder = 0x0011083300000000ull,
+	.compute_mmcr = p4_compute_mmcr,
+	.get_constraint = p4_get_constraint,
+	.get_alternatives = p4_get_alternatives,
+	.disable_pmc = p4_disable_pmc,
+	.n_generic = ARRAY_SIZE(p4_generic_events),
+	.generic_events = p4_generic_events,
+};
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
new file mode 100644
index 0000000..cec21ea
--- /dev/null
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -0,0 +1,452 @@
+/*
+ * Performance counter support for POWER5 (not POWER5++) processors.
+ *
+ * Copyright 2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/perf_counter.h>
+#include <asm/reg.h>
+
+/*
+ * Bits in event code for POWER5+ (POWER5 GS) and POWER5++ (POWER5 GS DD3)
+ */
+#define PM_PMC_SH	20	/* PMC number (1-based) for direct events */
+#define PM_PMC_MSK	0xf
+#define PM_PMC_MSKS	(PM_PMC_MSK << PM_PMC_SH)
+#define PM_UNIT_SH	16	/* TTMMUX number and setting - unit select */
+#define PM_UNIT_MSK	0xf
+#define PM_BYTE_SH	12	/* Byte number of event bus to use */
+#define PM_BYTE_MSK	7
+#define PM_GRS_SH	8	/* Storage subsystem mux select */
+#define PM_GRS_MSK	7
+#define PM_BUSEVENT_MSK	0x80	/* Set if event uses event bus */
+#define PM_PMCSEL_MSK	0x7f
+
+/* Values in PM_UNIT field */
+#define PM_FPU		0
+#define PM_ISU0		1
+#define PM_IFU		2
+#define PM_ISU1		3
+#define PM_IDU		4
+#define PM_ISU0_ALT	6
+#define PM_GRS		7
+#define PM_LSU0		8
+#define PM_LSU1		0xc
+#define PM_LASTUNIT	0xc
+
+/*
+ * Bits in MMCR1 for POWER5+
+ */
+#define MMCR1_TTM0SEL_SH	62
+#define MMCR1_TTM1SEL_SH	60
+#define MMCR1_TTM2SEL_SH	58
+#define MMCR1_TTM3SEL_SH	56
+#define MMCR1_TTMSEL_MSK	3
+#define MMCR1_TD_CP_DBG0SEL_SH	54
+#define MMCR1_TD_CP_DBG1SEL_SH	52
+#define MMCR1_TD_CP_DBG2SEL_SH	50
+#define MMCR1_TD_CP_DBG3SEL_SH	48
+#define MMCR1_GRS_L2SEL_SH	46
+#define MMCR1_GRS_L2SEL_MSK	3
+#define MMCR1_GRS_L3SEL_SH	44
+#define MMCR1_GRS_L3SEL_MSK	3
+#define MMCR1_GRS_MCSEL_SH	41
+#define MMCR1_GRS_MCSEL_MSK	7
+#define MMCR1_GRS_FABSEL_SH	39
+#define MMCR1_GRS_FABSEL_MSK	3
+#define MMCR1_PMC1_ADDER_SEL_SH	35
+#define MMCR1_PMC2_ADDER_SEL_SH	34
+#define MMCR1_PMC3_ADDER_SEL_SH	33
+#define MMCR1_PMC4_ADDER_SEL_SH	32
+#define MMCR1_PMC1SEL_SH	25
+#define MMCR1_PMC2SEL_SH	17
+#define MMCR1_PMC3SEL_SH	9
+#define MMCR1_PMC4SEL_SH	1
+#define MMCR1_PMCSEL_SH(n)	(MMCR1_PMC1SEL_SH - (n) * 8)
+#define MMCR1_PMCSEL_MSK	0x7f
+
+/*
+ * Bits in MMCRA
+ */
+
+/*
+ * Layout of constraint bits:
+ * 6666555555555544444444443333333333222222222211111111110000000000
+ * 3210987654321098765432109876543210987654321098765432109876543210
+ *             [  ><><>< ><> <><>[  >      <  ><  ><  ><  ><><><><>
+ *             NC  G0G1G2 G3 T0T1 UC        B0  B1  B2  B3 P4P3P2P1
+ *
+ * NC - number of counters
+ *     51: NC error 0x0008_0000_0000_0000
+ *     48-50: number of events needing PMC1-4 0x0007_0000_0000_0000
+ *
+ * G0..G3 - GRS mux constraints
+ *     46-47: GRS_L2SEL value
+ *     44-45: GRS_L3SEL value
+ *     41-44: GRS_MCSEL value
+ *     39-40: GRS_FABSEL value
+ *	Note that these match up with their bit positions in MMCR1
+ *
+ * T0 - TTM0 constraint
+ *     36-37: TTM0SEL value (0=FPU, 2=IFU, 3=ISU1) 0x30_0000_0000
+ *
+ * T1 - TTM1 constraint
+ *     34-35: TTM1SEL value (0=IDU, 3=GRS) 0x0c_0000_0000
+ *
+ * UC - unit constraint: can't have all three of FPU|IFU|ISU1, ISU0, IDU|GRS
+ *     33: UC3 error 0x02_0000_0000
+ *     32: FPU|IFU|ISU1 events needed 0x01_0000_0000
+ *     31: ISU0 events needed 0x01_8000_0000
+ *     30: IDU|GRS events needed 0x00_4000_0000
+ *
+ * B0
+ *     20-23: Byte 0 event source 0x00f0_0000
+ *	      Encoding as for the event code
+ *
+ * B1, B2, B3
+ *     16-19, 12-15, 8-11: Byte 1, 2, 3 event sources
+ *
+ * P4
+ *     7: P1 error 0x80
+ *     6-7: Count of events needing PMC4
+ *
+ * P1..P3
+ *     0-6: Count of events needing PMC1..PMC3
+ */
+
+static const int grsel_shift[8] = {
+	MMCR1_GRS_L2SEL_SH, MMCR1_GRS_L2SEL_SH, MMCR1_GRS_L2SEL_SH,
+	MMCR1_GRS_L3SEL_SH, MMCR1_GRS_L3SEL_SH, MMCR1_GRS_L3SEL_SH,
+	MMCR1_GRS_MCSEL_SH, MMCR1_GRS_FABSEL_SH
+};
+
+/* Masks and values for using events from the various units */
+static u64 unit_cons[PM_LASTUNIT+1][2] = {
+	[PM_FPU] =   { 0x3200000000ull, 0x0100000000ull },
+	[PM_ISU0] =  { 0x0200000000ull, 0x0080000000ull },
+	[PM_ISU1] =  { 0x3200000000ull, 0x3100000000ull },
+	[PM_IFU] =   { 0x3200000000ull, 0x2100000000ull },
+	[PM_IDU] =   { 0x0e00000000ull, 0x0040000000ull },
+	[PM_GRS] =   { 0x0e00000000ull, 0x0c40000000ull },
+};
+
+static int power5p_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+{
+	int pmc, byte, unit, sh;
+	int bit, fmask;
+	u64 mask = 0, value = 0;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc) {
+		if (pmc > 4)
+			return -1;
+		sh = (pmc - 1) * 2;
+		mask |= 2 << sh;
+		value |= 1 << sh;
+	}
+	if (event & PM_BUSEVENT_MSK) {
+		unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+		if (unit > PM_LASTUNIT)
+			return -1;
+		if (unit == PM_ISU0_ALT)
+			unit = PM_ISU0;
+		mask |= unit_cons[unit][0];
+		value |= unit_cons[unit][1];
+		byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+		if (byte >= 4) {
+			if (unit != PM_LSU1)
+				return -1;
+			/* Map LSU1 low word (bytes 4-7) to unit LSU1+1 */
+			++unit;
+			byte &= 3;
+		}
+		if (unit == PM_GRS) {
+			bit = event & 7;
+			fmask = (bit == 6)? 7: 3;
+			sh = grsel_shift[bit];
+			mask |= (u64)fmask << sh;
+			value |= (u64)((event >> PM_GRS_SH) & fmask) << sh;
+		}
+		/* Set byte lane select field */
+		mask  |= 0xfULL << (20 - 4 * byte);
+		value |= (u64)unit << (20 - 4 * byte);
+	}
+	mask  |= 0x8000000000000ull;
+	value |= 0x1000000000000ull;
+	*maskp = mask;
+	*valp = value;
+	return 0;
+}
+
+#define MAX_ALT	3	/* at most 3 alternatives for any event */
+
+static const unsigned int event_alternatives[][MAX_ALT] = {
+	{ 0x100c0,  0x40001f },			/* PM_GCT_FULL_CYC */
+	{ 0x120e4,  0x400002 },			/* PM_GRP_DISP_REJECT */
+	{ 0x230e2,  0x323087 },			/* PM_BR_PRED_CR */
+	{ 0x230e3,  0x223087, 0x3230a0 },	/* PM_BR_PRED_TA */
+	{ 0x410c7,  0x441084 },			/* PM_THRD_L2MISS_BOTH_CYC */
+	{ 0x800c4,  0xc20e0 },			/* PM_DTLB_MISS */
+	{ 0xc50c6,  0xc60e0 },			/* PM_MRK_DTLB_MISS */
+	{ 0x100009, 0x200009 },			/* PM_INST_CMPL */
+	{ 0x200015, 0x300015 },			/* PM_LSU_LMQ_SRQ_EMPTY_CYC */
+	{ 0x300009, 0x400009 },			/* PM_INST_DISP */
+};
+
+/*
+ * Scan the alternatives table for a match and return the
+ * index into the alternatives table if found, else -1.
+ */
+static int find_alternative(unsigned int event)
+{
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(event_alternatives); ++i) {
+		if (event < event_alternatives[i][0])
+			break;
+		for (j = 0; j < MAX_ALT && event_alternatives[i][j]; ++j)
+			if (event == event_alternatives[i][j])
+				return i;
+	}
+	return -1;
+}
+
+static const unsigned char bytedecode_alternatives[4][4] = {
+	/* PMC 1 */	{ 0x21, 0x23, 0x25, 0x27 },
+	/* PMC 2 */	{ 0x07, 0x17, 0x0e, 0x1e },
+	/* PMC 3 */	{ 0x20, 0x22, 0x24, 0x26 },
+	/* PMC 4 */	{ 0x07, 0x17, 0x0e, 0x1e }
+};
+
+/*
+ * Some direct events for decodes of event bus byte 3 have alternative
+ * PMCSEL values on other counters.  This returns the alternative
+ * event code for those that do, or -1 otherwise.  This also handles
+ * alternative PCMSEL values for add events.
+ */
+static int find_alternative_bdecode(unsigned int event)
+{
+	int pmc, altpmc, pp, j;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc == 0 || pmc > 4)
+		return -1;
+	altpmc = 5 - pmc;	/* 1 <-> 4, 2 <-> 3 */
+	pp = event & PM_PMCSEL_MSK;
+	for (j = 0; j < 4; ++j) {
+		if (bytedecode_alternatives[pmc - 1][j] == pp) {
+			return (event & ~(PM_PMC_MSKS | PM_PMCSEL_MSK)) |
+				(altpmc << PM_PMC_SH) |
+				bytedecode_alternatives[altpmc - 1][j];
+		}
+	}
+
+	/* new decode alternatives for power5+ */
+	if (pmc == 1 && (pp == 0x0d || pp == 0x0e))
+		return event + (2 << PM_PMC_SH) + (0x2e - 0x0d);
+	if (pmc == 3 && (pp == 0x2e || pp == 0x2f))
+		return event - (2 << PM_PMC_SH) - (0x2e - 0x0d);
+
+	/* alternative add event encodings */
+	if (pp == 0x10 || pp == 0x28)
+		return ((event ^ (0x10 ^ 0x28)) & ~PM_PMC_MSKS) |
+			(altpmc << PM_PMC_SH);
+
+	return -1;
+}
+
+static int power5p_get_alternatives(unsigned int event, unsigned int alt[])
+{
+	int i, j, ae, nalt = 1;
+
+	alt[0] = event;
+	nalt = 1;
+	i = find_alternative(event);
+	if (i >= 0) {
+		for (j = 0; j < MAX_ALT; ++j) {
+			ae = event_alternatives[i][j];
+			if (ae && ae != event)
+				alt[nalt++] = ae;
+		}
+	} else {
+		ae = find_alternative_bdecode(event);
+		if (ae > 0)
+			alt[nalt++] = ae;
+	}
+	return nalt;
+}
+
+static int power5p_compute_mmcr(unsigned int event[], int n_ev,
+				unsigned int hwc[], u64 mmcr[])
+{
+	u64 mmcr1 = 0;
+	unsigned int pmc, unit, byte, psel;
+	unsigned int ttm;
+	int i, isbus, bit, grsel;
+	unsigned int pmc_inuse = 0;
+	unsigned char busbyte[4];
+	unsigned char unituse[16];
+	int ttmuse;
+
+	if (n_ev > 4)
+		return -1;
+
+	/* First pass to count resource use */
+	memset(busbyte, 0, sizeof(busbyte));
+	memset(unituse, 0, sizeof(unituse));
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			if (pmc > 4)
+				return -1;
+			if (pmc_inuse & (1 << (pmc - 1)))
+				return -1;
+			pmc_inuse |= 1 << (pmc - 1);
+		}
+		if (event[i] & PM_BUSEVENT_MSK) {
+			unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+			byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+			if (unit > PM_LASTUNIT)
+				return -1;
+			if (unit == PM_ISU0_ALT)
+				unit = PM_ISU0;
+			if (byte >= 4) {
+				if (unit != PM_LSU1)
+					return -1;
+				++unit;
+				byte &= 3;
+			}
+			if (busbyte[byte] && busbyte[byte] != unit)
+				return -1;
+			busbyte[byte] = unit;
+			unituse[unit] = 1;
+		}
+	}
+
+	/*
+	 * Assign resources and set multiplexer selects.
+	 *
+	 * PM_ISU0 can go either on TTM0 or TTM1, but that's the only
+	 * choice we have to deal with.
+	 */
+	if (unituse[PM_ISU0] &
+	    (unituse[PM_FPU] | unituse[PM_IFU] | unituse[PM_ISU1])) {
+		unituse[PM_ISU0_ALT] = 1;	/* move ISU to TTM1 */
+		unituse[PM_ISU0] = 0;
+	}
+	/* Set TTM[01]SEL fields. */
+	ttmuse = 0;
+	for (i = PM_FPU; i <= PM_ISU1; ++i) {
+		if (!unituse[i])
+			continue;
+		if (ttmuse++)
+			return -1;
+		mmcr1 |= (u64)i << MMCR1_TTM0SEL_SH;
+	}
+	ttmuse = 0;
+	for (; i <= PM_GRS; ++i) {
+		if (!unituse[i])
+			continue;
+		if (ttmuse++)
+			return -1;
+		mmcr1 |= (u64)(i & 3) << MMCR1_TTM1SEL_SH;
+	}
+	if (ttmuse > 1)
+		return -1;
+
+	/* Set byte lane select fields, TTM[23]SEL and GRS_*SEL. */
+	for (byte = 0; byte < 4; ++byte) {
+		unit = busbyte[byte];
+		if (!unit)
+			continue;
+		if (unit == PM_ISU0 && unituse[PM_ISU0_ALT]) {
+			/* get ISU0 through TTM1 rather than TTM0 */
+			unit = PM_ISU0_ALT;
+		} else if (unit == PM_LSU1 + 1) {
+			/* select lower word of LSU1 for this byte */
+			mmcr1 |= 1ull << (MMCR1_TTM3SEL_SH + 3 - byte);
+		}
+		ttm = unit >> 2;
+		mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
+	}
+
+	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+		byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+		psel = event[i] & PM_PMCSEL_MSK;
+		isbus = event[i] & PM_BUSEVENT_MSK;
+		if (!pmc) {
+			/* Bus event or any-PMC direct event */
+			for (pmc = 0; pmc < 4; ++pmc) {
+				if (!(pmc_inuse & (1 << pmc)))
+					break;
+			}
+			if (pmc >= 4)
+				return -1;
+			pmc_inuse |= 1 << pmc;
+		} else {
+			/* Direct event */
+			--pmc;
+			if (isbus && (byte & 2) &&
+			    (psel == 8 || psel == 0x10 || psel == 0x28))
+				/* add events on higher-numbered bus */
+				mmcr1 |= 1ull << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
+		}
+		if (isbus && unit == PM_GRS) {
+			bit = psel & 7;
+			grsel = (event[i] >> PM_GRS_SH) & PM_GRS_MSK;
+			mmcr1 |= (u64)grsel << grsel_shift[bit];
+		}
+		if ((psel & 0x58) == 0x40 && (byte & 1) != ((pmc >> 1) & 1))
+			/* select alternate byte lane */
+			psel |= 0x10;
+		if (pmc <= 3)
+			mmcr1 |= psel << MMCR1_PMCSEL_SH(pmc);
+		hwc[i] = pmc;
+	}
+
+	/* Return MMCRx values */
+	mmcr[0] = 0;
+	if (pmc_inuse & 1)
+		mmcr[0] = MMCR0_PMC1CE;
+	if (pmc_inuse & 0x3e)
+		mmcr[0] |= MMCR0_PMCjCE;
+	mmcr[1] = mmcr1;
+	mmcr[2] = 0;
+	return 0;
+}
+
+static void power5p_disable_pmc(unsigned int pmc, u64 mmcr[])
+{
+	if (pmc <= 3)
+		mmcr[1] &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
+}
+
+static int power5p_generic_events[] = {
+	[PERF_COUNT_CPU_CYCLES] = 0xf,
+	[PERF_COUNT_INSTRUCTIONS] = 0x100009,
+	[PERF_COUNT_CACHE_REFERENCES] = 0x1c10a8,	/* LD_REF_L1 */
+	[PERF_COUNT_CACHE_MISSES] = 0x3c1088,		/* LD_MISS_L1 */
+	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x230e4,	/* BR_ISSUED */ 
+	[PERF_COUNT_BRANCH_MISSES] = 0x230e5,		/* BR_MPRED_CR */
+};
+
+struct power_pmu power5p_pmu = {
+	.n_counter = 4,
+	.max_alternatives = MAX_ALT,
+	.add_fields = 0x7000000000055ull,
+	.test_adder = 0x3000040000000ull,
+	.compute_mmcr = power5p_compute_mmcr,
+	.get_constraint = power5p_get_constraint,
+	.get_alternatives = power5p_get_alternatives,
+	.disable_pmc = power5p_disable_pmc,
+	.n_generic = ARRAY_SIZE(power5p_generic_events),
+	.generic_events = power5p_generic_events,
+};
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
new file mode 100644
index 0000000..379ed10
--- /dev/null
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -0,0 +1,475 @@
+/*
+ * Performance counter support for POWER5 (not POWER5++) processors.
+ *
+ * Copyright 2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/perf_counter.h>
+#include <asm/reg.h>
+
+/*
+ * Bits in event code for POWER5 (not POWER5++)
+ */
+#define PM_PMC_SH	20	/* PMC number (1-based) for direct events */
+#define PM_PMC_MSK	0xf
+#define PM_PMC_MSKS	(PM_PMC_MSK << PM_PMC_SH)
+#define PM_UNIT_SH	16	/* TTMMUX number and setting - unit select */
+#define PM_UNIT_MSK	0xf
+#define PM_BYTE_SH	12	/* Byte number of event bus to use */
+#define PM_BYTE_MSK	7
+#define PM_GRS_SH	8	/* Storage subsystem mux select */
+#define PM_GRS_MSK	7
+#define PM_BUSEVENT_MSK	0x80	/* Set if event uses event bus */
+#define PM_PMCSEL_MSK	0x7f
+
+/* Values in PM_UNIT field */
+#define PM_FPU		0
+#define PM_ISU0		1
+#define PM_IFU		2
+#define PM_ISU1		3
+#define PM_IDU		4
+#define PM_ISU0_ALT	6
+#define PM_GRS		7
+#define PM_LSU0		8
+#define PM_LSU1		0xc
+#define PM_LASTUNIT	0xc
+
+/*
+ * Bits in MMCR1 for POWER5
+ */
+#define MMCR1_TTM0SEL_SH	62
+#define MMCR1_TTM1SEL_SH	60
+#define MMCR1_TTM2SEL_SH	58
+#define MMCR1_TTM3SEL_SH	56
+#define MMCR1_TTMSEL_MSK	3
+#define MMCR1_TD_CP_DBG0SEL_SH	54
+#define MMCR1_TD_CP_DBG1SEL_SH	52
+#define MMCR1_TD_CP_DBG2SEL_SH	50
+#define MMCR1_TD_CP_DBG3SEL_SH	48
+#define MMCR1_GRS_L2SEL_SH	46
+#define MMCR1_GRS_L2SEL_MSK	3
+#define MMCR1_GRS_L3SEL_SH	44
+#define MMCR1_GRS_L3SEL_MSK	3
+#define MMCR1_GRS_MCSEL_SH	41
+#define MMCR1_GRS_MCSEL_MSK	7
+#define MMCR1_GRS_FABSEL_SH	39
+#define MMCR1_GRS_FABSEL_MSK	3
+#define MMCR1_PMC1_ADDER_SEL_SH	35
+#define MMCR1_PMC2_ADDER_SEL_SH	34
+#define MMCR1_PMC3_ADDER_SEL_SH	33
+#define MMCR1_PMC4_ADDER_SEL_SH	32
+#define MMCR1_PMC1SEL_SH	25
+#define MMCR1_PMC2SEL_SH	17
+#define MMCR1_PMC3SEL_SH	9
+#define MMCR1_PMC4SEL_SH	1
+#define MMCR1_PMCSEL_SH(n)	(MMCR1_PMC1SEL_SH - (n) * 8)
+#define MMCR1_PMCSEL_MSK	0x7f
+
+/*
+ * Bits in MMCRA
+ */
+
+/*
+ * Layout of constraint bits:
+ * 6666555555555544444444443333333333222222222211111111110000000000
+ * 3210987654321098765432109876543210987654321098765432109876543210
+ *         <><>[  ><><>< ><> [  >[ >[ ><  ><  ><  ><  ><><><><><><>
+ *         T0T1 NC G0G1G2 G3  UC PS1PS2 B0  B1  B2  B3 P6P5P4P3P2P1
+ *
+ * T0 - TTM0 constraint
+ *     54-55: TTM0SEL value (0=FPU, 2=IFU, 3=ISU1) 0xc0_0000_0000_0000
+ *
+ * T1 - TTM1 constraint
+ *     52-53: TTM1SEL value (0=IDU, 3=GRS) 0x30_0000_0000_0000
+ *
+ * NC - number of counters
+ *     51: NC error 0x0008_0000_0000_0000
+ *     48-50: number of events needing PMC1-4 0x0007_0000_0000_0000
+ *
+ * G0..G3 - GRS mux constraints
+ *     46-47: GRS_L2SEL value
+ *     44-45: GRS_L3SEL value
+ *     41-44: GRS_MCSEL value
+ *     39-40: GRS_FABSEL value
+ *	Note that these match up with their bit positions in MMCR1
+ *
+ * UC - unit constraint: can't have all three of FPU|IFU|ISU1, ISU0, IDU|GRS
+ *     37: UC3 error 0x20_0000_0000
+ *     36: FPU|IFU|ISU1 events needed 0x10_0000_0000
+ *     35: ISU0 events needed 0x08_0000_0000
+ *     34: IDU|GRS events needed 0x04_0000_0000
+ *
+ * PS1
+ *     33: PS1 error 0x2_0000_0000
+ *     31-32: count of events needing PMC1/2 0x1_8000_0000
+ *
+ * PS2
+ *     30: PS2 error 0x4000_0000
+ *     28-29: count of events needing PMC3/4 0x3000_0000
+ *
+ * B0
+ *     24-27: Byte 0 event source 0x0f00_0000
+ *	      Encoding as for the event code
+ *
+ * B1, B2, B3
+ *     20-23, 16-19, 12-15: Byte 1, 2, 3 event sources
+ *
+ * P1..P6
+ *     0-11: Count of events needing PMC1..PMC6
+ */
+
+static const int grsel_shift[8] = {
+	MMCR1_GRS_L2SEL_SH, MMCR1_GRS_L2SEL_SH, MMCR1_GRS_L2SEL_SH,
+	MMCR1_GRS_L3SEL_SH, MMCR1_GRS_L3SEL_SH, MMCR1_GRS_L3SEL_SH,
+	MMCR1_GRS_MCSEL_SH, MMCR1_GRS_FABSEL_SH
+};
+
+/* Masks and values for using events from the various units */
+static u64 unit_cons[PM_LASTUNIT+1][2] = {
+	[PM_FPU] =   { 0xc0002000000000ull, 0x00001000000000ull },
+	[PM_ISU0] =  { 0x00002000000000ull, 0x00000800000000ull },
+	[PM_ISU1] =  { 0xc0002000000000ull, 0xc0001000000000ull },
+	[PM_IFU] =   { 0xc0002000000000ull, 0x80001000000000ull },
+	[PM_IDU] =   { 0x30002000000000ull, 0x00000400000000ull },
+	[PM_GRS] =   { 0x30002000000000ull, 0x30000400000000ull },
+};
+
+static int power5_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+{
+	int pmc, byte, unit, sh;
+	int bit, fmask;
+	u64 mask = 0, value = 0;
+	int grp = -1;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc) {
+		if (pmc > 6)
+			return -1;
+		sh = (pmc - 1) * 2;
+		mask |= 2 << sh;
+		value |= 1 << sh;
+		if (pmc <= 4)
+			grp = (pmc - 1) >> 1;
+		else if (event != 0x500009 && event != 0x600005)
+			return -1;
+	}
+	if (event & PM_BUSEVENT_MSK) {
+		unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+		if (unit > PM_LASTUNIT)
+			return -1;
+		if (unit == PM_ISU0_ALT)
+			unit = PM_ISU0;
+		mask |= unit_cons[unit][0];
+		value |= unit_cons[unit][1];
+		byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+		if (byte >= 4) {
+			if (unit != PM_LSU1)
+				return -1;
+			/* Map LSU1 low word (bytes 4-7) to unit LSU1+1 */
+			++unit;
+			byte &= 3;
+		}
+		if (unit == PM_GRS) {
+			bit = event & 7;
+			fmask = (bit == 6)? 7: 3;
+			sh = grsel_shift[bit];
+			mask |= (u64)fmask << sh;
+			value |= (u64)((event >> PM_GRS_SH) & fmask) << sh;
+		}
+		/*
+		 * Bus events on bytes 0 and 2 can be counted
+		 * on PMC1/2; bytes 1 and 3 on PMC3/4.
+		 */
+		if (!pmc)
+			grp = byte & 1;
+		/* Set byte lane select field */
+		mask  |= 0xfULL << (24 - 4 * byte);
+		value |= (u64)unit << (24 - 4 * byte);
+	}
+	if (grp == 0) {
+		/* increment PMC1/2 field */
+		mask  |= 0x200000000ull;
+		value |= 0x080000000ull;
+	} else if (grp == 1) {
+		/* increment PMC3/4 field */
+		mask  |= 0x40000000ull;
+		value |= 0x10000000ull;
+	}
+	if (pmc < 5) {
+		/* need a counter from PMC1-4 set */
+		mask  |= 0x8000000000000ull;
+		value |= 0x1000000000000ull;
+	}
+	*maskp = mask;
+	*valp = value;
+	return 0;
+}
+
+#define MAX_ALT	3	/* at most 3 alternatives for any event */
+
+static const unsigned int event_alternatives[][MAX_ALT] = {
+	{ 0x120e4,  0x400002 },			/* PM_GRP_DISP_REJECT */
+	{ 0x410c7,  0x441084 },			/* PM_THRD_L2MISS_BOTH_CYC */
+	{ 0x100005, 0x600005 },			/* PM_RUN_CYC */
+	{ 0x100009, 0x200009, 0x500009 },	/* PM_INST_CMPL */
+	{ 0x300009, 0x400009 },			/* PM_INST_DISP */
+};
+
+/*
+ * Scan the alternatives table for a match and return the
+ * index into the alternatives table if found, else -1.
+ */
+static int find_alternative(unsigned int event)
+{
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(event_alternatives); ++i) {
+		if (event < event_alternatives[i][0])
+			break;
+		for (j = 0; j < MAX_ALT && event_alternatives[i][j]; ++j)
+			if (event == event_alternatives[i][j])
+				return i;
+	}
+	return -1;
+}
+
+static const unsigned char bytedecode_alternatives[4][4] = {
+	/* PMC 1 */	{ 0x21, 0x23, 0x25, 0x27 },
+	/* PMC 2 */	{ 0x07, 0x17, 0x0e, 0x1e },
+	/* PMC 3 */	{ 0x20, 0x22, 0x24, 0x26 },
+	/* PMC 4 */	{ 0x07, 0x17, 0x0e, 0x1e }
+};
+
+/*
+ * Some direct events for decodes of event bus byte 3 have alternative
+ * PMCSEL values on other counters.  This returns the alternative
+ * event code for those that do, or -1 otherwise.
+ */
+static int find_alternative_bdecode(unsigned int event)
+{
+	int pmc, altpmc, pp, j;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc == 0 || pmc > 4)
+		return -1;
+	altpmc = 5 - pmc;	/* 1 <-> 4, 2 <-> 3 */
+	pp = event & PM_PMCSEL_MSK;
+	for (j = 0; j < 4; ++j) {
+		if (bytedecode_alternatives[pmc - 1][j] == pp) {
+			return (event & ~(PM_PMC_MSKS | PM_PMCSEL_MSK)) |
+				(altpmc << PM_PMC_SH) |
+				bytedecode_alternatives[altpmc - 1][j];
+		}
+	}
+	return -1;
+}
+
+static int power5_get_alternatives(unsigned int event, unsigned int alt[])
+{
+	int i, j, ae, nalt = 1;
+
+	alt[0] = event;
+	nalt = 1;
+	i = find_alternative(event);
+	if (i >= 0) {
+		for (j = 0; j < MAX_ALT; ++j) {
+			ae = event_alternatives[i][j];
+			if (ae && ae != event)
+				alt[nalt++] = ae;
+		}
+	} else {
+		ae = find_alternative_bdecode(event);
+		if (ae > 0)
+			alt[nalt++] = ae;
+	}
+	return nalt;
+}
+
+static int power5_compute_mmcr(unsigned int event[], int n_ev,
+			       unsigned int hwc[], u64 mmcr[])
+{
+	u64 mmcr1 = 0;
+	unsigned int pmc, unit, byte, psel;
+	unsigned int ttm, grp;
+	int i, isbus, bit, grsel;
+	unsigned int pmc_inuse = 0;
+	unsigned int pmc_grp_use[2];
+	unsigned char busbyte[4];
+	unsigned char unituse[16];
+	int ttmuse;
+
+	if (n_ev > 6)
+		return -1;
+
+	/* First pass to count resource use */
+	pmc_grp_use[0] = pmc_grp_use[1] = 0;
+	memset(busbyte, 0, sizeof(busbyte));
+	memset(unituse, 0, sizeof(unituse));
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			if (pmc > 6)
+				return -1;
+			if (pmc_inuse & (1 << (pmc - 1)))
+				return -1;
+			pmc_inuse |= 1 << (pmc - 1);
+			/* count 1/2 vs 3/4 use */
+			if (pmc <= 4)
+				++pmc_grp_use[(pmc - 1) >> 1];
+		}
+		if (event[i] & PM_BUSEVENT_MSK) {
+			unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+			byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+			if (unit > PM_LASTUNIT)
+				return -1;
+			if (unit == PM_ISU0_ALT)
+				unit = PM_ISU0;
+			if (byte >= 4) {
+				if (unit != PM_LSU1)
+					return -1;
+				++unit;
+				byte &= 3;
+			}
+			if (!pmc)
+				++pmc_grp_use[byte & 1];
+			if (busbyte[byte] && busbyte[byte] != unit)
+				return -1;
+			busbyte[byte] = unit;
+			unituse[unit] = 1;
+		}
+	}
+	if (pmc_grp_use[0] > 2 || pmc_grp_use[1] > 2)
+		return -1;
+
+	/*
+	 * Assign resources and set multiplexer selects.
+	 *
+	 * PM_ISU0 can go either on TTM0 or TTM1, but that's the only
+	 * choice we have to deal with.
+	 */
+	if (unituse[PM_ISU0] &
+	    (unituse[PM_FPU] | unituse[PM_IFU] | unituse[PM_ISU1])) {
+		unituse[PM_ISU0_ALT] = 1;	/* move ISU to TTM1 */
+		unituse[PM_ISU0] = 0;
+	}
+	/* Set TTM[01]SEL fields. */
+	ttmuse = 0;
+	for (i = PM_FPU; i <= PM_ISU1; ++i) {
+		if (!unituse[i])
+			continue;
+		if (ttmuse++)
+			return -1;
+		mmcr1 |= (u64)i << MMCR1_TTM0SEL_SH;
+	}
+	ttmuse = 0;
+	for (; i <= PM_GRS; ++i) {
+		if (!unituse[i])
+			continue;
+		if (ttmuse++)
+			return -1;
+		mmcr1 |= (u64)(i & 3) << MMCR1_TTM1SEL_SH;
+	}
+	if (ttmuse > 1)
+		return -1;
+
+	/* Set byte lane select fields, TTM[23]SEL and GRS_*SEL. */
+	for (byte = 0; byte < 4; ++byte) {
+		unit = busbyte[byte];
+		if (!unit)
+			continue;
+		if (unit == PM_ISU0 && unituse[PM_ISU0_ALT]) {
+			/* get ISU0 through TTM1 rather than TTM0 */
+			unit = PM_ISU0_ALT;
+		} else if (unit == PM_LSU1 + 1) {
+			/* select lower word of LSU1 for this byte */
+			mmcr1 |= 1ull << (MMCR1_TTM3SEL_SH + 3 - byte);
+		}
+		ttm = unit >> 2;
+		mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
+	}
+
+	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+		byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+		psel = event[i] & PM_PMCSEL_MSK;
+		isbus = event[i] & PM_BUSEVENT_MSK;
+		if (!pmc) {
+			/* Bus event or any-PMC direct event */
+			for (pmc = 0; pmc < 4; ++pmc) {
+				if (pmc_inuse & (1 << pmc))
+					continue;
+				grp = (pmc >> 1) & 1;
+				if (isbus) {
+					if (grp == (byte & 1))
+						break;
+				} else if (pmc_grp_use[grp] < 2) {
+					++pmc_grp_use[grp];
+					break;
+				}
+			}
+			pmc_inuse |= 1 << pmc;
+		} else if (pmc <= 4) {
+			/* Direct event */
+			--pmc;
+			if ((psel == 8 || psel == 0x10) && isbus && (byte & 2))
+				/* add events on higher-numbered bus */
+				mmcr1 |= 1ull << (MMCR1_PMC1_ADDER_SEL_SH - pmc);
+		} else {
+			/* Instructions or run cycles on PMC5/6 */
+			--pmc;
+		}
+		if (isbus && unit == PM_GRS) {
+			bit = psel & 7;
+			grsel = (event[i] >> PM_GRS_SH) & PM_GRS_MSK;
+			mmcr1 |= (u64)grsel << grsel_shift[bit];
+		}
+		if (pmc <= 3)
+			mmcr1 |= psel << MMCR1_PMCSEL_SH(pmc);
+		hwc[i] = pmc;
+	}
+
+	/* Return MMCRx values */
+	mmcr[0] = 0;
+	if (pmc_inuse & 1)
+		mmcr[0] = MMCR0_PMC1CE;
+	if (pmc_inuse & 0x3e)
+		mmcr[0] |= MMCR0_PMCjCE;
+	mmcr[1] = mmcr1;
+	mmcr[2] = 0;
+	return 0;
+}
+
+static void power5_disable_pmc(unsigned int pmc, u64 mmcr[])
+{
+	if (pmc <= 3)
+		mmcr[1] &= ~(0x7fUL << MMCR1_PMCSEL_SH(pmc));
+}
+
+static int power5_generic_events[] = {
+	[PERF_COUNT_CPU_CYCLES] = 0xf,
+	[PERF_COUNT_INSTRUCTIONS] = 0x100009,
+	[PERF_COUNT_CACHE_REFERENCES] = 0x4c1090,	/* LD_REF_L1 */
+	[PERF_COUNT_CACHE_MISSES] = 0x3c1088,		/* LD_MISS_L1 */
+	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x230e4,	/* BR_ISSUED */ 
+	[PERF_COUNT_BRANCH_MISSES] = 0x230e5,		/* BR_MPRED_CR */
+};
+
+struct power_pmu power5_pmu = {
+	.n_counter = 6,
+	.max_alternatives = MAX_ALT,
+	.add_fields = 0x7000090000555ull,
+	.test_adder = 0x3000490000000ull,
+	.compute_mmcr = power5_compute_mmcr,
+	.get_constraint = power5_get_constraint,
+	.get_alternatives = power5_get_alternatives,
+	.disable_pmc = power5_disable_pmc,
+	.n_generic = ARRAY_SIZE(power5_generic_events),
+	.generic_events = power5_generic_events,
+};
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
new file mode 100644
index 0000000..b1f61f3
--- /dev/null
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -0,0 +1,283 @@
+/*
+ * Performance counter support for POWER6 processors.
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/perf_counter.h>
+#include <asm/reg.h>
+
+/*
+ * Bits in event code for POWER6
+ */
+#define PM_PMC_SH	20	/* PMC number (1-based) for direct events */
+#define PM_PMC_MSK	0x7
+#define PM_PMC_MSKS	(PM_PMC_MSK << PM_PMC_SH)
+#define PM_UNIT_SH	16	/* Unit event comes (TTMxSEL encoding) */
+#define PM_UNIT_MSK	0xf
+#define PM_UNIT_MSKS	(PM_UNIT_MSK << PM_UNIT_SH)
+#define PM_LLAV		0x8000	/* Load lookahead match value */
+#define PM_LLA		0x4000	/* Load lookahead match enable */
+#define PM_BYTE_SH	12	/* Byte of event bus to use */
+#define PM_BYTE_MSK	3
+#define PM_SUBUNIT_SH	8	/* Subunit event comes from (NEST_SEL enc.) */
+#define PM_SUBUNIT_MSK	7
+#define PM_SUBUNIT_MSKS	(PM_SUBUNIT_MSK << PM_SUBUNIT_SH)
+#define PM_PMCSEL_MSK	0xff	/* PMCxSEL value */
+#define PM_BUSEVENT_MSK	0xf3700
+
+/*
+ * Bits in MMCR1 for POWER6
+ */
+#define MMCR1_TTM0SEL_SH	60
+#define MMCR1_TTMSEL_SH(n)	(MMCR1_TTM0SEL_SH - (n) * 4)
+#define MMCR1_TTMSEL_MSK	0xf
+#define MMCR1_TTMSEL(m, n)	(((m) >> MMCR1_TTMSEL_SH(n)) & MMCR1_TTMSEL_MSK)
+#define MMCR1_NESTSEL_SH	45
+#define MMCR1_NESTSEL_MSK	0x7
+#define MMCR1_NESTSEL(m)	(((m) >> MMCR1_NESTSEL_SH) & MMCR1_NESTSEL_MSK)
+#define MMCR1_PMC1_LLA		((u64)1 << 44)
+#define MMCR1_PMC1_LLA_VALUE	((u64)1 << 39)
+#define MMCR1_PMC1_ADDR_SEL	((u64)1 << 35)
+#define MMCR1_PMC1SEL_SH	24
+#define MMCR1_PMCSEL_SH(n)	(MMCR1_PMC1SEL_SH - (n) * 8)
+#define MMCR1_PMCSEL_MSK	0xff
+
+/*
+ * Assign PMC numbers and compute MMCR1 value for a set of events
+ */
+static int p6_compute_mmcr(unsigned int event[], int n_ev,
+			   unsigned int hwc[], u64 mmcr[])
+{
+	u64 mmcr1 = 0;
+	int i;
+	unsigned int pmc, ev, b, u, s, psel;
+	unsigned int ttmset = 0;
+	unsigned int pmc_inuse = 0;
+
+	if (n_ev > 4)
+		return -1;
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			if (pmc_inuse & (1 << (pmc - 1)))
+				return -1;	/* collision! */
+			pmc_inuse |= 1 << (pmc - 1);
+		}
+	}
+	for (i = 0; i < n_ev; ++i) {
+		ev = event[i];
+		pmc = (ev >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			--pmc;
+		} else {
+			/* can go on any PMC; find a free one */
+			for (pmc = 0; pmc < 4; ++pmc)
+				if (!(pmc_inuse & (1 << pmc)))
+					break;
+			pmc_inuse |= 1 << pmc;
+		}
+		hwc[i] = pmc;
+		psel = ev & PM_PMCSEL_MSK;
+		if (ev & PM_BUSEVENT_MSK) {
+			/* this event uses the event bus */
+			b = (ev >> PM_BYTE_SH) & PM_BYTE_MSK;
+			u = (ev >> PM_UNIT_SH) & PM_UNIT_MSK;
+			/* check for conflict on this byte of event bus */
+			if ((ttmset & (1 << b)) && MMCR1_TTMSEL(mmcr1, b) != u)
+				return -1;
+			mmcr1 |= (u64)u << MMCR1_TTMSEL_SH(b);
+			ttmset |= 1 << b;
+			if (u == 5) {
+				/* Nest events have a further mux */
+				s = (ev >> PM_SUBUNIT_SH) & PM_SUBUNIT_MSK;
+				if ((ttmset & 0x10) &&
+				    MMCR1_NESTSEL(mmcr1) != s)
+					return -1;
+				ttmset |= 0x10;
+				mmcr1 |= (u64)s << MMCR1_NESTSEL_SH;
+			}
+			if (0x30 <= psel && psel <= 0x3d) {
+				/* these need the PMCx_ADDR_SEL bits */
+				if (b >= 2)
+					mmcr1 |= MMCR1_PMC1_ADDR_SEL >> pmc;
+			}
+			/* bus select values are different for PMC3/4 */
+			if (pmc >= 2 && (psel & 0x90) == 0x80)
+				psel ^= 0x20;
+		}
+		if (ev & PM_LLA) {
+			mmcr1 |= MMCR1_PMC1_LLA >> pmc;
+			if (ev & PM_LLAV)
+				mmcr1 |= MMCR1_PMC1_LLA_VALUE >> pmc;
+		}
+		mmcr1 |= (u64)psel << MMCR1_PMCSEL_SH(pmc);
+	}
+	mmcr[0] = 0;
+	if (pmc_inuse & 1)
+		mmcr[0] = MMCR0_PMC1CE;
+	if (pmc_inuse & 0xe)
+		mmcr[0] |= MMCR0_PMCjCE;
+	mmcr[1] = mmcr1;
+	mmcr[2] = 0;
+	return 0;
+}
+
+/*
+ * Layout of constraint bits:
+ *
+ *	0-1	add field: number of uses of PMC1 (max 1)
+ *	2-3, 4-5, 6-7: ditto for PMC2, 3, 4
+ *	8-10	select field: nest (subunit) event selector
+ *	16-19	select field: unit on byte 0 of event bus
+ *	20-23, 24-27, 28-31 ditto for bytes 1, 2, 3
+ */
+static int p6_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+{
+	int pmc, byte, sh;
+	unsigned int mask = 0, value = 0;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc) {
+		if (pmc > 4)
+			return -1;
+		sh = (pmc - 1) * 2;
+		mask |= 2 << sh;
+		value |= 1 << sh;
+	}
+	if (event & PM_BUSEVENT_MSK) {
+		byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+		sh = byte * 4;
+		mask |= PM_UNIT_MSKS << sh;
+		value |= (event & PM_UNIT_MSKS) << sh;
+		if ((event & PM_UNIT_MSKS) == (5 << PM_UNIT_SH)) {
+			mask |= PM_SUBUNIT_MSKS;
+			value |= event & PM_SUBUNIT_MSKS;
+		}
+	}
+	*maskp = mask;
+	*valp = value;
+	return 0;
+}
+
+#define MAX_ALT	4	/* at most 4 alternatives for any event */
+
+static const unsigned int event_alternatives[][MAX_ALT] = {
+	{ 0x0130e8, 0x2000f6, 0x3000fc },	/* PM_PTEG_RELOAD_VALID */
+	{ 0x080080, 0x10000d, 0x30000c, 0x4000f0 }, /* PM_LD_MISS_L1 */
+	{ 0x080088, 0x200054, 0x3000f0 },	/* PM_ST_MISS_L1 */
+	{ 0x10000a, 0x2000f4 },			/* PM_RUN_CYC */
+	{ 0x10000b, 0x2000f5 },			/* PM_RUN_COUNT */
+	{ 0x10000e, 0x400010 },			/* PM_PURR */
+	{ 0x100010, 0x4000f8 },			/* PM_FLUSH */
+	{ 0x10001a, 0x200010 },			/* PM_MRK_INST_DISP */
+	{ 0x100026, 0x3000f8 },			/* PM_TB_BIT_TRANS */
+	{ 0x100054, 0x2000f0 },			/* PM_ST_FIN */
+	{ 0x100056, 0x2000fc },			/* PM_L1_ICACHE_MISS */
+	{ 0x1000f0, 0x40000a },			/* PM_INST_IMC_MATCH_CMPL */
+	{ 0x1000f8, 0x200008 },			/* PM_GCT_EMPTY_CYC */
+	{ 0x1000fc, 0x400006 },			/* PM_LSU_DERAT_MISS_CYC */
+	{ 0x20000e, 0x400007 },			/* PM_LSU_DERAT_MISS */
+	{ 0x200012, 0x300012 },			/* PM_INST_DISP */
+	{ 0x2000f2, 0x3000f2 },			/* PM_INST_DISP */
+	{ 0x2000f8, 0x300010 },			/* PM_EXT_INT */
+	{ 0x2000fe, 0x300056 },			/* PM_DATA_FROM_L2MISS */
+	{ 0x2d0030, 0x30001a },			/* PM_MRK_FPU_FIN */
+	{ 0x30000a, 0x400018 },			/* PM_MRK_INST_FIN */
+	{ 0x3000f6, 0x40000e },			/* PM_L1_DCACHE_RELOAD_VALID */
+	{ 0x3000fe, 0x400056 },			/* PM_DATA_FROM_L3MISS */
+};
+
+/*
+ * This could be made more efficient with a binary search on
+ * a presorted list, if necessary
+ */
+static int find_alternatives_list(unsigned int event)
+{
+	int i, j;
+	unsigned int alt;
+
+	for (i = 0; i < ARRAY_SIZE(event_alternatives); ++i) {
+		if (event < event_alternatives[i][0])
+			return -1;
+		for (j = 0; j < MAX_ALT; ++j) {
+			alt = event_alternatives[i][j];
+			if (!alt || event < alt)
+				break;
+			if (event == alt)
+				return i;
+		}
+	}
+	return -1;
+}
+
+static int p6_get_alternatives(unsigned int event, unsigned int alt[])
+{
+	int i, j;
+	unsigned int aevent, psel, pmc;
+	unsigned int nalt = 1;
+
+	alt[0] = event;
+
+	/* check the alternatives table */
+	i = find_alternatives_list(event);
+	if (i >= 0) {
+		/* copy out alternatives from list */
+		for (j = 0; j < MAX_ALT; ++j) {
+			aevent = event_alternatives[i][j];
+			if (!aevent)
+				break;
+			if (aevent != event)
+				alt[nalt++] = aevent;
+		}
+
+	} else {
+		/* Check for alternative ways of computing sum events */
+		/* PMCSEL 0x32 counter N == PMCSEL 0x34 counter 5-N */
+		psel = event & (PM_PMCSEL_MSK & ~1);	/* ignore edge bit */
+		pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc && (psel == 0x32 || psel == 0x34))
+			alt[nalt++] = ((event ^ 0x6) & ~PM_PMC_MSKS) |
+				((5 - pmc) << PM_PMC_SH);
+
+		/* PMCSEL 0x38 counter N == PMCSEL 0x3a counter N+/-2 */
+		if (pmc && (psel == 0x38 || psel == 0x3a))
+			alt[nalt++] = ((event ^ 0x2) & ~PM_PMC_MSKS) |
+				((pmc > 2? pmc - 2: pmc + 2) << PM_PMC_SH);
+	}
+
+	return nalt;
+}
+
+static void p6_disable_pmc(unsigned int pmc, u64 mmcr[])
+{
+	/* Set PMCxSEL to 0 to disable PMCx */
+	mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
+}
+
+static int power6_generic_events[] = {
+	[PERF_COUNT_CPU_CYCLES] = 0x1e,
+	[PERF_COUNT_INSTRUCTIONS] = 2,
+	[PERF_COUNT_CACHE_REFERENCES] = 0x280030,	/* LD_REF_L1 */
+	[PERF_COUNT_CACHE_MISSES] = 0x30000c,		/* LD_MISS_L1 */
+	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x410a0,	/* BR_PRED */ 
+	[PERF_COUNT_BRANCH_MISSES] = 0x400052,		/* BR_MPRED */
+};
+
+struct power_pmu power6_pmu = {
+	.n_counter = 4,
+	.max_alternatives = MAX_ALT,
+	.add_fields = 0x55,
+	.test_adder = 0,
+	.compute_mmcr = p6_compute_mmcr,
+	.get_constraint = p6_get_constraint,
+	.get_alternatives = p6_get_alternatives,
+	.disable_pmc = p6_disable_pmc,
+	.n_generic = ARRAY_SIZE(power6_generic_events),
+	.generic_events = power6_generic_events,
+};
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
new file mode 100644
index 0000000..c325658
--- /dev/null
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -0,0 +1,375 @@
+/*
+ * Performance counter support for PPC970-family processors.
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/string.h>
+#include <linux/perf_counter.h>
+#include <asm/reg.h>
+
+/*
+ * Bits in event code for PPC970
+ */
+#define PM_PMC_SH	12	/* PMC number (1-based) for direct events */
+#define PM_PMC_MSK	0xf
+#define PM_UNIT_SH	8	/* TTMMUX number and setting - unit select */
+#define PM_UNIT_MSK	0xf
+#define PM_BYTE_SH	4	/* Byte number of event bus to use */
+#define PM_BYTE_MSK	3
+#define PM_PMCSEL_MSK	0xf
+
+/* Values in PM_UNIT field */
+#define PM_NONE		0
+#define PM_FPU		1
+#define PM_VPU		2
+#define PM_ISU		3
+#define PM_IFU		4
+#define PM_IDU		5
+#define PM_STS		6
+#define PM_LSU0		7
+#define PM_LSU1U	8
+#define PM_LSU1L	9
+#define PM_LASTUNIT	9
+
+/*
+ * Bits in MMCR0 for PPC970
+ */
+#define MMCR0_PMC1SEL_SH	8
+#define MMCR0_PMC2SEL_SH	1
+#define MMCR_PMCSEL_MSK		0x1f
+
+/*
+ * Bits in MMCR1 for PPC970
+ */
+#define MMCR1_TTM0SEL_SH	62
+#define MMCR1_TTM1SEL_SH	59
+#define MMCR1_TTM3SEL_SH	53
+#define MMCR1_TTMSEL_MSK	3
+#define MMCR1_TD_CP_DBG0SEL_SH	50
+#define MMCR1_TD_CP_DBG1SEL_SH	48
+#define MMCR1_TD_CP_DBG2SEL_SH	46
+#define MMCR1_TD_CP_DBG3SEL_SH	44
+#define MMCR1_PMC1_ADDER_SEL_SH	39
+#define MMCR1_PMC2_ADDER_SEL_SH	38
+#define MMCR1_PMC6_ADDER_SEL_SH	37
+#define MMCR1_PMC5_ADDER_SEL_SH	36
+#define MMCR1_PMC8_ADDER_SEL_SH	35
+#define MMCR1_PMC7_ADDER_SEL_SH	34
+#define MMCR1_PMC3_ADDER_SEL_SH	33
+#define MMCR1_PMC4_ADDER_SEL_SH	32
+#define MMCR1_PMC3SEL_SH	27
+#define MMCR1_PMC4SEL_SH	22
+#define MMCR1_PMC5SEL_SH	17
+#define MMCR1_PMC6SEL_SH	12
+#define MMCR1_PMC7SEL_SH	7
+#define MMCR1_PMC8SEL_SH	2
+
+static short mmcr1_adder_bits[8] = {
+	MMCR1_PMC1_ADDER_SEL_SH,
+	MMCR1_PMC2_ADDER_SEL_SH,
+	MMCR1_PMC3_ADDER_SEL_SH,
+	MMCR1_PMC4_ADDER_SEL_SH,
+	MMCR1_PMC5_ADDER_SEL_SH,
+	MMCR1_PMC6_ADDER_SEL_SH,
+	MMCR1_PMC7_ADDER_SEL_SH,
+	MMCR1_PMC8_ADDER_SEL_SH
+};
+
+/*
+ * Bits in MMCRA
+ */
+
+/*
+ * Layout of constraint bits:
+ * 6666555555555544444444443333333333222222222211111111110000000000
+ * 3210987654321098765432109876543210987654321098765432109876543210
+ *                 <><>[  >[  >[  ><  ><  ><  ><  ><><><><><><><><>
+ *                 T0T1 UC  PS1 PS2 B0  B1  B2  B3 P1P2P3P4P5P6P7P8
+ *
+ * T0 - TTM0 constraint
+ *     46-47: TTM0SEL value (0=FPU, 2=IFU, 3=VPU) 0xC000_0000_0000
+ *
+ * T1 - TTM1 constraint
+ *     44-45: TTM1SEL value (0=IDU, 3=STS) 0x3000_0000_0000
+ *
+ * UC - unit constraint: can't have all three of FPU|IFU|VPU, ISU, IDU|STS
+ *     43: UC3 error 0x0800_0000_0000
+ *     42: FPU|IFU|VPU events needed 0x0400_0000_0000
+ *     41: ISU events needed 0x0200_0000_0000
+ *     40: IDU|STS events needed 0x0100_0000_0000
+ *
+ * PS1
+ *     39: PS1 error 0x0080_0000_0000
+ *     36-38: count of events needing PMC1/2/5/6 0x0070_0000_0000
+ *
+ * PS2
+ *     35: PS2 error 0x0008_0000_0000
+ *     32-34: count of events needing PMC3/4/7/8 0x0007_0000_0000
+ *
+ * B0
+ *     28-31: Byte 0 event source 0xf000_0000
+ *	      Encoding as for the event code
+ *
+ * B1, B2, B3
+ *     24-27, 20-23, 16-19: Byte 1, 2, 3 event sources
+ *
+ * P1
+ *     15: P1 error 0x8000
+ *     14-15: Count of events needing PMC1
+ *
+ * P2..P8
+ *     0-13: Count of events needing PMC2..PMC8
+ */
+
+/* Masks and values for using events from the various units */
+static u64 unit_cons[PM_LASTUNIT+1][2] = {
+	[PM_FPU] =   { 0xc80000000000ull, 0x040000000000ull },
+	[PM_VPU] =   { 0xc80000000000ull, 0xc40000000000ull },
+	[PM_ISU] =   { 0x080000000000ull, 0x020000000000ull },
+	[PM_IFU] =   { 0xc80000000000ull, 0x840000000000ull },
+	[PM_IDU] =   { 0x380000000000ull, 0x010000000000ull },
+	[PM_STS] =   { 0x380000000000ull, 0x310000000000ull },
+};
+
+static int p970_get_constraint(unsigned int event, u64 *maskp, u64 *valp)
+{
+	int pmc, byte, unit, sh;
+	u64 mask = 0, value = 0;
+	int grp = -1;
+
+	pmc = (event >> PM_PMC_SH) & PM_PMC_MSK;
+	if (pmc) {
+		if (pmc > 8)
+			return -1;
+		sh = (pmc - 1) * 2;
+		mask |= 2 << sh;
+		value |= 1 << sh;
+		grp = ((pmc - 1) >> 1) & 1;
+	}
+	unit = (event >> PM_UNIT_SH) & PM_UNIT_MSK;
+	if (unit) {
+		if (unit > PM_LASTUNIT)
+			return -1;
+		mask |= unit_cons[unit][0];
+		value |= unit_cons[unit][1];
+		byte = (event >> PM_BYTE_SH) & PM_BYTE_MSK;
+		/*
+		 * Bus events on bytes 0 and 2 can be counted
+		 * on PMC1/2/5/6; bytes 1 and 3 on PMC3/4/7/8.
+		 */
+		if (!pmc)
+			grp = byte & 1;
+		/* Set byte lane select field */
+		mask  |= 0xfULL << (28 - 4 * byte);
+		value |= (u64)unit << (28 - 4 * byte);
+	}
+	if (grp == 0) {
+		/* increment PMC1/2/5/6 field */
+		mask  |= 0x8000000000ull;
+		value |= 0x1000000000ull;
+	} else if (grp == 1) {
+		/* increment PMC3/4/7/8 field */
+		mask  |= 0x800000000ull;
+		value |= 0x100000000ull;
+	}
+	*maskp = mask;
+	*valp = value;
+	return 0;
+}
+
+static int p970_get_alternatives(unsigned int event, unsigned int alt[])
+{
+	alt[0] = event;
+
+	/* 2 alternatives for LSU empty */
+	if (event == 0x2002 || event == 0x3002) {
+		alt[1] = event ^ 0x1000;
+		return 2;
+	}
+		
+	return 1;
+}
+
+static int p970_compute_mmcr(unsigned int event[], int n_ev,
+			     unsigned int hwc[], u64 mmcr[])
+{
+	u64 mmcr0 = 0, mmcr1 = 0, mmcra = 0;
+	unsigned int pmc, unit, byte, psel;
+	unsigned int ttm, grp;
+	unsigned int pmc_inuse = 0;
+	unsigned int pmc_grp_use[2];
+	unsigned char busbyte[4];
+	unsigned char unituse[16];
+	unsigned char unitmap[] = { 0, 0<<3, 3<<3, 1<<3, 2<<3, 0|4, 3|4 };
+	unsigned char ttmuse[2];
+	unsigned char pmcsel[8];
+	int i;
+
+	if (n_ev > 8)
+		return -1;
+
+	/* First pass to count resource use */
+	pmc_grp_use[0] = pmc_grp_use[1] = 0;
+	memset(busbyte, 0, sizeof(busbyte));
+	memset(unituse, 0, sizeof(unituse));
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		if (pmc) {
+			if (pmc_inuse & (1 << (pmc - 1)))
+				return -1;
+			pmc_inuse |= 1 << (pmc - 1);
+			/* count 1/2/5/6 vs 3/4/7/8 use */
+			++pmc_grp_use[((pmc - 1) >> 1) & 1];
+		}
+		unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+		byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+		if (unit) {
+			if (unit > PM_LASTUNIT)
+				return -1;
+			if (!pmc)
+				++pmc_grp_use[byte & 1];
+			if (busbyte[byte] && busbyte[byte] != unit)
+				return -1;
+			busbyte[byte] = unit;
+			unituse[unit] = 1;
+		}
+	}
+	if (pmc_grp_use[0] > 4 || pmc_grp_use[1] > 4)
+		return -1;
+
+	/*
+	 * Assign resources and set multiplexer selects.
+	 *
+	 * PM_ISU can go either on TTM0 or TTM1, but that's the only
+	 * choice we have to deal with.
+	 */
+	if (unituse[PM_ISU] &
+	    (unituse[PM_FPU] | unituse[PM_IFU] | unituse[PM_VPU]))
+		unitmap[PM_ISU] = 2 | 4;	/* move ISU to TTM1 */
+	/* Set TTM[01]SEL fields. */
+	ttmuse[0] = ttmuse[1] = 0;
+	for (i = PM_FPU; i <= PM_STS; ++i) {
+		if (!unituse[i])
+			continue;
+		ttm = unitmap[i];
+		++ttmuse[(ttm >> 2) & 1];
+		mmcr1 |= (u64)(ttm & ~4) << MMCR1_TTM1SEL_SH;
+	}
+	/* Check only one unit per TTMx */
+	if (ttmuse[0] > 1 || ttmuse[1] > 1)
+		return -1;
+
+	/* Set byte lane select fields and TTM3SEL. */
+	for (byte = 0; byte < 4; ++byte) {
+		unit = busbyte[byte];
+		if (!unit)
+			continue;
+		if (unit <= PM_STS)
+			ttm = (unitmap[unit] >> 2) & 1;
+		else if (unit == PM_LSU0)
+			ttm = 2;
+		else {
+			ttm = 3;
+			if (unit == PM_LSU1L && byte >= 2)
+				mmcr1 |= 1ull << (MMCR1_TTM3SEL_SH + 3 - byte);
+		}
+		mmcr1 |= (u64)ttm << (MMCR1_TD_CP_DBG0SEL_SH - 2 * byte);
+	}
+
+	/* Second pass: assign PMCs, set PMCxSEL and PMCx_ADDER_SEL fields */
+	memset(pmcsel, 0x8, sizeof(pmcsel));	/* 8 means don't count */
+	for (i = 0; i < n_ev; ++i) {
+		pmc = (event[i] >> PM_PMC_SH) & PM_PMC_MSK;
+		unit = (event[i] >> PM_UNIT_SH) & PM_UNIT_MSK;
+		byte = (event[i] >> PM_BYTE_SH) & PM_BYTE_MSK;
+		psel = event[i] & PM_PMCSEL_MSK;
+		if (!pmc) {
+			/* Bus event or any-PMC direct event */
+			if (unit)
+				psel |= 0x10 | ((byte & 2) << 2);
+			else
+				psel |= 8;
+			for (pmc = 0; pmc < 8; ++pmc) {
+				if (pmc_inuse & (1 << pmc))
+					continue;
+				grp = (pmc >> 1) & 1;
+				if (unit) {
+					if (grp == (byte & 1))
+						break;
+				} else if (pmc_grp_use[grp] < 4) {
+					++pmc_grp_use[grp];
+					break;
+				}
+			}
+			pmc_inuse |= 1 << pmc;
+		} else {
+			/* Direct event */
+			--pmc;
+			if (psel == 0 && (byte & 2))
+				/* add events on higher-numbered bus */
+				mmcr1 |= 1ull << mmcr1_adder_bits[pmc];
+		}
+		pmcsel[pmc] = psel;
+		hwc[i] = pmc;
+	}
+	for (pmc = 0; pmc < 2; ++pmc)
+		mmcr0 |= pmcsel[pmc] << (MMCR0_PMC1SEL_SH - 7 * pmc);
+	for (; pmc < 8; ++pmc)
+		mmcr1 |= (u64)pmcsel[pmc] << (MMCR1_PMC3SEL_SH - 5 * (pmc - 2));
+	if (pmc_inuse & 1)
+		mmcr0 |= MMCR0_PMC1CE;
+	if (pmc_inuse & 0xfe)
+		mmcr0 |= MMCR0_PMCjCE;
+
+	mmcra |= 0x2000;	/* mark only one IOP per PPC instruction */
+
+	/* Return MMCRx values */
+	mmcr[0] = mmcr0;
+	mmcr[1] = mmcr1;
+	mmcr[2] = mmcra;
+	return 0;
+}
+
+static void p970_disable_pmc(unsigned int pmc, u64 mmcr[])
+{
+	int shift, i;
+
+	if (pmc <= 1) {
+		shift = MMCR0_PMC1SEL_SH - 7 * pmc;
+		i = 0;
+	} else {
+		shift = MMCR1_PMC3SEL_SH - 5 * (pmc - 2);
+		i = 1;
+	}
+	/*
+	 * Setting the PMCxSEL field to 0x08 disables PMC x.
+	 */
+	mmcr[i] = (mmcr[i] & ~(0x1fUL << shift)) | (0x08UL << shift);
+}
+
+static int ppc970_generic_events[] = {
+	[PERF_COUNT_CPU_CYCLES] = 7,
+	[PERF_COUNT_INSTRUCTIONS] = 1,
+	[PERF_COUNT_CACHE_REFERENCES] = 0x8810,		/* PM_LD_REF_L1 */
+	[PERF_COUNT_CACHE_MISSES] = 0x3810,		/* PM_LD_MISS_L1 */
+	[PERF_COUNT_BRANCH_INSTRUCTIONS] = 0x431,	/* PM_BR_ISSUED */
+	[PERF_COUNT_BRANCH_MISSES] = 0x327,		/* PM_GRP_BR_MPRED */
+};
+
+struct power_pmu ppc970_pmu = {
+	.n_counter = 8,
+	.max_alternatives = 2,
+	.add_fields = 0x001100005555ull,
+	.test_adder = 0x013300000000ull,
+	.compute_mmcr = p970_compute_mmcr,
+	.get_constraint = p970_get_constraint,
+	.get_alternatives = p970_get_alternatives,
+	.disable_pmc = p970_disable_pmc,
+	.n_generic = ARRAY_SIZE(ppc970_generic_events),
+	.generic_events = ppc970_generic_events,
+};
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 91c7b86..de37a3a 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/perf_counter.h>
 
 #include <asm/firmware.h>
 #include <asm/page.h>
@@ -170,6 +171,8 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 		die("Weird page fault", regs, SIGSEGV);
 	}
 
+	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs);
+
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
@@ -321,6 +324,7 @@ good_area:
 	}
 	if (ret & VM_FAULT_MAJOR) {
 		current->maj_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0, regs);
 #ifdef CONFIG_PPC_SMLPAR
 		if (firmware_has_feature(FW_FEATURE_CMO)) {
 			preempt_disable();
@@ -328,8 +332,10 @@ good_area:
 			preempt_enable();
 		}
 #endif
-	} else
+	} else {
 		current->min_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0, regs);
+	}
 	up_read(&mm->mmap_sem);
 	return 0;
 
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index e868b5c..dc0f3c9 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,6 +1,7 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
+	select HAVE_PERF_COUNTERS
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a2d5f39..f5d7d29 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -725,6 +725,7 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
+	select HAVE_PERF_COUNTERS if (!M386 && !M486)
 
 config X86_IO_APIC
 	def_bool y
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 097a6b6..e4baa06 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -825,7 +825,8 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd4
 	.quad sys_eventfd2
 	.quad sys_epoll_create1
-	.quad sys_dup3			/* 330 */
+	.quad sys_dup3				/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
+	.quad sys_perf_counter_open
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 85b46fb..977250e 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -247,5 +247,223 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
+/* An 64bit atomic type */
+
+typedef struct {
+	unsigned long long counter;
+} atomic64_t;
+
+#define ATOMIC64_INIT(val)	{ (val) }
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically reads the value of @v.
+ * Doesn't imply a read memory barrier.
+ */
+#define __atomic64_read(ptr)		((ptr)->counter)
+
+static inline unsigned long long
+cmpxchg8b(unsigned long long *ptr, unsigned long long old, unsigned long long new)
+{
+	asm volatile(
+
+		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
+
+		     :		"=A" (old)
+
+		     : [ptr]	"D" (ptr),
+				"A" (old),
+				"b" (ll_low(new)),
+				"c" (ll_high(new))
+
+		     : "memory");
+
+	return old;
+}
+
+static inline unsigned long long
+atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
+		 unsigned long long new_val)
+{
+	return cmpxchg8b(&ptr->counter, old_val, new_val);
+}
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically sets the value of @ptr to @new_val.
+ */
+static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
+{
+	unsigned long long old_val;
+
+	do {
+		old_val = atomic_read(ptr);
+	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+}
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ *
+ * Atomically reads the value of @ptr and returns it.
+ */
+static inline unsigned long long atomic64_read(atomic64_t *ptr)
+{
+	unsigned long long curr_val;
+
+	do {
+		curr_val = __atomic64_read(ptr);
+	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
+
+	return curr_val;
+}
+
+/**
+ * atomic64_add_return - add and return
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ */
+static inline unsigned long long
+atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
+{
+	unsigned long long old_val, new_val;
+
+	do {
+		old_val = atomic_read(ptr);
+		new_val = old_val + delta;
+
+	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+
+	return new_val;
+}
+
+static inline long atomic64_sub_return(unsigned long long delta, atomic64_t *ptr)
+{
+	return atomic64_add_return(-delta, ptr);
+}
+
+static inline long atomic64_inc_return(atomic64_t *ptr)
+{
+	return atomic64_add_return(1, ptr);
+}
+
+static inline long atomic64_dec_return(atomic64_t *ptr)
+{
+	return atomic64_sub_return(1, ptr);
+}
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr.
+ */
+static inline void atomic64_add(unsigned long long delta, atomic64_t *ptr)
+{
+	atomic64_add_return(delta, ptr);
+}
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr.
+ */
+static inline void atomic64_sub(unsigned long long delta, atomic64_t *ptr)
+{
+	atomic64_add(-delta, ptr);
+}
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int
+atomic64_sub_and_test(unsigned long long delta, atomic64_t *ptr)
+{
+	unsigned long long old_val = atomic64_sub_return(delta, ptr);
+
+	return old_val == 0;
+}
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1.
+ */
+static inline void atomic64_inc(atomic64_t *ptr)
+{
+	atomic64_add(1, ptr);
+}
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1.
+ */
+static inline void atomic64_dec(atomic64_t *ptr)
+{
+	atomic64_sub(1, ptr);
+}
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int atomic64_dec_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(1, ptr);
+}
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic64_inc_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(-1, ptr);
+}
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static inline int
+atomic64_add_negative(unsigned long long delta, atomic64_t *ptr)
+{
+	long long old_val = atomic64_add_return(delta, ptr);
+
+	return old_val < 0;
+}
+
 #include <asm-generic/atomic.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 039db6a..2545442 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -13,6 +13,7 @@ typedef struct {
 	unsigned int irq_spurious_count;
 #endif
 	unsigned int generic_irqs;	/* arch dependent */
+	unsigned int apic_perf_irqs;
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b762ea4..ae80f64 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -29,6 +29,8 @@
 extern void apic_timer_interrupt(void);
 extern void generic_interrupt(void);
 extern void error_interrupt(void);
+extern void perf_counter_interrupt(void);
+
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
diff --git a/arch/x86/include/asm/intel_arch_perfmon.h b/arch/x86/include/asm/intel_arch_perfmon.h
deleted file mode 100644
index fa0fd06..0000000
--- a/arch/x86/include/asm/intel_arch_perfmon.h
+++ /dev/null
@@ -1,31 +0,0 @@
-#ifndef _ASM_X86_INTEL_ARCH_PERFMON_H
-#define _ASM_X86_INTEL_ARCH_PERFMON_H
-
-#define MSR_ARCH_PERFMON_PERFCTR0		0xc1
-#define MSR_ARCH_PERFMON_PERFCTR1		0xc2
-
-#define MSR_ARCH_PERFMON_EVENTSEL0		0x186
-#define MSR_ARCH_PERFMON_EVENTSEL1		0x187
-
-#define ARCH_PERFMON_EVENTSEL0_ENABLE	(1 << 22)
-#define ARCH_PERFMON_EVENTSEL_INT	(1 << 20)
-#define ARCH_PERFMON_EVENTSEL_OS	(1 << 17)
-#define ARCH_PERFMON_EVENTSEL_USR	(1 << 16)
-
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL	(0x3c)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK	(0x00 << 8)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX (0)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
-	(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
-
-union cpuid10_eax {
-	struct {
-		unsigned int version_id:8;
-		unsigned int num_counters:8;
-		unsigned int bit_width:8;
-		unsigned int mask_length:8;
-	} split;
-	unsigned int full;
-};
-
-#endif /* _ASM_X86_INTEL_ARCH_PERFMON_H */
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
new file mode 100644
index 0000000..1662043
--- /dev/null
+++ b/arch/x86/include/asm/perf_counter.h
@@ -0,0 +1,98 @@
+#ifndef _ASM_X86_PERF_COUNTER_H
+#define _ASM_X86_PERF_COUNTER_H
+
+/*
+ * Performance counter hw details:
+ */
+
+#define X86_PMC_MAX_GENERIC					8
+#define X86_PMC_MAX_FIXED					3
+
+#define X86_PMC_IDX_GENERIC				        0
+#define X86_PMC_IDX_FIXED				       32
+#define X86_PMC_IDX_MAX					       64
+
+#define MSR_ARCH_PERFMON_PERFCTR0			      0xc1
+#define MSR_ARCH_PERFMON_PERFCTR1			      0xc2
+
+#define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
+#define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
+
+#define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
+#define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
+#define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
+
+/*
+ * Includes eventsel and unit mask as well:
+ */
+#define ARCH_PERFMON_EVENT_MASK				    0xffff
+
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX 		 0
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
+		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
+
+#define ARCH_PERFMON_BRANCH_MISSES_RETIRED			 6
+
+/*
+ * Intel "Architectural Performance Monitoring" CPUID
+ * detection/enumeration details:
+ */
+union cpuid10_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid10_edx {
+	struct {
+		unsigned int num_counters_fixed:4;
+		unsigned int reserved:28;
+	} split;
+	unsigned int full;
+};
+
+
+/*
+ * Fixed-purpose performance counters:
+ */
+
+/*
+ * All 3 fixed-mode PMCs are configured via this single MSR:
+ */
+#define MSR_ARCH_PERFMON_FIXED_CTR_CTRL			0x38d
+
+/*
+ * The counts are available in three separate MSRs:
+ */
+
+/* Instr_Retired.Any: */
+#define MSR_ARCH_PERFMON_FIXED_CTR0			0x309
+#define X86_PMC_IDX_FIXED_INSTRUCTIONS			(X86_PMC_IDX_FIXED + 0)
+
+/* CPU_CLK_Unhalted.Core: */
+#define MSR_ARCH_PERFMON_FIXED_CTR1			0x30a
+#define X86_PMC_IDX_FIXED_CPU_CYCLES			(X86_PMC_IDX_FIXED + 1)
+
+/* CPU_CLK_Unhalted.Ref: */
+#define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
+#define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
+
+#define set_perf_counter_pending()	\
+		set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
+
+#ifdef CONFIG_PERF_COUNTERS
+extern void init_hw_perf_counters(void);
+extern void perf_counters_lapic_init(int nmi);
+#else
+static inline void init_hw_perf_counters(void)		{ }
+static inline void perf_counters_lapic_init(int nmi)	{ }
+#endif
+
+#endif /* _ASM_X86_PERF_COUNTER_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 431c246..83d2b73 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -83,6 +83,7 @@ struct thread_info {
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_PERF_COUNTERS	11	/* notify perf counter work */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -106,6 +107,7 @@ struct thread_info {
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
+#define _TIF_PERF_COUNTERS	(1 << TIF_PERF_COUNTERS)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -139,7 +141,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_PERF_COUNTERS|_TIF_NOTIFY_RESUME)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index f2bba78..7e47658 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -338,6 +338,7 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_perf_counter_open	333
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index d2e415e..53025fe 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -653,7 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
-
+#define __NR_perf_counter_open		295
+__SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 85eb8e1..b0e5e71 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -34,6 +34,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 
+#include <asm/perf_counter.h>
 #include <asm/pgalloc.h>
 #include <asm/atomic.h>
 #include <asm/mpspec.h>
@@ -755,6 +756,8 @@ static void local_apic_timer_interrupt(void)
 	inc_irq_stat(apic_timer_irqs);
 
 	evt->event_handler(evt);
+
+	perf_counter_unthrottle();
 }
 
 /*
@@ -1127,6 +1130,7 @@ void __cpuinit setup_local_APIC(void)
 		apic_write(APIC_ESR, 0);
 	}
 #endif
+	perf_counters_lapic_init(0);
 
 	preempt_disable();
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 4e242f9..3efcb2b 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -1,5 +1,5 @@
 #
-# Makefile for x86-compatible CPU details and quirks
+# Makefile for x86-compatible CPU details, features and quirks
 #
 
 # Don't trace early stages of a secondary CPU boot
@@ -23,11 +23,13 @@ obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
-obj-$(CONFIG_X86_MCE)	+= mcheck/
-obj-$(CONFIG_MTRR)	+= mtrr/
-obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
+obj-$(CONFIG_PERF_COUNTERS)		+= perf_counter.o
 
-obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+obj-$(CONFIG_X86_MCE)			+= mcheck/
+obj-$(CONFIG_MTRR)			+= mtrr/
+obj-$(CONFIG_CPU_FREQ)			+= cpufreq/
+
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..fd69c51 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -420,6 +420,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
+	/* Enable Performance counter for K7 and later */
+	if (c->x86 > 6 && c->x86 <= 0x11)
+		set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
+
 	if (!c->x86_model_id[0]) {
 		switch (c->x86) {
 		case 0xf:
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c4f6678..a86769e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 
 #include <asm/stackprotector.h>
+#include <asm/perf_counter.h>
 #include <asm/mmu_context.h>
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
@@ -854,6 +855,7 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
+	init_hw_perf_counters();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
new file mode 100644
index 0000000..902282d
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -0,0 +1,989 @@
+/*
+ * Performance counter x86 architecture code
+ *
+ *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *  Copyright(C) 2009 Jaswinder Singh Rajput
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_counter.h>
+#include <linux/capability.h>
+#include <linux/notifier.h>
+#include <linux/hardirq.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <linux/sched.h>
+
+#include <asm/apic.h>
+
+static bool perf_counters_initialized __read_mostly;
+
+/*
+ * Number of (generic) HW counters:
+ */
+static int nr_counters_generic __read_mostly;
+static u64 perf_counter_mask __read_mostly;
+static u64 counter_value_mask __read_mostly;
+static int counter_value_bits __read_mostly;
+
+static int nr_counters_fixed __read_mostly;
+
+struct cpu_hw_counters {
+	struct perf_counter	*counters[X86_PMC_IDX_MAX];
+	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		interrupts;
+	u64			throttle_ctrl;
+	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int			enabled;
+};
+
+/*
+ * struct pmc_x86_ops - performance counter x86 ops
+ */
+struct pmc_x86_ops {
+	u64		(*save_disable_all)(void);
+	void		(*restore_all)(u64);
+	u64		(*get_status)(u64);
+	void		(*ack_status)(u64);
+	void		(*enable)(int, u64);
+	void		(*disable)(int, u64);
+	unsigned	eventsel;
+	unsigned	perfctr;
+	u64		(*event_map)(int);
+	u64		(*raw_event)(u64);
+	int		max_events;
+};
+
+static struct pmc_x86_ops *pmc_ops __read_mostly;
+
+static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters) = {
+	.enabled = 1,
+};
+
+static __read_mostly int intel_perfmon_version;
+
+/*
+ * Intel PerfMon v3. Used on Core2 and later.
+ */
+static const u64 intel_perfmon_event_map[] =
+{
+  [PERF_COUNT_CPU_CYCLES]		= 0x003c,
+  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_CACHE_REFERENCES]		= 0x4f2e,
+  [PERF_COUNT_CACHE_MISSES]		= 0x412e,
+  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_BUS_CYCLES]		= 0x013c,
+};
+
+static u64 pmc_intel_event_map(int event)
+{
+	return intel_perfmon_event_map[event];
+}
+
+static u64 pmc_intel_raw_event(u64 event)
+{
+#define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
+#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
+#define CORE_EVNTSEL_COUNTER_MASK	0xFF000000ULL
+
+#define CORE_EVNTSEL_MASK 		\
+	(CORE_EVNTSEL_EVENT_MASK |	\
+	 CORE_EVNTSEL_UNIT_MASK  |	\
+	 CORE_EVNTSEL_COUNTER_MASK)
+
+	return event & CORE_EVNTSEL_MASK;
+}
+
+/*
+ * AMD Performance Monitor K7 and later.
+ */
+static const u64 amd_perfmon_event_map[] =
+{
+  [PERF_COUNT_CPU_CYCLES]		= 0x0076,
+  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_CACHE_REFERENCES]		= 0x0080,
+  [PERF_COUNT_CACHE_MISSES]		= 0x0081,
+  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
+};
+
+static u64 pmc_amd_event_map(int event)
+{
+	return amd_perfmon_event_map[event];
+}
+
+static u64 pmc_amd_raw_event(u64 event)
+{
+#define K7_EVNTSEL_EVENT_MASK	0x7000000FFULL
+#define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
+#define K7_EVNTSEL_COUNTER_MASK	0x0FF000000ULL
+
+#define K7_EVNTSEL_MASK			\
+	(K7_EVNTSEL_EVENT_MASK |	\
+	 K7_EVNTSEL_UNIT_MASK  |	\
+	 K7_EVNTSEL_COUNTER_MASK)
+
+	return event & K7_EVNTSEL_MASK;
+}
+
+/*
+ * Propagate counter elapsed time into the generic counter.
+ * Can only be executed on the CPU where the counter is active.
+ * Returns the delta events processed.
+ */
+static void
+x86_perf_counter_update(struct perf_counter *counter,
+			struct hw_perf_counter *hwc, int idx)
+{
+	u64 prev_raw_count, new_raw_count, delta;
+
+	/*
+	 * Careful: an NMI might modify the previous counter value.
+	 *
+	 * Our tactic to handle this is to first atomically read and
+	 * exchange a new raw count - then add that new-prev delta
+	 * count to the generic counter atomically:
+	 */
+again:
+	prev_raw_count = atomic64_read(&hwc->prev_count);
+	rdmsrl(hwc->counter_base + idx, new_raw_count);
+
+	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
+					new_raw_count) != prev_raw_count)
+		goto again;
+
+	/*
+	 * Now we have the new raw value and have updated the prev
+	 * timestamp already. We can now calculate the elapsed delta
+	 * (counter-)time and add that to the generic counter.
+	 *
+	 * Careful, not all hw sign-extends above the physical width
+	 * of the count, so we do that by clipping the delta to 32 bits:
+	 */
+	delta = (u64)(u32)((s32)new_raw_count - (s32)prev_raw_count);
+
+	atomic64_add(delta, &counter->count);
+	atomic64_sub(delta, &hwc->period_left);
+}
+
+/*
+ * Setup the hardware configuration for a given hw_event_type
+ */
+static int __hw_perf_counter_init(struct perf_counter *counter)
+{
+	struct perf_counter_hw_event *hw_event = &counter->hw_event;
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	if (unlikely(!perf_counters_initialized))
+		return -EINVAL;
+
+	/*
+	 * Generate PMC IRQs:
+	 * (keep 'enabled' bit clear for now)
+	 */
+	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
+
+	/*
+	 * Count user and OS events unless requested not to.
+	 */
+	if (!hw_event->exclude_user)
+		hwc->config |= ARCH_PERFMON_EVENTSEL_USR;
+	if (!hw_event->exclude_kernel)
+		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
+
+	/*
+	 * If privileged enough, allow NMI events:
+	 */
+	hwc->nmi = 0;
+	if (capable(CAP_SYS_ADMIN) && hw_event->nmi)
+		hwc->nmi = 1;
+
+	hwc->irq_period		= hw_event->irq_period;
+	/*
+	 * Intel PMCs cannot be accessed sanely above 32 bit width,
+	 * so we install an artificial 1<<31 period regardless of
+	 * the generic counter period:
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		if ((s64)hwc->irq_period <= 0 || hwc->irq_period > 0x7FFFFFFF)
+			hwc->irq_period = 0x7FFFFFFF;
+
+	atomic64_set(&hwc->period_left, hwc->irq_period);
+
+	/*
+	 * Raw event type provide the config in the event structure
+	 */
+	if (hw_event->raw_type) {
+		hwc->config |= pmc_ops->raw_event(hw_event->raw_event_id);
+	} else {
+		if (hw_event->event_id >= pmc_ops->max_events)
+			return -EINVAL;
+		/*
+		 * The generic map:
+		 */
+		hwc->config |= pmc_ops->event_map(hw_event->event_id);
+	}
+	counter->wakeup_pending = 0;
+
+	return 0;
+}
+
+static u64 pmc_intel_save_disable_all(void)
+{
+	u64 ctrl;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	return ctrl;
+}
+
+static u64 pmc_amd_save_disable_all(void)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	int enabled, idx;
+
+	enabled = cpuc->enabled;
+	cpuc->enabled = 0;
+	/*
+	 * ensure we write the disable before we start disabling the
+	 * counters proper, so that pcm_amd_enable() does the right thing.
+	 */
+	barrier();
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		u64 val;
+
+		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE) {
+			val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		}
+	}
+
+	return enabled;
+}
+
+u64 hw_perf_save_disable(void)
+{
+	if (unlikely(!perf_counters_initialized))
+		return 0;
+
+	return pmc_ops->save_disable_all();
+}
+/*
+ * Exported because of ACPI idle
+ */
+EXPORT_SYMBOL_GPL(hw_perf_save_disable);
+
+static void pmc_intel_restore_all(u64 ctrl)
+{
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+}
+
+static void pmc_amd_restore_all(u64 ctrl)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	int idx;
+
+	cpuc->enabled = ctrl;
+	barrier();
+	if (!ctrl)
+		return;
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		if (test_bit(idx, cpuc->active_mask)) {
+			u64 val;
+
+			rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
+			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		}
+	}
+}
+
+void hw_perf_restore(u64 ctrl)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	pmc_ops->restore_all(ctrl);
+}
+/*
+ * Exported because of ACPI idle
+ */
+EXPORT_SYMBOL_GPL(hw_perf_restore);
+
+static u64 pmc_intel_get_status(u64 mask)
+{
+	u64 status;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+
+	return status;
+}
+
+static u64 pmc_amd_get_status(u64 mask)
+{
+	u64 status = 0;
+	int idx;
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		s64 val;
+
+		if (!(mask & (1 << idx)))
+			continue;
+
+		rdmsrl(MSR_K7_PERFCTR0 + idx, val);
+		val <<= (64 - counter_value_bits);
+		if (val >= 0)
+			status |= (1 << idx);
+	}
+
+	return status;
+}
+
+static u64 hw_perf_get_status(u64 mask)
+{
+	if (unlikely(!perf_counters_initialized))
+		return 0;
+
+	return pmc_ops->get_status(mask);
+}
+
+static void pmc_intel_ack_status(u64 ack)
+{
+	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
+}
+
+static void pmc_amd_ack_status(u64 ack)
+{
+}
+
+static void hw_perf_ack_status(u64 ack)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	pmc_ops->ack_status(ack);
+}
+
+static void pmc_intel_enable(int idx, u64 config)
+{
+	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx,
+			config | ARCH_PERFMON_EVENTSEL0_ENABLE);
+}
+
+static void pmc_amd_enable(int idx, u64 config)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	set_bit(idx, cpuc->active_mask);
+	if (cpuc->enabled)
+		config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+
+	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
+}
+
+static void hw_perf_enable(int idx, u64 config)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	pmc_ops->enable(idx, config);
+}
+
+static void pmc_intel_disable(int idx, u64 config)
+{
+	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, config);
+}
+
+static void pmc_amd_disable(int idx, u64 config)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	clear_bit(idx, cpuc->active_mask);
+	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
+
+}
+
+static void hw_perf_disable(int idx, u64 config)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	pmc_ops->disable(idx, config);
+}
+
+static inline void
+__pmc_fixed_disable(struct perf_counter *counter,
+		    struct hw_perf_counter *hwc, unsigned int __idx)
+{
+	int idx = __idx - X86_PMC_IDX_FIXED;
+	u64 ctrl_val, mask;
+	int err;
+
+	mask = 0xfULL << (idx * 4);
+
+	rdmsrl(hwc->config_base, ctrl_val);
+	ctrl_val &= ~mask;
+	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static inline void
+__pmc_generic_disable(struct perf_counter *counter,
+			   struct hw_perf_counter *hwc, unsigned int idx)
+{
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
+		__pmc_fixed_disable(counter, hwc, idx);
+	else
+		hw_perf_disable(idx, hwc->config);
+}
+
+static DEFINE_PER_CPU(u64, prev_left[X86_PMC_IDX_MAX]);
+
+/*
+ * Set the next IRQ period, based on the hwc->period_left value.
+ * To be called with the counter disabled in hw:
+ */
+static void
+__hw_perf_counter_set_period(struct perf_counter *counter,
+			     struct hw_perf_counter *hwc, int idx)
+{
+	s64 left = atomic64_read(&hwc->period_left);
+	s64 period = hwc->irq_period;
+	int err;
+
+	/*
+	 * If we are way outside a reasoable range then just skip forward:
+	 */
+	if (unlikely(left <= -period)) {
+		left = period;
+		atomic64_set(&hwc->period_left, left);
+	}
+
+	if (unlikely(left <= 0)) {
+		left += period;
+		atomic64_set(&hwc->period_left, left);
+	}
+
+	per_cpu(prev_left[idx], smp_processor_id()) = left;
+
+	/*
+	 * The hw counter starts counting from this counter offset,
+	 * mark it to be able to extra future deltas:
+	 */
+	atomic64_set(&hwc->prev_count, (u64)-left);
+
+	err = checking_wrmsrl(hwc->counter_base + idx,
+			     (u64)(-left) & counter_value_mask);
+}
+
+static inline void
+__pmc_fixed_enable(struct perf_counter *counter,
+		   struct hw_perf_counter *hwc, unsigned int __idx)
+{
+	int idx = __idx - X86_PMC_IDX_FIXED;
+	u64 ctrl_val, bits, mask;
+	int err;
+
+	/*
+	 * Enable IRQ generation (0x8),
+	 * and enable ring-3 counting (0x2) and ring-0 counting (0x1)
+	 * if requested:
+	 */
+	bits = 0x8ULL;
+	if (hwc->config & ARCH_PERFMON_EVENTSEL_USR)
+		bits |= 0x2;
+	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
+		bits |= 0x1;
+	bits <<= (idx * 4);
+	mask = 0xfULL << (idx * 4);
+
+	rdmsrl(hwc->config_base, ctrl_val);
+	ctrl_val &= ~mask;
+	ctrl_val |= bits;
+	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static void
+__pmc_generic_enable(struct perf_counter *counter,
+			  struct hw_perf_counter *hwc, int idx)
+{
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
+		__pmc_fixed_enable(counter, hwc, idx);
+	else
+		hw_perf_enable(idx, hwc->config);
+}
+
+static int
+fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
+{
+	unsigned int event;
+
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return -1;
+
+	if (unlikely(hwc->nmi))
+		return -1;
+
+	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
+
+	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_INSTRUCTIONS)))
+		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
+	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_CPU_CYCLES)))
+		return X86_PMC_IDX_FIXED_CPU_CYCLES;
+	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_BUS_CYCLES)))
+		return X86_PMC_IDX_FIXED_BUS_CYCLES;
+
+	return -1;
+}
+
+/*
+ * Find a PMC slot for the freshly enabled / scheduled in counter:
+ */
+static int pmc_generic_enable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx;
+
+	idx = fixed_mode_idx(counter, hwc);
+	if (idx >= 0) {
+		/*
+		 * Try to get the fixed counter, if that is already taken
+		 * then try to get a generic counter:
+		 */
+		if (test_and_set_bit(idx, cpuc->used))
+			goto try_generic;
+
+		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
+		/*
+		 * We set it so that counter_base + idx in wrmsr/rdmsr maps to
+		 * MSR_ARCH_PERFMON_FIXED_CTR0 ... CTR2:
+		 */
+		hwc->counter_base =
+			MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
+		hwc->idx = idx;
+	} else {
+		idx = hwc->idx;
+		/* Try to get the previous generic counter again */
+		if (test_and_set_bit(idx, cpuc->used)) {
+try_generic:
+			idx = find_first_zero_bit(cpuc->used, nr_counters_generic);
+			if (idx == nr_counters_generic)
+				return -EAGAIN;
+
+			set_bit(idx, cpuc->used);
+			hwc->idx = idx;
+		}
+		hwc->config_base  = pmc_ops->eventsel;
+		hwc->counter_base = pmc_ops->perfctr;
+	}
+
+	perf_counters_lapic_init(hwc->nmi);
+
+	__pmc_generic_disable(counter, hwc, idx);
+
+	cpuc->counters[idx] = counter;
+	/*
+	 * Make it visible before enabling the hw:
+	 */
+	smp_wmb();
+
+	__hw_perf_counter_set_period(counter, hwc, idx);
+	__pmc_generic_enable(counter, hwc, idx);
+
+	return 0;
+}
+
+void perf_counter_print_debug(void)
+{
+	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, prev_left, fixed;
+	struct cpu_hw_counters *cpuc;
+	int cpu, idx;
+
+	if (!nr_counters_generic)
+		return;
+
+	local_irq_disable();
+
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	if (intel_perfmon_version >= 2) {
+		rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+		rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+		rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
+		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR_CTRL, fixed);
+
+		pr_info("\n");
+		pr_info("CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
+		pr_info("CPU#%d: status:     %016llx\n", cpu, status);
+		pr_info("CPU#%d: overflow:   %016llx\n", cpu, overflow);
+		pr_info("CPU#%d: fixed:      %016llx\n", cpu, fixed);
+	}
+	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		rdmsrl(pmc_ops->eventsel + idx, pmc_ctrl);
+		rdmsrl(pmc_ops->perfctr  + idx, pmc_count);
+
+		prev_left = per_cpu(prev_left[idx], cpu);
+
+		pr_info("CPU#%d:   gen-PMC%d ctrl:  %016llx\n",
+			cpu, idx, pmc_ctrl);
+		pr_info("CPU#%d:   gen-PMC%d count: %016llx\n",
+			cpu, idx, pmc_count);
+		pr_info("CPU#%d:   gen-PMC%d left:  %016llx\n",
+			cpu, idx, prev_left);
+	}
+	for (idx = 0; idx < nr_counters_fixed; idx++) {
+		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, pmc_count);
+
+		pr_info("CPU#%d: fixed-PMC%d count: %016llx\n",
+			cpu, idx, pmc_count);
+	}
+	local_irq_enable();
+}
+
+static void pmc_generic_disable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	unsigned int idx = hwc->idx;
+
+	__pmc_generic_disable(counter, hwc, idx);
+
+	clear_bit(idx, cpuc->used);
+	cpuc->counters[idx] = NULL;
+	/*
+	 * Make sure the cleared pointer becomes visible before we
+	 * (potentially) free the counter:
+	 */
+	smp_wmb();
+
+	/*
+	 * Drain the remaining delta count out of a counter
+	 * that we are disabling:
+	 */
+	x86_perf_counter_update(counter, hwc, idx);
+}
+
+/*
+ * Save and restart an expired counter. Called by NMI contexts,
+ * so it has to be careful about preempting normal counter ops:
+ */
+static void perf_save_and_restart(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx = hwc->idx;
+
+	x86_perf_counter_update(counter, hwc, idx);
+	__hw_perf_counter_set_period(counter, hwc, idx);
+
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
+		__pmc_generic_enable(counter, hwc, idx);
+}
+
+/*
+ * Maximum interrupt frequency of 100KHz per CPU
+ */
+#define PERFMON_MAX_INTERRUPTS (100000/HZ)
+
+/*
+ * This handler is triggered by the local APIC, so the APIC IRQ handling
+ * rules apply:
+ */
+static int __smp_perf_counter_interrupt(struct pt_regs *regs, int nmi)
+{
+	int bit, cpu = smp_processor_id();
+	u64 ack, status;
+	struct cpu_hw_counters *cpuc = &per_cpu(cpu_hw_counters, cpu);
+	int ret = 0;
+
+	cpuc->throttle_ctrl = hw_perf_save_disable();
+
+	status = hw_perf_get_status(cpuc->throttle_ctrl);
+	if (!status)
+		goto out;
+
+	ret = 1;
+again:
+	inc_irq_stat(apic_perf_irqs);
+	ack = status;
+	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
+		struct perf_counter *counter = cpuc->counters[bit];
+
+		clear_bit(bit, (unsigned long *) &status);
+		if (!counter)
+			continue;
+
+		perf_save_and_restart(counter);
+		perf_counter_output(counter, nmi, regs);
+	}
+
+	hw_perf_ack_status(ack);
+
+	/*
+	 * Repeat if there is more work to be done:
+	 */
+	status = hw_perf_get_status(cpuc->throttle_ctrl);
+	if (status)
+		goto again;
+out:
+	/*
+	 * Restore - do not reenable when global enable is off or throttled:
+	 */
+	if (++cpuc->interrupts < PERFMON_MAX_INTERRUPTS)
+		hw_perf_restore(cpuc->throttle_ctrl);
+
+	return ret;
+}
+
+void perf_counter_unthrottle(void)
+{
+	struct cpu_hw_counters *cpuc;
+
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return;
+
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	cpuc = &__get_cpu_var(cpu_hw_counters);
+	if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING "PERFMON: max interrupts exceeded!\n");
+		hw_perf_restore(cpuc->throttle_ctrl);
+	}
+	cpuc->interrupts = 0;
+}
+
+void smp_perf_counter_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+	ack_APIC_irq();
+	__smp_perf_counter_interrupt(regs, 0);
+	irq_exit();
+}
+
+/*
+ * This handler is triggered by NMI contexts:
+ */
+void perf_counter_notify(struct pt_regs *regs)
+{
+	struct cpu_hw_counters *cpuc;
+	unsigned long flags;
+	int bit, cpu;
+
+	local_irq_save(flags);
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	for_each_bit(bit, cpuc->used, X86_PMC_IDX_MAX) {
+		struct perf_counter *counter = cpuc->counters[bit];
+
+		if (!counter)
+			continue;
+
+		if (counter->wakeup_pending) {
+			counter->wakeup_pending = 0;
+			wake_up(&counter->waitq);
+		}
+	}
+
+	local_irq_restore(flags);
+}
+
+void perf_counters_lapic_init(int nmi)
+{
+	u32 apic_val;
+
+	if (!perf_counters_initialized)
+		return;
+	/*
+	 * Enable the performance counter vector in the APIC LVT:
+	 */
+	apic_val = apic_read(APIC_LVTERR);
+
+	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
+	if (nmi)
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
+	else
+		apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+	apic_write(APIC_LVTERR, apic_val);
+}
+
+static int __kprobes
+perf_counter_nmi_handler(struct notifier_block *self,
+			 unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	struct pt_regs *regs;
+	int ret;
+
+	switch (cmd) {
+	case DIE_NMI:
+	case DIE_NMI_IPI:
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	regs = args->regs;
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	ret = __smp_perf_counter_interrupt(regs, 1);
+
+	return ret ? NOTIFY_STOP : NOTIFY_OK;
+}
+
+static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
+	.notifier_call		= perf_counter_nmi_handler,
+	.next			= NULL,
+	.priority		= 1
+};
+
+static struct pmc_x86_ops pmc_intel_ops = {
+	.save_disable_all	= pmc_intel_save_disable_all,
+	.restore_all		= pmc_intel_restore_all,
+	.get_status		= pmc_intel_get_status,
+	.ack_status		= pmc_intel_ack_status,
+	.enable			= pmc_intel_enable,
+	.disable		= pmc_intel_disable,
+	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
+	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
+	.event_map		= pmc_intel_event_map,
+	.raw_event		= pmc_intel_raw_event,
+	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
+};
+
+static struct pmc_x86_ops pmc_amd_ops = {
+	.save_disable_all	= pmc_amd_save_disable_all,
+	.restore_all		= pmc_amd_restore_all,
+	.get_status		= pmc_amd_get_status,
+	.ack_status		= pmc_amd_ack_status,
+	.enable			= pmc_amd_enable,
+	.disable		= pmc_amd_disable,
+	.eventsel		= MSR_K7_EVNTSEL0,
+	.perfctr		= MSR_K7_PERFCTR0,
+	.event_map		= pmc_amd_event_map,
+	.raw_event		= pmc_amd_raw_event,
+	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
+};
+
+static struct pmc_x86_ops *pmc_intel_init(void)
+{
+	union cpuid10_edx edx;
+	union cpuid10_eax eax;
+	unsigned int unused;
+	unsigned int ebx;
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Branch Misses Retired Event or not.
+	 */
+	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
+	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
+		return NULL;
+
+	intel_perfmon_version = eax.split.version_id;
+	if (intel_perfmon_version < 2)
+		return NULL;
+
+	pr_info("Intel Performance Monitoring support detected.\n");
+	pr_info("... version:         %d\n", intel_perfmon_version);
+	pr_info("... bit width:       %d\n", eax.split.bit_width);
+	pr_info("... mask length:     %d\n", eax.split.mask_length);
+
+	nr_counters_generic = eax.split.num_counters;
+	nr_counters_fixed = edx.split.num_counters_fixed;
+	counter_value_mask = (1ULL << eax.split.bit_width) - 1;
+
+	return &pmc_intel_ops;
+}
+
+static struct pmc_x86_ops *pmc_amd_init(void)
+{
+	nr_counters_generic = 4;
+	nr_counters_fixed = 0;
+	counter_value_mask = 0x0000FFFFFFFFFFFFULL;
+	counter_value_bits = 48;
+
+	pr_info("AMD Performance Monitoring support detected.\n");
+
+	return &pmc_amd_ops;
+}
+
+void __init init_hw_perf_counters(void)
+{
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return;
+
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		pmc_ops = pmc_intel_init();
+		break;
+	case X86_VENDOR_AMD:
+		pmc_ops = pmc_amd_init();
+		break;
+	}
+	if (!pmc_ops)
+		return;
+
+	pr_info("... num counters:    %d\n", nr_counters_generic);
+	if (nr_counters_generic > X86_PMC_MAX_GENERIC) {
+		nr_counters_generic = X86_PMC_MAX_GENERIC;
+		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
+			nr_counters_generic, X86_PMC_MAX_GENERIC);
+	}
+	perf_counter_mask = (1 << nr_counters_generic) - 1;
+	perf_max_counters = nr_counters_generic;
+
+	pr_info("... value mask:      %016Lx\n", counter_value_mask);
+
+	if (nr_counters_fixed > X86_PMC_MAX_FIXED) {
+		nr_counters_fixed = X86_PMC_MAX_FIXED;
+		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
+			nr_counters_fixed, X86_PMC_MAX_FIXED);
+	}
+	pr_info("... fixed counters:  %d\n", nr_counters_fixed);
+
+	perf_counter_mask |= ((1LL << nr_counters_fixed)-1) << X86_PMC_IDX_FIXED;
+
+	pr_info("... counter mask:    %016Lx\n", perf_counter_mask);
+	perf_counters_initialized = true;
+
+	perf_counters_lapic_init(0);
+	register_die_notifier(&perf_counter_nmi_notifier);
+}
+
+static void pmc_generic_read(struct perf_counter *counter)
+{
+	x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
+}
+
+static const struct hw_perf_counter_ops x86_perf_counter_ops = {
+	.enable		= pmc_generic_enable,
+	.disable	= pmc_generic_disable,
+	.read		= pmc_generic_read,
+};
+
+const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	int err;
+
+	err = __hw_perf_counter_init(counter);
+	if (err)
+		return NULL;
+
+	return &x86_perf_counter_ops;
+}
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index f6c70a1..d6f5b9f 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -19,8 +19,8 @@
 #include <linux/nmi.h>
 #include <linux/kprobes.h>
 
-#include <asm/genapic.h>
-#include <asm/intel_arch_perfmon.h>
+#include <asm/apic.h>
+#include <asm/perf_counter.h>
 
 struct nmi_watchdog_ctlblk {
 	unsigned int cccr_msr;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a331ec3..3f129d9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1025,6 +1025,11 @@ apicinterrupt ERROR_APIC_VECTOR \
 apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
+#ifdef CONFIG_PERF_COUNTERS
+apicinterrupt LOCAL_PERF_VECTOR \
+	perf_counter_interrupt smp_perf_counter_interrupt
+#endif
+
 /*
  * Exception entry points.
  */
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index b8ac3b6..33d0723 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -58,6 +58,10 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
+	seq_printf(p, "CNT: ");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
+	seq_printf(p, "  Performance counter interrupts\n");
 #endif
 	if (generic_interrupt_extension) {
 		seq_printf(p, "PLT: ");
@@ -174,6 +178,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
+	sum += irq_stats(cpu)->apic_perf_irqs;
 #endif
 	if (generic_interrupt_extension)
 		sum += irq_stats(cpu)->generic_irqs;
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index bc13261..0bd93bd 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -120,28 +120,8 @@ int vector_used_by_percpu_irq(unsigned int vector)
 	return 0;
 }
 
-/* Overridden in paravirt.c */
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
-
-void __init native_init_IRQ(void)
+static void __init smp_intr_init(void)
 {
-	int i;
-
-	/* Execute any quirks before the call gates are initialised: */
-	x86_quirk_pre_intr_init();
-
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
-		/* SYSCALL_VECTOR was reserved in trap_init. */
-		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
-	}
-
-
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
@@ -170,6 +150,11 @@ void __init native_init_IRQ(void)
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
+}
+
+static void __init apic_intr_init(void)
+{
+	smp_intr_init();
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* self generated IPI for local APIC timer */
@@ -181,12 +166,40 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-#endif
+# ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+# endif
 
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
+# ifdef CONFIG_X86_MCE_P4THERMAL
 	/* thermal monitor LVT interrupt */
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+# endif
 #endif
+}
+
+/* Overridden in paravirt.c */
+void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	/* Execute any quirks before the call gates are initialised: */
+	x86_quirk_pre_intr_init();
+
+	apic_intr_init();
+
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		/* SYSCALL_VECTOR was reserved in trap_init. */
+		if (!test_bit(vector, used_vectors))
+			set_intr_gate(vector, interrupt[i]);
+	}
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index c7a49e0..5c9ed86 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -153,6 +153,11 @@ static void __init apic_intr_init(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+
+	/* Performance monitoring interrupt: */
+#ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+#endif
 }
 
 void __init native_init_IRQ(void)
@@ -160,6 +165,9 @@ void __init native_init_IRQ(void)
 	int i;
 
 	init_ISA_irqs();
+
+	apic_intr_init();
+
 	/*
 	 * Cover the whole vector space, no vector can escape
 	 * us. (some of these will be overridden and become
@@ -167,12 +175,10 @@ void __init native_init_IRQ(void)
 	 */
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != IA32_SYSCALL_VECTOR)
+		if (!test_bit(vector, used_vectors))
 			set_intr_gate(vector, interrupt[i]);
 	}
 
-	apic_intr_init();
-
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index dfcc74a..62f2164 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -6,7 +6,7 @@
  *  2000-06-20  Pentium III FXSR, SSE support by Gareth Hughes
  *  2000-2002   x86-64 support by Andi Kleen
  */
-
+#include <linux/perf_counter.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -872,6 +872,11 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		tracehook_notify_resume(regs);
 	}
 
+	if (thread_info_flags & _TIF_PERF_COUNTERS) {
+		clear_thread_flag(TIF_PERF_COUNTERS);
+		perf_counter_notify(regs);
+	}
+
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
 #endif /* CONFIG_X86_32 */
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 3bdb648..b7607c4 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_perf_counter_open
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8f20204..e447aa8 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -950,8 +950,13 @@ void __init trap_init(void)
 #endif
 	set_intr_gate(19, &simd_coprocessor_error);
 
+	/* Reserve all the builtin and the syscall vector: */
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
+		set_bit(i, used_vectors);
+
 #ifdef CONFIG_IA32_EMULATION
 	set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
+	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
 #endif
 
 #ifdef CONFIG_X86_32
@@ -968,17 +973,9 @@ void __init trap_init(void)
 	}
 
 	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
-#endif
-
-	/* Reserve all the builtin and the syscall vector: */
-	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
-		set_bit(i, used_vectors);
-
-#ifdef CONFIG_X86_64
-	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
-#else
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3fcd79a..f70b901 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -27,6 +27,7 @@
 #include <linux/tty.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/perf_counter.h>
 
 #include <asm-generic/sections.h>
 
@@ -1056,6 +1057,8 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
+	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs);
+
 	/*
 	 * If we're in an interrupt, have no user context or are running
 	 * in an atomic region then we must not take the fault:
@@ -1149,10 +1152,13 @@ good_area:
 		return;
 	}
 
-	if (fault & VM_FAULT_MAJOR)
+	if (fault & VM_FAULT_MAJOR) {
 		tsk->maj_flt++;
-	else
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0, regs);
+	} else {
 		tsk->min_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0, regs);
+	}
 
 	check_v8086_mode(regs, address, tsk);
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 202864a..c638685 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -40,8 +40,9 @@ static int profile_exceptions_notify(struct notifier_block *self,
 
 	switch (val) {
 	case DIE_NMI:
-		if (model->check_ctrs(args->regs, &per_cpu(cpu_msrs, cpu)))
-			ret = NOTIFY_STOP;
+	case DIE_NMI_IPI:
+		model->check_ctrs(args->regs, &per_cpu(cpu_msrs, cpu));
+		ret = NOTIFY_STOP;
 		break;
 	default:
 		break;
@@ -134,7 +135,7 @@ static void nmi_cpu_setup(void *dummy)
 static struct notifier_block profile_exceptions_nb = {
 	.notifier_call = profile_exceptions_notify,
 	.next = NULL,
-	.priority = 0
+	.priority = 2
 };
 
 static int nmi_setup(void)
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 10131fb..4da7230 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -18,7 +18,7 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
-#include <asm/intel_arch_perfmon.h>
+#include <asm/perf_counter.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -136,6 +136,13 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
+	/*
+	 * This can happen if perf counters are in use when
+	 * we steal the die notifier NMI.
+	 */
+	if (unlikely(!reset_value))
+		goto out;
+
 	for (i = 0 ; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -146,6 +153,7 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
+out:
 	/* Only P6 based Pentium M need to re-unmask the apic vector but it
 	 * doesn't hurt other P6 variant */
 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 7bc22a4..08def2f 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -824,8 +824,11 @@ static int acpi_idle_bm_check(void)
  */
 static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
+	u64 perf_flags;
+
 	/* Don't trace irqs off for idle */
 	stop_critical_timings();
+	perf_flags = hw_perf_save_disable();
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
@@ -840,6 +843,7 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	hw_perf_restore(perf_flags);
 	start_critical_timings();
 }
 
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 6f8579d..1777977 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -25,6 +25,7 @@
 #include <linux/kbd_kern.h>
 #include <linux/proc_fs.h>
 #include <linux/quotaops.h>
+#include <linux/perf_counter.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
@@ -244,6 +245,7 @@ static void sysrq_handle_showregs(int key, struct tty_struct *tty)
 	struct pt_regs *regs = get_irq_regs();
 	if (regs)
 		show_regs(regs);
+	perf_counter_print_debug();
 }
 static struct sysrq_key_op sysrq_showregs_op = {
 	.handler	= sysrq_handle_showregs,
diff --git a/fs/exec.c b/fs/exec.c
index 929b580..af1600c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
+#include <linux/perf_counter.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
@@ -1010,6 +1011,13 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	current->personality &= ~bprm->per_clear;
 
+	/*
+	 * Flush performance counters when crossing a
+	 * security domain:
+	 */
+	if (!get_dumpable(current->mm))
+		perf_counter_exit_task(current);
+
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index af1de95..ca226a9 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -120,6 +120,18 @@ extern struct group_info init_groups;
 
 extern struct cred init_cred;
 
+#ifdef CONFIG_PERF_COUNTERS
+# define INIT_PERF_COUNTERS(tsk)					\
+	.perf_counter_ctx.counter_list =				\
+		LIST_HEAD_INIT(tsk.perf_counter_ctx.counter_list),	\
+	.perf_counter_ctx.event_list =					\
+		LIST_HEAD_INIT(tsk.perf_counter_ctx.event_list),	\
+	.perf_counter_ctx.lock =					\
+		__SPIN_LOCK_UNLOCKED(tsk.perf_counter_ctx.lock),
+#else
+# define INIT_PERF_COUNTERS(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -185,6 +197,7 @@ extern struct cred init_cred;
 	INIT_IDS							\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	INIT_PERF_COUNTERS(tsk)						\
 }
 
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 0c8b89f..b6d2887 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -81,7 +81,15 @@ static inline unsigned int kstat_irqs(unsigned int irq)
 	return sum;
 }
 
+
+/*
+ * Lock/unlock the current runqueue - to extract task statistics:
+ */
+extern void curr_rq_lock_irq_save(unsigned long *flags);
+extern void curr_rq_unlock_irq_restore(unsigned long *flags);
+extern unsigned long long __task_delta_exec(struct task_struct *tsk, int update);
 extern unsigned long long task_delta_exec(struct task_struct *);
+
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
new file mode 100644
index 0000000..98f5990
--- /dev/null
+++ b/include/linux/perf_counter.h
@@ -0,0 +1,367 @@
+/*
+ *  Performance counters:
+ *
+ *   Copyright(C) 2008, Thomas Gleixner <tglx@linutronix.de>
+ *   Copyright(C) 2008, Red Hat, Inc., Ingo Molnar
+ *
+ *  Data type definitions, declarations, prototypes.
+ *
+ *  Started by: Thomas Gleixner and Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+#ifndef _LINUX_PERF_COUNTER_H
+#define _LINUX_PERF_COUNTER_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <asm/byteorder.h>
+
+/*
+ * User-space ABI bits:
+ */
+
+/*
+ * hw_event.type
+ */
+enum perf_event_types {
+	PERF_TYPE_HARDWARE		= 0,
+	PERF_TYPE_SOFTWARE		= 1,
+	PERF_TYPE_TRACEPOINT		= 2,
+
+	/*
+	 * available TYPE space, raw is the max value.
+	 */
+
+	PERF_TYPE_RAW			= 128,
+};
+
+/*
+ * Generalized performance counter event types, used by the hw_event.event_id
+ * parameter of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_ids {
+	/*
+	 * Common hardware events, generalized by the kernel:
+	 */
+	PERF_COUNT_CPU_CYCLES		= 0,
+	PERF_COUNT_INSTRUCTIONS		= 1,
+	PERF_COUNT_CACHE_REFERENCES	= 2,
+	PERF_COUNT_CACHE_MISSES		= 3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	= 4,
+	PERF_COUNT_BRANCH_MISSES	= 5,
+	PERF_COUNT_BUS_CYCLES		= 6,
+
+	PERF_HW_EVENTS_MAX		= 7,
+};
+
+/*
+ * Special "software" counters provided by the kernel, even if the hardware
+ * does not support performance counters. These counters measure various
+ * physical and sw events of the kernel (and allow the profiling of them as
+ * well):
+ */
+enum sw_event_ids {
+	PERF_COUNT_CPU_CLOCK		= 0,
+	PERF_COUNT_TASK_CLOCK		= 1,
+	PERF_COUNT_PAGE_FAULTS		= 2,
+	PERF_COUNT_CONTEXT_SWITCHES	= 3,
+	PERF_COUNT_CPU_MIGRATIONS	= 4,
+	PERF_COUNT_PAGE_FAULTS_MIN	= 5,
+	PERF_COUNT_PAGE_FAULTS_MAJ	= 6,
+
+	PERF_SW_EVENTS_MAX		= 7,
+};
+
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_counter_record_type {
+	PERF_RECORD_SIMPLE		= 0,
+	PERF_RECORD_IRQ			= 1,
+	PERF_RECORD_GROUP		= 2,
+};
+
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_hw_event {
+	union {
+#ifndef __BIG_ENDIAN_BITFIELD
+		struct {
+			__u64			event_id	: 56,
+						type		:  8;
+		};
+		struct {
+			__u64			raw_event_id	: 63,
+						raw_type	:  1;
+		};
+#else
+		struct {
+			__u64			type		:  8,
+						event_id	: 56;
+		};
+		struct {
+			__u64			raw_type	:  1,
+						raw_event_id	: 63;
+		};
+#endif /* __BIT_ENDIAN_BITFIELD */
+		__u64		event_config;
+	};
+
+	__u64			irq_period;
+	__u64			record_type;
+	__u64			read_format;
+
+	__u64			disabled       :  1, /* off by default        */
+				nmi	       :  1, /* NMI sampling          */
+				inherit	       :  1, /* children inherit it   */
+				pinned	       :  1, /* must always be on PMU */
+				exclusive      :  1, /* only group on PMU     */
+				exclude_user   :  1, /* don't count user      */
+				exclude_kernel :  1, /* ditto kernel          */
+				exclude_hv     :  1, /* ditto hypervisor      */
+				exclude_idle   :  1, /* don't count when idle */
+
+				__reserved_1   : 55;
+
+	__u32			extra_config_len;
+	__u32			__reserved_4;
+
+	__u64			__reserved_2;
+	__u64			__reserved_3;
+};
+
+/*
+ * Ioctls that can be done on a perf counter fd:
+ */
+#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
+#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
+
+#ifdef __KERNEL__
+/*
+ * Kernel-internal data types and definitions:
+ */
+
+#ifdef CONFIG_PERF_COUNTERS
+# include <asm/perf_counter.h>
+#endif
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+#include <linux/hrtimer.h>
+#include <asm/atomic.h>
+
+struct task_struct;
+
+/**
+ * struct hw_perf_counter - performance counter hardware details:
+ */
+struct hw_perf_counter {
+#ifdef CONFIG_PERF_COUNTERS
+	union {
+		struct { /* hardware */
+			u64				config;
+			unsigned long			config_base;
+			unsigned long			counter_base;
+			int				nmi;
+			unsigned int			idx;
+		};
+		union { /* software */
+			atomic64_t			count;
+			struct hrtimer			hrtimer;
+		};
+	};
+	atomic64_t			prev_count;
+	u64				irq_period;
+	atomic64_t			period_left;
+#endif
+};
+
+/*
+ * Hardcoded buffer length limit for now, for IRQ-fed events:
+ */
+#define PERF_DATA_BUFLEN		2048
+
+/**
+ * struct perf_data - performance counter IRQ data sampling ...
+ */
+struct perf_data {
+	int				len;
+	int				rd_idx;
+	int				overrun;
+	u8				data[PERF_DATA_BUFLEN];
+};
+
+struct perf_counter;
+
+/**
+ * struct hw_perf_counter_ops - performance counter hw ops
+ */
+struct hw_perf_counter_ops {
+	int (*enable)			(struct perf_counter *counter);
+	void (*disable)			(struct perf_counter *counter);
+	void (*read)			(struct perf_counter *counter);
+};
+
+/**
+ * enum perf_counter_active_state - the states of a counter
+ */
+enum perf_counter_active_state {
+	PERF_COUNTER_STATE_ERROR	= -2,
+	PERF_COUNTER_STATE_OFF		= -1,
+	PERF_COUNTER_STATE_INACTIVE	=  0,
+	PERF_COUNTER_STATE_ACTIVE	=  1,
+};
+
+struct file;
+
+/**
+ * struct perf_counter - performance counter kernel representation:
+ */
+struct perf_counter {
+#ifdef CONFIG_PERF_COUNTERS
+	struct list_head		list_entry;
+	struct list_head		event_entry;
+	struct list_head		sibling_list;
+	struct perf_counter		*group_leader;
+	const struct hw_perf_counter_ops *hw_ops;
+
+	enum perf_counter_active_state	state;
+	enum perf_counter_active_state	prev_state;
+	atomic64_t			count;
+
+	struct perf_counter_hw_event	hw_event;
+	struct hw_perf_counter		hw;
+
+	struct perf_counter_context	*ctx;
+	struct task_struct		*task;
+	struct file			*filp;
+
+	struct perf_counter		*parent;
+	struct list_head		child_list;
+
+	/*
+	 * Protect attach/detach and child_list:
+	 */
+	struct mutex			mutex;
+
+	int				oncpu;
+	int				cpu;
+
+	/* read() / irq related data */
+	wait_queue_head_t		waitq;
+	/* optional: for NMIs */
+	int				wakeup_pending;
+	struct perf_data		*irqdata;
+	struct perf_data		*usrdata;
+	struct perf_data		data[2];
+
+	void (*destroy)(struct perf_counter *);
+	struct rcu_head			rcu_head;
+#endif
+};
+
+/**
+ * struct perf_counter_context - counter context structure
+ *
+ * Used as a container for task counters and CPU counters as well:
+ */
+struct perf_counter_context {
+#ifdef CONFIG_PERF_COUNTERS
+	/*
+	 * Protect the states of the counters in the list,
+	 * nr_active, and the list:
+	 */
+	spinlock_t		lock;
+	/*
+	 * Protect the list of counters.  Locking either mutex or lock
+	 * is sufficient to ensure the list doesn't change; to change
+	 * the list you need to lock both the mutex and the spinlock.
+	 */
+	struct mutex		mutex;
+
+	struct list_head	counter_list;
+	struct list_head	event_list;
+	int			nr_counters;
+	int			nr_active;
+	int			is_active;
+	struct task_struct	*task;
+#endif
+};
+
+/**
+ * struct perf_counter_cpu_context - per cpu counter context structure
+ */
+struct perf_cpu_context {
+	struct perf_counter_context	ctx;
+	struct perf_counter_context	*task_ctx;
+	int				active_oncpu;
+	int				max_pertask;
+	int				exclusive;
+};
+
+/*
+ * Set by architecture code:
+ */
+extern int perf_max_counters;
+
+#ifdef CONFIG_PERF_COUNTERS
+extern const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter);
+
+extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
+extern void perf_counter_task_sched_out(struct task_struct *task, int cpu);
+extern void perf_counter_task_tick(struct task_struct *task, int cpu);
+extern void perf_counter_init_task(struct task_struct *child);
+extern void perf_counter_exit_task(struct task_struct *child);
+extern void perf_counter_notify(struct pt_regs *regs);
+extern void perf_counter_print_debug(void);
+extern void perf_counter_unthrottle(void);
+extern u64 hw_perf_save_disable(void);
+extern void hw_perf_restore(u64 ctrl);
+extern int perf_counter_task_disable(void);
+extern int perf_counter_task_enable(void);
+extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu);
+
+extern void perf_counter_output(struct perf_counter *counter,
+				int nmi, struct pt_regs *regs);
+/*
+ * Return 1 for a software counter, 0 for a hardware counter
+ */
+static inline int is_software_counter(struct perf_counter *counter)
+{
+	return !counter->hw_event.raw_type &&
+		counter->hw_event.type != PERF_TYPE_HARDWARE;
+}
+
+extern void perf_swcounter_event(u32, u64, int, struct pt_regs *);
+
+#else
+static inline void
+perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_sched_out(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
+static inline void perf_counter_init_task(struct task_struct *child)	{ }
+static inline void perf_counter_exit_task(struct task_struct *child)	{ }
+static inline void perf_counter_notify(struct pt_regs *regs)		{ }
+static inline void perf_counter_print_debug(void)			{ }
+static inline void perf_counter_unthrottle(void)			{ }
+static inline void hw_perf_restore(u64 ctrl)				{ }
+static inline u64 hw_perf_save_disable(void)		      { return 0; }
+static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
+static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
+
+static inline void perf_swcounter_event(u32 event, u64 nr,
+					int nmi, struct pt_regs *regs)	{ }
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _LINUX_PERF_COUNTER_H */
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 48d887e..b00df4c 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -85,4 +85,7 @@
 #define PR_SET_TIMERSLACK 29
 #define PR_GET_TIMERSLACK 30
 
+#define PR_TASK_PERF_COUNTERS_DISABLE		31
+#define PR_TASK_PERF_COUNTERS_ENABLE		32
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 19187a2..1410859 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -71,6 +71,7 @@ struct sched_param {
 #include <linux/fs_struct.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
+#include <linux/perf_counter.h>
 #include <linux/pid.h>
 #include <linux/percpu.h>
 #include <linux/topology.h>
@@ -136,6 +137,7 @@ extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
+extern u64 cpu_nr_migrations(int cpu);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
@@ -1060,9 +1062,10 @@ struct sched_entity {
 	u64			last_wakeup;
 	u64			avg_overlap;
 
+	u64			nr_migrations;
+
 	u64			start_runtime;
 	u64			avg_wakeup;
-	u64			nr_migrations;
 
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
@@ -1381,6 +1384,7 @@ struct task_struct {
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
 #endif
+	struct perf_counter_context perf_counter_ctx;
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;
 	short il_next;
@@ -2377,6 +2381,13 @@ static inline void inc_syscw(struct task_struct *tsk)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+/*
+ * Call the function if the target task is executing on a CPU right now:
+ */
+extern void task_oncpu_function_call(struct task_struct *p,
+				     void (*func) (void *info), void *info);
+
+
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0cff9bb..dfe2a44 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -55,6 +55,7 @@ struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
 struct old_linux_dirent;
+struct perf_counter_hw_event;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -750,4 +751,8 @@ asmlinkage long sys_pipe(int __user *);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+
+asmlinkage long sys_perf_counter_open(
+		const struct perf_counter_hw_event __user *hw_event_uptr,
+		pid_t pid, int cpu, int group_fd, unsigned long flags);
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index d8c95e1..215deb7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -917,6 +917,41 @@ config AIO
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+config HAVE_PERF_COUNTERS
+	bool
+
+menu "Performance Counters"
+
+config PERF_COUNTERS
+	bool "Kernel Performance Counters"
+	depends on HAVE_PERF_COUNTERS
+	default y
+	select ANON_INODES
+	help
+	  Enable kernel support for performance counter hardware.
+
+	  Performance counters are special hardware registers available
+	  on most modern CPUs. These registers count the number of certain
+	  types of hw events: such as instructions executed, cachemisses
+	  suffered, or branches mis-predicted - without slowing down the
+	  kernel or applications. These registers can also trigger interrupts
+	  when a threshold number of events have passed - and can thus be
+	  used to profile the code that runs on that CPU.
+
+	  The Linux Performance Counter subsystem provides an abstraction of
+	  these hardware capabilities, available via a system call. It
+	  provides per task and per CPU counters, and it provides event
+	  capabilities on top of those.
+
+	  Say Y if unsure.
+
+config EVENT_PROFILE
+	bool "Tracepoint profile sources"
+	depends on PERF_COUNTERS && EVENT_TRACER
+	default y
+
+endmenu
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
diff --git a/kernel/Makefile b/kernel/Makefile
index 3e43fd1..5714563 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
+obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/exit.c b/kernel/exit.c
index 167e1e3..f52c24e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -162,6 +162,9 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 {
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
+#ifdef CONFIG_PERF_COUNTERS
+	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
+#endif
 	trace_sched_process_free(tsk);
 	put_task_struct(tsk);
 }
@@ -1093,10 +1096,6 @@ NORET_TYPE void do_exit(long code)
 	tsk->mempolicy = NULL;
 #endif
 #ifdef CONFIG_FUTEX
-	/*
-	 * This must happen late, after the PID is not
-	 * hashed anymore:
-	 */
 	if (unlikely(!list_empty(&tsk->pi_state_list)))
 		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
@@ -1363,6 +1362,12 @@ static int wait_task_zombie(struct task_struct *p, int options,
 	 */
 	read_unlock(&tasklist_lock);
 
+	/*
+	 * Flush inherited counters to the parent - before the parent
+	 * gets woken up by child-exit notifications.
+	 */
+	perf_counter_exit_task(p);
+
 	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
diff --git a/kernel/fork.c b/kernel/fork.c
index 39b1062..656d798 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -992,6 +992,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	rt_mutex_init_task(p);
+	perf_counter_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
new file mode 100644
index 0000000..f054b8c
--- /dev/null
+++ b/kernel/perf_counter.c
@@ -0,0 +1,2438 @@
+/*
+ * Performance counter core code
+ *
+ *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/fs.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/sysfs.h>
+#include <linux/ptrace.h>
+#include <linux/percpu.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/anon_inodes.h>
+#include <linux/kernel_stat.h>
+#include <linux/perf_counter.h>
+#include <linux/mm.h>
+#include <linux/vmstat.h>
+#include <linux/rculist.h>
+
+#include <asm/irq_regs.h>
+
+/*
+ * Each CPU has a list of per CPU counters:
+ */
+DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
+
+int perf_max_counters __read_mostly = 1;
+static int perf_reserved_percpu __read_mostly;
+static int perf_overcommit __read_mostly = 1;
+
+/*
+ * Mutex for (sysadmin-configurable) counter reservations:
+ */
+static DEFINE_MUTEX(perf_resource_mutex);
+
+/*
+ * Architecture provided APIs - weak aliases:
+ */
+extern __weak const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	return NULL;
+}
+
+u64 __weak hw_perf_save_disable(void)		{ return 0; }
+void __weak hw_perf_restore(u64 ctrl)		{ barrier(); }
+void __weak hw_perf_counter_setup(int cpu)	{ barrier(); }
+int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx, int cpu)
+{
+	return 0;
+}
+
+void __weak perf_counter_print_debug(void)	{ }
+
+static void
+list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
+{
+	struct perf_counter *group_leader = counter->group_leader;
+
+	/*
+	 * Depending on whether it is a standalone or sibling counter,
+	 * add it straight to the context's counter list, or to the group
+	 * leader's sibling list:
+	 */
+	if (counter->group_leader == counter)
+		list_add_tail(&counter->list_entry, &ctx->counter_list);
+	else
+		list_add_tail(&counter->list_entry, &group_leader->sibling_list);
+
+	list_add_rcu(&counter->event_entry, &ctx->event_list);
+}
+
+static void
+list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
+{
+	struct perf_counter *sibling, *tmp;
+
+	list_del_init(&counter->list_entry);
+	list_del_rcu(&counter->event_entry);
+
+	/*
+	 * If this was a group counter with sibling counters then
+	 * upgrade the siblings to singleton counters by adding them
+	 * to the context list directly:
+	 */
+	list_for_each_entry_safe(sibling, tmp,
+				 &counter->sibling_list, list_entry) {
+
+		list_move_tail(&sibling->list_entry, &ctx->counter_list);
+		sibling->group_leader = sibling;
+	}
+}
+
+static void
+counter_sched_out(struct perf_counter *counter,
+		  struct perf_cpu_context *cpuctx,
+		  struct perf_counter_context *ctx)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->hw_ops->disable(counter);
+	counter->oncpu = -1;
+
+	if (!is_software_counter(counter))
+		cpuctx->active_oncpu--;
+	ctx->nr_active--;
+	if (counter->hw_event.exclusive || !cpuctx->active_oncpu)
+		cpuctx->exclusive = 0;
+}
+
+static void
+group_sched_out(struct perf_counter *group_counter,
+		struct perf_cpu_context *cpuctx,
+		struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+
+	if (group_counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
+	counter_sched_out(group_counter, cpuctx, ctx);
+
+	/*
+	 * Schedule out siblings (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
+		counter_sched_out(counter, cpuctx, ctx);
+
+	if (group_counter->hw_event.exclusive)
+		cpuctx->exclusive = 0;
+}
+
+/*
+ * Cross CPU call to remove a performance counter
+ *
+ * We disable the counter on the hardware level first. After that we
+ * remove it from the context list.
+ */
+static void __perf_counter_remove_from_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	unsigned long flags;
+	u64 perf_flags;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	counter_sched_out(counter, cpuctx, ctx);
+
+	counter->task = NULL;
+	ctx->nr_counters--;
+
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level. NOP for non NMI based counters.
+	 */
+	perf_flags = hw_perf_save_disable();
+	list_del_counter(counter, ctx);
+	hw_perf_restore(perf_flags);
+
+	if (!ctx->task) {
+		/*
+		 * Allow more per task counters with respect to the
+		 * reservation:
+		 */
+		cpuctx->max_pertask =
+			min(perf_max_counters - ctx->nr_counters,
+			    perf_max_counters - perf_reserved_percpu);
+	}
+
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+
+/*
+ * Remove the counter from a task's (or a CPU's) list of counters.
+ *
+ * Must be called with counter->mutex and ctx->mutex held.
+ *
+ * CPU counters are removed with a smp call. For task counters we only
+ * call when the task is on a CPU.
+ */
+static void perf_counter_remove_from_context(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Per cpu counters are removed via an smp call and
+		 * the removal is always sucessful.
+		 */
+		smp_call_function_single(counter->cpu,
+					 __perf_counter_remove_from_context,
+					 counter, 1);
+		return;
+	}
+
+retry:
+	task_oncpu_function_call(task, __perf_counter_remove_from_context,
+				 counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * If the context is active we need to retry the smp call.
+	 */
+	if (ctx->nr_active && !list_empty(&counter->list_entry)) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * The lock prevents that this context is scheduled in so we
+	 * can remove the counter safely, if the call above did not
+	 * succeed.
+	 */
+	if (!list_empty(&counter->list_entry)) {
+		ctx->nr_counters--;
+		list_del_counter(counter, ctx);
+		counter->task = NULL;
+	}
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Cross CPU call to disable a performance counter
+ */
+static void __perf_counter_disable(void *info)
+{
+	struct perf_counter *counter = info;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = counter->ctx;
+	unsigned long flags;
+
+	/*
+	 * If this is a per-task counter, need to check whether this
+	 * counter's task is the current task on this cpu.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	/*
+	 * If the counter is on, turn it off.
+	 * If it is in error state, leave it in error state.
+	 */
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
+		if (counter == counter->group_leader)
+			group_sched_out(counter, cpuctx, ctx);
+		else
+			counter_sched_out(counter, cpuctx, ctx);
+		counter->state = PERF_COUNTER_STATE_OFF;
+	}
+
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+/*
+ * Disable a counter.
+ */
+static void perf_counter_disable(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Disable the counter on the cpu that it's on
+		 */
+		smp_call_function_single(counter->cpu, __perf_counter_disable,
+					 counter, 1);
+		return;
+	}
+
+ retry:
+	task_oncpu_function_call(task, __perf_counter_disable, counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * If the counter is still active, we need to retry the cross-call.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * Since we have the lock this context can't be scheduled
+	 * in, so we can change the state safely.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Disable a counter and all its children.
+ */
+static void perf_counter_disable_family(struct perf_counter *counter)
+{
+	struct perf_counter *child;
+
+	perf_counter_disable(counter);
+
+	/*
+	 * Lock the mutex to protect the list of children
+	 */
+	mutex_lock(&counter->mutex);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		perf_counter_disable(child);
+	mutex_unlock(&counter->mutex);
+}
+
+static int
+counter_sched_in(struct perf_counter *counter,
+		 struct perf_cpu_context *cpuctx,
+		 struct perf_counter_context *ctx,
+		 int cpu)
+{
+	if (counter->state <= PERF_COUNTER_STATE_OFF)
+		return 0;
+
+	counter->state = PERF_COUNTER_STATE_ACTIVE;
+	counter->oncpu = cpu;	/* TODO: put 'cpu' into cpuctx->cpu */
+	/*
+	 * The new state must be visible before we turn it on in the hardware:
+	 */
+	smp_wmb();
+
+	if (counter->hw_ops->enable(counter)) {
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->oncpu = -1;
+		return -EAGAIN;
+	}
+
+	if (!is_software_counter(counter))
+		cpuctx->active_oncpu++;
+	ctx->nr_active++;
+
+	if (counter->hw_event.exclusive)
+		cpuctx->exclusive = 1;
+
+	return 0;
+}
+
+/*
+ * Return 1 for a group consisting entirely of software counters,
+ * 0 if the group contains any hardware counters.
+ */
+static int is_software_only_group(struct perf_counter *leader)
+{
+	struct perf_counter *counter;
+
+	if (!is_software_counter(leader))
+		return 0;
+	list_for_each_entry(counter, &leader->sibling_list, list_entry)
+		if (!is_software_counter(counter))
+			return 0;
+	return 1;
+}
+
+/*
+ * Work out whether we can put this counter group on the CPU now.
+ */
+static int group_can_go_on(struct perf_counter *counter,
+			   struct perf_cpu_context *cpuctx,
+			   int can_add_hw)
+{
+	/*
+	 * Groups consisting entirely of software counters can always go on.
+	 */
+	if (is_software_only_group(counter))
+		return 1;
+	/*
+	 * If an exclusive group is already on, no other hardware
+	 * counters can go on.
+	 */
+	if (cpuctx->exclusive)
+		return 0;
+	/*
+	 * If this group is exclusive and there are already
+	 * counters on the CPU, it can't go on.
+	 */
+	if (counter->hw_event.exclusive && cpuctx->active_oncpu)
+		return 0;
+	/*
+	 * Otherwise, try to add it if all previous groups were able
+	 * to go on.
+	 */
+	return can_add_hw;
+}
+
+/*
+ * Cross CPU call to install and enable a performance counter
+ */
+static void __perf_install_in_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *leader = counter->group_leader;
+	int cpu = smp_processor_id();
+	unsigned long flags;
+	u64 perf_flags;
+	int err;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level. NOP for non NMI based counters.
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_add_counter(counter, ctx);
+	ctx->nr_counters++;
+	counter->prev_state = PERF_COUNTER_STATE_OFF;
+
+	/*
+	 * Don't put the counter on if it is disabled or if
+	 * it is in a group and the group isn't on.
+	 */
+	if (counter->state != PERF_COUNTER_STATE_INACTIVE ||
+	    (leader != counter && leader->state != PERF_COUNTER_STATE_ACTIVE))
+		goto unlock;
+
+	/*
+	 * An exclusive counter can't go on if there are already active
+	 * hardware counters, and no hardware counter can go on if there
+	 * is already an exclusive counter on.
+	 */
+	if (!group_can_go_on(counter, cpuctx, 1))
+		err = -EEXIST;
+	else
+		err = counter_sched_in(counter, cpuctx, ctx, cpu);
+
+	if (err) {
+		/*
+		 * This counter couldn't go on.  If it is in a group
+		 * then we have to pull the whole group off.
+		 * If the counter group is pinned then put it in error state.
+		 */
+		if (leader != counter)
+			group_sched_out(leader, cpuctx, ctx);
+		if (leader->hw_event.pinned)
+			leader->state = PERF_COUNTER_STATE_ERROR;
+	}
+
+	if (!err && !ctx->task && cpuctx->max_pertask)
+		cpuctx->max_pertask--;
+
+ unlock:
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+/*
+ * Attach a performance counter to a context
+ *
+ * First we add the counter to the list with the hardware enable bit
+ * in counter->hw_config cleared.
+ *
+ * If the counter is attached to a task which is on a CPU we use a smp
+ * call to enable it in the task context. The task might have been
+ * scheduled away, but we check this in the smp call again.
+ *
+ * Must be called with ctx->mutex held.
+ */
+static void
+perf_install_in_context(struct perf_counter_context *ctx,
+			struct perf_counter *counter,
+			int cpu)
+{
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Per cpu counters are installed via an smp call and
+		 * the install is always sucessful.
+		 */
+		smp_call_function_single(cpu, __perf_install_in_context,
+					 counter, 1);
+		return;
+	}
+
+	counter->task = task;
+retry:
+	task_oncpu_function_call(task, __perf_install_in_context,
+				 counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * we need to retry the smp call.
+	 */
+	if (ctx->is_active && list_empty(&counter->list_entry)) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * The lock prevents that this context is scheduled in so we
+	 * can add the counter safely, if it the call above did not
+	 * succeed.
+	 */
+	if (list_empty(&counter->list_entry)) {
+		list_add_counter(counter, ctx);
+		ctx->nr_counters++;
+	}
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Cross CPU call to enable a performance counter
+ */
+static void __perf_counter_enable(void *info)
+{
+	struct perf_counter *counter = info;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *leader = counter->group_leader;
+	unsigned long flags;
+	int err;
+
+	/*
+	 * If this is a per-task counter, need to check whether this
+	 * counter's task is the current task on this cpu.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	counter->prev_state = counter->state;
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		goto unlock;
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+
+	/*
+	 * If the counter is in a group and isn't the group leader,
+	 * then don't put it on unless the group is on.
+	 */
+	if (leader != counter && leader->state != PERF_COUNTER_STATE_ACTIVE)
+		goto unlock;
+
+	if (!group_can_go_on(counter, cpuctx, 1))
+		err = -EEXIST;
+	else
+		err = counter_sched_in(counter, cpuctx, ctx,
+				       smp_processor_id());
+
+	if (err) {
+		/*
+		 * If this counter can't go on and it's part of a
+		 * group, then the whole group has to come off.
+		 */
+		if (leader != counter)
+			group_sched_out(leader, cpuctx, ctx);
+		if (leader->hw_event.pinned)
+			leader->state = PERF_COUNTER_STATE_ERROR;
+	}
+
+ unlock:
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+/*
+ * Enable a counter.
+ */
+static void perf_counter_enable(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Enable the counter on the cpu that it's on
+		 */
+		smp_call_function_single(counter->cpu, __perf_counter_enable,
+					 counter, 1);
+		return;
+	}
+
+	spin_lock_irq(&ctx->lock);
+	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		goto out;
+
+	/*
+	 * If the counter is in error state, clear that first.
+	 * That way, if we see the counter in error state below, we
+	 * know that it has gone back into error state, as distinct
+	 * from the task having been scheduled away before the
+	 * cross-call arrived.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ERROR)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+ retry:
+	spin_unlock_irq(&ctx->lock);
+	task_oncpu_function_call(task, __perf_counter_enable, counter);
+
+	spin_lock_irq(&ctx->lock);
+
+	/*
+	 * If the context is active and the counter is still off,
+	 * we need to retry the cross-call.
+	 */
+	if (ctx->is_active && counter->state == PERF_COUNTER_STATE_OFF)
+		goto retry;
+
+	/*
+	 * Since we have the lock this context can't be scheduled
+	 * in, so we can change the state safely.
+	 */
+	if (counter->state == PERF_COUNTER_STATE_OFF)
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+ out:
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Enable a counter and all its children.
+ */
+static void perf_counter_enable_family(struct perf_counter *counter)
+{
+	struct perf_counter *child;
+
+	perf_counter_enable(counter);
+
+	/*
+	 * Lock the mutex to protect the list of children
+	 */
+	mutex_lock(&counter->mutex);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		perf_counter_enable(child);
+	mutex_unlock(&counter->mutex);
+}
+
+void __perf_counter_sched_out(struct perf_counter_context *ctx,
+			      struct perf_cpu_context *cpuctx)
+{
+	struct perf_counter *counter;
+	u64 flags;
+
+	spin_lock(&ctx->lock);
+	ctx->is_active = 0;
+	if (likely(!ctx->nr_counters))
+		goto out;
+
+	flags = hw_perf_save_disable();
+	if (ctx->nr_active) {
+		list_for_each_entry(counter, &ctx->counter_list, list_entry)
+			group_sched_out(counter, cpuctx, ctx);
+	}
+	hw_perf_restore(flags);
+ out:
+	spin_unlock(&ctx->lock);
+}
+
+/*
+ * Called from scheduler to remove the counters of the current task,
+ * with interrupts disabled.
+ *
+ * We stop each counter and update the counter value in counter->count.
+ *
+ * This does not protect us against NMI, but disable()
+ * sets the disabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * not restart the counter.
+ */
+void perf_counter_task_sched_out(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+	struct pt_regs *regs;
+
+	if (likely(!cpuctx->task_ctx))
+		return;
+
+	regs = task_pt_regs(task);
+	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs);
+	__perf_counter_sched_out(ctx, cpuctx);
+
+	cpuctx->task_ctx = NULL;
+}
+
+static void perf_counter_cpu_sched_out(struct perf_cpu_context *cpuctx)
+{
+	__perf_counter_sched_out(&cpuctx->ctx, cpuctx);
+}
+
+static int
+group_sched_in(struct perf_counter *group_counter,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx,
+	       int cpu)
+{
+	struct perf_counter *counter, *partial_group;
+	int ret;
+
+	if (group_counter->state == PERF_COUNTER_STATE_OFF)
+		return 0;
+
+	ret = hw_perf_group_sched_in(group_counter, cpuctx, ctx, cpu);
+	if (ret)
+		return ret < 0 ? ret : 0;
+
+	group_counter->prev_state = group_counter->state;
+	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
+		return -EAGAIN;
+
+	/*
+	 * Schedule in siblings as one group (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		counter->prev_state = counter->state;
+		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
+			partial_group = counter;
+			goto group_error;
+		}
+	}
+
+	return 0;
+
+group_error:
+	/*
+	 * Groups can be scheduled in as one unit only, so undo any
+	 * partial group before returning:
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		if (counter == partial_group)
+			break;
+		counter_sched_out(counter, cpuctx, ctx);
+	}
+	counter_sched_out(group_counter, cpuctx, ctx);
+
+	return -EAGAIN;
+}
+
+static void
+__perf_counter_sched_in(struct perf_counter_context *ctx,
+			struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct perf_counter *counter;
+	u64 flags;
+	int can_add_hw = 1;
+
+	spin_lock(&ctx->lock);
+	ctx->is_active = 1;
+	if (likely(!ctx->nr_counters))
+		goto out;
+
+	flags = hw_perf_save_disable();
+
+	/*
+	 * First go through the list and put on any pinned groups
+	 * in order to give them the best chance of going on.
+	 */
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state <= PERF_COUNTER_STATE_OFF ||
+		    !counter->hw_event.pinned)
+			continue;
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+
+		if (group_can_go_on(counter, cpuctx, 1))
+			group_sched_in(counter, cpuctx, ctx, cpu);
+
+		/*
+		 * If this pinned group hasn't been scheduled,
+		 * put it in error state.
+		 */
+		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
+			counter->state = PERF_COUNTER_STATE_ERROR;
+	}
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		/*
+		 * Ignore counters in OFF or ERROR state, and
+		 * ignore pinned counters since we did them already.
+		 */
+		if (counter->state <= PERF_COUNTER_STATE_OFF ||
+		    counter->hw_event.pinned)
+			continue;
+
+		/*
+		 * Listen to the 'cpu' scheduling filter constraint
+		 * of counters:
+		 */
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+
+		if (group_can_go_on(counter, cpuctx, can_add_hw)) {
+			if (group_sched_in(counter, cpuctx, ctx, cpu))
+				can_add_hw = 0;
+		}
+	}
+	hw_perf_restore(flags);
+ out:
+	spin_unlock(&ctx->lock);
+}
+
+/*
+ * Called from scheduler to add the counters of the current task
+ * with interrupts disabled.
+ *
+ * We restore the counter value and then enable it.
+ *
+ * This does not protect us against NMI, but enable()
+ * sets the enabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * keep the counter running.
+ */
+void perf_counter_task_sched_in(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+
+	__perf_counter_sched_in(ctx, cpuctx, cpu);
+	cpuctx->task_ctx = ctx;
+}
+
+static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+
+	__perf_counter_sched_in(ctx, cpuctx, cpu);
+}
+
+int perf_counter_task_disable(void)
+{
+	struct task_struct *curr = current;
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	unsigned long flags;
+	u64 perf_flags;
+	int cpu;
+
+	if (likely(!ctx->nr_counters))
+		return 0;
+
+	curr_rq_lock_irq_save(&flags);
+	cpu = smp_processor_id();
+
+	/* force the update of the task clock: */
+	__task_delta_exec(curr, 1);
+
+	perf_counter_task_sched_out(curr, cpu);
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Disable all the counters:
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state != PERF_COUNTER_STATE_ERROR)
+			counter->state = PERF_COUNTER_STATE_OFF;
+	}
+
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+
+	curr_rq_unlock_irq_restore(&flags);
+
+	return 0;
+}
+
+int perf_counter_task_enable(void)
+{
+	struct task_struct *curr = current;
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	unsigned long flags;
+	u64 perf_flags;
+	int cpu;
+
+	if (likely(!ctx->nr_counters))
+		return 0;
+
+	curr_rq_lock_irq_save(&flags);
+	cpu = smp_processor_id();
+
+	/* force the update of the task clock: */
+	__task_delta_exec(curr, 1);
+
+	perf_counter_task_sched_out(curr, cpu);
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Disable all the counters:
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state > PERF_COUNTER_STATE_OFF)
+			continue;
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->hw_event.disabled = 0;
+	}
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+
+	perf_counter_task_sched_in(curr, cpu);
+
+	curr_rq_unlock_irq_restore(&flags);
+
+	return 0;
+}
+
+/*
+ * Round-robin a context's counters:
+ */
+static void rotate_ctx(struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+	u64 perf_flags;
+
+	if (!ctx->nr_counters)
+		return;
+
+	spin_lock(&ctx->lock);
+	/*
+	 * Rotate the first entry last (works just fine for group counters too):
+	 */
+	perf_flags = hw_perf_save_disable();
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		list_move_tail(&counter->list_entry, &ctx->counter_list);
+		break;
+	}
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+}
+
+void perf_counter_task_tick(struct task_struct *curr, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	const int rotate_percpu = 0;
+
+	if (rotate_percpu)
+		perf_counter_cpu_sched_out(cpuctx);
+	perf_counter_task_sched_out(curr, cpu);
+
+	if (rotate_percpu)
+		rotate_ctx(&cpuctx->ctx);
+	rotate_ctx(ctx);
+
+	if (rotate_percpu)
+		perf_counter_cpu_sched_in(cpuctx, cpu);
+	perf_counter_task_sched_in(curr, cpu);
+}
+
+/*
+ * Cross CPU call to read the hardware counter
+ */
+static void __read(void *info)
+{
+	struct perf_counter *counter = info;
+	unsigned long flags;
+
+	curr_rq_lock_irq_save(&flags);
+	counter->hw_ops->read(counter);
+	curr_rq_unlock_irq_restore(&flags);
+}
+
+static u64 perf_counter_read(struct perf_counter *counter)
+{
+	/*
+	 * If counter is enabled and currently active on a CPU, update the
+	 * value in the counter structure:
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+		smp_call_function_single(counter->oncpu,
+					 __read, counter, 1);
+	}
+
+	return atomic64_read(&counter->count);
+}
+
+/*
+ * Cross CPU call to switch performance data pointers
+ */
+static void __perf_switch_irq_data(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_data *oldirqdata = counter->irqdata;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task) {
+		if (cpuctx->task_ctx != ctx)
+			return;
+		spin_lock(&ctx->lock);
+	}
+
+	/* Change the pointer NMI safe */
+	atomic_long_set((atomic_long_t *)&counter->irqdata,
+			(unsigned long) counter->usrdata);
+	counter->usrdata = oldirqdata;
+
+	if (ctx->task)
+		spin_unlock(&ctx->lock);
+}
+
+static struct perf_data *perf_switch_irq_data(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_data *oldirqdata = counter->irqdata;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		smp_call_function_single(counter->cpu,
+					 __perf_switch_irq_data,
+					 counter, 1);
+		return counter->usrdata;
+	}
+
+retry:
+	spin_lock_irq(&ctx->lock);
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE) {
+		counter->irqdata = counter->usrdata;
+		counter->usrdata = oldirqdata;
+		spin_unlock_irq(&ctx->lock);
+		return oldirqdata;
+	}
+	spin_unlock_irq(&ctx->lock);
+	task_oncpu_function_call(task, __perf_switch_irq_data, counter);
+	/* Might have failed, because task was scheduled out */
+	if (counter->irqdata == oldirqdata)
+		goto retry;
+
+	return counter->usrdata;
+}
+
+static void put_context(struct perf_counter_context *ctx)
+{
+	if (ctx->task)
+		put_task_struct(ctx->task);
+}
+
+static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_counter_context *ctx;
+	struct task_struct *task;
+
+	/*
+	 * If cpu is not a wildcard then this is a percpu counter:
+	 */
+	if (cpu != -1) {
+		/* Must be root to operate on a CPU counter: */
+		if (!capable(CAP_SYS_ADMIN))
+			return ERR_PTR(-EACCES);
+
+		if (cpu < 0 || cpu > num_possible_cpus())
+			return ERR_PTR(-EINVAL);
+
+		/*
+		 * We could be clever and allow to attach a counter to an
+		 * offline CPU and activate it when the CPU comes up, but
+		 * that's for later.
+		 */
+		if (!cpu_isset(cpu, cpu_online_map))
+			return ERR_PTR(-ENODEV);
+
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		ctx = &cpuctx->ctx;
+
+		return ctx;
+	}
+
+	rcu_read_lock();
+	if (!pid)
+		task = current;
+	else
+		task = find_task_by_vpid(pid);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+
+	if (!task)
+		return ERR_PTR(-ESRCH);
+
+	ctx = &task->perf_counter_ctx;
+	ctx->task = task;
+
+	/* Reuse ptrace permission checks for now. */
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		put_context(ctx);
+		return ERR_PTR(-EACCES);
+	}
+
+	return ctx;
+}
+
+static void free_counter_rcu(struct rcu_head *head)
+{
+	struct perf_counter *counter;
+
+	counter = container_of(head, struct perf_counter, rcu_head);
+	kfree(counter);
+}
+
+static void free_counter(struct perf_counter *counter)
+{
+	if (counter->destroy)
+		counter->destroy(counter);
+
+	call_rcu(&counter->rcu_head, free_counter_rcu);
+}
+
+/*
+ * Called when the last reference to the file is gone.
+ */
+static int perf_release(struct inode *inode, struct file *file)
+{
+	struct perf_counter *counter = file->private_data;
+	struct perf_counter_context *ctx = counter->ctx;
+
+	file->private_data = NULL;
+
+	mutex_lock(&ctx->mutex);
+	mutex_lock(&counter->mutex);
+
+	perf_counter_remove_from_context(counter);
+
+	mutex_unlock(&counter->mutex);
+	mutex_unlock(&ctx->mutex);
+
+	free_counter(counter);
+	put_context(ctx);
+
+	return 0;
+}
+
+/*
+ * Read the performance counter - simple non blocking version for now
+ */
+static ssize_t
+perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
+{
+	u64 cntval;
+
+	if (count != sizeof(cntval))
+		return -EINVAL;
+
+	/*
+	 * Return end-of-file for a read on a counter that is in
+	 * error state (i.e. because it was pinned but it couldn't be
+	 * scheduled on to the CPU at some point).
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ERROR)
+		return 0;
+
+	mutex_lock(&counter->mutex);
+	cntval = perf_counter_read(counter);
+	mutex_unlock(&counter->mutex);
+
+	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
+}
+
+static ssize_t
+perf_copy_usrdata(struct perf_data *usrdata, char __user *buf, size_t count)
+{
+	if (!usrdata->len)
+		return 0;
+
+	count = min(count, (size_t)usrdata->len);
+	if (copy_to_user(buf, usrdata->data + usrdata->rd_idx, count))
+		return -EFAULT;
+
+	/* Adjust the counters */
+	usrdata->len -= count;
+	if (!usrdata->len)
+		usrdata->rd_idx = 0;
+	else
+		usrdata->rd_idx += count;
+
+	return count;
+}
+
+static ssize_t
+perf_read_irq_data(struct perf_counter	*counter,
+		   char __user		*buf,
+		   size_t		count,
+		   int			nonblocking)
+{
+	struct perf_data *irqdata, *usrdata;
+	DECLARE_WAITQUEUE(wait, current);
+	ssize_t res, res2;
+
+	irqdata = counter->irqdata;
+	usrdata = counter->usrdata;
+
+	if (usrdata->len + irqdata->len >= count)
+		goto read_pending;
+
+	if (nonblocking)
+		return -EAGAIN;
+
+	spin_lock_irq(&counter->waitq.lock);
+	__add_wait_queue(&counter->waitq, &wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (usrdata->len + irqdata->len >= count)
+			break;
+
+		if (signal_pending(current))
+			break;
+
+		if (counter->state == PERF_COUNTER_STATE_ERROR)
+			break;
+
+		spin_unlock_irq(&counter->waitq.lock);
+		schedule();
+		spin_lock_irq(&counter->waitq.lock);
+	}
+	__remove_wait_queue(&counter->waitq, &wait);
+	__set_current_state(TASK_RUNNING);
+	spin_unlock_irq(&counter->waitq.lock);
+
+	if (usrdata->len + irqdata->len < count &&
+	    counter->state != PERF_COUNTER_STATE_ERROR)
+		return -ERESTARTSYS;
+read_pending:
+	mutex_lock(&counter->mutex);
+
+	/* Drain pending data first: */
+	res = perf_copy_usrdata(usrdata, buf, count);
+	if (res < 0 || res == count)
+		goto out;
+
+	/* Switch irq buffer: */
+	usrdata = perf_switch_irq_data(counter);
+	res2 = perf_copy_usrdata(usrdata, buf + res, count - res);
+	if (res2 < 0) {
+		if (!res)
+			res = -EFAULT;
+	} else {
+		res += res2;
+	}
+out:
+	mutex_unlock(&counter->mutex);
+
+	return res;
+}
+
+static ssize_t
+perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct perf_counter *counter = file->private_data;
+
+	switch (counter->hw_event.record_type) {
+	case PERF_RECORD_SIMPLE:
+		return perf_read_hw(counter, buf, count);
+
+	case PERF_RECORD_IRQ:
+	case PERF_RECORD_GROUP:
+		return perf_read_irq_data(counter, buf, count,
+					  file->f_flags & O_NONBLOCK);
+	}
+	return -EINVAL;
+}
+
+static unsigned int perf_poll(struct file *file, poll_table *wait)
+{
+	struct perf_counter *counter = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+
+	poll_wait(file, &counter->waitq, wait);
+
+	spin_lock_irqsave(&counter->waitq.lock, flags);
+	if (counter->usrdata->len || counter->irqdata->len)
+		events |= POLLIN;
+	spin_unlock_irqrestore(&counter->waitq.lock, flags);
+
+	return events;
+}
+
+static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct perf_counter *counter = file->private_data;
+	int err = 0;
+
+	switch (cmd) {
+	case PERF_COUNTER_IOC_ENABLE:
+		perf_counter_enable_family(counter);
+		break;
+	case PERF_COUNTER_IOC_DISABLE:
+		perf_counter_disable_family(counter);
+		break;
+	default:
+		err = -ENOTTY;
+	}
+	return err;
+}
+
+static const struct file_operations perf_fops = {
+	.release		= perf_release,
+	.read			= perf_read,
+	.poll			= perf_poll,
+	.unlocked_ioctl		= perf_ioctl,
+	.compat_ioctl		= perf_ioctl,
+};
+
+/*
+ * Output
+ */
+
+static void perf_counter_store_irq(struct perf_counter *counter, u64 data)
+{
+	struct perf_data *irqdata = counter->irqdata;
+
+	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
+		irqdata->overrun++;
+	} else {
+		u64 *p = (u64 *) &irqdata->data[irqdata->len];
+
+		*p = data;
+		irqdata->len += sizeof(u64);
+	}
+}
+
+static void perf_counter_handle_group(struct perf_counter *counter)
+{
+	struct perf_counter *leader, *sub;
+
+	leader = counter->group_leader;
+	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+		if (sub != counter)
+			sub->hw_ops->read(sub);
+		perf_counter_store_irq(counter, sub->hw_event.event_config);
+		perf_counter_store_irq(counter, atomic64_read(&sub->count));
+	}
+}
+
+void perf_counter_output(struct perf_counter *counter,
+			 int nmi, struct pt_regs *regs)
+{
+	switch (counter->hw_event.record_type) {
+	case PERF_RECORD_SIMPLE:
+		return;
+
+	case PERF_RECORD_IRQ:
+		perf_counter_store_irq(counter, instruction_pointer(regs));
+		break;
+
+	case PERF_RECORD_GROUP:
+		perf_counter_handle_group(counter);
+		break;
+	}
+
+	if (nmi) {
+		counter->wakeup_pending = 1;
+		set_perf_counter_pending();
+	} else
+		wake_up(&counter->waitq);
+}
+
+/*
+ * Generic software counter infrastructure
+ */
+
+static void perf_swcounter_update(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	u64 prev, now;
+	s64 delta;
+
+again:
+	prev = atomic64_read(&hwc->prev_count);
+	now = atomic64_read(&hwc->count);
+	if (atomic64_cmpxchg(&hwc->prev_count, prev, now) != prev)
+		goto again;
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+	atomic64_sub(delta, &hwc->period_left);
+}
+
+static void perf_swcounter_set_period(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	s64 left = atomic64_read(&hwc->period_left);
+	s64 period = hwc->irq_period;
+
+	if (unlikely(left <= -period)) {
+		left = period;
+		atomic64_set(&hwc->period_left, left);
+	}
+
+	if (unlikely(left <= 0)) {
+		left += period;
+		atomic64_add(period, &hwc->period_left);
+	}
+
+	atomic64_set(&hwc->prev_count, -left);
+	atomic64_set(&hwc->count, -left);
+}
+
+static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
+{
+	struct perf_counter *counter;
+	struct pt_regs *regs;
+
+	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
+	counter->hw_ops->read(counter);
+
+	regs = get_irq_regs();
+	/*
+	 * In case we exclude kernel IPs or are somehow not in interrupt
+	 * context, provide the next best thing, the user IP.
+	 */
+	if ((counter->hw_event.exclude_kernel || !regs) &&
+			!counter->hw_event.exclude_user)
+		regs = task_pt_regs(current);
+
+	if (regs)
+		perf_counter_output(counter, 0, regs);
+
+	hrtimer_forward_now(hrtimer, ns_to_ktime(counter->hw.irq_period));
+
+	return HRTIMER_RESTART;
+}
+
+static void perf_swcounter_overflow(struct perf_counter *counter,
+				    int nmi, struct pt_regs *regs)
+{
+	perf_swcounter_update(counter);
+	perf_swcounter_set_period(counter);
+	perf_counter_output(counter, nmi, regs);
+}
+
+static int perf_swcounter_match(struct perf_counter *counter,
+				enum perf_event_types type,
+				u32 event, struct pt_regs *regs)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return 0;
+
+	if (counter->hw_event.raw_type)
+		return 0;
+
+	if (counter->hw_event.type != type)
+		return 0;
+
+	if (counter->hw_event.event_id != event)
+		return 0;
+
+	if (counter->hw_event.exclude_user && user_mode(regs))
+		return 0;
+
+	if (counter->hw_event.exclude_kernel && !user_mode(regs))
+		return 0;
+
+	return 1;
+}
+
+static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
+			       int nmi, struct pt_regs *regs)
+{
+	int neg = atomic64_add_negative(nr, &counter->hw.count);
+	if (counter->hw.irq_period && !neg)
+		perf_swcounter_overflow(counter, nmi, regs);
+}
+
+static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
+				     enum perf_event_types type, u32 event,
+				     u64 nr, int nmi, struct pt_regs *regs)
+{
+	struct perf_counter *counter;
+
+	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
+		if (perf_swcounter_match(counter, type, event, regs))
+			perf_swcounter_add(counter, nr, nmi, regs);
+	}
+	rcu_read_unlock();
+}
+
+static void __perf_swcounter_event(enum perf_event_types type, u32 event,
+				   u64 nr, int nmi, struct pt_regs *regs)
+{
+	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
+
+	perf_swcounter_ctx_event(&cpuctx->ctx, type, event, nr, nmi, regs);
+	if (cpuctx->task_ctx) {
+		perf_swcounter_ctx_event(cpuctx->task_ctx, type, event,
+				nr, nmi, regs);
+	}
+
+	put_cpu_var(perf_cpu_context);
+}
+
+void perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs)
+{
+	__perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, regs);
+}
+
+static void perf_swcounter_read(struct perf_counter *counter)
+{
+	perf_swcounter_update(counter);
+}
+
+static int perf_swcounter_enable(struct perf_counter *counter)
+{
+	perf_swcounter_set_period(counter);
+	return 0;
+}
+
+static void perf_swcounter_disable(struct perf_counter *counter)
+{
+	perf_swcounter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_generic = {
+	.enable		= perf_swcounter_enable,
+	.disable	= perf_swcounter_disable,
+	.read		= perf_swcounter_read,
+};
+
+/*
+ * Software counter: cpu wall time clock
+ */
+
+static void cpu_clock_perf_counter_update(struct perf_counter *counter)
+{
+	int cpu = raw_smp_processor_id();
+	s64 prev;
+	u64 now;
+
+	now = cpu_clock(cpu);
+	prev = atomic64_read(&counter->hw.prev_count);
+	atomic64_set(&counter->hw.prev_count, now);
+	atomic64_add(now - prev, &counter->count);
+}
+
+static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	int cpu = raw_smp_processor_id();
+
+	atomic64_set(&hwc->prev_count, cpu_clock(cpu));
+	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.function = perf_swcounter_hrtimer;
+	if (hwc->irq_period) {
+		__hrtimer_start_range_ns(&hwc->hrtimer,
+				ns_to_ktime(hwc->irq_period), 0,
+				HRTIMER_MODE_REL, 0);
+	}
+
+	return 0;
+}
+
+static void cpu_clock_perf_counter_disable(struct perf_counter *counter)
+{
+	hrtimer_cancel(&counter->hw.hrtimer);
+	cpu_clock_perf_counter_update(counter);
+}
+
+static void cpu_clock_perf_counter_read(struct perf_counter *counter)
+{
+	cpu_clock_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_cpu_clock = {
+	.enable		= cpu_clock_perf_counter_enable,
+	.disable	= cpu_clock_perf_counter_disable,
+	.read		= cpu_clock_perf_counter_read,
+};
+
+/*
+ * Software counter: task time clock
+ */
+
+/*
+ * Called from within the scheduler:
+ */
+static u64 task_clock_perf_counter_val(struct perf_counter *counter, int update)
+{
+	struct task_struct *curr = counter->task;
+	u64 delta;
+
+	delta = __task_delta_exec(curr, update);
+
+	return curr->se.sum_exec_runtime + delta;
+}
+
+static void task_clock_perf_counter_update(struct perf_counter *counter, u64 now)
+{
+	u64 prev;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static int task_clock_perf_counter_enable(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	atomic64_set(&hwc->prev_count, task_clock_perf_counter_val(counter, 0));
+	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.function = perf_swcounter_hrtimer;
+	if (hwc->irq_period) {
+		__hrtimer_start_range_ns(&hwc->hrtimer,
+				ns_to_ktime(hwc->irq_period), 0,
+				HRTIMER_MODE_REL, 0);
+	}
+
+	return 0;
+}
+
+static void task_clock_perf_counter_disable(struct perf_counter *counter)
+{
+	hrtimer_cancel(&counter->hw.hrtimer);
+	task_clock_perf_counter_update(counter,
+			task_clock_perf_counter_val(counter, 0));
+}
+
+static void task_clock_perf_counter_read(struct perf_counter *counter)
+{
+	task_clock_perf_counter_update(counter,
+			task_clock_perf_counter_val(counter, 1));
+}
+
+static const struct hw_perf_counter_ops perf_ops_task_clock = {
+	.enable		= task_clock_perf_counter_enable,
+	.disable	= task_clock_perf_counter_disable,
+	.read		= task_clock_perf_counter_read,
+};
+
+/*
+ * Software counter: cpu migrations
+ */
+
+static inline u64 get_cpu_migrations(struct perf_counter *counter)
+{
+	struct task_struct *curr = counter->ctx->task;
+
+	if (curr)
+		return curr->se.nr_migrations;
+	return cpu_nr_migrations(smp_processor_id());
+}
+
+static void cpu_migrations_perf_counter_update(struct perf_counter *counter)
+{
+	u64 prev, now;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+	now = get_cpu_migrations(counter);
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void cpu_migrations_perf_counter_read(struct perf_counter *counter)
+{
+	cpu_migrations_perf_counter_update(counter);
+}
+
+static int cpu_migrations_perf_counter_enable(struct perf_counter *counter)
+{
+	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
+		atomic64_set(&counter->hw.prev_count,
+			     get_cpu_migrations(counter));
+	return 0;
+}
+
+static void cpu_migrations_perf_counter_disable(struct perf_counter *counter)
+{
+	cpu_migrations_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
+	.enable		= cpu_migrations_perf_counter_enable,
+	.disable	= cpu_migrations_perf_counter_disable,
+	.read		= cpu_migrations_perf_counter_read,
+};
+
+#ifdef CONFIG_EVENT_PROFILE
+void perf_tpcounter_event(int event_id)
+{
+	struct pt_regs *regs = get_irq_regs();
+
+	if (!regs)
+		regs = task_pt_regs(current);
+
+	__perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, regs);
+}
+
+extern int ftrace_profile_enable(int);
+extern void ftrace_profile_disable(int);
+
+static void tp_perf_counter_destroy(struct perf_counter *counter)
+{
+	ftrace_profile_disable(counter->hw_event.event_id);
+}
+
+static const struct hw_perf_counter_ops *
+tp_perf_counter_init(struct perf_counter *counter)
+{
+	int event_id = counter->hw_event.event_id;
+	int ret;
+
+	ret = ftrace_profile_enable(event_id);
+	if (ret)
+		return NULL;
+
+	counter->destroy = tp_perf_counter_destroy;
+	counter->hw.irq_period = counter->hw_event.irq_period;
+
+	return &perf_ops_generic;
+}
+#else
+static const struct hw_perf_counter_ops *
+tp_perf_counter_init(struct perf_counter *counter)
+{
+	return NULL;
+}
+#endif
+
+static const struct hw_perf_counter_ops *
+sw_perf_counter_init(struct perf_counter *counter)
+{
+	struct perf_counter_hw_event *hw_event = &counter->hw_event;
+	const struct hw_perf_counter_ops *hw_ops = NULL;
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	/*
+	 * Software counters (currently) can't in general distinguish
+	 * between user, kernel and hypervisor events.
+	 * However, context switches and cpu migrations are considered
+	 * to be kernel events, and page faults are never hypervisor
+	 * events.
+	 */
+	switch (counter->hw_event.event_id) {
+	case PERF_COUNT_CPU_CLOCK:
+		hw_ops = &perf_ops_cpu_clock;
+
+		if (hw_event->irq_period && hw_event->irq_period < 10000)
+			hw_event->irq_period = 10000;
+		break;
+	case PERF_COUNT_TASK_CLOCK:
+		/*
+		 * If the user instantiates this as a per-cpu counter,
+		 * use the cpu_clock counter instead.
+		 */
+		if (counter->ctx->task)
+			hw_ops = &perf_ops_task_clock;
+		else
+			hw_ops = &perf_ops_cpu_clock;
+
+		if (hw_event->irq_period && hw_event->irq_period < 10000)
+			hw_event->irq_period = 10000;
+		break;
+	case PERF_COUNT_PAGE_FAULTS:
+	case PERF_COUNT_PAGE_FAULTS_MIN:
+	case PERF_COUNT_PAGE_FAULTS_MAJ:
+	case PERF_COUNT_CONTEXT_SWITCHES:
+		hw_ops = &perf_ops_generic;
+		break;
+	case PERF_COUNT_CPU_MIGRATIONS:
+		if (!counter->hw_event.exclude_kernel)
+			hw_ops = &perf_ops_cpu_migrations;
+		break;
+	}
+
+	if (hw_ops)
+		hwc->irq_period = hw_event->irq_period;
+
+	return hw_ops;
+}
+
+/*
+ * Allocate and initialize a counter structure
+ */
+static struct perf_counter *
+perf_counter_alloc(struct perf_counter_hw_event *hw_event,
+		   int cpu,
+		   struct perf_counter_context *ctx,
+		   struct perf_counter *group_leader,
+		   gfp_t gfpflags)
+{
+	const struct hw_perf_counter_ops *hw_ops;
+	struct perf_counter *counter;
+
+	counter = kzalloc(sizeof(*counter), gfpflags);
+	if (!counter)
+		return NULL;
+
+	/*
+	 * Single counters are their own group leaders, with an
+	 * empty sibling list:
+	 */
+	if (!group_leader)
+		group_leader = counter;
+
+	mutex_init(&counter->mutex);
+	INIT_LIST_HEAD(&counter->list_entry);
+	INIT_LIST_HEAD(&counter->event_entry);
+	INIT_LIST_HEAD(&counter->sibling_list);
+	init_waitqueue_head(&counter->waitq);
+
+	INIT_LIST_HEAD(&counter->child_list);
+
+	counter->irqdata		= &counter->data[0];
+	counter->usrdata		= &counter->data[1];
+	counter->cpu			= cpu;
+	counter->hw_event		= *hw_event;
+	counter->wakeup_pending		= 0;
+	counter->group_leader		= group_leader;
+	counter->hw_ops			= NULL;
+	counter->ctx			= ctx;
+
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	if (hw_event->disabled)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+	hw_ops = NULL;
+
+	if (hw_event->raw_type)
+		hw_ops = hw_perf_counter_init(counter);
+	else switch (hw_event->type) {
+	case PERF_TYPE_HARDWARE:
+		hw_ops = hw_perf_counter_init(counter);
+		break;
+
+	case PERF_TYPE_SOFTWARE:
+		hw_ops = sw_perf_counter_init(counter);
+		break;
+
+	case PERF_TYPE_TRACEPOINT:
+		hw_ops = tp_perf_counter_init(counter);
+		break;
+	}
+
+	if (!hw_ops) {
+		kfree(counter);
+		return NULL;
+	}
+	counter->hw_ops = hw_ops;
+
+	return counter;
+}
+
+/**
+ * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
+ *
+ * @hw_event_uptr:	event type attributes for monitoring/sampling
+ * @pid:		target pid
+ * @cpu:		target cpu
+ * @group_fd:		group leader counter fd
+ */
+SYSCALL_DEFINE5(perf_counter_open,
+		const struct perf_counter_hw_event __user *, hw_event_uptr,
+		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
+{
+	struct perf_counter *counter, *group_leader;
+	struct perf_counter_hw_event hw_event;
+	struct perf_counter_context *ctx;
+	struct file *counter_file = NULL;
+	struct file *group_file = NULL;
+	int fput_needed = 0;
+	int fput_needed2 = 0;
+	int ret;
+
+	/* for future expandability... */
+	if (flags)
+		return -EINVAL;
+
+	if (copy_from_user(&hw_event, hw_event_uptr, sizeof(hw_event)) != 0)
+		return -EFAULT;
+
+	/*
+	 * Get the target context (task or percpu):
+	 */
+	ctx = find_get_context(pid, cpu);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	/*
+	 * Look up the group leader (we will attach this counter to it):
+	 */
+	group_leader = NULL;
+	if (group_fd != -1) {
+		ret = -EINVAL;
+		group_file = fget_light(group_fd, &fput_needed);
+		if (!group_file)
+			goto err_put_context;
+		if (group_file->f_op != &perf_fops)
+			goto err_put_context;
+
+		group_leader = group_file->private_data;
+		/*
+		 * Do not allow a recursive hierarchy (this new sibling
+		 * becoming part of another group-sibling):
+		 */
+		if (group_leader->group_leader != group_leader)
+			goto err_put_context;
+		/*
+		 * Do not allow to attach to a group in a different
+		 * task or CPU context:
+		 */
+		if (group_leader->ctx != ctx)
+			goto err_put_context;
+		/*
+		 * Only a group leader can be exclusive or pinned
+		 */
+		if (hw_event.exclusive || hw_event.pinned)
+			goto err_put_context;
+	}
+
+	ret = -EINVAL;
+	counter = perf_counter_alloc(&hw_event, cpu, ctx, group_leader,
+				     GFP_KERNEL);
+	if (!counter)
+		goto err_put_context;
+
+	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
+	if (ret < 0)
+		goto err_free_put_context;
+
+	counter_file = fget_light(ret, &fput_needed2);
+	if (!counter_file)
+		goto err_free_put_context;
+
+	counter->filp = counter_file;
+	mutex_lock(&ctx->mutex);
+	perf_install_in_context(ctx, counter, cpu);
+	mutex_unlock(&ctx->mutex);
+
+	fput_light(counter_file, fput_needed2);
+
+out_fput:
+	fput_light(group_file, fput_needed);
+
+	return ret;
+
+err_free_put_context:
+	kfree(counter);
+
+err_put_context:
+	put_context(ctx);
+
+	goto out_fput;
+}
+
+/*
+ * Initialize the perf_counter context in a task_struct:
+ */
+static void
+__perf_counter_init_context(struct perf_counter_context *ctx,
+			    struct task_struct *task)
+{
+	memset(ctx, 0, sizeof(*ctx));
+	spin_lock_init(&ctx->lock);
+	mutex_init(&ctx->mutex);
+	INIT_LIST_HEAD(&ctx->counter_list);
+	INIT_LIST_HEAD(&ctx->event_list);
+	ctx->task = task;
+}
+
+/*
+ * inherit a counter from parent task to child task:
+ */
+static struct perf_counter *
+inherit_counter(struct perf_counter *parent_counter,
+	      struct task_struct *parent,
+	      struct perf_counter_context *parent_ctx,
+	      struct task_struct *child,
+	      struct perf_counter *group_leader,
+	      struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *child_counter;
+
+	/*
+	 * Instead of creating recursive hierarchies of counters,
+	 * we link inherited counters back to the original parent,
+	 * which has a filp for sure, which we use as the reference
+	 * count:
+	 */
+	if (parent_counter->parent)
+		parent_counter = parent_counter->parent;
+
+	child_counter = perf_counter_alloc(&parent_counter->hw_event,
+					   parent_counter->cpu, child_ctx,
+					   group_leader, GFP_KERNEL);
+	if (!child_counter)
+		return NULL;
+
+	/*
+	 * Link it up in the child's context:
+	 */
+	child_counter->task = child;
+	list_add_counter(child_counter, child_ctx);
+	child_ctx->nr_counters++;
+
+	child_counter->parent = parent_counter;
+	/*
+	 * inherit into child's child as well:
+	 */
+	child_counter->hw_event.inherit = 1;
+
+	/*
+	 * Get a reference to the parent filp - we will fput it
+	 * when the child counter exits. This is safe to do because
+	 * we are in the parent and we know that the filp still
+	 * exists and has a nonzero count:
+	 */
+	atomic_long_inc(&parent_counter->filp->f_count);
+
+	/*
+	 * Link this into the parent counter's child list
+	 */
+	mutex_lock(&parent_counter->mutex);
+	list_add_tail(&child_counter->child_list, &parent_counter->child_list);
+
+	/*
+	 * Make the child state follow the state of the parent counter,
+	 * not its hw_event.disabled bit.  We hold the parent's mutex,
+	 * so we won't race with perf_counter_{en,dis}able_family.
+	 */
+	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
+		child_counter->state = PERF_COUNTER_STATE_INACTIVE;
+	else
+		child_counter->state = PERF_COUNTER_STATE_OFF;
+
+	mutex_unlock(&parent_counter->mutex);
+
+	return child_counter;
+}
+
+static int inherit_group(struct perf_counter *parent_counter,
+	      struct task_struct *parent,
+	      struct perf_counter_context *parent_ctx,
+	      struct task_struct *child,
+	      struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *leader;
+	struct perf_counter *sub;
+
+	leader = inherit_counter(parent_counter, parent, parent_ctx,
+				 child, NULL, child_ctx);
+	if (!leader)
+		return -ENOMEM;
+	list_for_each_entry(sub, &parent_counter->sibling_list, list_entry) {
+		if (!inherit_counter(sub, parent, parent_ctx,
+				     child, leader, child_ctx))
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static void sync_child_counter(struct perf_counter *child_counter,
+			       struct perf_counter *parent_counter)
+{
+	u64 parent_val, child_val;
+
+	parent_val = atomic64_read(&parent_counter->count);
+	child_val = atomic64_read(&child_counter->count);
+
+	/*
+	 * Add back the child's count to the parent's count:
+	 */
+	atomic64_add(child_val, &parent_counter->count);
+
+	/*
+	 * Remove this counter from the parent's list
+	 */
+	mutex_lock(&parent_counter->mutex);
+	list_del_init(&child_counter->child_list);
+	mutex_unlock(&parent_counter->mutex);
+
+	/*
+	 * Release the parent counter, if this was the last
+	 * reference to it.
+	 */
+	fput(parent_counter->filp);
+}
+
+static void
+__perf_counter_exit_task(struct task_struct *child,
+			 struct perf_counter *child_counter,
+			 struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *parent_counter;
+	struct perf_counter *sub, *tmp;
+
+	/*
+	 * If we do not self-reap then we have to wait for the
+	 * child task to unschedule (it will happen for sure),
+	 * so that its counter is at its final count. (This
+	 * condition triggers rarely - child tasks usually get
+	 * off their CPU before the parent has a chance to
+	 * get this far into the reaping action)
+	 */
+	if (child != current) {
+		wait_task_inactive(child, 0);
+		list_del_init(&child_counter->list_entry);
+	} else {
+		struct perf_cpu_context *cpuctx;
+		unsigned long flags;
+		u64 perf_flags;
+
+		/*
+		 * Disable and unlink this counter.
+		 *
+		 * Be careful about zapping the list - IRQ/NMI context
+		 * could still be processing it:
+		 */
+		curr_rq_lock_irq_save(&flags);
+		perf_flags = hw_perf_save_disable();
+
+		cpuctx = &__get_cpu_var(perf_cpu_context);
+
+		group_sched_out(child_counter, cpuctx, child_ctx);
+
+		list_del_init(&child_counter->list_entry);
+
+		child_ctx->nr_counters--;
+
+		hw_perf_restore(perf_flags);
+		curr_rq_unlock_irq_restore(&flags);
+	}
+
+	parent_counter = child_counter->parent;
+	/*
+	 * It can happen that parent exits first, and has counters
+	 * that are still around due to the child reference. These
+	 * counters need to be zapped - but otherwise linger.
+	 */
+	if (parent_counter) {
+		sync_child_counter(child_counter, parent_counter);
+		list_for_each_entry_safe(sub, tmp, &child_counter->sibling_list,
+					 list_entry) {
+			if (sub->parent) {
+				sync_child_counter(sub, sub->parent);
+				free_counter(sub);
+			}
+		}
+		free_counter(child_counter);
+	}
+}
+
+/*
+ * When a child task exits, feed back counter values to parent counters.
+ *
+ * Note: we may be running in child context, but the PID is not hashed
+ * anymore so new counters will not be added.
+ */
+void perf_counter_exit_task(struct task_struct *child)
+{
+	struct perf_counter *child_counter, *tmp;
+	struct perf_counter_context *child_ctx;
+
+	child_ctx = &child->perf_counter_ctx;
+
+	if (likely(!child_ctx->nr_counters))
+		return;
+
+	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
+				 list_entry)
+		__perf_counter_exit_task(child, child_counter, child_ctx);
+}
+
+/*
+ * Initialize the perf_counter context in task_struct
+ */
+void perf_counter_init_task(struct task_struct *child)
+{
+	struct perf_counter_context *child_ctx, *parent_ctx;
+	struct perf_counter *counter;
+	struct task_struct *parent = current;
+
+	child_ctx  =  &child->perf_counter_ctx;
+	parent_ctx = &parent->perf_counter_ctx;
+
+	__perf_counter_init_context(child_ctx, child);
+
+	/*
+	 * This is executed from the parent task context, so inherit
+	 * counters that have been marked for cloning:
+	 */
+
+	if (likely(!parent_ctx->nr_counters))
+		return;
+
+	/*
+	 * Lock the parent list. No need to lock the child - not PID
+	 * hashed yet and not running, so nobody can access it.
+	 */
+	mutex_lock(&parent_ctx->mutex);
+
+	/*
+	 * We dont have to disable NMIs - we are only looking at
+	 * the list, not manipulating it:
+	 */
+	list_for_each_entry(counter, &parent_ctx->counter_list, list_entry) {
+		if (!counter->hw_event.inherit)
+			continue;
+
+		if (inherit_group(counter, parent,
+				  parent_ctx, child, child_ctx))
+			break;
+	}
+
+	mutex_unlock(&parent_ctx->mutex);
+}
+
+static void __cpuinit perf_counter_init_cpu(int cpu)
+{
+	struct perf_cpu_context *cpuctx;
+
+	cpuctx = &per_cpu(perf_cpu_context, cpu);
+	__perf_counter_init_context(&cpuctx->ctx, NULL);
+
+	mutex_lock(&perf_resource_mutex);
+	cpuctx->max_pertask = perf_max_counters - perf_reserved_percpu;
+	mutex_unlock(&perf_resource_mutex);
+
+	hw_perf_counter_setup(cpu);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void __perf_counter_exit_cpu(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+	struct perf_counter *counter, *tmp;
+
+	list_for_each_entry_safe(counter, tmp, &ctx->counter_list, list_entry)
+		__perf_counter_remove_from_context(counter);
+}
+static void perf_counter_exit_cpu(int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+
+	mutex_lock(&ctx->mutex);
+	smp_call_function_single(cpu, __perf_counter_exit_cpu, NULL, 1);
+	mutex_unlock(&ctx->mutex);
+}
+#else
+static inline void perf_counter_exit_cpu(int cpu) { }
+#endif
+
+static int __cpuinit
+perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action) {
+
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		perf_counter_init_cpu(cpu);
+		break;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		perf_counter_exit_cpu(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata perf_cpu_nb = {
+	.notifier_call		= perf_cpu_notify,
+};
+
+static int __init perf_counter_init(void)
+{
+	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
+			(void *)(long)smp_processor_id());
+	register_cpu_notifier(&perf_cpu_nb);
+
+	return 0;
+}
+early_initcall(perf_counter_init);
+
+static ssize_t perf_show_reserve_percpu(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_reserved_percpu);
+}
+
+static ssize_t
+perf_set_reserve_percpu(struct sysdev_class *class,
+			const char *buf,
+			size_t count)
+{
+	struct perf_cpu_context *cpuctx;
+	unsigned long val;
+	int err, cpu, mpt;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > perf_max_counters)
+		return -EINVAL;
+
+	mutex_lock(&perf_resource_mutex);
+	perf_reserved_percpu = val;
+	for_each_online_cpu(cpu) {
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		spin_lock_irq(&cpuctx->ctx.lock);
+		mpt = min(perf_max_counters - cpuctx->ctx.nr_counters,
+			  perf_max_counters - perf_reserved_percpu);
+		cpuctx->max_pertask = mpt;
+		spin_unlock_irq(&cpuctx->ctx.lock);
+	}
+	mutex_unlock(&perf_resource_mutex);
+
+	return count;
+}
+
+static ssize_t perf_show_overcommit(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_overcommit);
+}
+
+static ssize_t
+perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
+{
+	unsigned long val;
+	int err;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > 1)
+		return -EINVAL;
+
+	mutex_lock(&perf_resource_mutex);
+	perf_overcommit = val;
+	mutex_unlock(&perf_resource_mutex);
+
+	return count;
+}
+
+static SYSDEV_CLASS_ATTR(
+				reserve_percpu,
+				0644,
+				perf_show_reserve_percpu,
+				perf_set_reserve_percpu
+			);
+
+static SYSDEV_CLASS_ATTR(
+				overcommit,
+				0644,
+				perf_show_overcommit,
+				perf_set_overcommit
+			);
+
+static struct attribute *perfclass_attrs[] = {
+	&attr_reserve_percpu.attr,
+	&attr_overcommit.attr,
+	NULL
+};
+
+static struct attribute_group perfclass_attr_group = {
+	.attrs			= perfclass_attrs,
+	.name			= "perf_counters",
+};
+
+static int __init perf_counter_sysfs_init(void)
+{
+	return sysfs_create_group(&cpu_sysdev_class.kset.kobj,
+				  &perfclass_attr_group);
+}
+device_initcall(perf_counter_sysfs_init);
diff --git a/kernel/sched.c b/kernel/sched.c
index 5b0b3c6..3e827b8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -584,6 +584,7 @@ struct rq {
 	struct load_weight load;
 	unsigned long nr_load_updates;
 	u64 nr_switches;
+	u64 nr_migrations_in;
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
@@ -695,7 +696,7 @@ static inline int cpu_of(struct rq *rq)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
-static inline void update_rq_clock(struct rq *rq)
+inline void update_rq_clock(struct rq *rq)
 {
 	rq->clock = sched_clock_cpu(cpu_of(rq));
 }
@@ -1006,6 +1007,26 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	}
 }
 
+void curr_rq_lock_irq_save(unsigned long *flags)
+	__acquires(rq->lock)
+{
+	struct rq *rq;
+
+	local_irq_save(*flags);
+	rq = cpu_rq(smp_processor_id());
+	spin_lock(&rq->lock);
+}
+
+void curr_rq_unlock_irq_restore(unsigned long *flags)
+	__releases(rq->lock)
+{
+	struct rq *rq;
+
+	rq = cpu_rq(smp_processor_id());
+	spin_unlock(&rq->lock);
+	local_irq_restore(*flags);
+}
+
 void task_rq_unlock_wait(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
@@ -1958,12 +1979,15 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		p->se.sleep_start -= clock_offset;
 	if (p->se.block_start)
 		p->se.block_start -= clock_offset;
+#endif
 	if (old_cpu != new_cpu) {
-		schedstat_inc(p, se.nr_migrations);
+		p->se.nr_migrations++;
+		new_rq->nr_migrations_in++;
+#ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
-	}
 #endif
+	}
 	p->se.vruntime -= old_cfsrq->min_vruntime -
 					 new_cfsrq->min_vruntime;
 
@@ -2315,6 +2339,27 @@ static int sched_balance_self(int cpu, int flag)
 
 #endif /* CONFIG_SMP */
 
+/**
+ * task_oncpu_function_call - call a function on the cpu on which a task runs
+ * @p:		the task to evaluate
+ * @func:	the function to be called
+ * @info:	the function call argument
+ *
+ * Calls the function @func when the task is currently running. This might
+ * be on the current CPU, which just calls the function directly
+ */
+void task_oncpu_function_call(struct task_struct *p,
+			      void (*func) (void *info), void *info)
+{
+	int cpu;
+
+	preempt_disable();
+	cpu = task_cpu(p);
+	if (task_curr(p))
+		smp_call_function_single(cpu, func, info, 1);
+	preempt_enable();
+}
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -2471,6 +2516,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
+	p->se.nr_migrations		= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
 	p->se.start_runtime		= 0;
@@ -2701,6 +2747,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
 #ifdef CONFIG_SMP
 	if (post_schedule)
@@ -2863,6 +2910,15 @@ unsigned long nr_active(void)
 }
 
 /*
+ * Externally visible per-cpu scheduler statistics:
+ * cpu_nr_migrations(cpu) - number of migrations into that cpu
+ */
+u64 cpu_nr_migrations(int cpu)
+{
+	return cpu_rq(cpu)->nr_migrations_in;
+}
+
+/*
  * Update rq->cpu_load[] statistics. This function is usually called every
  * scheduler tick (TICK_NSEC).
  */
@@ -4251,6 +4307,29 @@ EXPORT_PER_CPU_SYMBOL(kstat);
  * Return any ns on the sched_clock that have not yet been banked in
  * @p in case that task is currently running.
  */
+unsigned long long __task_delta_exec(struct task_struct *p, int update)
+{
+	s64 delta_exec;
+	struct rq *rq;
+
+	rq = task_rq(p);
+	WARN_ON_ONCE(!runqueue_is_locked());
+	WARN_ON_ONCE(!task_current(rq, p));
+
+	if (update)
+		update_rq_clock(rq);
+
+	delta_exec = rq->clock - p->se.exec_start;
+
+	WARN_ON_ONCE(delta_exec < 0);
+
+	return delta_exec;
+}
+
+/*
+ * Return any ns on the sched_clock that have not yet been banked in
+ * @p in case that task is currently running.
+ */
 unsigned long long task_delta_exec(struct task_struct *p)
 {
 	unsigned long flags;
@@ -4510,6 +4589,7 @@ void scheduler_tick(void)
 	update_rq_clock(rq);
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	perf_counter_task_tick(curr, cpu);
 	spin_unlock(&rq->lock);
 
 #ifdef CONFIG_SMP
@@ -4727,6 +4807,7 @@ need_resched_nonpreemptible:
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
+		perf_counter_task_sched_out(prev, cpu);
 
 		rq->nr_switches++;
 		rq->curr = next;
diff --git a/kernel/sys.c b/kernel/sys.c
index 37f458e..7306f94 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -14,6 +14,7 @@
 #include <linux/prctl.h>
 #include <linux/highuid.h>
 #include <linux/fs.h>
+#include <linux/perf_counter.h>
 #include <linux/resource.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
@@ -1800,6 +1801,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_TSC:
 			error = SET_TSC_CTL(arg2);
 			break;
+		case PR_TASK_PERF_COUNTERS_DISABLE:
+			error = perf_counter_task_disable();
+			break;
+		case PR_TASK_PERF_COUNTERS_ENABLE:
+			error = perf_counter_task_enable();
+			break;
 		case PR_GET_TIMERSLACK:
 			error = current->timer_slack_ns;
 			break;
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 27dad29..68320f6 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -175,3 +175,6 @@ cond_syscall(compat_sys_timerfd_settime);
 cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
+
+/* performance counters: */
+cond_syscall(sys_perf_counter_open);

