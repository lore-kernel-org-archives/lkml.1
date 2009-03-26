Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbZCZPBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbZCZPBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZCZPAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:00:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47554 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbZCZPAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:00:46 -0400
Date: Thu, 26 Mar 2009 16:00:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: [GIT PULL] scheduler updates for v2.6.30
Message-ID: <20090326150022.GA24000@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Linus,

Please pull the latest sched-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-for-linus

Highlights:

 - Most of the linecount comes from a clean-up of the balancing code

 - Real-time scheduling optimizations

 - Performance tweaks (sched-clock speedups for x86)

 - Iteractivity tweaks

Risks:

 - There were no unusual trouble spots during development.

 - There are no open regressions.

 - The interactivity/performance tweaks carry performance regression
   risks:

     e52fb7c: sched: prefer wakers
     df1c99d: sched: add avg_overlap decay

Thanks,

	Ingo

------------------>
Américo Wang (1):
      sched: use TASK_NICE for task_struct

Arjan van de Ven (1):
      sched, latencytop: incorporate review feedback from Andrew Morton

Frederic Weisbecker (1):
      sched: don't rebalance if attached on NULL domain

Gautham R Shenoy (11):
      sched: Simple helper functions for find_busiest_group()
      sched: Fix indentations in find_busiest_group() using gotos
      sched: Define structure to store the sched_group statistics for fbg()
      sched: Create a helper function to calculate sched_group stats for fbg()
      sched: Define structure to store the sched_domain statistics for fbg()
      sched: Create a helper function to calculate sched_domain stats for fbg()
      sched: Create helper to calculate small_imbalance in fbg()
      sched: Create a helper function to calculate imbalance
      sched: Optimize the !power_savings_balance during fbg()
      sched: Refactor the power savings balance code
      sched: Add comments to find_busiest_group() function

Gregory Haskins (13):
      sched: cleanup inc/dec_rt_tasks
      sched: track the next-highest priority on each runqueue
      sched: use highest_prio.curr for pull threshold
      sched: use highest_prio.next to optimize pull operations
      sched: only try to push a task on wakeup if it is migratable
      sched: pull only one task during NEWIDLE balancing to limit critical section
      sched: make double-lock-balance fair
      sched: add sched_class->needs_post_schedule() member
      plist: fix PLIST_NODE_INIT to work with debug enabled
      sched: create "pushable_tasks" list to limit pushing to one attempt
      RT: fix push_rt_task() to handle dequeue_pushable properly
      sched: de CPP-ify the scheduler code
      sched: fix build error in kernel/sched_rt.c when RT_GROUP_SCHED && !SMP

Henrik Austad (1):
      sched: idle_at_tick is only used when CONFIG_SMP is set

Ingo Molnar (4):
      sched: fix !CONFIG_SCHEDSTATS build failure
      sched: allow architectures to specify sched_clock_stable
      x86: set X86_FEATURE_TSC_RELIABLE
      x86, sched_clock(): mark variables read-mostly

Lai Jiangshan (1):
      sched: TIF_NEED_RESCHED -> need_reshed() cleanup

Li Zefan (1):
      cpuacct: add a branch prediction

Luis Henriques (4):
      sched: fix typos in documentation
      sched: small optimisation of can_migrate_task()
      sched: jiffies not printed per CPU
      sched: remove unused fields from struct rq

Mike Galbraith (1):
      sched: add avg_overlap decay

Peter Zijlstra (5):
      sched: introduce avg_wakeup
      sched: prefer wakers
      sched: make plist a library facility
      sched_clock: cleanups
      sched: optimize ttwu vs group scheduling

Wang Chen (2):
      sched, documentation: remove old O(1) scheduler document
      sched: kill unused parameter of pick_next_task()


 Documentation/scheduler/00-INDEX         |    2 -
 Documentation/scheduler/sched-coding.txt |  126 ----
 arch/x86/kernel/cpu/intel.c              |    8 +-
 arch/x86/kernel/tsc.c                    |    9 +-
 include/linux/init_task.h                |    1 +
 include/linux/latencytop.h               |   10 +-
 include/linux/plist.h                    |    9 +-
 include/linux/sched.h                    |   17 +-
 init/Kconfig                             |    1 -
 kernel/latencytop.c                      |   83 +++-
 kernel/sched.c                           |  982 +++++++++++++++++++++---------
 kernel/sched_clock.c                     |   30 +-
 kernel/sched_debug.c                     |    8 +-
 kernel/sched_fair.c                      |   59 ++-
 kernel/sched_features.h                  |    3 +-
 kernel/sched_rt.c                        |  537 ++++++++++++-----
 kernel/sched_stats.h                     |    7 +-
 lib/Kconfig                              |    6 -
 lib/Makefile                             |    4 +-
 lib/kernel_lock.c                        |    2 +-
 20 files changed, 1262 insertions(+), 642 deletions(-)
 delete mode 100644 Documentation/scheduler/sched-coding.txt

diff --git a/Documentation/scheduler/00-INDEX b/Documentation/scheduler/00-INDEX
index aabcc3a..3c00c9c 100644
--- a/Documentation/scheduler/00-INDEX
+++ b/Documentation/scheduler/00-INDEX
@@ -2,8 +2,6 @@
 	- this file.
 sched-arch.txt
 	- CPU Scheduler implementation hints for architecture specific code.
-sched-coding.txt
-	- reference for various scheduler-related methods in the O(1) scheduler.
 sched-design-CFS.txt
 	- goals, design and implementation of the Complete Fair Scheduler.
 sched-domains.txt
diff --git a/Documentation/scheduler/sched-coding.txt b/Documentation/scheduler/sched-coding.txt
deleted file mode 100644
index cbd8db7..0000000
--- a/Documentation/scheduler/sched-coding.txt
+++ /dev/null
@@ -1,126 +0,0 @@
-     Reference for various scheduler-related methods in the O(1) scheduler
-		Robert Love <rml@tech9.net>, MontaVista Software
-
-
-Note most of these methods are local to kernel/sched.c - this is by design.
-The scheduler is meant to be self-contained and abstracted away.  This document
-is primarily for understanding the scheduler, not interfacing to it.  Some of
-the discussed interfaces, however, are general process/scheduling methods.
-They are typically defined in include/linux/sched.h.
-
-
-Main Scheduling Methods
------------------------
-
-void load_balance(runqueue_t *this_rq, int idle)
-	Attempts to pull tasks from one cpu to another to balance cpu usage,
-	if needed.  This method is called explicitly if the runqueues are
-	imbalanced or periodically by the timer tick.  Prior to calling,
-	the current runqueue must be locked and interrupts disabled.
-
-void schedule()
-	The main scheduling function.  Upon return, the highest priority
-	process will be active.
-
-
-Locking
--------
-
-Each runqueue has its own lock, rq->lock.  When multiple runqueues need
-to be locked, lock acquires must be ordered by ascending &runqueue value.
-
-A specific runqueue is locked via
-
-	task_rq_lock(task_t pid, unsigned long *flags)
-
-which disables preemption, disables interrupts, and locks the runqueue pid is
-running on.  Likewise,
-
-	task_rq_unlock(task_t pid, unsigned long *flags)
-
-unlocks the runqueue pid is running on, restores interrupts to their previous
-state, and reenables preemption.
-
-The routines
-
-	double_rq_lock(runqueue_t *rq1, runqueue_t *rq2)
-
-and
-
-	double_rq_unlock(runqueue_t *rq1, runqueue_t *rq2)
-
-safely lock and unlock, respectively, the two specified runqueues.  They do
-not, however, disable and restore interrupts.  Users are required to do so
-manually before and after calls.
-
-
-Values
-------
-
-MAX_PRIO
-	The maximum priority of the system, stored in the task as task->prio.
-	Lower priorities are higher.  Normal (non-RT) priorities range from
-	MAX_RT_PRIO to (MAX_PRIO - 1).
-MAX_RT_PRIO
-	The maximum real-time priority of the system.  Valid RT priorities
-	range from 0 to (MAX_RT_PRIO - 1).
-MAX_USER_RT_PRIO
-	The maximum real-time priority that is exported to user-space.  Should
-	always be equal to or less than MAX_RT_PRIO.  Setting it less allows
-	kernel threads to have higher priorities than any user-space task.
-MIN_TIMESLICE
-MAX_TIMESLICE
-	Respectively, the minimum and maximum timeslices (quanta) of a process.
-
-Data
-----
-
-struct runqueue
-	The main per-CPU runqueue data structure.
-struct task_struct
-	The main per-process data structure.
-
-
-General Methods
----------------
-
-cpu_rq(cpu)
-	Returns the runqueue of the specified cpu.
-this_rq()
-	Returns the runqueue of the current cpu.
-task_rq(pid)
-	Returns the runqueue which holds the specified pid.
-cpu_curr(cpu)
-	Returns the task currently running on the given cpu.
-rt_task(pid)
-	Returns true if pid is real-time, false if not.
-
-
-Process Control Methods
------------------------
-
-void set_user_nice(task_t *p, long nice)
-	Sets the "nice" value of task p to the given value.
-int setscheduler(pid_t pid, int policy, struct sched_param *param)
-	Sets the scheduling policy and parameters for the given pid.
-int set_cpus_allowed(task_t *p, unsigned long new_mask)
-	Sets a given task's CPU affinity and migrates it to a proper cpu.
-	Callers must have a valid reference to the task and assure the
-	task not exit prematurely.  No locks can be held during the call.
-set_task_state(tsk, state_value)
-	Sets the given task's state to the given value.
-set_current_state(state_value)
-	Sets the current task's state to the given value.
-void set_tsk_need_resched(struct task_struct *tsk)
-	Sets need_resched in the given task.
-void clear_tsk_need_resched(struct task_struct *tsk)
-	Clears need_resched in the given task.
-void set_need_resched()
-	Sets need_resched in the current task.
-void clear_need_resched()
-	Clears need_resched in the current task.
-int need_resched()
-	Returns true if need_resched is set in the current task, false
-	otherwise.
-yield()
-	Place the current process at the end of the runqueue and call schedule.
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 24ff26a..5fff00c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -4,6 +4,7 @@
 #include <linux/string.h>
 #include <linux/bitops.h>
 #include <linux/smp.h>
+#include <linux/sched.h>
 #include <linux/thread_info.h>
 #include <linux/module.h>
 
@@ -56,11 +57,16 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 
 	/*
 	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states
+	 * with P/T states and does not stop in deep C-states.
+	 *
+	 * It is also reliable across cores and sockets. (but not across
+	 * cabinets - we turn it off in that case explicitly.)
 	 */
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
+		sched_clock_stable = 1;
 	}
 
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d5cebb5..dfa6f7b 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -17,20 +17,21 @@
 #include <asm/delay.h>
 #include <asm/hypervisor.h>
 
-unsigned int cpu_khz;           /* TSC clocks / usec, not used here */
+unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
-unsigned int tsc_khz;
+
+unsigned int __read_mostly tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
 /*
  * TSC can be unstable due to cpufreq or due to unsynced TSCs
  */
-static int tsc_unstable;
+static int __read_mostly tsc_unstable;
 
 /* native_sched_clock() is called before tsc_init(), so
    we must start with the TSC soft disabled to prevent
    erroneous rdtsc usage on !cpu_has_tsc processors */
-static int tsc_disabled = -1;
+static int __read_mostly tsc_disabled = -1;
 
 static int tsc_clocksource_reliable;
 /*
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e752d97..af1de95 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -147,6 +147,7 @@ extern struct cred init_cred;
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
+	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	= &tsk,						\
diff --git a/include/linux/latencytop.h b/include/linux/latencytop.h
index 901c2d6..b0e9989 100644
--- a/include/linux/latencytop.h
+++ b/include/linux/latencytop.h
@@ -9,6 +9,7 @@
 #ifndef _INCLUDE_GUARD_LATENCYTOP_H_
 #define _INCLUDE_GUARD_LATENCYTOP_H_
 
+#include <linux/compiler.h>
 #ifdef CONFIG_LATENCYTOP
 
 #define LT_SAVECOUNT		32
@@ -24,7 +25,14 @@ struct latency_record {
 
 struct task_struct;
 
-void account_scheduler_latency(struct task_struct *task, int usecs, int inter);
+extern int latencytop_enabled;
+void __account_scheduler_latency(struct task_struct *task, int usecs, int inter);
+static inline void
+account_scheduler_latency(struct task_struct *task, int usecs, int inter)
+{
+	if (unlikely(latencytop_enabled))
+		__account_scheduler_latency(task, usecs, inter);
+}
 
 void clear_all_latency_tracing(struct task_struct *p);
 
diff --git a/include/linux/plist.h b/include/linux/plist.h
index 85de2f0..45926d7 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -96,6 +96,10 @@ struct plist_node {
 # define PLIST_HEAD_LOCK_INIT(_lock)
 #endif
 
+#define _PLIST_HEAD_INIT(head)				\
+	.prio_list = LIST_HEAD_INIT((head).prio_list),	\
+	.node_list = LIST_HEAD_INIT((head).node_list)
+
 /**
  * PLIST_HEAD_INIT - static struct plist_head initializer
  * @head:	struct plist_head variable name
@@ -103,8 +107,7 @@ struct plist_node {
  */
 #define PLIST_HEAD_INIT(head, _lock)			\
 {							\
-	.prio_list = LIST_HEAD_INIT((head).prio_list),	\
-	.node_list = LIST_HEAD_INIT((head).node_list),	\
+        _PLIST_HEAD_INIT(head),                         \
 	PLIST_HEAD_LOCK_INIT(&(_lock))			\
 }
 
@@ -116,7 +119,7 @@ struct plist_node {
 #define PLIST_NODE_INIT(node, __prio)			\
 {							\
 	.prio  = (__prio),				\
-	.plist = PLIST_HEAD_INIT((node).plist, NULL),	\
+	.plist = { _PLIST_HEAD_INIT((node).plist) }, 	\
 }
 
 /**
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 011db2f..d94ebc8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -998,6 +998,7 @@ struct sched_class {
 			      struct rq *busiest, struct sched_domain *sd,
 			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
+	int (*needs_post_schedule) (struct rq *this_rq);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
 
@@ -1052,6 +1053,10 @@ struct sched_entity {
 	u64			last_wakeup;
 	u64			avg_overlap;
 
+	u64			start_runtime;
+	u64			avg_wakeup;
+	u64			nr_migrations;
+
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
@@ -1067,7 +1072,6 @@ struct sched_entity {
 	u64			exec_max;
 	u64			slice_max;
 
-	u64			nr_migrations;
 	u64			nr_migrations_cold;
 	u64			nr_failed_migrations_affine;
 	u64			nr_failed_migrations_running;
@@ -1164,6 +1168,7 @@ struct task_struct {
 #endif
 
 	struct list_head tasks;
+	struct plist_node pushable_tasks;
 
 	struct mm_struct *mm, *active_mm;
 
@@ -1673,6 +1678,16 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 	return set_cpus_allowed_ptr(p, &new_mask);
 }
 
+/*
+ * Architectures can set this to 1 if they have specified
+ * CONFIG_HAVE_UNSTABLE_SCHED_CLOCK in their arch Kconfig,
+ * but then during bootup it turns out that sched_clock()
+ * is reliable after all:
+ */
+#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+extern int sched_clock_stable;
+#endif
+
 extern unsigned long long sched_clock(void);
 
 extern void sched_clock_init(void);
diff --git a/init/Kconfig b/init/Kconfig
index 6a5c5fe..6869913 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -966,7 +966,6 @@ config SLABINFO
 
 config RT_MUTEXES
 	boolean
-	select PLIST
 
 config BASE_SMALL
 	int
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index 449db46..ca07c5c 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -9,6 +9,44 @@
  * as published by the Free Software Foundation; version 2
  * of the License.
  */
+
+/*
+ * CONFIG_LATENCYTOP enables a kernel latency tracking infrastructure that is
+ * used by the "latencytop" userspace tool. The latency that is tracked is not
+ * the 'traditional' interrupt latency (which is primarily caused by something
+ * else consuming CPU), but instead, it is the latency an application encounters
+ * because the kernel sleeps on its behalf for various reasons.
+ *
+ * This code tracks 2 levels of statistics:
+ * 1) System level latency
+ * 2) Per process latency
+ *
+ * The latency is stored in fixed sized data structures in an accumulated form;
+ * if the "same" latency cause is hit twice, this will be tracked as one entry
+ * in the data structure. Both the count, total accumulated latency and maximum
+ * latency are tracked in this data structure. When the fixed size structure is
+ * full, no new causes are tracked until the buffer is flushed by writing to
+ * the /proc file; the userspace tool does this on a regular basis.
+ *
+ * A latency cause is identified by a stringified backtrace at the point that
+ * the scheduler gets invoked. The userland tool will use this string to
+ * identify the cause of the latency in human readable form.
+ *
+ * The information is exported via /proc/latency_stats and /proc/<pid>/latency.
+ * These files look like this:
+ *
+ * Latency Top version : v0.1
+ * 70 59433 4897 i915_irq_wait drm_ioctl vfs_ioctl do_vfs_ioctl sys_ioctl
+ * |    |    |    |
+ * |    |    |    +----> the stringified backtrace
+ * |    |    +---------> The maximum latency for this entry in microseconds
+ * |    +--------------> The accumulated latency for this entry (microseconds)
+ * +-------------------> The number of times this entry is hit
+ *
+ * (note: the average latency is the accumulated latency divided by the number
+ * of times)
+ */
+
 #include <linux/latencytop.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
@@ -72,7 +110,7 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
 				firstnonnull = i;
 			continue;
 		}
-		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
+		for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
 			unsigned long record = lat->backtrace[q];
 
 			if (latency_record[i].backtrace[q] != record) {
@@ -101,31 +139,52 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
 	memcpy(&latency_record[i], lat, sizeof(struct latency_record));
 }
 
-static inline void store_stacktrace(struct task_struct *tsk, struct latency_record *lat)
+/*
+ * Iterator to store a backtrace into a latency record entry
+ */
+static inline void store_stacktrace(struct task_struct *tsk,
+					struct latency_record *lat)
 {
 	struct stack_trace trace;
 
 	memset(&trace, 0, sizeof(trace));
 	trace.max_entries = LT_BACKTRACEDEPTH;
 	trace.entries = &lat->backtrace[0];
-	trace.skip = 0;
 	save_stack_trace_tsk(tsk, &trace);
 }
 
+/**
+ * __account_scheduler_latency - record an occured latency
+ * @tsk - the task struct of the task hitting the latency
+ * @usecs - the duration of the latency in microseconds
+ * @inter - 1 if the sleep was interruptible, 0 if uninterruptible
+ *
+ * This function is the main entry point for recording latency entries
+ * as called by the scheduler.
+ *
+ * This function has a few special cases to deal with normal 'non-latency'
+ * sleeps: specifically, interruptible sleep longer than 5 msec is skipped
+ * since this usually is caused by waiting for events via select() and co.
+ *
+ * Negative latencies (caused by time going backwards) are also explicitly
+ * skipped.
+ */
 void __sched
-account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
+__account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 {
 	unsigned long flags;
 	int i, q;
 	struct latency_record lat;
 
-	if (!latencytop_enabled)
-		return;
-
 	/* Long interruptible waits are generally user requested... */
 	if (inter && usecs > 5000)
 		return;
 
+	/* Negative sleeps are time going backwards */
+	/* Zero-time sleeps are non-interesting */
+	if (usecs <= 0)
+		return;
+
 	memset(&lat, 0, sizeof(lat));
 	lat.count = 1;
 	lat.time = usecs;
@@ -143,12 +202,12 @@ account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 	if (tsk->latency_record_count >= LT_SAVECOUNT)
 		goto out_unlock;
 
-	for (i = 0; i < LT_SAVECOUNT ; i++) {
+	for (i = 0; i < LT_SAVECOUNT; i++) {
 		struct latency_record *mylat;
 		int same = 1;
 
 		mylat = &tsk->latency_record[i];
-		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
+		for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
 			unsigned long record = lat.backtrace[q];
 
 			if (mylat->backtrace[q] != record) {
@@ -186,7 +245,7 @@ static int lstats_show(struct seq_file *m, void *v)
 	for (i = 0; i < MAXLR; i++) {
 		if (latency_record[i].backtrace[0]) {
 			int q;
-			seq_printf(m, "%i %li %li ",
+			seq_printf(m, "%i %lu %lu ",
 				latency_record[i].count,
 				latency_record[i].time,
 				latency_record[i].max);
@@ -223,7 +282,7 @@ static int lstats_open(struct inode *inode, struct file *filp)
 	return single_open(filp, lstats_show, NULL);
 }
 
-static struct file_operations lstats_fops = {
+static const struct file_operations lstats_fops = {
 	.open		= lstats_open,
 	.read		= seq_read,
 	.write		= lstats_write,
@@ -236,4 +295,4 @@ static int __init init_lstats_procfs(void)
 	proc_create("latency_stats", 0644, NULL, &lstats_fops);
 	return 0;
 }
-__initcall(init_lstats_procfs);
+device_initcall(init_lstats_procfs);
diff --git a/kernel/sched.c b/kernel/sched.c
index 8e2558c..9f8506d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -331,6 +331,13 @@ static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
+#ifdef CONFIG_SMP
+static int root_task_group_empty(void)
+{
+	return list_empty(&root_task_group.children);
+}
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
@@ -391,6 +398,13 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 
 #else
 
+#ifdef CONFIG_SMP
+static int root_task_group_empty(void)
+{
+	return 1;
+}
+#endif
+
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
 static inline struct task_group *task_group(struct task_struct *p)
 {
@@ -467,11 +481,17 @@ struct rt_rq {
 	struct rt_prio_array active;
 	unsigned long rt_nr_running;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	int highest_prio; /* highest queued rt task prio */
+	struct {
+		int curr; /* highest queued rt task prio */
+#ifdef CONFIG_SMP
+		int next; /* next highest */
+#endif
+	} highest_prio;
 #endif
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
 	int overloaded;
+	struct plist_head pushable_tasks;
 #endif
 	int rt_throttled;
 	u64 rt_time;
@@ -549,7 +569,6 @@ struct rq {
 	unsigned long nr_running;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
-	unsigned char idle_at_tick;
 #ifdef CONFIG_NO_HZ
 	unsigned long last_tick_seen;
 	unsigned char in_nohz_recently;
@@ -590,6 +609,7 @@ struct rq {
 	struct root_domain *rd;
 	struct sched_domain *sd;
 
+	unsigned char idle_at_tick;
 	/* For active balancing */
 	int active_balance;
 	int push_cpu;
@@ -618,9 +638,6 @@ struct rq {
 	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
 
 	/* sys_sched_yield() stats */
-	unsigned int yld_exp_empty;
-	unsigned int yld_act_empty;
-	unsigned int yld_both_empty;
 	unsigned int yld_count;
 
 	/* schedule() stats */
@@ -1183,10 +1200,10 @@ static void resched_task(struct task_struct *p)
 
 	assert_spin_locked(&task_rq(p)->lock);
 
-	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
+	if (test_tsk_need_resched(p))
 		return;
 
-	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
+	set_tsk_need_resched(p);
 
 	cpu = task_cpu(p);
 	if (cpu == smp_processor_id())
@@ -1242,7 +1259,7 @@ void wake_up_idle_cpu(int cpu)
 	 * lockless. The worst case is that the other CPU runs the
 	 * idle task through an additional NOOP schedule()
 	 */
-	set_tsk_thread_flag(rq->idle, TIF_NEED_RESCHED);
+	set_tsk_need_resched(rq->idle);
 
 	/* NEED_RESCHED must be visible before we test polling */
 	smp_mb();
@@ -1610,21 +1627,42 @@ static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 
 #endif
 
+#ifdef CONFIG_PREEMPT
+
 /*
- * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
+ * fair double_lock_balance: Safely acquires both rq->locks in a fair
+ * way at the expense of forcing extra atomic operations in all
+ * invocations.  This assures that the double_lock is acquired using the
+ * same underlying policy as the spinlock_t on this architecture, which
+ * reduces latency compared to the unfair variant below.  However, it
+ * also adds more overhead and therefore may reduce throughput.
  */
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->lock)
+	__acquires(busiest->lock)
+	__acquires(this_rq->lock)
+{
+	spin_unlock(&this_rq->lock);
+	double_rq_lock(this_rq, busiest);
+
+	return 1;
+}
+
+#else
+/*
+ * Unfair double_lock_balance: Optimizes throughput at the expense of
+ * latency by eliminating extra atomic operations when the locks are
+ * already in proper order on entry.  This favors lower cpu-ids and will
+ * grant the double lock to lower cpus over higher ids under contention,
+ * regardless of entry order into the function.
+ */
+static int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(this_rq->lock)
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
 	int ret = 0;
 
-	if (unlikely(!irqs_disabled())) {
-		/* printk() doesn't work good under rq->lock */
-		spin_unlock(&this_rq->lock);
-		BUG_ON(1);
-	}
 	if (unlikely(!spin_trylock(&busiest->lock))) {
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
@@ -1637,6 +1675,22 @@ static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	return ret;
 }
 
+#endif /* CONFIG_PREEMPT */
+
+/*
+ * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
+ */
+static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+{
+	if (unlikely(!irqs_disabled())) {
+		/* printk() doesn't work good under rq->lock */
+		spin_unlock(&this_rq->lock);
+		BUG_ON(1);
+	}
+
+	return _double_lock_balance(this_rq, busiest);
+}
+
 static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(busiest->lock)
 {
@@ -1705,6 +1759,9 @@ static void update_avg(u64 *avg, u64 sample)
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
+	if (wakeup)
+		p->se.start_runtime = p->se.sum_exec_runtime;
+
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup);
 	p->se.on_rq = 1;
@@ -1712,10 +1769,15 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (sleep && p->se.last_wakeup) {
-		update_avg(&p->se.avg_overlap,
-			   p->se.sum_exec_runtime - p->se.last_wakeup);
-		p->se.last_wakeup = 0;
+	if (sleep) {
+		if (p->se.last_wakeup) {
+			update_avg(&p->se.avg_overlap,
+				p->se.sum_exec_runtime - p->se.last_wakeup);
+			p->se.last_wakeup = 0;
+		} else {
+			update_avg(&p->se.avg_wakeup,
+				sysctl_sched_wakeup_granularity);
+		}
 	}
 
 	sched_info_dequeued(p);
@@ -2017,7 +2079,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * it must be off the runqueue _entirely_, and not
 		 * preempted!
 		 *
-		 * So if it wa still runnable (but just not actively
+		 * So if it was still runnable (but just not actively
 		 * running right now), it's preempted, and we should
 		 * yield - it could be a while.
 		 */
@@ -2267,7 +2329,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 		sync = 0;
 
 #ifdef CONFIG_SMP
-	if (sched_feat(LB_WAKEUP_UPDATE)) {
+	if (sched_feat(LB_WAKEUP_UPDATE) && !root_task_group_empty()) {
 		struct sched_domain *sd;
 
 		this_cpu = raw_smp_processor_id();
@@ -2345,6 +2407,22 @@ out_activate:
 	activate_task(rq, p, 1);
 	success = 1;
 
+	/*
+	 * Only attribute actual wakeups done by this task.
+	 */
+	if (!in_interrupt()) {
+		struct sched_entity *se = &current->se;
+		u64 sample = se->sum_exec_runtime;
+
+		if (se->last_wakeup)
+			sample -= se->last_wakeup;
+		else
+			sample -= se->start_runtime;
+		update_avg(&se->avg_wakeup, sample);
+
+		se->last_wakeup = se->sum_exec_runtime;
+	}
+
 out_running:
 	trace_sched_wakeup(rq, p, success);
 	check_preempt_curr(rq, p, sync);
@@ -2355,8 +2433,6 @@ out_running:
 		p->sched_class->task_wake_up(rq, p);
 #endif
 out:
-	current->se.last_wakeup = current->se.sum_exec_runtime;
-
 	task_rq_unlock(rq, &flags);
 
 	return success;
@@ -2386,6 +2462,8 @@ static void __sched_fork(struct task_struct *p)
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
+	p->se.start_runtime		= 0;
+	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start		= 0;
@@ -2448,6 +2526,8 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
+	plist_node_init(&p->pushable_tasks, MAX_PRIO);
+
 	put_cpu();
 }
 
@@ -2491,7 +2571,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 /**
- * preempt_notifier_register - tell me when current is being being preempted & rescheduled
+ * preempt_notifier_register - tell me when current is being preempted & rescheduled
  * @notifier: notifier struct to register
  */
 void preempt_notifier_register(struct preempt_notifier *notifier)
@@ -2588,6 +2668,12 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 {
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
+#ifdef CONFIG_SMP
+	int post_schedule = 0;
+
+	if (current->sched_class->needs_post_schedule)
+		post_schedule = current->sched_class->needs_post_schedule(rq);
+#endif
 
 	rq->prev_mm = NULL;
 
@@ -2606,7 +2692,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
 #ifdef CONFIG_SMP
-	if (current->sched_class->post_schedule)
+	if (post_schedule)
 		current->sched_class->post_schedule(rq);
 #endif
 
@@ -2913,6 +2999,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		     struct sched_domain *sd, enum cpu_idle_type idle,
 		     int *all_pinned)
 {
+	int tsk_cache_hot = 0;
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) running (obviously), or
@@ -2936,10 +3023,11 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) too many balance attempts have failed.
 	 */
 
-	if (!task_hot(p, rq->clock, sd) ||
-			sd->nr_balance_failed > sd->cache_nice_tries) {
+	tsk_cache_hot = task_hot(p, rq->clock, sd);
+	if (!tsk_cache_hot ||
+		sd->nr_balance_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, rq->clock, sd)) {
+		if (tsk_cache_hot) {
 			schedstat_inc(sd, lb_hot_gained[idle]);
 			schedstat_inc(p, se.nr_forced_migrations);
 		}
@@ -2947,7 +3035,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		return 1;
 	}
 
-	if (task_hot(p, rq->clock, sd)) {
+	if (tsk_cache_hot) {
 		schedstat_inc(p, se.nr_failed_migrations_hot);
 		return 0;
 	}
@@ -2987,6 +3075,16 @@ next:
 	pulled++;
 	rem_load_move -= p->se.load.weight;
 
+#ifdef CONFIG_PREEMPT
+	/*
+	 * NEWIDLE balancing is a source of latency, so preemptible kernels
+	 * will stop after the first task is pulled to minimize the critical
+	 * section.
+	 */
+	if (idle == CPU_NEWLY_IDLE)
+		goto out;
+#endif
+
 	/*
 	 * We only want to steal up to the prescribed amount of weighted load.
 	 */
@@ -3033,9 +3131,15 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 				sd, idle, all_pinned, &this_best_prio);
 		class = class->next;
 
+#ifdef CONFIG_PREEMPT
+		/*
+		 * NEWIDLE balancing is a source of latency, so preemptible
+		 * kernels will stop after the first task is pulled to minimize
+		 * the critical section.
+		 */
 		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
 			break;
-
+#endif
 	} while (class && max_load_move > total_load_moved);
 
 	return total_load_moved > 0;
@@ -3085,246 +3189,479 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	return 0;
 }
+/********** Helpers for find_busiest_group ************************/
+/**
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ * 		during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest; /* Busiest group in this sd */
+	struct sched_group *this;  /* Local group in this sd */
+	unsigned long total_load;  /* Total load of all groups in sd */
+	unsigned long total_pwr;   /*	Total power of all groups in sd */
+	unsigned long avg_load;	   /* Average load across all groups in sd */
+
+	/** Statistics of this group */
+	unsigned long this_load;
+	unsigned long this_load_per_task;
+	unsigned long this_nr_running;
+
+	/* Statistics of the busiest group */
+	unsigned long max_load;
+	unsigned long busiest_load_per_task;
+	unsigned long busiest_nr_running;
+
+	int group_imb; /* Is there imbalance in this sd */
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+	int power_savings_balance; /* Is powersave balance needed for this sd */
+	struct sched_group *group_min; /* Least loaded group in sd */
+	struct sched_group *group_leader; /* Group which relieves group_min */
+	unsigned long min_load_per_task; /* load_per_task in group_min */
+	unsigned long leader_nr_running; /* Nr running of group_leader */
+	unsigned long min_nr_running; /* Nr running of group_min */
+#endif
+};
 
-/*
- * find_busiest_group finds and returns the busiest CPU group within the
- * domain. It calculates and returns the amount of weighted load which
- * should be moved to restore balance via the imbalance parameter.
+/**
+ * sg_lb_stats - stats of a sched_group required for load_balancing
+ */
+struct sg_lb_stats {
+	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	unsigned long group_load; /* Total load over the CPUs of the group */
+	unsigned long sum_nr_running; /* Nr tasks running in the group */
+	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	unsigned long group_capacity;
+	int group_imb; /* Is there an imbalance in the group ? */
+};
+
+/**
+ * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
+ * @group: The group whose first cpu is to be returned.
  */
-static struct sched_group *
-find_busiest_group(struct sched_domain *sd, int this_cpu,
-		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const struct cpumask *cpus, int *balance)
+static inline unsigned int group_first_cpu(struct sched_group *group)
 {
-	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
-	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
-	unsigned long max_pull;
-	unsigned long busiest_load_per_task, busiest_nr_running;
-	unsigned long this_load_per_task, this_nr_running;
-	int load_idx, group_imb = 0;
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	int power_savings_balance = 1;
-	unsigned long leader_nr_running = 0, min_load_per_task = 0;
-	unsigned long min_nr_running = ULONG_MAX;
-	struct sched_group *group_min = NULL, *group_leader = NULL;
-#endif
+	return cpumask_first(sched_group_cpus(group));
+}
 
-	max_load = this_load = total_load = total_pwr = 0;
-	busiest_load_per_task = busiest_nr_running = 0;
-	this_load_per_task = this_nr_running = 0;
+/**
+ * get_sd_load_idx - Obtain the load index for a given sched domain.
+ * @sd: The sched_domain whose load_idx is to be obtained.
+ * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
+ */
+static inline int get_sd_load_idx(struct sched_domain *sd,
+					enum cpu_idle_type idle)
+{
+	int load_idx;
 
-	if (idle == CPU_NOT_IDLE)
+	switch (idle) {
+	case CPU_NOT_IDLE:
 		load_idx = sd->busy_idx;
-	else if (idle == CPU_NEWLY_IDLE)
+		break;
+
+	case CPU_NEWLY_IDLE:
 		load_idx = sd->newidle_idx;
-	else
+		break;
+	default:
 		load_idx = sd->idle_idx;
+		break;
+	}
 
-	do {
-		unsigned long load, group_capacity, max_cpu_load, min_cpu_load;
-		int local_group;
-		int i;
-		int __group_imb = 0;
-		unsigned int balance_cpu = -1, first_idle_cpu = 0;
-		unsigned long sum_nr_running, sum_weighted_load;
-		unsigned long sum_avg_load_per_task;
-		unsigned long avg_load_per_task;
+	return load_idx;
+}
 
-		local_group = cpumask_test_cpu(this_cpu,
-					       sched_group_cpus(group));
 
-		if (local_group)
-			balance_cpu = cpumask_first(sched_group_cpus(group));
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+/**
+ * init_sd_power_savings_stats - Initialize power savings statistics for
+ * the given sched_domain, during load balancing.
+ *
+ * @sd: Sched domain whose power-savings statistics are to be initialized.
+ * @sds: Variable containing the statistics for sd.
+ * @idle: Idle status of the CPU at which we're performing load-balancing.
+ */
+static inline void init_sd_power_savings_stats(struct sched_domain *sd,
+	struct sd_lb_stats *sds, enum cpu_idle_type idle)
+{
+	/*
+	 * Busy processors will not participate in power savings
+	 * balance.
+	 */
+	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+		sds->power_savings_balance = 0;
+	else {
+		sds->power_savings_balance = 1;
+		sds->min_nr_running = ULONG_MAX;
+		sds->leader_nr_running = 0;
+	}
+}
 
-		/* Tally up the load of all CPUs in the group */
-		sum_weighted_load = sum_nr_running = avg_load = 0;
-		sum_avg_load_per_task = avg_load_per_task = 0;
+/**
+ * update_sd_power_savings_stats - Update the power saving stats for a
+ * sched_domain while performing load balancing.
+ *
+ * @group: sched_group belonging to the sched_domain under consideration.
+ * @sds: Variable containing the statistics of the sched_domain
+ * @local_group: Does group contain the CPU for which we're performing
+ * 		load balancing ?
+ * @sgs: Variable containing the statistics of the group.
+ */
+static inline void update_sd_power_savings_stats(struct sched_group *group,
+	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
+{
 
-		max_cpu_load = 0;
-		min_cpu_load = ~0UL;
+	if (!sds->power_savings_balance)
+		return;
 
-		for_each_cpu_and(i, sched_group_cpus(group), cpus) {
-			struct rq *rq = cpu_rq(i);
+	/*
+	 * If the local group is idle or completely loaded
+	 * no need to do power savings balance at this domain
+	 */
+	if (local_group && (sds->this_nr_running >= sgs->group_capacity ||
+				!sds->this_nr_running))
+		sds->power_savings_balance = 0;
 
-			if (*sd_idle && rq->nr_running)
-				*sd_idle = 0;
+	/*
+	 * If a group is already running at full capacity or idle,
+	 * don't include that group in power savings calculations
+	 */
+	if (!sds->power_savings_balance ||
+		sgs->sum_nr_running >= sgs->group_capacity ||
+		!sgs->sum_nr_running)
+		return;
 
-			/* Bias balancing toward cpus of our domain */
-			if (local_group) {
-				if (idle_cpu(i) && !first_idle_cpu) {
-					first_idle_cpu = 1;
-					balance_cpu = i;
-				}
+	/*
+	 * Calculate the group which has the least non-idle load.
+	 * This is the group from where we need to pick up the load
+	 * for saving power
+	 */
+	if ((sgs->sum_nr_running < sds->min_nr_running) ||
+	    (sgs->sum_nr_running == sds->min_nr_running &&
+	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
+		sds->group_min = group;
+		sds->min_nr_running = sgs->sum_nr_running;
+		sds->min_load_per_task = sgs->sum_weighted_load /
+						sgs->sum_nr_running;
+	}
 
-				load = target_load(i, load_idx);
-			} else {
-				load = source_load(i, load_idx);
-				if (load > max_cpu_load)
-					max_cpu_load = load;
-				if (min_cpu_load > load)
-					min_cpu_load = load;
-			}
+	/*
+	 * Calculate the group which is almost near its
+	 * capacity but still has some space to pick up some load
+	 * from other group and save more power
+	 */
+	if (sgs->sum_nr_running > sgs->group_capacity - 1)
+		return;
 
-			avg_load += load;
-			sum_nr_running += rq->nr_running;
-			sum_weighted_load += weighted_cpuload(i);
+	if (sgs->sum_nr_running > sds->leader_nr_running ||
+	    (sgs->sum_nr_running == sds->leader_nr_running &&
+	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
+		sds->group_leader = group;
+		sds->leader_nr_running = sgs->sum_nr_running;
+	}
+}
 
-			sum_avg_load_per_task += cpu_avg_load_per_task(i);
-		}
+/**
+ * check_power_save_busiest_group - Check if we have potential to perform
+ *	some power-savings balance. If yes, set the busiest group to be
+ *	the least loaded group in the sched_domain, so that it's CPUs can
+ *	be put to idle.
+ *
+ * @sds: Variable containing the statistics of the sched_domain
+ *	under consideration.
+ * @this_cpu: Cpu at which we're currently performing load-balancing.
+ * @imbalance: Variable to store the imbalance.
+ *
+ * Returns 1 if there is potential to perform power-savings balance.
+ * Else returns 0.
+ */
+static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
+					int this_cpu, unsigned long *imbalance)
+{
+	if (!sds->power_savings_balance)
+		return 0;
 
-		/*
-		 * First idle cpu or the first cpu(busiest) in this sched group
-		 * is eligible for doing load balancing at this and above
-		 * domains. In the newly idle case, we will allow all the cpu's
-		 * to do the newly idle load balance.
-		 */
-		if (idle != CPU_NEWLY_IDLE && local_group &&
-		    balance_cpu != this_cpu && balance) {
-			*balance = 0;
-			goto ret;
-		}
+	if (sds->this != sds->group_leader ||
+			sds->group_leader == sds->group_min)
+		return 0;
 
-		total_load += avg_load;
-		total_pwr += group->__cpu_power;
+	*imbalance = sds->min_load_per_task;
+	sds->busiest = sds->group_min;
 
-		/* Adjust by relative CPU power of the group */
-		avg_load = sg_div_cpu_power(group,
-				avg_load * SCHED_LOAD_SCALE);
+	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
+		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+			group_first_cpu(sds->group_leader);
+	}
 
+	return 1;
 
-		/*
-		 * Consider the group unbalanced when the imbalance is larger
-		 * than the average weight of two tasks.
-		 *
-		 * APZ: with cgroup the avg task weight can vary wildly and
-		 *      might not be a suitable number - should we keep a
-		 *      normalized nr_running number somewhere that negates
-		 *      the hierarchy?
-		 */
-		avg_load_per_task = sg_div_cpu_power(group,
-				sum_avg_load_per_task * SCHED_LOAD_SCALE);
+}
+#else /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+static inline void init_sd_power_savings_stats(struct sched_domain *sd,
+	struct sd_lb_stats *sds, enum cpu_idle_type idle)
+{
+	return;
+}
 
-		if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
-			__group_imb = 1;
+static inline void update_sd_power_savings_stats(struct sched_group *group,
+	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
+{
+	return;
+}
+
+static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
+					int this_cpu, unsigned long *imbalance)
+{
+	return 0;
+}
+#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
-		group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
 
+/**
+ * update_sg_lb_stats - Update sched_group's statistics for load balancing.
+ * @group: sched_group whose statistics are to be updated.
+ * @this_cpu: Cpu for which load balance is currently performed.
+ * @idle: Idle status of this_cpu
+ * @load_idx: Load index of sched_domain of this_cpu for load calc.
+ * @sd_idle: Idle status of the sched_domain containing group.
+ * @local_group: Does group contain this_cpu.
+ * @cpus: Set of cpus considered for load balancing.
+ * @balance: Should we balance.
+ * @sgs: variable to hold the statistics for this group.
+ */
+static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
+			enum cpu_idle_type idle, int load_idx, int *sd_idle,
+			int local_group, const struct cpumask *cpus,
+			int *balance, struct sg_lb_stats *sgs)
+{
+	unsigned long load, max_cpu_load, min_cpu_load;
+	int i;
+	unsigned int balance_cpu = -1, first_idle_cpu = 0;
+	unsigned long sum_avg_load_per_task;
+	unsigned long avg_load_per_task;
+
+	if (local_group)
+		balance_cpu = group_first_cpu(group);
+
+	/* Tally up the load of all CPUs in the group */
+	sum_avg_load_per_task = avg_load_per_task = 0;
+	max_cpu_load = 0;
+	min_cpu_load = ~0UL;
+
+	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
+		struct rq *rq = cpu_rq(i);
+
+		if (*sd_idle && rq->nr_running)
+			*sd_idle = 0;
+
+		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			this_load = avg_load;
-			this = group;
-			this_nr_running = sum_nr_running;
-			this_load_per_task = sum_weighted_load;
-		} else if (avg_load > max_load &&
-			   (sum_nr_running > group_capacity || __group_imb)) {
-			max_load = avg_load;
-			busiest = group;
-			busiest_nr_running = sum_nr_running;
-			busiest_load_per_task = sum_weighted_load;
-			group_imb = __group_imb;
+			if (idle_cpu(i) && !first_idle_cpu) {
+				first_idle_cpu = 1;
+				balance_cpu = i;
+			}
+
+			load = target_load(i, load_idx);
+		} else {
+			load = source_load(i, load_idx);
+			if (load > max_cpu_load)
+				max_cpu_load = load;
+			if (min_cpu_load > load)
+				min_cpu_load = load;
 		}
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-		/*
-		 * Busy processors will not participate in power savings
-		 * balance.
-		 */
-		if (idle == CPU_NOT_IDLE ||
-				!(sd->flags & SD_POWERSAVINGS_BALANCE))
-			goto group_next;
+		sgs->group_load += load;
+		sgs->sum_nr_running += rq->nr_running;
+		sgs->sum_weighted_load += weighted_cpuload(i);
 
-		/*
-		 * If the local group is idle or completely loaded
-		 * no need to do power savings balance at this domain
-		 */
-		if (local_group && (this_nr_running >= group_capacity ||
-				    !this_nr_running))
-			power_savings_balance = 0;
+		sum_avg_load_per_task += cpu_avg_load_per_task(i);
+	}
 
-		/*
-		 * If a group is already running at full capacity or idle,
-		 * don't include that group in power savings calculations
-		 */
-		if (!power_savings_balance || sum_nr_running >= group_capacity
-		    || !sum_nr_running)
-			goto group_next;
+	/*
+	 * First idle cpu or the first cpu(busiest) in this sched group
+	 * is eligible for doing load balancing at this and above
+	 * domains. In the newly idle case, we will allow all the cpu's
+	 * to do the newly idle load balance.
+	 */
+	if (idle != CPU_NEWLY_IDLE && local_group &&
+	    balance_cpu != this_cpu && balance) {
+		*balance = 0;
+		return;
+	}
 
-		/*
-		 * Calculate the group which has the least non-idle load.
-		 * This is the group from where we need to pick up the load
-		 * for saving power
-		 */
-		if ((sum_nr_running < min_nr_running) ||
-		    (sum_nr_running == min_nr_running &&
-		     cpumask_first(sched_group_cpus(group)) >
-		     cpumask_first(sched_group_cpus(group_min)))) {
-			group_min = group;
-			min_nr_running = sum_nr_running;
-			min_load_per_task = sum_weighted_load /
-						sum_nr_running;
-		}
+	/* Adjust by relative CPU power of the group */
+	sgs->avg_load = sg_div_cpu_power(group,
+			sgs->group_load * SCHED_LOAD_SCALE);
 
-		/*
-		 * Calculate the group which is almost near its
-		 * capacity but still has some space to pick up some load
-		 * from other group and save more power
-		 */
-		if (sum_nr_running <= group_capacity - 1) {
-			if (sum_nr_running > leader_nr_running ||
-			    (sum_nr_running == leader_nr_running &&
-			     cpumask_first(sched_group_cpus(group)) <
-			     cpumask_first(sched_group_cpus(group_leader)))) {
-				group_leader = group;
-				leader_nr_running = sum_nr_running;
-			}
+
+	/*
+	 * Consider the group unbalanced when the imbalance is larger
+	 * than the average weight of two tasks.
+	 *
+	 * APZ: with cgroup the avg task weight can vary wildly and
+	 *      might not be a suitable number - should we keep a
+	 *      normalized nr_running number somewhere that negates
+	 *      the hierarchy?
+	 */
+	avg_load_per_task = sg_div_cpu_power(group,
+			sum_avg_load_per_task * SCHED_LOAD_SCALE);
+
+	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
+		sgs->group_imb = 1;
+
+	sgs->group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
+
+}
+
+/**
+ * update_sd_lb_stats - Update sched_group's statistics for load balancing.
+ * @sd: sched_domain whose statistics are to be updated.
+ * @this_cpu: Cpu for which load balance is currently performed.
+ * @idle: Idle status of this_cpu
+ * @sd_idle: Idle status of the sched_domain containing group.
+ * @cpus: Set of cpus considered for load balancing.
+ * @balance: Should we balance.
+ * @sds: variable to hold the statistics for this sched_domain.
+ */
+static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
+			enum cpu_idle_type idle, int *sd_idle,
+			const struct cpumask *cpus, int *balance,
+			struct sd_lb_stats *sds)
+{
+	struct sched_group *group = sd->groups;
+	struct sg_lb_stats sgs;
+	int load_idx;
+
+	init_sd_power_savings_stats(sd, sds, idle);
+	load_idx = get_sd_load_idx(sd, idle);
+
+	do {
+		int local_group;
+
+		local_group = cpumask_test_cpu(this_cpu,
+					       sched_group_cpus(group));
+		memset(&sgs, 0, sizeof(sgs));
+		update_sg_lb_stats(group, this_cpu, idle, load_idx, sd_idle,
+				local_group, cpus, balance, &sgs);
+
+		if (local_group && balance && !(*balance))
+			return;
+
+		sds->total_load += sgs.group_load;
+		sds->total_pwr += group->__cpu_power;
+
+		if (local_group) {
+			sds->this_load = sgs.avg_load;
+			sds->this = group;
+			sds->this_nr_running = sgs.sum_nr_running;
+			sds->this_load_per_task = sgs.sum_weighted_load;
+		} else if (sgs.avg_load > sds->max_load &&
+			   (sgs.sum_nr_running > sgs.group_capacity ||
+				sgs.group_imb)) {
+			sds->max_load = sgs.avg_load;
+			sds->busiest = group;
+			sds->busiest_nr_running = sgs.sum_nr_running;
+			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->group_imb = sgs.group_imb;
 		}
-group_next:
-#endif
+
+		update_sd_power_savings_stats(group, sds, local_group, &sgs);
 		group = group->next;
 	} while (group != sd->groups);
 
-	if (!busiest || this_load >= max_load || busiest_nr_running == 0)
-		goto out_balanced;
-
-	avg_load = (SCHED_LOAD_SCALE * total_load) / total_pwr;
+}
 
-	if (this_load >= avg_load ||
-			100*max_load <= sd->imbalance_pct*this_load)
-		goto out_balanced;
+/**
+ * fix_small_imbalance - Calculate the minor imbalance that exists
+ *			amongst the groups of a sched_domain, during
+ *			load balancing.
+ * @sds: Statistics of the sched_domain whose imbalance is to be calculated.
+ * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
+ * @imbalance: Variable to store the imbalance.
+ */
+static inline void fix_small_imbalance(struct sd_lb_stats *sds,
+				int this_cpu, unsigned long *imbalance)
+{
+	unsigned long tmp, pwr_now = 0, pwr_move = 0;
+	unsigned int imbn = 2;
+
+	if (sds->this_nr_running) {
+		sds->this_load_per_task /= sds->this_nr_running;
+		if (sds->busiest_load_per_task >
+				sds->this_load_per_task)
+			imbn = 1;
+	} else
+		sds->this_load_per_task =
+			cpu_avg_load_per_task(this_cpu);
 
-	busiest_load_per_task /= busiest_nr_running;
-	if (group_imb)
-		busiest_load_per_task = min(busiest_load_per_task, avg_load);
+	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
+			sds->busiest_load_per_task * imbn) {
+		*imbalance = sds->busiest_load_per_task;
+		return;
+	}
 
 	/*
-	 * We're trying to get all the cpus to the average_load, so we don't
-	 * want to push ourselves above the average load, nor do we wish to
-	 * reduce the max loaded cpu below the average load, as either of these
-	 * actions would just result in more rebalancing later, and ping-pong
-	 * tasks around. Thus we look for the minimum possible imbalance.
-	 * Negative imbalances (*we* are more loaded than anyone else) will
-	 * be counted as no imbalance for these purposes -- we can't fix that
-	 * by pulling tasks to us. Be careful of negative numbers as they'll
-	 * appear as very large values with unsigned longs.
+	 * OK, we don't have enough imbalance to justify moving tasks,
+	 * however we may be able to increase total CPU power used by
+	 * moving them.
 	 */
-	if (max_load <= busiest_load_per_task)
-		goto out_balanced;
 
+	pwr_now += sds->busiest->__cpu_power *
+			min(sds->busiest_load_per_task, sds->max_load);
+	pwr_now += sds->this->__cpu_power *
+			min(sds->this_load_per_task, sds->this_load);
+	pwr_now /= SCHED_LOAD_SCALE;
+
+	/* Amount of load we'd subtract */
+	tmp = sg_div_cpu_power(sds->busiest,
+			sds->busiest_load_per_task * SCHED_LOAD_SCALE);
+	if (sds->max_load > tmp)
+		pwr_move += sds->busiest->__cpu_power *
+			min(sds->busiest_load_per_task, sds->max_load - tmp);
+
+	/* Amount of load we'd add */
+	if (sds->max_load * sds->busiest->__cpu_power <
+		sds->busiest_load_per_task * SCHED_LOAD_SCALE)
+		tmp = sg_div_cpu_power(sds->this,
+			sds->max_load * sds->busiest->__cpu_power);
+	else
+		tmp = sg_div_cpu_power(sds->this,
+			sds->busiest_load_per_task * SCHED_LOAD_SCALE);
+	pwr_move += sds->this->__cpu_power *
+			min(sds->this_load_per_task, sds->this_load + tmp);
+	pwr_move /= SCHED_LOAD_SCALE;
+
+	/* Move if we gain throughput */
+	if (pwr_move > pwr_now)
+		*imbalance = sds->busiest_load_per_task;
+}
+
+/**
+ * calculate_imbalance - Calculate the amount of imbalance present within the
+ *			 groups of a given sched_domain during load balance.
+ * @sds: statistics of the sched_domain whose imbalance is to be calculated.
+ * @this_cpu: Cpu for which currently load balance is being performed.
+ * @imbalance: The variable to store the imbalance.
+ */
+static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
+		unsigned long *imbalance)
+{
+	unsigned long max_pull;
 	/*
 	 * In the presence of smp nice balancing, certain scenarios can have
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
 	 */
-	if (max_load < avg_load) {
+	if (sds->max_load < sds->avg_load) {
 		*imbalance = 0;
-		goto small_imbalance;
+		return fix_small_imbalance(sds, this_cpu, imbalance);
 	}
 
 	/* Don't want to pull so many tasks that a group would go idle */
-	max_pull = min(max_load - avg_load, max_load - busiest_load_per_task);
+	max_pull = min(sds->max_load - sds->avg_load,
+			sds->max_load - sds->busiest_load_per_task);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * busiest->__cpu_power,
-				(avg_load - this_load) * this->__cpu_power)
+	*imbalance = min(max_pull * sds->busiest->__cpu_power,
+		(sds->avg_load - sds->this_load) * sds->this->__cpu_power)
 			/ SCHED_LOAD_SCALE;
 
 	/*
@@ -3333,78 +3670,110 @@ group_next:
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance < busiest_load_per_task) {
-		unsigned long tmp, pwr_now, pwr_move;
-		unsigned int imbn;
-
-small_imbalance:
-		pwr_move = pwr_now = 0;
-		imbn = 2;
-		if (this_nr_running) {
-			this_load_per_task /= this_nr_running;
-			if (busiest_load_per_task > this_load_per_task)
-				imbn = 1;
-		} else
-			this_load_per_task = cpu_avg_load_per_task(this_cpu);
+	if (*imbalance < sds->busiest_load_per_task)
+		return fix_small_imbalance(sds, this_cpu, imbalance);
 
-		if (max_load - this_load + busiest_load_per_task >=
-					busiest_load_per_task * imbn) {
-			*imbalance = busiest_load_per_task;
-			return busiest;
-		}
+}
+/******* find_busiest_group() helpers end here *********************/
 
-		/*
-		 * OK, we don't have enough imbalance to justify moving tasks,
-		 * however we may be able to increase total CPU power used by
-		 * moving them.
-		 */
+/**
+ * find_busiest_group - Returns the busiest group within the sched_domain
+ * if there is an imbalance. If there isn't an imbalance, and
+ * the user has opted for power-savings, it returns a group whose
+ * CPUs can be put to idle by rebalancing those tasks elsewhere, if
+ * such a group exists.
+ *
+ * Also calculates the amount of weighted load which should be moved
+ * to restore balance.
+ *
+ * @sd: The sched_domain whose busiest group is to be returned.
+ * @this_cpu: The cpu for which load balancing is currently being performed.
+ * @imbalance: Variable which stores amount of weighted load which should
+ *		be moved to restore balance/put a group to idle.
+ * @idle: The idle status of this_cpu.
+ * @sd_idle: The idleness of sd
+ * @cpus: The set of CPUs under consideration for load-balancing.
+ * @balance: Pointer to a variable indicating if this_cpu
+ *	is the appropriate cpu to perform load balancing at this_level.
+ *
+ * Returns:	- the busiest group if imbalance exists.
+ *		- If no imbalance and user has opted for power-savings balance,
+ *		   return the least loaded group whose CPUs can be
+ *		   put to idle by rebalancing its tasks onto our group.
+ */
+static struct sched_group *
+find_busiest_group(struct sched_domain *sd, int this_cpu,
+		   unsigned long *imbalance, enum cpu_idle_type idle,
+		   int *sd_idle, const struct cpumask *cpus, int *balance)
+{
+	struct sd_lb_stats sds;
 
-		pwr_now += busiest->__cpu_power *
-				min(busiest_load_per_task, max_load);
-		pwr_now += this->__cpu_power *
-				min(this_load_per_task, this_load);
-		pwr_now /= SCHED_LOAD_SCALE;
-
-		/* Amount of load we'd subtract */
-		tmp = sg_div_cpu_power(busiest,
-				busiest_load_per_task * SCHED_LOAD_SCALE);
-		if (max_load > tmp)
-			pwr_move += busiest->__cpu_power *
-				min(busiest_load_per_task, max_load - tmp);
-
-		/* Amount of load we'd add */
-		if (max_load * busiest->__cpu_power <
-				busiest_load_per_task * SCHED_LOAD_SCALE)
-			tmp = sg_div_cpu_power(this,
-					max_load * busiest->__cpu_power);
-		else
-			tmp = sg_div_cpu_power(this,
-				busiest_load_per_task * SCHED_LOAD_SCALE);
-		pwr_move += this->__cpu_power *
-				min(this_load_per_task, this_load + tmp);
-		pwr_move /= SCHED_LOAD_SCALE;
+	memset(&sds, 0, sizeof(sds));
 
-		/* Move if we gain throughput */
-		if (pwr_move > pwr_now)
-			*imbalance = busiest_load_per_task;
-	}
+	/*
+	 * Compute the various statistics relavent for load balancing at
+	 * this level.
+	 */
+	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
+					balance, &sds);
+
+	/* Cases where imbalance does not exist from POV of this_cpu */
+	/* 1) this_cpu is not the appropriate cpu to perform load balancing
+	 *    at this level.
+	 * 2) There is no busy sibling group to pull from.
+	 * 3) This group is the busiest group.
+	 * 4) This group is more busy than the avg busieness at this
+	 *    sched_domain.
+	 * 5) The imbalance is within the specified limit.
+	 * 6) Any rebalance would lead to ping-pong
+	 */
+	if (balance && !(*balance))
+		goto ret;
 
-	return busiest;
+	if (!sds.busiest || sds.busiest_nr_running == 0)
+		goto out_balanced;
 
-out_balanced:
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
-		goto ret;
+	if (sds.this_load >= sds.max_load)
+		goto out_balanced;
 
-	if (this == group_leader && group_leader != group_min) {
-		*imbalance = min_load_per_task;
-		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
-			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-				cpumask_first(sched_group_cpus(group_leader));
-		}
-		return group_min;
-	}
-#endif
+	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
+
+	if (sds.this_load >= sds.avg_load)
+		goto out_balanced;
+
+	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
+		goto out_balanced;
+
+	sds.busiest_load_per_task /= sds.busiest_nr_running;
+	if (sds.group_imb)
+		sds.busiest_load_per_task =
+			min(sds.busiest_load_per_task, sds.avg_load);
+
+	/*
+	 * We're trying to get all the cpus to the average_load, so we don't
+	 * want to push ourselves above the average load, nor do we wish to
+	 * reduce the max loaded cpu below the average load, as either of these
+	 * actions would just result in more rebalancing later, and ping-pong
+	 * tasks around. Thus we look for the minimum possible imbalance.
+	 * Negative imbalances (*we* are more loaded than anyone else) will
+	 * be counted as no imbalance for these purposes -- we can't fix that
+	 * by pulling tasks to us. Be careful of negative numbers as they'll
+	 * appear as very large values with unsigned longs.
+	 */
+	if (sds.max_load <= sds.busiest_load_per_task)
+		goto out_balanced;
+
+	/* Looks like there is an imbalance. Compute it */
+	calculate_imbalance(&sds, this_cpu, imbalance);
+	return sds.busiest;
+
+out_balanced:
+	/*
+	 * There is no obvious imbalance. But check if we can do some balancing
+	 * to save power.
+	 */
+	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
+		return sds.busiest;
 ret:
 	*imbalance = 0;
 	return NULL;
@@ -4057,6 +4426,11 @@ static void run_rebalance_domains(struct softirq_action *h)
 #endif
 }
 
+static inline int on_null_domain(int cpu)
+{
+	return !rcu_dereference(cpu_rq(cpu)->sd);
+}
+
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  *
@@ -4114,7 +4488,9 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 	    cpumask_test_cpu(cpu, nohz.cpu_mask))
 		return;
 #endif
-	if (time_after_eq(jiffies, rq->next_balance))
+	/* Don't need to rebalance while attached to NULL domain */
+	if (time_after_eq(jiffies, rq->next_balance) &&
+	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 }
 
@@ -4508,11 +4884,33 @@ static inline void schedule_debug(struct task_struct *prev)
 #endif
 }
 
+static void put_prev_task(struct rq *rq, struct task_struct *prev)
+{
+	if (prev->state == TASK_RUNNING) {
+		u64 runtime = prev->se.sum_exec_runtime;
+
+		runtime -= prev->se.prev_sum_exec_runtime;
+		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
+
+		/*
+		 * In order to avoid avg_overlap growing stale when we are
+		 * indeed overlapping and hence not getting put to sleep, grow
+		 * the avg_overlap on preemption.
+		 *
+		 * We use the average preemption runtime because that
+		 * correlates to the amount of cache footprint a task can
+		 * build up.
+		 */
+		update_avg(&prev->se.avg_overlap, runtime);
+	}
+	prev->sched_class->put_prev_task(rq, prev);
+}
+
 /*
  * Pick up the highest-prio task:
  */
 static inline struct task_struct *
-pick_next_task(struct rq *rq, struct task_struct *prev)
+pick_next_task(struct rq *rq)
 {
 	const struct sched_class *class;
 	struct task_struct *p;
@@ -4586,8 +4984,8 @@ need_resched_nonpreemptible:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	prev->sched_class->put_prev_task(rq, prev);
-	next = pick_next_task(rq, prev);
+	put_prev_task(rq, prev);
+	next = pick_next_task(rq);
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
@@ -4642,7 +5040,7 @@ asmlinkage void __sched preempt_schedule(void)
 		 * between schedule and now.
 		 */
 		barrier();
-	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
+	} while (need_resched());
 }
 EXPORT_SYMBOL(preempt_schedule);
 
@@ -4671,7 +5069,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 		 * between schedule and now.
 		 */
 		barrier();
-	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
+	} while (need_resched());
 }
 
 #endif /* CONFIG_PREEMPT */
@@ -5145,7 +5543,7 @@ SYSCALL_DEFINE1(nice, int, increment)
 	if (increment > 40)
 		increment = 40;
 
-	nice = PRIO_TO_NICE(current->static_prio) + increment;
+	nice = TASK_NICE(current) + increment;
 	if (nice < -20)
 		nice = -20;
 	if (nice > 19)
@@ -6423,7 +6821,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 		if (!rq->nr_running)
 			break;
 		update_rq_clock(rq);
-		next = pick_next_task(rq, rq->curr);
+		next = pick_next_task(rq);
 		if (!next)
 			break;
 		next->sched_class->put_prev_task(rq, next);
@@ -8218,11 +8616,15 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	__set_bit(MAX_RT_PRIO, array->bitmap);
 
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	rt_rq->highest_prio = MAX_RT_PRIO;
+	rt_rq->highest_prio.curr = MAX_RT_PRIO;
+#ifdef CONFIG_SMP
+	rt_rq->highest_prio.next = MAX_RT_PRIO;
+#endif
 #endif
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
+	plist_head_init(&rq->rt.pushable_tasks, &rq->lock);
 #endif
 
 	rt_rq->rt_time = 0;
@@ -9598,7 +10000,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	struct cpuacct *ca;
 	int cpu;
 
-	if (!cpuacct_subsys.active)
+	if (unlikely(!cpuacct_subsys.active))
 		return;
 
 	cpu = task_cpu(tsk);
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index a0b0852..390f332 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -24,11 +24,11 @@
  * The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
  * consistent between cpus (never more than 2 jiffies difference).
  */
-#include <linux/sched.h>
-#include <linux/percpu.h>
 #include <linux/spinlock.h>
-#include <linux/ktime.h>
 #include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/ktime.h>
+#include <linux/sched.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -43,6 +43,7 @@ unsigned long long __attribute__((weak)) sched_clock(void)
 static __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+__read_mostly int sched_clock_stable;
 
 struct sched_clock_data {
 	/*
@@ -87,7 +88,7 @@ void sched_clock_init(void)
 }
 
 /*
- * min,max except they take wrapping into account
+ * min, max except they take wrapping into account
  */
 
 static inline u64 wrap_min(u64 x, u64 y)
@@ -111,15 +112,13 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 	s64 delta = now - scd->tick_raw;
 	u64 clock, min_clock, max_clock;
 
-	WARN_ON_ONCE(!irqs_disabled());
-
 	if (unlikely(delta < 0))
 		delta = 0;
 
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
-	 * 		      max(scd->tick_gtod, scd->clock),
-	 * 		      scd->tick_gtod + TICK_NSEC);
+	 *		      max(scd->tick_gtod, scd->clock),
+	 *		      scd->tick_gtod + TICK_NSEC);
 	 */
 
 	clock = scd->tick_gtod + delta;
@@ -148,12 +147,13 @@ static void lock_double_clock(struct sched_clock_data *data1,
 
 u64 sched_clock_cpu(int cpu)
 {
-	struct sched_clock_data *scd = cpu_sdc(cpu);
 	u64 now, clock, this_clock, remote_clock;
+	struct sched_clock_data *scd;
 
-	if (unlikely(!sched_clock_running))
-		return 0ull;
+	if (sched_clock_stable)
+		return sched_clock();
 
+	scd = cpu_sdc(cpu);
 	WARN_ON_ONCE(!irqs_disabled());
 	now = sched_clock();
 
@@ -195,14 +195,18 @@ u64 sched_clock_cpu(int cpu)
 
 void sched_clock_tick(void)
 {
-	struct sched_clock_data *scd = this_scd();
+	struct sched_clock_data *scd;
 	u64 now, now_gtod;
 
+	if (sched_clock_stable)
+		return;
+
 	if (unlikely(!sched_clock_running))
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
 
+	scd = this_scd();
 	now_gtod = ktime_to_ns(ktime_get());
 	now = sched_clock();
 
@@ -250,7 +254,7 @@ u64 sched_clock_cpu(int cpu)
 	return sched_clock();
 }
 
-#endif
+#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 unsigned long long cpu_clock(int cpu)
 {
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 16eeba4..467ca72 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -272,7 +272,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(nr_switches);
 	P(nr_load_updates);
 	P(nr_uninterruptible);
-	SEQ_printf(m, "  .%-30s: %lu\n", "jiffies", jiffies);
 	PN(next_balance);
 	P(curr->pid);
 	PN(clock);
@@ -287,9 +286,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
 
-	P(yld_exp_empty);
-	P(yld_act_empty);
-	P(yld_both_empty);
 	P(yld_count);
 
 	P(sched_switch);
@@ -314,7 +310,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.08, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
@@ -325,6 +321,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	SEQ_printf(m, "  .%-40s: %Ld\n", #x, (long long)(x))
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+	P(jiffies);
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
@@ -397,6 +394,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
+	PN(se.avg_wakeup);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0566f2a..3816f21 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1314,16 +1314,63 @@ out:
 }
 #endif /* CONFIG_SMP */
 
-static unsigned long wakeup_gran(struct sched_entity *se)
+/*
+ * Adaptive granularity
+ *
+ * se->avg_wakeup gives the average time a task runs until it does a wakeup,
+ * with the limit of wakeup_gran -- when it never does a wakeup.
+ *
+ * So the smaller avg_wakeup is the faster we want this task to preempt,
+ * but we don't want to treat the preemptee unfairly and therefore allow it
+ * to run for at least the amount of time we'd like to run.
+ *
+ * NOTE: we use 2*avg_wakeup to increase the probability of actually doing one
+ *
+ * NOTE: we use *nr_running to scale with load, this nicely matches the
+ *       degrading latency on load.
+ */
+static unsigned long
+adaptive_gran(struct sched_entity *curr, struct sched_entity *se)
+{
+	u64 this_run = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
+	u64 expected_wakeup = 2*se->avg_wakeup * cfs_rq_of(se)->nr_running;
+	u64 gran = 0;
+
+	if (this_run < expected_wakeup)
+		gran = expected_wakeup - this_run;
+
+	return min_t(s64, gran, sysctl_sched_wakeup_granularity);
+}
+
+static unsigned long
+wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 {
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
+	if (cfs_rq_of(curr)->curr && sched_feat(ADAPTIVE_GRAN))
+		gran = adaptive_gran(curr, se);
+
 	/*
-	 * More easily preempt - nice tasks, while not making it harder for
-	 * + nice tasks.
+	 * Since its curr running now, convert the gran from real-time
+	 * to virtual-time in his units.
 	 */
-	if (!sched_feat(ASYM_GRAN) || se->load.weight > NICE_0_LOAD)
-		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
+	if (sched_feat(ASYM_GRAN)) {
+		/*
+		 * By using 'se' instead of 'curr' we penalize light tasks, so
+		 * they get preempted easier. That is, if 'se' < 'curr' then
+		 * the resulting gran will be larger, therefore penalizing the
+		 * lighter, if otoh 'se' > 'curr' then the resulting gran will
+		 * be smaller, again penalizing the lighter task.
+		 *
+		 * This is especially important for buddies when the leftmost
+		 * task is higher priority than the buddy.
+		 */
+		if (unlikely(se->load.weight != NICE_0_LOAD))
+			gran = calc_delta_fair(gran, se);
+	} else {
+		if (unlikely(curr->load.weight != NICE_0_LOAD))
+			gran = calc_delta_fair(gran, curr);
+	}
 
 	return gran;
 }
@@ -1350,7 +1397,7 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 	if (vdiff <= 0)
 		return -1;
 
-	gran = wakeup_gran(curr);
+	gran = wakeup_gran(curr, se);
 	if (vdiff > gran)
 		return 1;
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index da5d93b..76f6175 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,5 +1,6 @@
 SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
-SCHED_FEAT(NORMALIZED_SLEEPER, 1)
+SCHED_FEAT(NORMALIZED_SLEEPER, 0)
+SCHED_FEAT(ADAPTIVE_GRAN, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bac1061..c79dc78 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -3,6 +3,40 @@
  * policies)
  */
 
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+{
+	return container_of(rt_se, struct task_struct, rt);
+}
+
+#ifdef CONFIG_RT_GROUP_SCHED
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return rt_rq->rq;
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	return rt_se->rt_rq;
+}
+
+#else /* CONFIG_RT_GROUP_SCHED */
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return container_of(rt_rq, struct rq, rt);
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	struct task_struct *p = rt_task_of(rt_se);
+	struct rq *rq = task_rq(p);
+
+	return &rq->rt;
+}
+
+#endif /* CONFIG_RT_GROUP_SCHED */
+
 #ifdef CONFIG_SMP
 
 static inline int rt_overloaded(struct rq *rq)
@@ -37,25 +71,69 @@ static inline void rt_clear_overload(struct rq *rq)
 	cpumask_clear_cpu(rq->cpu, rq->rd->rto_mask);
 }
 
-static void update_rt_migration(struct rq *rq)
+static void update_rt_migration(struct rt_rq *rt_rq)
 {
-	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1)) {
-		if (!rq->rt.overloaded) {
-			rt_set_overload(rq);
-			rq->rt.overloaded = 1;
+	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
+		if (!rt_rq->overloaded) {
+			rt_set_overload(rq_of_rt_rq(rt_rq));
+			rt_rq->overloaded = 1;
 		}
-	} else if (rq->rt.overloaded) {
-		rt_clear_overload(rq);
-		rq->rt.overloaded = 0;
+	} else if (rt_rq->overloaded) {
+		rt_clear_overload(rq_of_rt_rq(rt_rq));
+		rt_rq->overloaded = 0;
 	}
 }
-#endif /* CONFIG_SMP */
 
-static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	if (rt_se->nr_cpus_allowed > 1)
+		rt_rq->rt_nr_migratory++;
+
+	update_rt_migration(rt_rq);
+}
+
+static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	if (rt_se->nr_cpus_allowed > 1)
+		rt_rq->rt_nr_migratory--;
+
+	update_rt_migration(rt_rq);
+}
+
+static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
+{
+	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
+	plist_node_init(&p->pushable_tasks, p->prio);
+	plist_add(&p->pushable_tasks, &rq->rt.pushable_tasks);
+}
+
+static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
+{
+	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
+}
+
+#else
+
+static inline void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 {
-	return container_of(rt_se, struct task_struct, rt);
 }
 
+static inline void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
+{
+}
+
+static inline
+void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+}
+
+static inline
+void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+}
+
+#endif /* CONFIG_SMP */
+
 static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 {
 	return !list_empty(&rt_se->run_list);
@@ -79,16 +157,6 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	return rt_rq->rq;
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	return rt_se->rt_rq;
-}
-
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = rt_se->parent)
 
@@ -108,7 +176,7 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
 			enqueue_rt_entity(rt_se);
-		if (rt_rq->highest_prio < curr->prio)
+		if (rt_rq->highest_prio.curr < curr->prio)
 			resched_task(curr);
 	}
 }
@@ -176,19 +244,6 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	return container_of(rt_rq, struct rq, rt);
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	struct task_struct *p = rt_task_of(rt_se);
-	struct rq *rq = task_rq(p);
-
-	return &rq->rt;
-}
-
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = NULL)
 
@@ -473,7 +528,7 @@ static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 	struct rt_rq *rt_rq = group_rt_rq(rt_se);
 
 	if (rt_rq)
-		return rt_rq->highest_prio;
+		return rt_rq->highest_prio.curr;
 #endif
 
 	return rt_task_of(rt_se)->prio;
@@ -547,91 +602,174 @@ static void update_curr_rt(struct rq *rq)
 	}
 }
 
-static inline
-void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+#if defined CONFIG_SMP
+
+static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
+
+static inline int next_prio(struct rq *rq)
 {
-	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
-	rt_rq->rt_nr_running++;
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
-#ifdef CONFIG_SMP
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-#endif
+	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
+
+	if (next && rt_prio(next->prio))
+		return next->prio;
+	else
+		return MAX_RT_PRIO;
+}
+
+static void
+inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+
+	if (prio < prev_prio) {
+
+		/*
+		 * If the new task is higher in priority than anything on the
+		 * run-queue, we know that the previous high becomes our
+		 * next-highest.
+		 */
+		rt_rq->highest_prio.next = prev_prio;
 
-		rt_rq->highest_prio = rt_se_prio(rt_se);
-#ifdef CONFIG_SMP
 		if (rq->online)
-			cpupri_set(&rq->rd->cpupri, rq->cpu,
-				   rt_se_prio(rt_se));
-#endif
-	}
-#endif
-#ifdef CONFIG_SMP
-	if (rt_se->nr_cpus_allowed > 1) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
+			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 
-		rq->rt.rt_nr_migratory++;
-	}
+	} else if (prio == rt_rq->highest_prio.curr)
+		/*
+		 * If the next task is equal in priority to the highest on
+		 * the run-queue, then we implicitly know that the next highest
+		 * task cannot be any lower than current
+		 */
+		rt_rq->highest_prio.next = prio;
+	else if (prio < rt_rq->highest_prio.next)
+		/*
+		 * Otherwise, we need to recompute next-highest
+		 */
+		rt_rq->highest_prio.next = next_prio(rq);
+}
 
-	update_rt_migration(rq_of_rt_rq(rt_rq));
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-	if (rt_se_boosted(rt_se))
-		rt_rq->rt_nr_boosted++;
+static void
+dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (rt_rq->tg)
-		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
-#else
-	start_rt_bandwidth(&def_rt_bandwidth);
-#endif
+	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
+		rt_rq->highest_prio.next = next_prio(rq);
+
+	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
+		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
 
+#else /* CONFIG_SMP */
+
 static inline
-void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
-{
-#ifdef CONFIG_SMP
-	int highest_prio = rt_rq->highest_prio;
-#endif
+void inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
+static inline
+void dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
+
+#endif /* CONFIG_SMP */
 
-	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
-	WARN_ON(!rt_rq->rt_nr_running);
-	rt_rq->rt_nr_running--;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+static void
+inc_rt_prio(struct rt_rq *rt_rq, int prio)
+{
+	int prev_prio = rt_rq->highest_prio.curr;
+
+	if (prio < prev_prio)
+		rt_rq->highest_prio.curr = prio;
+
+	inc_rt_prio_smp(rt_rq, prio, prev_prio);
+}
+
+static void
+dec_rt_prio(struct rt_rq *rt_rq, int prio)
+{
+	int prev_prio = rt_rq->highest_prio.curr;
+
 	if (rt_rq->rt_nr_running) {
-		struct rt_prio_array *array;
 
-		WARN_ON(rt_se_prio(rt_se) < rt_rq->highest_prio);
-		if (rt_se_prio(rt_se) == rt_rq->highest_prio) {
-			/* recalculate */
-			array = &rt_rq->active;
-			rt_rq->highest_prio =
+		WARN_ON(prio < prev_prio);
+
+		/*
+		 * This may have been our highest task, and therefore
+		 * we may have some recomputation to do
+		 */
+		if (prio == prev_prio) {
+			struct rt_prio_array *array = &rt_rq->active;
+
+			rt_rq->highest_prio.curr =
 				sched_find_first_bit(array->bitmap);
-		} /* otherwise leave rq->highest prio alone */
+		}
+
 	} else
-		rt_rq->highest_prio = MAX_RT_PRIO;
-#endif
-#ifdef CONFIG_SMP
-	if (rt_se->nr_cpus_allowed > 1) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-		rq->rt.rt_nr_migratory--;
-	}
+		rt_rq->highest_prio.curr = MAX_RT_PRIO;
 
-	if (rt_rq->highest_prio != highest_prio) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
+	dec_rt_prio_smp(rt_rq, prio, prev_prio);
+}
 
-		if (rq->online)
-			cpupri_set(&rq->rd->cpupri, rq->cpu,
-				   rt_rq->highest_prio);
-	}
+#else
+
+static inline void inc_rt_prio(struct rt_rq *rt_rq, int prio) {}
+static inline void dec_rt_prio(struct rt_rq *rt_rq, int prio) {}
+
+#endif /* CONFIG_SMP || CONFIG_RT_GROUP_SCHED */
 
-	update_rt_migration(rq_of_rt_rq(rt_rq));
-#endif /* CONFIG_SMP */
 #ifdef CONFIG_RT_GROUP_SCHED
+
+static void
+inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	if (rt_se_boosted(rt_se))
+		rt_rq->rt_nr_boosted++;
+
+	if (rt_rq->tg)
+		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
+}
+
+static void
+dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
 	if (rt_se_boosted(rt_se))
 		rt_rq->rt_nr_boosted--;
 
 	WARN_ON(!rt_rq->rt_nr_running && rt_rq->rt_nr_boosted);
-#endif
+}
+
+#else /* CONFIG_RT_GROUP_SCHED */
+
+static void
+inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	start_rt_bandwidth(&def_rt_bandwidth);
+}
+
+static inline
+void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
+
+#endif /* CONFIG_RT_GROUP_SCHED */
+
+static inline
+void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	int prio = rt_se_prio(rt_se);
+
+	WARN_ON(!rt_prio(prio));
+	rt_rq->rt_nr_running++;
+
+	inc_rt_prio(rt_rq, prio);
+	inc_rt_migration(rt_se, rt_rq);
+	inc_rt_group(rt_se, rt_rq);
+}
+
+static inline
+void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
+	WARN_ON(!rt_rq->rt_nr_running);
+	rt_rq->rt_nr_running--;
+
+	dec_rt_prio(rt_rq, rt_se_prio(rt_se));
+	dec_rt_migration(rt_se, rt_rq);
+	dec_rt_group(rt_se, rt_rq);
 }
 
 static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
@@ -718,6 +856,9 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 
 	enqueue_rt_entity(rt_se);
 
+	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
+		enqueue_pushable_task(rq, p);
+
 	inc_cpu_load(rq, p->se.load.weight);
 }
 
@@ -728,6 +869,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 	update_curr_rt(rq);
 	dequeue_rt_entity(rt_se);
 
+	dequeue_pushable_task(rq, p);
+
 	dec_cpu_load(rq, p->se.load.weight);
 }
 
@@ -878,7 +1021,7 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 	return next;
 }
 
-static struct task_struct *pick_next_task_rt(struct rq *rq)
+static struct task_struct *_pick_next_task_rt(struct rq *rq)
 {
 	struct sched_rt_entity *rt_se;
 	struct task_struct *p;
@@ -900,6 +1043,18 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 
 	p = rt_task_of(rt_se);
 	p->se.exec_start = rq->clock;
+
+	return p;
+}
+
+static struct task_struct *pick_next_task_rt(struct rq *rq)
+{
+	struct task_struct *p = _pick_next_task_rt(rq);
+
+	/* The running task is never eligible for pushing */
+	if (p)
+		dequeue_pushable_task(rq, p);
+
 	return p;
 }
 
@@ -907,6 +1062,13 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
 	p->se.exec_start = 0;
+
+	/*
+	 * The previous task needs to be made eligible for pushing
+	 * if it is still active
+	 */
+	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
+		enqueue_pushable_task(rq, p);
 }
 
 #ifdef CONFIG_SMP
@@ -1072,7 +1234,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 		}
 
 		/* If this rq is still suitable use it. */
-		if (lowest_rq->rt.highest_prio > task->prio)
+		if (lowest_rq->rt.highest_prio.curr > task->prio)
 			break;
 
 		/* try again */
@@ -1083,6 +1245,31 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 	return lowest_rq;
 }
 
+static inline int has_pushable_tasks(struct rq *rq)
+{
+	return !plist_head_empty(&rq->rt.pushable_tasks);
+}
+
+static struct task_struct *pick_next_pushable_task(struct rq *rq)
+{
+	struct task_struct *p;
+
+	if (!has_pushable_tasks(rq))
+		return NULL;
+
+	p = plist_first_entry(&rq->rt.pushable_tasks,
+			      struct task_struct, pushable_tasks);
+
+	BUG_ON(rq->cpu != task_cpu(p));
+	BUG_ON(task_current(rq, p));
+	BUG_ON(p->rt.nr_cpus_allowed <= 1);
+
+	BUG_ON(!p->se.on_rq);
+	BUG_ON(!rt_task(p));
+
+	return p;
+}
+
 /*
  * If the current CPU has more than one RT task, see if the non
  * running task can migrate over to a CPU that is running a task
@@ -1092,13 +1279,11 @@ static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
-	int ret = 0;
-	int paranoid = RT_MAX_TRIES;
 
 	if (!rq->rt.overloaded)
 		return 0;
 
-	next_task = pick_next_highest_task_rt(rq, -1);
+	next_task = pick_next_pushable_task(rq);
 	if (!next_task)
 		return 0;
 
@@ -1127,16 +1312,34 @@ static int push_rt_task(struct rq *rq)
 		struct task_struct *task;
 		/*
 		 * find lock_lowest_rq releases rq->lock
-		 * so it is possible that next_task has changed.
-		 * If it has, then try again.
+		 * so it is possible that next_task has migrated.
+		 *
+		 * We need to make sure that the task is still on the same
+		 * run-queue and is also still the next task eligible for
+		 * pushing.
 		 */
-		task = pick_next_highest_task_rt(rq, -1);
-		if (unlikely(task != next_task) && task && paranoid--) {
-			put_task_struct(next_task);
-			next_task = task;
-			goto retry;
+		task = pick_next_pushable_task(rq);
+		if (task_cpu(next_task) == rq->cpu && task == next_task) {
+			/*
+			 * If we get here, the task hasnt moved at all, but
+			 * it has failed to push.  We will not try again,
+			 * since the other cpus will pull from us when they
+			 * are ready.
+			 */
+			dequeue_pushable_task(rq, next_task);
+			goto out;
 		}
-		goto out;
+
+		if (!task)
+			/* No more tasks, just exit */
+			goto out;
+
+		/*
+		 * Something has shifted, try again.
+		 */
+		put_task_struct(next_task);
+		next_task = task;
+		goto retry;
 	}
 
 	deactivate_task(rq, next_task, 0);
@@ -1147,23 +1350,12 @@ static int push_rt_task(struct rq *rq)
 
 	double_unlock_balance(rq, lowest_rq);
 
-	ret = 1;
 out:
 	put_task_struct(next_task);
 
-	return ret;
+	return 1;
 }
 
-/*
- * TODO: Currently we just use the second highest prio task on
- *       the queue, and stop when it can't migrate (or there's
- *       no more RT tasks).  There may be a case where a lower
- *       priority RT task has a different affinity than the
- *       higher RT task. In this case the lower RT task could
- *       possibly be able to migrate where as the higher priority
- *       RT task could not.  We currently ignore this issue.
- *       Enhancements are welcome!
- */
 static void push_rt_tasks(struct rq *rq)
 {
 	/* push_rt_task will return true if it moved an RT */
@@ -1174,33 +1366,35 @@ static void push_rt_tasks(struct rq *rq)
 static int pull_rt_task(struct rq *this_rq)
 {
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
-	struct task_struct *p, *next;
+	struct task_struct *p;
 	struct rq *src_rq;
 
 	if (likely(!rt_overloaded(this_rq)))
 		return 0;
 
-	next = pick_next_task_rt(this_rq);
-
 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
 
 		src_rq = cpu_rq(cpu);
+
+		/*
+		 * Don't bother taking the src_rq->lock if the next highest
+		 * task is known to be lower-priority than our current task.
+		 * This may look racy, but if this value is about to go
+		 * logically higher, the src_rq will push this task away.
+		 * And if its going logically lower, we do not care
+		 */
+		if (src_rq->rt.highest_prio.next >=
+		    this_rq->rt.highest_prio.curr)
+			continue;
+
 		/*
 		 * We can potentially drop this_rq's lock in
 		 * double_lock_balance, and another CPU could
-		 * steal our next task - hence we must cause
-		 * the caller to recalculate the next task
-		 * in that case:
+		 * alter this_rq
 		 */
-		if (double_lock_balance(this_rq, src_rq)) {
-			struct task_struct *old_next = next;
-
-			next = pick_next_task_rt(this_rq);
-			if (next != old_next)
-				ret = 1;
-		}
+		double_lock_balance(this_rq, src_rq);
 
 		/*
 		 * Are there still pullable RT tasks?
@@ -1214,7 +1408,7 @@ static int pull_rt_task(struct rq *this_rq)
 		 * Do we have an RT task that preempts
 		 * the to-be-scheduled task?
 		 */
-		if (p && (!next || (p->prio < next->prio))) {
+		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p == src_rq->curr);
 			WARN_ON(!p->se.on_rq);
 
@@ -1224,12 +1418,9 @@ static int pull_rt_task(struct rq *this_rq)
 			 * This is just that p is wakeing up and hasn't
 			 * had a chance to schedule. We only pull
 			 * p if it is lower in priority than the
-			 * current task on the run queue or
-			 * this_rq next task is lower in prio than
-			 * the current task on that rq.
+			 * current task on the run queue
 			 */
-			if (p->prio < src_rq->curr->prio ||
-			    (next && next->prio < src_rq->curr->prio))
+			if (p->prio < src_rq->curr->prio)
 				goto skip;
 
 			ret = 1;
@@ -1242,13 +1433,7 @@ static int pull_rt_task(struct rq *this_rq)
 			 * case there's an even higher prio task
 			 * in another runqueue. (low likelyhood
 			 * but possible)
-			 *
-			 * Update next so that we won't pick a task
-			 * on another cpu with a priority lower (or equal)
-			 * than the one we just picked.
 			 */
-			next = p;
-
 		}
  skip:
 		double_unlock_balance(this_rq, src_rq);
@@ -1260,24 +1445,27 @@ static int pull_rt_task(struct rq *this_rq)
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio > prev->prio)
+	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
 }
 
+/*
+ * assumes rq->lock is held
+ */
+static int needs_post_schedule_rt(struct rq *rq)
+{
+	return has_pushable_tasks(rq);
+}
+
 static void post_schedule_rt(struct rq *rq)
 {
 	/*
-	 * If we have more than one rt_task queued, then
-	 * see if we can push the other rt_tasks off to other CPUS.
-	 * Note we may release the rq lock, and since
-	 * the lock was owned by prev, we need to release it
-	 * first via finish_lock_switch and then reaquire it here.
+	 * This is only called if needs_post_schedule_rt() indicates that
+	 * we need to push tasks away
 	 */
-	if (unlikely(rq->rt.overloaded)) {
-		spin_lock_irq(&rq->lock);
-		push_rt_tasks(rq);
-		spin_unlock_irq(&rq->lock);
-	}
+	spin_lock_irq(&rq->lock);
+	push_rt_tasks(rq);
+	spin_unlock_irq(&rq->lock);
 }
 
 /*
@@ -1288,7 +1476,8 @@ static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
 {
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
-	    rq->rt.overloaded)
+	    has_pushable_tasks(rq) &&
+	    p->rt.nr_cpus_allowed > 1)
 		push_rt_tasks(rq);
 }
 
@@ -1324,6 +1513,24 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 	if (p->se.on_rq && (weight != p->rt.nr_cpus_allowed)) {
 		struct rq *rq = task_rq(p);
 
+		if (!task_current(rq, p)) {
+			/*
+			 * Make sure we dequeue this task from the pushable list
+			 * before going further.  It will either remain off of
+			 * the list because we are no longer pushable, or it
+			 * will be requeued.
+			 */
+			if (p->rt.nr_cpus_allowed > 1)
+				dequeue_pushable_task(rq, p);
+
+			/*
+			 * Requeue if our weight is changing and still > 1
+			 */
+			if (weight > 1)
+				enqueue_pushable_task(rq, p);
+
+		}
+
 		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
 			rq->rt.rt_nr_migratory++;
 		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
@@ -1331,7 +1538,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 			rq->rt.rt_nr_migratory--;
 		}
 
-		update_rt_migration(rq);
+		update_rt_migration(&rq->rt);
 	}
 
 	cpumask_copy(&p->cpus_allowed, new_mask);
@@ -1346,7 +1553,7 @@ static void rq_online_rt(struct rq *rq)
 
 	__enable_runtime(rq);
 
-	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
+	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio.curr);
 }
 
 /* Assumes rq->lock is held */
@@ -1438,7 +1645,7 @@ static void prio_changed_rt(struct rq *rq, struct task_struct *p,
 		 * can release the rq lock and p could migrate.
 		 * Only reschedule if p is still on the same runqueue.
 		 */
-		if (p->prio > rq->rt.highest_prio && rq->curr == p)
+		if (p->prio > rq->rt.highest_prio.curr && rq->curr == p)
 			resched_task(p);
 #else
 		/* For UP simply resched on drop of prio */
@@ -1509,6 +1716,9 @@ static void set_curr_task_rt(struct rq *rq)
 	struct task_struct *p = rq->curr;
 
 	p->se.exec_start = rq->clock;
+
+	/* The running task is never eligible for pushing */
+	dequeue_pushable_task(rq, p);
 }
 
 static const struct sched_class rt_sched_class = {
@@ -1531,6 +1741,7 @@ static const struct sched_class rt_sched_class = {
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
+	.needs_post_schedule	= needs_post_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_wake_up		= task_wake_up_rt,
 	.switched_from		= switched_from_rt,
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index a8f93dd..32d2bd4 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -4,7 +4,7 @@
  * bump this up when changing the output format or the meaning of an existing
  * format, so that tools can adapt (or abort)
  */
-#define SCHEDSTAT_VERSION 14
+#define SCHEDSTAT_VERSION 15
 
 static int show_schedstat(struct seq_file *seq, void *v)
 {
@@ -26,9 +26,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
-		    cpu, rq->yld_both_empty,
-		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
+		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    cpu, rq->yld_count,
 		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
diff --git a/lib/Kconfig b/lib/Kconfig
index 03c2c24..fc8ea1c 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -136,12 +136,6 @@ config TEXTSEARCH_BM
 config TEXTSEARCH_FSM
 	tristate
 
-#
-# plist support is select#ed if needed
-#
-config PLIST
-	boolean
-
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
diff --git a/lib/Makefile b/lib/Makefile
index 32b0e64..902d738 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -11,7 +11,8 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o show_mem.o is_single_threaded.o
+	 proportions.o prio_heap.o ratelimit.o show_mem.o \
+	 is_single_threaded.o plist.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -40,7 +41,6 @@ lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
-obj-$(CONFIG_PLIST) += plist.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 01a3c22..39f1029 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -39,7 +39,7 @@ static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kernel_flag);
 int __lockfunc __reacquire_kernel_lock(void)
 {
 	while (!_raw_spin_trylock(&kernel_flag)) {
-		if (test_thread_flag(TIF_NEED_RESCHED))
+		if (need_resched())
 			return -EAGAIN;
 		cpu_relax();
 	}
