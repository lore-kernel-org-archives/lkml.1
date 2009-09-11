Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZIKTZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZIKTZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZIKTZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:25:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44020 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbZIKTZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:25:21 -0400
Date: Fri, 11 Sep 2009 21:25:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: [GIT PULL] sched/core for v2.6.32
Message-ID: <20090911192505.GA20006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

Highlights:

 - Child-runs-first is now off - i.e. we run parent first.
   [ Warning: this might trigger races in user-space. ]

 - Rewritten and cleaned up load-balancer

 - Re-tuned and fixed the scheduler core for more interactivity

 Thanks,

	Ingo

------------------>
Andreas Herrmann (12):
      sched: Use structure to store local data in __build_sched_domains
      sched: Separate out allocation/free/goto-hell from __build_sched_domains
      sched: Separate out build of NUMA sched domain from __build_sched_domains
      sched: Separate out build of CPU sched domain from __build_sched_domains
      sched: Separate out build of MC sched domain from __build_sched_domains
      sched: Separate out build of SMT sched domain from __build_sched_domains
      sched: Separate out build of SMT sched groups from __build_sched_domains
      sched: Separate out build of MC sched groups from __build_sched_domains
      sched: Separate out build of CPU sched groups from __build_sched_domains
      sched: Separate out build of ALLNODES sched groups from __build_sched_domains
      sched: Separate out build of NUMA sched groups from __build_sched_domains
      sched: Consolidate definition of variable sd in __build_sched_domains

Anirban Sinha (1):
      sched: Rename init_cfs_rq => init_tg_cfs_rq

Arjan van de Ven (1):
      sched: Provide iowait counters

Arnd Bergmann (1):
      sched: Add default defines for PREEMPT_ACTIVE

Frederic Weisbecker (8):
      sched: Drop the need_resched() loop from cond_resched()
      sched: Remove obsolete comment in __cond_resched()
      sched: Cover the CONFIG_DEBUG_SPINLOCK_SLEEP off-case for __might_sleep()
      sched: Add a preempt count base offset to __might_sleep()
      sched: Remove the CONFIG_PREEMPT_BKL case definition of cond_resched()
      sched: Pull up the might_sleep() check into cond_resched()
      sched: Convert the only user of cond_resched_bkl to use cond_resched()
      sched: Fix cond_resched_lock() in !CONFIG_PREEMPT

Gautham R Shenoy (1):
      sched: Try to deal with low capacity, fix update_sd_power_savings_stats()

Gregory Haskins (2):
      sched: Enhance the pre/post scheduling logic
      sched: Fully integrate cpus_active_map and root-domain code

Hiroshi Shimamoto (2):
      sched, task_struct: stack_canary is not needed without CC_STACKPROTECTOR
      sched: Use for_each_class macro in move_one_task()

Hitoshi Mitake (1):
      sched: Hide runqueues from direct reference at source code level for __raw_get_cpu_var()

Ingo Molnar (6):
      sched: Fix cpupri build on !CONFIG_SMP
      sched: Fix dynamic power-balancing crash
      sched: Clean up topology.h
      sched: Turn on SD_BALANCE_NEWIDLE
      sched: Disable NEW_FAIR_SLEEPERS for now
      sched: Fix sched::sched_stat_wait tracepoint field

Lennart Poettering (1):
      sched: Introduce SCHED_RESET_ON_FORK scheduling policy flag

Mike Galbraith (6):
      sched: Clean up SCHED_RESET_ON_FORK
      sched: Add SCHED_RESET_ON_FORK functionality for nice < 0 tasks
      sched: Ensure that a child can't gain time over it's parent after fork()
      sched: Turn off child_runs_first
      sched: Re-tune the scheduler latency defaults to decrease worst-case latencies
      sched: Keep kthreads at default priority

Peter Zijlstra (18):
      sched: Fix cgroup smp fairness
      sched: Optimize unused cgroup configuration
      sched: Add debug check to task_of()
      sched: Ensure the migration task doesn't go away during use
      sched: Avoid division by zero
      sched: Fix division by zero - really
      sched: Add wait, sleep and iowait accounting tracepoints
      sched: Restore __cpu_power to a straight sum of power
      sched: Add SD_PREFER_SIBLING
      sched: Update the cpu_power sum during load-balance
      sched: Add smt_gain
      sched: Implement dynamic cpu_power
      sched: Scale down cpu_power due to RT tasks
      sched: Try to deal with low capacity
      sched: Remove reciprocal for cpu_power
      sched: Remove short cut from select_task_rq_fair()
      sched: Deal with low-load in wake_affine()
      sched: enable SD_WAKE_IDLE

Steven Rostedt (2):
      sched: Check for pushing rt tasks after all scheduling
      sched: Add new prio to cpupri before removing old prio

Thomas Gleixner (2):
      sched: Fix return value of migration_init()
      init: Move sched_clock_init after late_time_init


 arch/x86/include/asm/topology.h |   47 +-
 fs/dcache.c                     |    1 +
 fs/locks.c                      |    2 +-
 include/linux/hardirq.h         |    6 +
 include/linux/kernel.h          |    5 +-
 include/linux/sched.h           |   94 ++--
 include/linux/topology.h        |  168 ++++---
 include/trace/events/sched.h    |   95 ++++
 init/main.c                     |    2 +-
 kernel/kthread.c                |    4 -
 kernel/sched.c                  | 1099 +++++++++++++++++++++++++--------------
 kernel/sched_cpupri.c           |   30 +-
 kernel/sched_debug.c            |    4 +
 kernel/sched_fair.c             |   84 +++-
 kernel/sched_features.h         |    2 +-
 kernel/sched_rt.c               |   62 +--
 kernel/sysctl.c                 |   24 +-
 kernel/workqueue.c              |    2 -
 18 files changed, 1117 insertions(+), 614 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 066ef59..26d06e0 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -129,25 +129,34 @@ extern unsigned long node_remap_size[];
 #endif
 
 /* sched_domains SD_NODE_INIT for NUMA machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= SD_CACHE_NICE_TRIES,	\
-	.busy_idx		= 3,			\
-	.idle_idx		= SD_IDLE_IDX,		\
-	.newidle_idx		= SD_NEWIDLE_IDX,	\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= SD_FORKEXEC_IDX,	\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
+#define SD_NODE_INIT (struct sched_domain) {				\
+	.min_interval		= 8,					\
+	.max_interval		= 32,					\
+	.busy_factor		= 32,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= SD_CACHE_NICE_TRIES,			\
+	.busy_idx		= 3,					\
+	.idle_idx		= SD_IDLE_IDX,				\
+	.newidle_idx		= SD_NEWIDLE_IDX,			\
+	.wake_idx		= 1,					\
+	.forkexec_idx		= SD_FORKEXEC_IDX,			\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_BALANCE			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_POWERSAVINGS_BALANCE		\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SERIALIZE			\
+				| 1*SD_WAKE_IDLE_FAR			\
+				| 0*SD_PREFER_SIBLING			\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 1,					\
 }
 
 #ifdef CONFIG_X86_64_ACPI_NUMA
diff --git a/fs/dcache.c b/fs/dcache.c
index 9e5cd3c..a100fa3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -32,6 +32,7 @@
 #include <linux/swap.h>
 #include <linux/bootmem.h>
 #include <linux/fs_struct.h>
+#include <linux/hardirq.h>
 #include "internal.h"
 
 int sysctl_vfs_cache_pressure __read_mostly = 100;
diff --git a/fs/locks.c b/fs/locks.c
index b6440f5..2eb8197 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -768,7 +768,7 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 	 * give it the opportunity to lock the file.
 	 */
 	if (found)
-		cond_resched_bkl();
+		cond_resched();
 
 find_conflict:
 	for_each_lock(inode, before) {
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 8246c69..0d885fd 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -64,6 +64,12 @@
 #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
 #define NMI_OFFSET	(1UL << NMI_SHIFT)
 
+#ifndef PREEMPT_ACTIVE
+#define PREEMPT_ACTIVE_BITS	1
+#define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
+#define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_ACTIVE_SHIFT)
+#endif
+
 #if PREEMPT_ACTIVE < (1 << (NMI_SHIFT + NMI_BITS))
 #error PREEMPT_ACTIVE is too low!
 #endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..2b5b1e0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -125,7 +125,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line);
+  void __might_sleep(char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -137,8 +137,9 @@ extern int _cond_resched(void);
  * supposed to.
  */
 # define might_sleep() \
-	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
+	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
 #else
+  static inline void __might_sleep(char *file, int line, int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
 #endif
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f1ea4a..3a50e82 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -38,6 +38,8 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+/* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
+#define SCHED_RESET_ON_FORK     0x40000000
 
 #ifdef __KERNEL__
 
@@ -796,18 +798,19 @@ enum cpu_idle_type {
 #define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
 
 #ifdef CONFIG_SMP
-#define SD_LOAD_BALANCE		1	/* Do load balancing on this domain. */
-#define SD_BALANCE_NEWIDLE	2	/* Balance when about to become idle */
-#define SD_BALANCE_EXEC		4	/* Balance on exec */
-#define SD_BALANCE_FORK		8	/* Balance on fork, clone */
-#define SD_WAKE_IDLE		16	/* Wake to idle CPU on task wakeup */
-#define SD_WAKE_AFFINE		32	/* Wake task to waking CPU */
-#define SD_WAKE_BALANCE		64	/* Perform balancing at task wakeup */
-#define SD_SHARE_CPUPOWER	128	/* Domain members share cpu power */
-#define SD_POWERSAVINGS_BALANCE	256	/* Balance for power savings */
-#define SD_SHARE_PKG_RESOURCES	512	/* Domain members share cpu pkg resources */
-#define SD_SERIALIZE		1024	/* Only a single load balancing instance */
-#define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
+#define SD_LOAD_BALANCE		0x0001	/* Do load balancing on this domain. */
+#define SD_BALANCE_NEWIDLE	0x0002	/* Balance when about to become idle */
+#define SD_BALANCE_EXEC		0x0004	/* Balance on exec */
+#define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
+#define SD_WAKE_IDLE		0x0010	/* Wake to idle CPU on task wakeup */
+#define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
+#define SD_WAKE_BALANCE		0x0040	/* Perform balancing at task wakeup */
+#define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
+#define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
+#define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
+#define SD_WAKE_IDLE_FAR	0x0800	/* Gain latency sacrificing cache hit */
+#define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
@@ -827,7 +830,7 @@ static inline int sd_balance_for_mc_power(void)
 	if (sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return 0;
+	return SD_PREFER_SIBLING;
 }
 
 static inline int sd_balance_for_package_power(void)
@@ -835,7 +838,7 @@ static inline int sd_balance_for_package_power(void)
 	if (sched_mc_power_savings | sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return 0;
+	return SD_PREFER_SIBLING;
 }
 
 /*
@@ -857,15 +860,9 @@ struct sched_group {
 
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
-	 * single CPU. This is read only (except for setup, hotplug CPU).
-	 * Note : Never change cpu_power without recompute its reciprocal
-	 */
-	unsigned int __cpu_power;
-	/*
-	 * reciprocal value of cpu_power to avoid expensive divides
-	 * (see include/linux/reciprocal_div.h)
+	 * single CPU.
 	 */
-	u32 reciprocal_cpu_power;
+	unsigned int cpu_power;
 
 	/*
 	 * The CPUs this group covers.
@@ -918,6 +915,7 @@ struct sched_domain {
 	unsigned int newidle_idx;
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
+	unsigned int smt_gain;
 	int flags;			/* See SD_* */
 	enum sched_domain_level level;
 
@@ -1045,7 +1043,6 @@ struct sched_class {
 			      struct rq *busiest, struct sched_domain *sd,
 			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
-	int (*needs_post_schedule) (struct rq *this_rq);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
 
@@ -1110,6 +1107,8 @@ struct sched_entity {
 	u64			wait_max;
 	u64			wait_count;
 	u64			wait_sum;
+	u64			iowait_count;
+	u64			iowait_sum;
 
 	u64			sleep_start;
 	u64			sleep_max;
@@ -1230,11 +1229,19 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
+	unsigned in_iowait:1;
+
+
+	/* Revert to default priority/policy when forking */
+	unsigned sched_reset_on_fork:1;
+
 	pid_t pid;
 	pid_t tgid;
 
+#ifdef CONFIG_CC_STACKPROTECTOR
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
+#endif
 
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,
@@ -1813,11 +1820,12 @@ extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_shares_ratelimit;
 extern unsigned int sysctl_sched_shares_thresh;
-#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_child_runs_first;
+#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
@@ -2281,23 +2289,31 @@ static inline int need_resched(void)
  * cond_resched_softirq() will enable bhs before scheduling.
  */
 extern int _cond_resched(void);
-#ifdef CONFIG_PREEMPT_BKL
-static inline int cond_resched(void)
-{
-	return 0;
-}
+
+#define cond_resched() ({			\
+	__might_sleep(__FILE__, __LINE__, 0);	\
+	_cond_resched();			\
+})
+
+extern int __cond_resched_lock(spinlock_t *lock);
+
+#ifdef CONFIG_PREEMPT
+#define PREEMPT_LOCK_OFFSET	PREEMPT_OFFSET
 #else
-static inline int cond_resched(void)
-{
-	return _cond_resched();
-}
+#define PREEMPT_LOCK_OFFSET	0
 #endif
-extern int cond_resched_lock(spinlock_t * lock);
-extern int cond_resched_softirq(void);
-static inline int cond_resched_bkl(void)
-{
-	return _cond_resched();
-}
+
+#define cond_resched_lock(lock) ({				\
+	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
+	__cond_resched_lock(lock);				\
+})
+
+extern int __cond_resched_softirq(void);
+
+#define cond_resched_softirq() ({				\
+	__might_sleep(__FILE__, __LINE__, SOFTIRQ_OFFSET);	\
+	__cond_resched_softirq();				\
+})
 
 /*
  * Does a critical section need to be broken due to another
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7402c1a..85e8cf7 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -85,20 +85,29 @@ int arch_update_cpu_topology(void);
 #define ARCH_HAS_SCHED_WAKE_IDLE
 /* Common values for SMT siblings */
 #ifndef SD_SIBLING_INIT
-#define SD_SIBLING_INIT (struct sched_domain) {		\
-	.min_interval		= 1,			\
-	.max_interval		= 2,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 110,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| SD_SHARE_CPUPOWER,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
+#define SD_SIBLING_INIT (struct sched_domain) {				\
+	.min_interval		= 1,					\
+	.max_interval		= 2,					\
+	.busy_factor		= 64,					\
+	.imbalance_pct		= 110,					\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_BALANCE			\
+				| 1*SD_SHARE_CPUPOWER			\
+				| 0*SD_POWERSAVINGS_BALANCE		\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 0*SD_SERIALIZE			\
+				| 0*SD_WAKE_IDLE_FAR			\
+				| 0*SD_PREFER_SIBLING			\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 1,					\
+	.smt_gain		= 1178,	/* 15% */			\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -106,69 +115,94 @@ int arch_update_cpu_topology(void);
 #ifdef CONFIG_SCHED_MC
 /* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
 #ifndef SD_MC_INIT
-#define SD_MC_INIT (struct sched_domain) {		\
-	.min_interval		= 1,			\
-	.max_interval		= 4,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 1,			\
-	.busy_idx		= 2,			\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= 1,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| SD_SHARE_PKG_RESOURCES\
-				| sd_balance_for_mc_power()\
-				| sd_power_saving_flags(),\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
+#define SD_MC_INIT (struct sched_domain) {				\
+	.min_interval		= 1,					\
+	.max_interval		= 4,					\
+	.busy_factor		= 64,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 2,					\
+	.wake_idx		= 1,					\
+	.forkexec_idx		= 1,					\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 1*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_BALANCE			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 1*SD_SHARE_PKG_RESOURCES		\
+				| 0*SD_SERIALIZE			\
+				| 0*SD_WAKE_IDLE_FAR			\
+				| sd_balance_for_mc_power()		\
+				| sd_power_saving_flags()		\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 1,					\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
 
 /* Common values for CPUs */
 #ifndef SD_CPU_INIT
-#define SD_CPU_INIT (struct sched_domain) {		\
-	.min_interval		= 1,			\
-	.max_interval		= 4,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 1,			\
-	.busy_idx		= 2,			\
-	.idle_idx		= 1,			\
-	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= 1,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| sd_balance_for_package_power()\
-				| sd_power_saving_flags(),\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
+#define SD_CPU_INIT (struct sched_domain) {				\
+	.min_interval		= 1,					\
+	.max_interval		= 4,					\
+	.busy_factor		= 64,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 2,					\
+	.idle_idx		= 1,					\
+	.newidle_idx		= 2,					\
+	.wake_idx		= 1,					\
+	.forkexec_idx		= 1,					\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 1*SD_WAKE_IDLE			\
+				| 0*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_BALANCE			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 0*SD_SERIALIZE			\
+				| 0*SD_WAKE_IDLE_FAR			\
+				| sd_balance_for_package_power()	\
+				| sd_power_saving_flags()		\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 1,					\
 }
 #endif
 
 /* sched_domains SD_ALLNODES_INIT for NUMA machines */
-#define SD_ALLNODES_INIT (struct sched_domain) {	\
-	.min_interval		= 64,			\
-	.max_interval		= 64*num_online_cpus(),	\
-	.busy_factor		= 128,			\
-	.imbalance_pct		= 133,			\
-	.cache_nice_tries	= 1,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 3,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_WAKE_AFFINE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 64,			\
+#define SD_ALLNODES_INIT (struct sched_domain) {			\
+	.min_interval		= 64,					\
+	.max_interval		= 64*num_online_cpus(),			\
+	.busy_factor		= 128,					\
+	.imbalance_pct		= 133,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 3,					\
+	.idle_idx		= 3,					\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 0*SD_BALANCE_EXEC			\
+				| 0*SD_BALANCE_FORK			\
+				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 0*SD_WAKE_BALANCE			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_POWERSAVINGS_BALANCE		\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SERIALIZE			\
+				| 1*SD_WAKE_IDLE_FAR			\
+				| 0*SD_PREFER_SIBLING			\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 64,					\
 }
 
 #ifdef CONFIG_NUMA
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 8949bb7..a4c369e 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -340,6 +340,101 @@ TRACE_EVENT(sched_signal_send,
 		  __entry->sig, __entry->comm, __entry->pid)
 );
 
+/*
+ * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
+ *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
+ */
+
+/*
+ * Tracepoint for accounting wait time (time the task is runnable
+ * but not actually running due to scheduler contention).
+ */
+TRACE_EVENT(sched_stat_wait,
+
+	TP_PROTO(struct task_struct *tsk, u64 delay),
+
+	TP_ARGS(tsk, delay),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	delay			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid	= tsk->pid;
+		__entry->delay	= delay;
+	)
+	TP_perf_assign(
+		__perf_count(delay);
+	),
+
+	TP_printk("task: %s:%d wait: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
+/*
+ * Tracepoint for accounting sleep time (time the task is not runnable,
+ * including iowait, see below).
+ */
+TRACE_EVENT(sched_stat_sleep,
+
+	TP_PROTO(struct task_struct *tsk, u64 delay),
+
+	TP_ARGS(tsk, delay),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	delay			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid	= tsk->pid;
+		__entry->delay	= delay;
+	)
+	TP_perf_assign(
+		__perf_count(delay);
+	),
+
+	TP_printk("task: %s:%d sleep: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
+/*
+ * Tracepoint for accounting iowait time (time the task is not runnable
+ * due to waiting on IO to complete).
+ */
+TRACE_EVENT(sched_stat_iowait,
+
+	TP_PROTO(struct task_struct *tsk, u64 delay),
+
+	TP_ARGS(tsk, delay),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	delay			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid	= tsk->pid;
+		__entry->delay	= delay;
+	)
+	TP_perf_assign(
+		__perf_count(delay);
+	),
+
+	TP_printk("task: %s:%d iowait: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->delay)
+);
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/init/main.c b/init/main.c
index 11f4f14..0ec75ce 100644
--- a/init/main.c
+++ b/init/main.c
@@ -631,7 +631,6 @@ asmlinkage void __init start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	time_init();
-	sched_clock_init();
 	profile_init();
 	if (!irqs_disabled())
 		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
@@ -682,6 +681,7 @@ asmlinkage void __init start_kernel(void)
 	numa_policy_init();
 	if (late_time_init)
 		late_time_init();
+	sched_clock_init();
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
diff --git a/kernel/kthread.c b/kernel/kthread.c
index eb8751a..5fe7099 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -16,8 +16,6 @@
 #include <linux/mutex.h>
 #include <trace/events/sched.h>
 
-#define KTHREAD_NICE_LEVEL (-5)
-
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
@@ -145,7 +143,6 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 		 * The kernel thread should not inherit these properties.
 		 */
 		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
-		set_user_nice(create.result, KTHREAD_NICE_LEVEL);
 		set_cpus_allowed_ptr(create.result, cpu_all_mask);
 	}
 	return create.result;
@@ -221,7 +218,6 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
-	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 	set_mems_allowed(node_possible_map);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..796baf7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -64,7 +64,6 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
-#include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
@@ -120,30 +119,8 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
-#ifdef CONFIG_SMP
-
 static void double_rq_lock(struct rq *rq1, struct rq *rq2);
 
-/*
- * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
- * Since cpu_power is a 'constant', we can use a reciprocal divide.
- */
-static inline u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
-{
-	return reciprocal_divide(load, sg->reciprocal_cpu_power);
-}
-
-/*
- * Each time a sched group cpu_power is changed,
- * we must compute its reciprocal value
- */
-static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
-{
-	sg->__cpu_power += val;
-	sg->reciprocal_cpu_power = reciprocal_value(sg->__cpu_power);
-}
-#endif
-
 static inline int rt_policy(int policy)
 {
 	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
@@ -309,8 +286,8 @@ void set_tg_uid(struct user_struct *user)
 
 /*
  * Root task group.
- * 	Every UID task group (including init_task_group aka UID-0) will
- * 	be a child to this group.
+ *	Every UID task group (including init_task_group aka UID-0) will
+ *	be a child to this group.
  */
 struct task_group root_task_group;
 
@@ -318,7 +295,7 @@ struct task_group root_task_group;
 /* Default task group's sched entity on each cpu */
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
-static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU(struct cfs_rq, init_tg_cfs_rq) ____cacheline_aligned_in_smp;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -616,6 +593,7 @@ struct rq {
 
 	unsigned char idle_at_tick;
 	/* For active balancing */
+	int post_schedule;
 	int active_balance;
 	int push_cpu;
 	/* cpu of this runqueue: */
@@ -626,6 +604,9 @@ struct rq {
 
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
+
+	u64 rt_avg;
+	u64 age_stamp;
 #endif
 
 	/* calc_load related fields */
@@ -693,6 +674,7 @@ static inline int cpu_of(struct rq *rq)
 #define this_rq()		(&__get_cpu_var(runqueues))
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
 inline void update_rq_clock(struct rq *rq)
 {
@@ -861,6 +843,14 @@ unsigned int sysctl_sched_shares_ratelimit = 250000;
 unsigned int sysctl_sched_shares_thresh = 4;
 
 /*
+ * period over which we average the RT time consumption, measured
+ * in ms.
+ *
+ * default: 1s
+ */
+const_debug unsigned int sysctl_sched_time_avg = MSEC_PER_SEC;
+
+/*
  * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
@@ -1278,12 +1268,37 @@ void wake_up_idle_cpu(int cpu)
 }
 #endif /* CONFIG_NO_HZ */
 
+static u64 sched_avg_period(void)
+{
+	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
+}
+
+static void sched_avg_update(struct rq *rq)
+{
+	s64 period = sched_avg_period();
+
+	while ((s64)(rq->clock - rq->age_stamp) > period) {
+		rq->age_stamp += period;
+		rq->rt_avg /= 2;
+	}
+}
+
+static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
+{
+	rq->rt_avg += rt_delta;
+	sched_avg_update(rq);
+}
+
 #else /* !CONFIG_SMP */
 static void resched_task(struct task_struct *p)
 {
 	assert_spin_locked(&task_rq(p)->lock);
 	set_tsk_need_resched(p);
 }
+
+static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -1513,28 +1528,35 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
+struct update_shares_data {
+	unsigned long rq_weight[NR_CPUS];
+};
+
+static DEFINE_PER_CPU(struct update_shares_data, update_shares_data);
+
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
 
 /*
  * Calculate and set the cpu's group shares.
  */
-static void
-update_group_shares_cpu(struct task_group *tg, int cpu,
-			unsigned long sd_shares, unsigned long sd_rq_weight)
+static void update_group_shares_cpu(struct task_group *tg, int cpu,
+				    unsigned long sd_shares,
+				    unsigned long sd_rq_weight,
+				    struct update_shares_data *usd)
 {
-	unsigned long shares;
-	unsigned long rq_weight;
+	unsigned long shares, rq_weight;
+	int boost = 0;
 
-	if (!tg->se[cpu])
-		return;
-
-	rq_weight = tg->cfs_rq[cpu]->rq_weight;
+	rq_weight = usd->rq_weight[cpu];
+	if (!rq_weight) {
+		boost = 1;
+		rq_weight = NICE_0_LOAD;
+	}
 
 	/*
-	 *           \Sum shares * rq_weight
-	 * shares =  -----------------------
-	 *               \Sum rq_weight
-	 *
+	 *             \Sum_j shares_j * rq_weight_i
+	 * shares_i =  -----------------------------
+	 *                  \Sum_j rq_weight_j
 	 */
 	shares = (sd_shares * rq_weight) / sd_rq_weight;
 	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
@@ -1545,8 +1567,8 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		tg->cfs_rq[cpu]->shares = shares;
-
+		tg->cfs_rq[cpu]->rq_weight = boost ? 0 : rq_weight;
+		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
 		__set_se_shares(tg->se[cpu], shares);
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
@@ -1559,22 +1581,30 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long weight, rq_weight = 0;
-	unsigned long shares = 0;
+	unsigned long weight, rq_weight = 0, shares = 0;
+	struct update_shares_data *usd;
 	struct sched_domain *sd = data;
+	unsigned long flags;
 	int i;
 
+	if (!tg->se[0])
+		return 0;
+
+	local_irq_save(flags);
+	usd = &__get_cpu_var(update_shares_data);
+
 	for_each_cpu(i, sched_domain_span(sd)) {
+		weight = tg->cfs_rq[i]->load.weight;
+		usd->rq_weight[i] = weight;
+
 		/*
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
 		 * run here it will not get delayed by group starvation.
 		 */
-		weight = tg->cfs_rq[i]->load.weight;
 		if (!weight)
 			weight = NICE_0_LOAD;
 
-		tg->cfs_rq[i]->rq_weight = weight;
 		rq_weight += weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
@@ -1586,7 +1616,9 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		shares = tg->shares;
 
 	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight);
+		update_group_shares_cpu(tg, i, shares, rq_weight, usd);
+
+	local_irq_restore(flags);
 
 	return 0;
 }
@@ -1616,8 +1648,14 @@ static int tg_load_down(struct task_group *tg, void *data)
 
 static void update_shares(struct sched_domain *sd)
 {
-	u64 now = cpu_clock(raw_smp_processor_id());
-	s64 elapsed = now - sd->last_update;
+	s64 elapsed;
+	u64 now;
+
+	if (root_task_group_empty())
+		return;
+
+	now = cpu_clock(raw_smp_processor_id());
+	elapsed = now - sd->last_update;
 
 	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
 		sd->last_update = now;
@@ -1627,6 +1665,9 @@ static void update_shares(struct sched_domain *sd)
 
 static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 {
+	if (root_task_group_empty())
+		return;
+
 	spin_unlock(&rq->lock);
 	update_shares(sd);
 	spin_lock(&rq->lock);
@@ -1634,6 +1675,9 @@ static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 
 static void update_h_load(long cpu)
 {
+	if (root_task_group_empty())
+		return;
+
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 
@@ -2268,8 +2312,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = sg_div_cpu_power(group,
-				avg_load * SCHED_LOAD_SCALE);
+		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -2637,9 +2680,32 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	set_task_cpu(p, cpu);
 
 	/*
-	 * Make sure we do not leak PI boosting priority to the child:
+	 * Make sure we do not leak PI boosting priority to the child.
 	 */
 	p->prio = current->normal_prio;
+
+	/*
+	 * Revert to default priority/policy on fork if requested.
+	 */
+	if (unlikely(p->sched_reset_on_fork)) {
+		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR)
+			p->policy = SCHED_NORMAL;
+
+		if (p->normal_prio < DEFAULT_PRIO)
+			p->prio = DEFAULT_PRIO;
+
+		if (PRIO_TO_NICE(p->static_prio) < 0) {
+			p->static_prio = NICE_TO_PRIO(0);
+			set_load_weight(p);
+		}
+
+		/*
+		 * We don't need the reset flag anymore after the fork. It has
+		 * fulfilled its duty:
+		 */
+		p->sched_reset_on_fork = 0;
+	}
+
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
@@ -2796,12 +2862,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 {
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
-#ifdef CONFIG_SMP
-	int post_schedule = 0;
-
-	if (current->sched_class->needs_post_schedule)
-		post_schedule = current->sched_class->needs_post_schedule(rq);
-#endif
 
 	rq->prev_mm = NULL;
 
@@ -2820,10 +2880,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	finish_arch_switch(prev);
 	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
-#ifdef CONFIG_SMP
-	if (post_schedule)
-		current->sched_class->post_schedule(rq);
-#endif
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
@@ -2838,6 +2894,42 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	}
 }
 
+#ifdef CONFIG_SMP
+
+/* assumes rq->lock is held */
+static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
+{
+	if (prev->sched_class->pre_schedule)
+		prev->sched_class->pre_schedule(rq, prev);
+}
+
+/* rq->lock is NOT held, but preemption is disabled */
+static inline void post_schedule(struct rq *rq)
+{
+	if (rq->post_schedule) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&rq->lock, flags);
+		if (rq->curr->sched_class->post_schedule)
+			rq->curr->sched_class->post_schedule(rq);
+		spin_unlock_irqrestore(&rq->lock, flags);
+
+		rq->post_schedule = 0;
+	}
+}
+
+#else
+
+static inline void pre_schedule(struct rq *rq, struct task_struct *p)
+{
+}
+
+static inline void post_schedule(struct rq *rq)
+{
+}
+
+#endif
+
 /**
  * schedule_tail - first thing a freshly forked thread must call.
  * @prev: the thread we just switched away from.
@@ -2848,6 +2940,13 @@ asmlinkage void schedule_tail(struct task_struct *prev)
 	struct rq *rq = this_rq();
 
 	finish_task_switch(rq, prev);
+
+	/*
+	 * FIXME: do we need to worry about rq being invalidated by the
+	 * task_switch?
+	 */
+	post_schedule(rq);
+
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	/* In this case, finish_task_switch does not reenable preemption */
 	preempt_enable();
@@ -3379,9 +3478,10 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 {
 	const struct sched_class *class;
 
-	for (class = sched_class_highest; class; class = class->next)
+	for_each_class(class) {
 		if (class->move_one_task(this_rq, this_cpu, busiest, sd, idle))
 			return 1;
+	}
 
 	return 0;
 }
@@ -3544,7 +3644,7 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
 	 * capacity but still has some space to pick up some load
 	 * from other group and save more power
 	 */
-	if (sgs->sum_nr_running > sgs->group_capacity - 1)
+	if (sgs->sum_nr_running + 1 > sgs->group_capacity)
 		return;
 
 	if (sgs->sum_nr_running > sds->leader_nr_running ||
@@ -3611,6 +3711,77 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
+unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long smt_gain = sd->smt_gain;
+
+	smt_gain /= weight;
+
+	return smt_gain;
+}
+
+unsigned long scale_rt_power(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 total, available;
+
+	sched_avg_update(rq);
+
+	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	available = total - rq->rt_avg;
+
+	if (unlikely((s64)total < SCHED_LOAD_SCALE))
+		total = SCHED_LOAD_SCALE;
+
+	total >>= SCHED_LOAD_SHIFT;
+
+	return div_u64(available, total);
+}
+
+static void update_cpu_power(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long power = SCHED_LOAD_SCALE;
+	struct sched_group *sdg = sd->groups;
+
+	/* here we could scale based on cpufreq */
+
+	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
+		power *= arch_scale_smt_power(sd, cpu);
+		power >>= SCHED_LOAD_SHIFT;
+	}
+
+	power *= scale_rt_power(cpu);
+	power >>= SCHED_LOAD_SHIFT;
+
+	if (!power)
+		power = 1;
+
+	sdg->cpu_power = power;
+}
+
+static void update_group_power(struct sched_domain *sd, int cpu)
+{
+	struct sched_domain *child = sd->child;
+	struct sched_group *group, *sdg = sd->groups;
+	unsigned long power;
+
+	if (!child) {
+		update_cpu_power(sd, cpu);
+		return;
+	}
+
+	power = 0;
+
+	group = child->groups;
+	do {
+		power += group->cpu_power;
+		group = group->next;
+	} while (group != child->groups);
+
+	sdg->cpu_power = power;
+}
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
@@ -3624,7 +3795,8 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
-static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
+static inline void update_sg_lb_stats(struct sched_domain *sd,
+			struct sched_group *group, int this_cpu,
 			enum cpu_idle_type idle, int load_idx, int *sd_idle,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
@@ -3635,8 +3807,11 @@ static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
 	unsigned long sum_avg_load_per_task;
 	unsigned long avg_load_per_task;
 
-	if (local_group)
+	if (local_group) {
 		balance_cpu = group_first_cpu(group);
+		if (balance_cpu == this_cpu)
+			update_group_power(sd, this_cpu);
+	}
 
 	/* Tally up the load of all CPUs in the group */
 	sum_avg_load_per_task = avg_load_per_task = 0;
@@ -3685,8 +3860,7 @@ static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = sg_div_cpu_power(group,
-			sgs->group_load * SCHED_LOAD_SCALE);
+	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 
 	/*
@@ -3698,14 +3872,14 @@ static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
 	 *      normalized nr_running number somewhere that negates
 	 *      the hierarchy?
 	 */
-	avg_load_per_task = sg_div_cpu_power(group,
-			sum_avg_load_per_task * SCHED_LOAD_SCALE);
+	avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
+		group->cpu_power;
 
 	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
-
+	sgs->group_capacity =
+		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 }
 
 /**
@@ -3723,9 +3897,13 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			const struct cpumask *cpus, int *balance,
 			struct sd_lb_stats *sds)
 {
+	struct sched_domain *child = sd->child;
 	struct sched_group *group = sd->groups;
 	struct sg_lb_stats sgs;
-	int load_idx;
+	int load_idx, prefer_sibling = 0;
+
+	if (child && child->flags & SD_PREFER_SIBLING)
+		prefer_sibling = 1;
 
 	init_sd_power_savings_stats(sd, sds, idle);
 	load_idx = get_sd_load_idx(sd, idle);
@@ -3736,14 +3914,22 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		local_group = cpumask_test_cpu(this_cpu,
 					       sched_group_cpus(group));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(group, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && balance && !(*balance))
 			return;
 
 		sds->total_load += sgs.group_load;
-		sds->total_pwr += group->__cpu_power;
+		sds->total_pwr += group->cpu_power;
+
+		/*
+		 * In case the child domain prefers tasks go to siblings
+		 * first, lower the group capacity to one so that we'll try
+		 * and move all the excess tasks away.
+		 */
+		if (prefer_sibling)
+			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
@@ -3763,7 +3949,6 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		update_sd_power_savings_stats(group, sds, local_group, &sgs);
 		group = group->next;
 	} while (group != sd->groups);
-
 }
 
 /**
@@ -3801,28 +3986,28 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 	 * moving them.
 	 */
 
-	pwr_now += sds->busiest->__cpu_power *
+	pwr_now += sds->busiest->cpu_power *
 			min(sds->busiest_load_per_task, sds->max_load);
-	pwr_now += sds->this->__cpu_power *
+	pwr_now += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load);
 	pwr_now /= SCHED_LOAD_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = sg_div_cpu_power(sds->busiest,
-			sds->busiest_load_per_task * SCHED_LOAD_SCALE);
+	tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+		sds->busiest->cpu_power;
 	if (sds->max_load > tmp)
-		pwr_move += sds->busiest->__cpu_power *
+		pwr_move += sds->busiest->cpu_power *
 			min(sds->busiest_load_per_task, sds->max_load - tmp);
 
 	/* Amount of load we'd add */
-	if (sds->max_load * sds->busiest->__cpu_power <
+	if (sds->max_load * sds->busiest->cpu_power <
 		sds->busiest_load_per_task * SCHED_LOAD_SCALE)
-		tmp = sg_div_cpu_power(sds->this,
-			sds->max_load * sds->busiest->__cpu_power);
+		tmp = (sds->max_load * sds->busiest->cpu_power) /
+			sds->this->cpu_power;
 	else
-		tmp = sg_div_cpu_power(sds->this,
-			sds->busiest_load_per_task * SCHED_LOAD_SCALE);
-	pwr_move += sds->this->__cpu_power *
+		tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+			sds->this->cpu_power;
+	pwr_move += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
 	pwr_move /= SCHED_LOAD_SCALE;
 
@@ -3857,8 +4042,8 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 			sds->max_load - sds->busiest_load_per_task);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->__cpu_power,
-		(sds->avg_load - sds->this_load) * sds->this->__cpu_power)
+	*imbalance = min(max_pull * sds->busiest->cpu_power,
+		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
 			/ SCHED_LOAD_SCALE;
 
 	/*
@@ -3976,6 +4161,26 @@ ret:
 	return NULL;
 }
 
+static struct sched_group *group_of(int cpu)
+{
+	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
+
+	if (!sd)
+		return NULL;
+
+	return sd->groups;
+}
+
+static unsigned long power_of(int cpu)
+{
+	struct sched_group *group = group_of(cpu);
+
+	if (!group)
+		return SCHED_LOAD_SCALE;
+
+	return group->cpu_power;
+}
+
 /*
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
@@ -3988,15 +4193,18 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
+		unsigned long power = power_of(i);
+		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
 		unsigned long wl;
 
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
 		rq = cpu_rq(i);
-		wl = weighted_cpuload(i);
+		wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
+		wl /= power;
 
-		if (rq->nr_running == 1 && wl > imbalance)
+		if (capacity && rq->nr_running == 1 && wl > imbalance)
 			continue;
 
 		if (wl > max_load) {
@@ -5349,10 +5557,7 @@ need_resched_nonpreemptible:
 		switch_count = &prev->nvcsw;
 	}
 
-#ifdef CONFIG_SMP
-	if (prev->sched_class->pre_schedule)
-		prev->sched_class->pre_schedule(rq, prev);
-#endif
+	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
@@ -5378,6 +5583,8 @@ need_resched_nonpreemptible:
 	} else
 		spin_unlock_irq(&rq->lock);
 
+	post_schedule(rq);
+
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
 
@@ -6123,17 +6330,25 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
 	unsigned long flags;
 	const struct sched_class *prev_class = p->sched_class;
 	struct rq *rq;
+	int reset_on_fork;
 
 	/* may grab non-irq protected spin_locks */
 	BUG_ON(in_interrupt());
 recheck:
 	/* double check policy once rq lock held */
-	if (policy < 0)
+	if (policy < 0) {
+		reset_on_fork = p->sched_reset_on_fork;
 		policy = oldpolicy = p->policy;
-	else if (policy != SCHED_FIFO && policy != SCHED_RR &&
-			policy != SCHED_NORMAL && policy != SCHED_BATCH &&
-			policy != SCHED_IDLE)
-		return -EINVAL;
+	} else {
+		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
+		policy &= ~SCHED_RESET_ON_FORK;
+
+		if (policy != SCHED_FIFO && policy != SCHED_RR &&
+				policy != SCHED_NORMAL && policy != SCHED_BATCH &&
+				policy != SCHED_IDLE)
+			return -EINVAL;
+	}
+
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
 	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
@@ -6177,6 +6392,10 @@ recheck:
 		/* can't change other user's priorities */
 		if (!check_same_owner(p))
 			return -EPERM;
+
+		/* Normal users shall not reset the sched_reset_on_fork flag */
+		if (p->sched_reset_on_fork && !reset_on_fork)
+			return -EPERM;
 	}
 
 	if (user) {
@@ -6220,6 +6439,8 @@ recheck:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
+	p->sched_reset_on_fork = reset_on_fork;
+
 	oldprio = p->prio;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
@@ -6336,14 +6557,15 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 	if (p) {
 		retval = security_task_getscheduler(p);
 		if (!retval)
-			retval = p->policy;
+			retval = p->policy
+				| (p->sched_reset_on_fork ? SCHED_RESET_ON_FORK : 0);
 	}
 	read_unlock(&tasklist_lock);
 	return retval;
 }
 
 /**
- * sys_sched_getscheduler - get the RT priority of a thread
+ * sys_sched_getparam - get the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the RT priority.
  */
@@ -6571,19 +6793,9 @@ static inline int should_resched(void)
 
 static void __cond_resched(void)
 {
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-	__might_sleep(__FILE__, __LINE__);
-#endif
-	/*
-	 * The BKS might be reacquired before we have dropped
-	 * PREEMPT_ACTIVE, which could trigger a second
-	 * cond_resched() call.
-	 */
-	do {
-		add_preempt_count(PREEMPT_ACTIVE);
-		schedule();
-		sub_preempt_count(PREEMPT_ACTIVE);
-	} while (need_resched());
+	add_preempt_count(PREEMPT_ACTIVE);
+	schedule();
+	sub_preempt_count(PREEMPT_ACTIVE);
 }
 
 int __sched _cond_resched(void)
@@ -6597,14 +6809,14 @@ int __sched _cond_resched(void)
 EXPORT_SYMBOL(_cond_resched);
 
 /*
- * cond_resched_lock() - if a reschedule is pending, drop the given lock,
+ * __cond_resched_lock() - if a reschedule is pending, drop the given lock,
  * call schedule, and on return reacquire the lock.
  *
  * This works OK both with and without CONFIG_PREEMPT. We do strange low-level
  * operations here to prevent schedule() from being called twice (once via
  * spin_unlock(), once by hand).
  */
-int cond_resched_lock(spinlock_t *lock)
+int __cond_resched_lock(spinlock_t *lock)
 {
 	int resched = should_resched();
 	int ret = 0;
@@ -6620,9 +6832,9 @@ int cond_resched_lock(spinlock_t *lock)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(cond_resched_lock);
+EXPORT_SYMBOL(__cond_resched_lock);
 
-int __sched cond_resched_softirq(void)
+int __sched __cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
@@ -6634,7 +6846,7 @@ int __sched cond_resched_softirq(void)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(cond_resched_softirq);
+EXPORT_SYMBOL(__cond_resched_softirq);
 
 /**
  * yield - yield the current processor to other threads.
@@ -6658,11 +6870,13 @@ EXPORT_SYMBOL(yield);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = raw_rq();
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
 	schedule();
+	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 }
@@ -6670,12 +6884,14 @@ EXPORT_SYMBOL(io_schedule);
 
 long __sched io_schedule_timeout(long timeout)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = raw_rq();
 	long ret;
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
+	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 	return ret;
@@ -6992,8 +7208,12 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 
 	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
+		struct task_struct *mt = rq->migration_thread;
+
+		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
 		wake_up_process(rq->migration_thread);
+		put_task_struct(mt);
 		wait_for_completion(&req.done);
 		tlb_migrate_finish(p->mm);
 		return 0;
@@ -7625,7 +7845,7 @@ static int __init migration_init(void)
 	migration_call(&migration_notifier, CPU_ONLINE, cpu);
 	register_cpu_notifier(&migration_notifier);
 
-	return err;
+	return 0;
 }
 early_initcall(migration_init);
 #endif
@@ -7672,7 +7892,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		if (!group->__cpu_power) {
+		if (!group->cpu_power) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: domain->cpu_power not "
 					"set\n");
@@ -7696,9 +7916,9 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->__cpu_power != SCHED_LOAD_SCALE) {
-			printk(KERN_CONT " (__cpu_power = %d)",
-				group->__cpu_power);
+		if (group->cpu_power != SCHED_LOAD_SCALE) {
+			printk(KERN_CONT " (cpu_power = %d)",
+				group->cpu_power);
 		}
 
 		group = group->next;
@@ -7841,7 +8061,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	rq->rd = rd;
 
 	cpumask_set_cpu(rq->cpu, rd->span);
-	if (cpumask_test_cpu(rq->cpu, cpu_online_mask))
+	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
@@ -7983,7 +8203,7 @@ init_sched_build_groups(const struct cpumask *span,
 			continue;
 
 		cpumask_clear(sched_group_cpus(sg));
-		sg->__cpu_power = 0;
+		sg->cpu_power = 0;
 
 		for_each_cpu(j, span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
@@ -8091,6 +8311,39 @@ struct static_sched_domain {
 	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
 };
 
+struct s_data {
+#ifdef CONFIG_NUMA
+	int			sd_allnodes;
+	cpumask_var_t		domainspan;
+	cpumask_var_t		covered;
+	cpumask_var_t		notcovered;
+#endif
+	cpumask_var_t		nodemask;
+	cpumask_var_t		this_sibling_map;
+	cpumask_var_t		this_core_map;
+	cpumask_var_t		send_covered;
+	cpumask_var_t		tmpmask;
+	struct sched_group	**sched_group_nodes;
+	struct root_domain	*rd;
+};
+
+enum s_alloc {
+	sa_sched_groups = 0,
+	sa_rootdomain,
+	sa_tmpmask,
+	sa_send_covered,
+	sa_this_core_map,
+	sa_this_sibling_map,
+	sa_nodemask,
+	sa_sched_group_nodes,
+#ifdef CONFIG_NUMA
+	sa_notcovered,
+	sa_covered,
+	sa_domainspan,
+#endif
+	sa_none,
+};
+
 /*
  * SMT sched-domains:
  */
@@ -8208,11 +8461,76 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 				continue;
 			}
 
-			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
+			sg->cpu_power += sd->groups->cpu_power;
 		}
 		sg = sg->next;
 	} while (sg != group_head);
 }
+
+static int build_numa_sched_groups(struct s_data *d,
+				   const struct cpumask *cpu_map, int num)
+{
+	struct sched_domain *sd;
+	struct sched_group *sg, *prev;
+	int n, j;
+
+	cpumask_clear(d->covered);
+	cpumask_and(d->nodemask, cpumask_of_node(num), cpu_map);
+	if (cpumask_empty(d->nodemask)) {
+		d->sched_group_nodes[num] = NULL;
+		goto out;
+	}
+
+	sched_domain_node_span(num, d->domainspan);
+	cpumask_and(d->domainspan, d->domainspan, cpu_map);
+
+	sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
+			  GFP_KERNEL, num);
+	if (!sg) {
+		printk(KERN_WARNING "Can not alloc domain group for node %d\n",
+		       num);
+		return -ENOMEM;
+	}
+	d->sched_group_nodes[num] = sg;
+
+	for_each_cpu(j, d->nodemask) {
+		sd = &per_cpu(node_domains, j).sd;
+		sd->groups = sg;
+	}
+
+	sg->cpu_power = 0;
+	cpumask_copy(sched_group_cpus(sg), d->nodemask);
+	sg->next = sg;
+	cpumask_or(d->covered, d->covered, d->nodemask);
+
+	prev = sg;
+	for (j = 0; j < nr_node_ids; j++) {
+		n = (num + j) % nr_node_ids;
+		cpumask_complement(d->notcovered, d->covered);
+		cpumask_and(d->tmpmask, d->notcovered, cpu_map);
+		cpumask_and(d->tmpmask, d->tmpmask, d->domainspan);
+		if (cpumask_empty(d->tmpmask))
+			break;
+		cpumask_and(d->tmpmask, d->tmpmask, cpumask_of_node(n));
+		if (cpumask_empty(d->tmpmask))
+			continue;
+		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
+				  GFP_KERNEL, num);
+		if (!sg) {
+			printk(KERN_WARNING
+			       "Can not alloc domain group for node %d\n", j);
+			return -ENOMEM;
+		}
+		sg->cpu_power = 0;
+		cpumask_copy(sched_group_cpus(sg), d->tmpmask);
+		sg->next = prev->next;
+		cpumask_or(d->covered, d->covered, d->tmpmask);
+		prev->next = sg;
+		prev = sg;
+	}
+out:
+	return 0;
+}
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_NUMA
@@ -8266,15 +8584,13 @@ static void free_sched_groups(const struct cpumask *cpu_map,
  * there are asymmetries in the topology. If there are asymmetries, group
  * having more cpu_power will pickup more load compared to the group having
  * less cpu_power.
- *
- * cpu_power will be a multiple of SCHED_LOAD_SCALE. This multiple represents
- * the maximum number of tasks a group can handle in the presence of other idle
- * or lightly loaded groups in the same sched domain.
  */
 static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
 	struct sched_domain *child;
 	struct sched_group *group;
+	long power;
+	int weight;
 
 	WARN_ON(!sd || !sd->groups);
 
@@ -8283,28 +8599,32 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	child = sd->child;
 
-	sd->groups->__cpu_power = 0;
+	sd->groups->cpu_power = 0;
 
-	/*
-	 * For perf policy, if the groups in child domain share resources
-	 * (for example cores sharing some portions of the cache hierarchy
-	 * or SMT), then set this domain groups cpu_power such that each group
-	 * can handle only one task, when there are other idle groups in the
-	 * same sched domain.
-	 */
-	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
-		       (child->flags &
-			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
-		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
+	if (!child) {
+		power = SCHED_LOAD_SCALE;
+		weight = cpumask_weight(sched_domain_span(sd));
+		/*
+		 * SMT siblings share the power of a single core.
+		 * Usually multiple threads get a better yield out of
+		 * that one core than a single thread would have,
+		 * reflect that in sd->smt_gain.
+		 */
+		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
+			power *= sd->smt_gain;
+			power /= weight;
+			power >>= SCHED_LOAD_SHIFT;
+		}
+		sd->groups->cpu_power += power;
 		return;
 	}
 
 	/*
-	 * add cpu_power of each child group to this groups cpu_power
+	 * Add cpu_power of each child group to this groups cpu_power.
 	 */
 	group = child->groups;
 	do {
-		sg_inc_cpu_power(sd->groups, group->__cpu_power);
+		sd->groups->cpu_power += group->cpu_power;
 		group = group->next;
 	} while (group != child->groups);
 }
@@ -8378,280 +8698,285 @@ static void set_domain_attribute(struct sched_domain *sd,
 	}
 }
 
-/*
- * Build sched domains for a given set of cpus and attach the sched domains
- * to the individual cpus
- */
-static int __build_sched_domains(const struct cpumask *cpu_map,
-				 struct sched_domain_attr *attr)
-{
-	int i, err = -ENOMEM;
-	struct root_domain *rd;
-	cpumask_var_t nodemask, this_sibling_map, this_core_map, send_covered,
-		tmpmask;
+static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
+				 const struct cpumask *cpu_map)
+{
+	switch (what) {
+	case sa_sched_groups:
+		free_sched_groups(cpu_map, d->tmpmask); /* fall through */
+		d->sched_group_nodes = NULL;
+	case sa_rootdomain:
+		free_rootdomain(d->rd); /* fall through */
+	case sa_tmpmask:
+		free_cpumask_var(d->tmpmask); /* fall through */
+	case sa_send_covered:
+		free_cpumask_var(d->send_covered); /* fall through */
+	case sa_this_core_map:
+		free_cpumask_var(d->this_core_map); /* fall through */
+	case sa_this_sibling_map:
+		free_cpumask_var(d->this_sibling_map); /* fall through */
+	case sa_nodemask:
+		free_cpumask_var(d->nodemask); /* fall through */
+	case sa_sched_group_nodes:
 #ifdef CONFIG_NUMA
-	cpumask_var_t domainspan, covered, notcovered;
-	struct sched_group **sched_group_nodes = NULL;
-	int sd_allnodes = 0;
-
-	if (!alloc_cpumask_var(&domainspan, GFP_KERNEL))
-		goto out;
-	if (!alloc_cpumask_var(&covered, GFP_KERNEL))
-		goto free_domainspan;
-	if (!alloc_cpumask_var(&notcovered, GFP_KERNEL))
-		goto free_covered;
-#endif
-
-	if (!alloc_cpumask_var(&nodemask, GFP_KERNEL))
-		goto free_notcovered;
-	if (!alloc_cpumask_var(&this_sibling_map, GFP_KERNEL))
-		goto free_nodemask;
-	if (!alloc_cpumask_var(&this_core_map, GFP_KERNEL))
-		goto free_this_sibling_map;
-	if (!alloc_cpumask_var(&send_covered, GFP_KERNEL))
-		goto free_this_core_map;
-	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
-		goto free_send_covered;
+		kfree(d->sched_group_nodes); /* fall through */
+	case sa_notcovered:
+		free_cpumask_var(d->notcovered); /* fall through */
+	case sa_covered:
+		free_cpumask_var(d->covered); /* fall through */
+	case sa_domainspan:
+		free_cpumask_var(d->domainspan); /* fall through */
+#endif
+	case sa_none:
+		break;
+	}
+}
 
+static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
+						   const struct cpumask *cpu_map)
+{
 #ifdef CONFIG_NUMA
-	/*
-	 * Allocate the per-node list of sched groups
-	 */
-	sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
-				    GFP_KERNEL);
-	if (!sched_group_nodes) {
+	if (!alloc_cpumask_var(&d->domainspan, GFP_KERNEL))
+		return sa_none;
+	if (!alloc_cpumask_var(&d->covered, GFP_KERNEL))
+		return sa_domainspan;
+	if (!alloc_cpumask_var(&d->notcovered, GFP_KERNEL))
+		return sa_covered;
+	/* Allocate the per-node list of sched groups */
+	d->sched_group_nodes = kcalloc(nr_node_ids,
+				      sizeof(struct sched_group *), GFP_KERNEL);
+	if (!d->sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
-		goto free_tmpmask;
-	}
-#endif
-
-	rd = alloc_rootdomain();
-	if (!rd) {
+		return sa_notcovered;
+	}
+	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
+#endif
+	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
+		return sa_sched_group_nodes;
+	if (!alloc_cpumask_var(&d->this_sibling_map, GFP_KERNEL))
+		return sa_nodemask;
+	if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
+		return sa_this_sibling_map;
+	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
+		return sa_this_core_map;
+	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
+		return sa_send_covered;
+	d->rd = alloc_rootdomain();
+	if (!d->rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
-		goto free_sched_groups;
+		return sa_tmpmask;
 	}
+	return sa_rootdomain;
+}
 
+static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr, int i)
+{
+	struct sched_domain *sd = NULL;
 #ifdef CONFIG_NUMA
-	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = sched_group_nodes;
-#endif
-
-	/*
-	 * Set up domains for cpus specified by the cpu_map.
-	 */
-	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd = NULL, *p;
+	struct sched_domain *parent;
 
-		cpumask_and(nodemask, cpumask_of_node(cpu_to_node(i)), cpu_map);
-
-#ifdef CONFIG_NUMA
-		if (cpumask_weight(cpu_map) >
-				SD_NODES_PER_DOMAIN*cpumask_weight(nodemask)) {
-			sd = &per_cpu(allnodes_domains, i).sd;
-			SD_INIT(sd, ALLNODES);
-			set_domain_attribute(sd, attr);
-			cpumask_copy(sched_domain_span(sd), cpu_map);
-			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
-			p = sd;
-			sd_allnodes = 1;
-		} else
-			p = NULL;
-
-		sd = &per_cpu(node_domains, i).sd;
-		SD_INIT(sd, NODE);
+	d->sd_allnodes = 0;
+	if (cpumask_weight(cpu_map) >
+	    SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) {
+		sd = &per_cpu(allnodes_domains, i).sd;
+		SD_INIT(sd, ALLNODES);
 		set_domain_attribute(sd, attr);
-		sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
-		sd->parent = p;
-		if (p)
-			p->child = sd;
-		cpumask_and(sched_domain_span(sd),
-			    sched_domain_span(sd), cpu_map);
+		cpumask_copy(sched_domain_span(sd), cpu_map);
+		cpu_to_allnodes_group(i, cpu_map, &sd->groups, d->tmpmask);
+		d->sd_allnodes = 1;
+	}
+	parent = sd;
+
+	sd = &per_cpu(node_domains, i).sd;
+	SD_INIT(sd, NODE);
+	set_domain_attribute(sd, attr);
+	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
+	sd->parent = parent;
+	if (parent)
+		parent->child = sd;
+	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
 #endif
+	return sd;
+}
 
-		p = sd;
-		sd = &per_cpu(phys_domains, i).sd;
-		SD_INIT(sd, CPU);
-		set_domain_attribute(sd, attr);
-		cpumask_copy(sched_domain_span(sd), nodemask);
-		sd->parent = p;
-		if (p)
-			p->child = sd;
-		cpu_to_phys_group(i, cpu_map, &sd->groups, tmpmask);
+static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd;
+	sd = &per_cpu(phys_domains, i).sd;
+	SD_INIT(sd, CPU);
+	set_domain_attribute(sd, attr);
+	cpumask_copy(sched_domain_span(sd), d->nodemask);
+	sd->parent = parent;
+	if (parent)
+		parent->child = sd;
+	cpu_to_phys_group(i, cpu_map, &sd->groups, d->tmpmask);
+	return sd;
+}
 
+static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_MC
-		p = sd;
-		sd = &per_cpu(core_domains, i).sd;
-		SD_INIT(sd, MC);
-		set_domain_attribute(sd, attr);
-		cpumask_and(sched_domain_span(sd), cpu_map,
-						   cpu_coregroup_mask(i));
-		sd->parent = p;
-		p->child = sd;
-		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
+	sd = &per_cpu(core_domains, i).sd;
+	SD_INIT(sd, MC);
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_coregroup_mask(i));
+	sd->parent = parent;
+	parent->child = sd;
+	cpu_to_core_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
+	return sd;
+}
 
+static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_SMT
-		p = sd;
-		sd = &per_cpu(cpu_domains, i).sd;
-		SD_INIT(sd, SIBLING);
-		set_domain_attribute(sd, attr);
-		cpumask_and(sched_domain_span(sd),
-			    topology_thread_cpumask(i), cpu_map);
-		sd->parent = p;
-		p->child = sd;
-		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
+	sd = &per_cpu(cpu_domains, i).sd;
+	SD_INIT(sd, SIBLING);
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, topology_thread_cpumask(i));
+	sd->parent = parent;
+	parent->child = sd;
+	cpu_to_cpu_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
-	}
+	return sd;
+}
 
+static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
+			       const struct cpumask *cpu_map, int cpu)
+{
+	switch (l) {
 #ifdef CONFIG_SCHED_SMT
-	/* Set up CPU (sibling) groups */
-	for_each_cpu(i, cpu_map) {
-		cpumask_and(this_sibling_map,
-			    topology_thread_cpumask(i), cpu_map);
-		if (i != cpumask_first(this_sibling_map))
-			continue;
-
-		init_sched_build_groups(this_sibling_map, cpu_map,
-					&cpu_to_cpu_group,
-					send_covered, tmpmask);
-	}
+	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
+		cpumask_and(d->this_sibling_map, cpu_map,
+			    topology_thread_cpumask(cpu));
+		if (cpu == cpumask_first(d->this_sibling_map))
+			init_sched_build_groups(d->this_sibling_map, cpu_map,
+						&cpu_to_cpu_group,
+						d->send_covered, d->tmpmask);
+		break;
 #endif
-
 #ifdef CONFIG_SCHED_MC
-	/* Set up multi-core groups */
-	for_each_cpu(i, cpu_map) {
-		cpumask_and(this_core_map, cpu_coregroup_mask(i), cpu_map);
-		if (i != cpumask_first(this_core_map))
-			continue;
-
-		init_sched_build_groups(this_core_map, cpu_map,
-					&cpu_to_core_group,
-					send_covered, tmpmask);
-	}
+	case SD_LV_MC: /* set up multi-core groups */
+		cpumask_and(d->this_core_map, cpu_map, cpu_coregroup_mask(cpu));
+		if (cpu == cpumask_first(d->this_core_map))
+			init_sched_build_groups(d->this_core_map, cpu_map,
+						&cpu_to_core_group,
+						d->send_covered, d->tmpmask);
+		break;
 #endif
-
-	/* Set up physical groups */
-	for (i = 0; i < nr_node_ids; i++) {
-		cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
-		if (cpumask_empty(nodemask))
-			continue;
-
-		init_sched_build_groups(nodemask, cpu_map,
-					&cpu_to_phys_group,
-					send_covered, tmpmask);
-	}
-
+	case SD_LV_CPU: /* set up physical groups */
+		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
+		if (!cpumask_empty(d->nodemask))
+			init_sched_build_groups(d->nodemask, cpu_map,
+						&cpu_to_phys_group,
+						d->send_covered, d->tmpmask);
+		break;
 #ifdef CONFIG_NUMA
-	/* Set up node groups */
-	if (sd_allnodes) {
-		init_sched_build_groups(cpu_map, cpu_map,
-					&cpu_to_allnodes_group,
-					send_covered, tmpmask);
+	case SD_LV_ALLNODES:
+		init_sched_build_groups(cpu_map, cpu_map, &cpu_to_allnodes_group,
+					d->send_covered, d->tmpmask);
+		break;
+#endif
+	default:
+		break;
 	}
+}
 
-	for (i = 0; i < nr_node_ids; i++) {
-		/* Set up node groups */
-		struct sched_group *sg, *prev;
-		int j;
-
-		cpumask_clear(covered);
-		cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
-		if (cpumask_empty(nodemask)) {
-			sched_group_nodes[i] = NULL;
-			continue;
-		}
+/*
+ * Build sched domains for a given set of cpus and attach the sched domains
+ * to the individual cpus
+ */
+static int __build_sched_domains(const struct cpumask *cpu_map,
+				 struct sched_domain_attr *attr)
+{
+	enum s_alloc alloc_state = sa_none;
+	struct s_data d;
+	struct sched_domain *sd;
+	int i;
+#ifdef CONFIG_NUMA
+	d.sd_allnodes = 0;
+#endif
 
-		sched_domain_node_span(i, domainspan);
-		cpumask_and(domainspan, domainspan, cpu_map);
+	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
+	if (alloc_state != sa_rootdomain)
+		goto error;
+	alloc_state = sa_sched_groups;
 
-		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				  GFP_KERNEL, i);
-		if (!sg) {
-			printk(KERN_WARNING "Can not alloc domain group for "
-				"node %d\n", i);
-			goto error;
-		}
-		sched_group_nodes[i] = sg;
-		for_each_cpu(j, nodemask) {
-			struct sched_domain *sd;
+	/*
+	 * Set up domains for cpus specified by the cpu_map.
+	 */
+	for_each_cpu(i, cpu_map) {
+		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
+			    cpu_map);
 
-			sd = &per_cpu(node_domains, j).sd;
-			sd->groups = sg;
-		}
-		sg->__cpu_power = 0;
-		cpumask_copy(sched_group_cpus(sg), nodemask);
-		sg->next = sg;
-		cpumask_or(covered, covered, nodemask);
-		prev = sg;
+		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
+		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
+		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
+		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
+	}
 
-		for (j = 0; j < nr_node_ids; j++) {
-			int n = (i + j) % nr_node_ids;
+	for_each_cpu(i, cpu_map) {
+		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
+		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
+	}
 
-			cpumask_complement(notcovered, covered);
-			cpumask_and(tmpmask, notcovered, cpu_map);
-			cpumask_and(tmpmask, tmpmask, domainspan);
-			if (cpumask_empty(tmpmask))
-				break;
+	/* Set up physical groups */
+	for (i = 0; i < nr_node_ids; i++)
+		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
 
-			cpumask_and(tmpmask, tmpmask, cpumask_of_node(n));
-			if (cpumask_empty(tmpmask))
-				continue;
+#ifdef CONFIG_NUMA
+	/* Set up node groups */
+	if (d.sd_allnodes)
+		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, 0);
 
-			sg = kmalloc_node(sizeof(struct sched_group) +
-					  cpumask_size(),
-					  GFP_KERNEL, i);
-			if (!sg) {
-				printk(KERN_WARNING
-				"Can not alloc domain group for node %d\n", j);
-				goto error;
-			}
-			sg->__cpu_power = 0;
-			cpumask_copy(sched_group_cpus(sg), tmpmask);
-			sg->next = prev->next;
-			cpumask_or(covered, covered, tmpmask);
-			prev->next = sg;
-			prev = sg;
-		}
-	}
+	for (i = 0; i < nr_node_ids; i++)
+		if (build_numa_sched_groups(&d, cpu_map, i))
+			goto error;
 #endif
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd = &per_cpu(cpu_domains, i).sd;
-
+		sd = &per_cpu(cpu_domains, i).sd;
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd = &per_cpu(core_domains, i).sd;
-
+		sd = &per_cpu(core_domains, i).sd;
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd = &per_cpu(phys_domains, i).sd;
-
+		sd = &per_cpu(phys_domains, i).sd;
 		init_sched_groups_power(i, sd);
 	}
 
 #ifdef CONFIG_NUMA
 	for (i = 0; i < nr_node_ids; i++)
-		init_numa_sched_groups_power(sched_group_nodes[i]);
+		init_numa_sched_groups_power(d.sched_group_nodes[i]);
 
-	if (sd_allnodes) {
+	if (d.sd_allnodes) {
 		struct sched_group *sg;
 
 		cpu_to_allnodes_group(cpumask_first(cpu_map), cpu_map, &sg,
-								tmpmask);
+								d.tmpmask);
 		init_numa_sched_groups_power(sg);
 	}
 #endif
 
 	/* Attach the domains */
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i).sd;
 #elif defined(CONFIG_SCHED_MC)
@@ -8659,44 +8984,16 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 #else
 		sd = &per_cpu(phys_domains, i).sd;
 #endif
-		cpu_attach_domain(sd, rd, i);
+		cpu_attach_domain(sd, d.rd, i);
 	}
 
-	err = 0;
-
-free_tmpmask:
-	free_cpumask_var(tmpmask);
-free_send_covered:
-	free_cpumask_var(send_covered);
-free_this_core_map:
-	free_cpumask_var(this_core_map);
-free_this_sibling_map:
-	free_cpumask_var(this_sibling_map);
-free_nodemask:
-	free_cpumask_var(nodemask);
-free_notcovered:
-#ifdef CONFIG_NUMA
-	free_cpumask_var(notcovered);
-free_covered:
-	free_cpumask_var(covered);
-free_domainspan:
-	free_cpumask_var(domainspan);
-out:
-#endif
-	return err;
-
-free_sched_groups:
-#ifdef CONFIG_NUMA
-	kfree(sched_group_nodes);
-#endif
-	goto free_tmpmask;
+	d.sched_group_nodes = NULL; /* don't free this we still need it */
+	__free_domain_allocs(&d, sa_tmpmask, cpu_map);
+	return 0;
 
-#ifdef CONFIG_NUMA
 error:
-	free_sched_groups(cpu_map, tmpmask);
-	free_rootdomain(rd);
-	goto free_tmpmask;
-#endif
+	__free_domain_allocs(&d, alloc_state, cpu_map);
+	return -ENOMEM;
 }
 
 static int build_sched_domains(const struct cpumask *cpu_map)
@@ -9304,11 +9601,11 @@ void __init sched_init(void)
 		 * system cpu resource, based on the weight assigned to root
 		 * user's cpu share (INIT_TASK_GROUP_LOAD). This is accomplished
 		 * by letting tasks of init_task_group sit in a separate cfs_rq
-		 * (init_cfs_rq) and having one entity represent this group of
+		 * (init_tg_cfs_rq) and having one entity represent this group of
 		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
 		 */
 		init_tg_cfs_entry(&init_task_group,
-				&per_cpu(init_cfs_rq, i),
+				&per_cpu(init_tg_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1,
 				root_task_group.se[i]);
 
@@ -9334,6 +9631,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
+		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
@@ -9398,13 +9696,20 @@ void __init sched_init(void)
 }
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-void __might_sleep(char *file, int line)
+static inline int preempt_count_equals(int preempt_offset)
+{
+	int nested = preempt_count() & ~PREEMPT_ACTIVE;
+
+	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
+}
+
+void __might_sleep(char *file, int line, int preempt_offset)
 {
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
-	if ((!in_atomic() && !irqs_disabled()) ||
-		    system_state != SYSTEM_RUNNING || oops_in_progress)
+	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
 		return;
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index d014efb..0f052fc 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -127,21 +127,11 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 
 	/*
 	 * If the cpu was currently mapped to a different value, we
-	 * first need to unmap the old value
+	 * need to map it to the new value then remove the old value.
+	 * Note, we must add the new value first, otherwise we risk the
+	 * cpu being cleared from pri_active, and this cpu could be
+	 * missed for a push or pull.
 	 */
-	if (likely(oldpri != CPUPRI_INVALID)) {
-		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
-
-		spin_lock_irqsave(&vec->lock, flags);
-
-		vec->count--;
-		if (!vec->count)
-			clear_bit(oldpri, cp->pri_active);
-		cpumask_clear_cpu(cpu, vec->mask);
-
-		spin_unlock_irqrestore(&vec->lock, flags);
-	}
-
 	if (likely(newpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
 
@@ -154,6 +144,18 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 
 		spin_unlock_irqrestore(&vec->lock, flags);
 	}
+	if (likely(oldpri != CPUPRI_INVALID)) {
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		vec->count--;
+		if (!vec->count)
+			clear_bit(oldpri, cp->pri_active);
+		cpumask_clear_cpu(cpu, vec->mask);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
 
 	*currpri = newpri;
 }
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 70c7e0b..5ddbd08 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -409,6 +409,8 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.wait_max);
 	PN(se.wait_sum);
 	P(se.wait_count);
+	PN(se.iowait_sum);
+	P(se.iowait_count);
 	P(sched_info.bkl_count);
 	P(se.nr_migrations);
 	P(se.nr_migrations_cold);
@@ -479,6 +481,8 @@ void proc_sched_set_task(struct task_struct *p)
 	p->se.wait_max				= 0;
 	p->se.wait_sum				= 0;
 	p->se.wait_count			= 0;
+	p->se.iowait_sum			= 0;
+	p->se.iowait_count			= 0;
 	p->se.sleep_max				= 0;
 	p->se.sum_sleep_runtime			= 0;
 	p->se.block_max				= 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 652e8bd..aa7f841 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -24,7 +24,7 @@
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
- * (default: 20ms * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 5ms * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * NOTE: this latency value is not the same as the concept of
  * 'timeslice length' - timeslices in CFS are of variable length
@@ -34,13 +34,13 @@
  * (to see the precise effective timeslice length of your workload,
  *  run vmstat and monitor the context-switches (cs) field)
  */
-unsigned int sysctl_sched_latency = 20000000ULL;
+unsigned int sysctl_sched_latency = 5000000ULL;
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
- * (default: 4 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity = 4000000ULL;
+unsigned int sysctl_sched_min_granularity = 1000000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
@@ -48,10 +48,10 @@ unsigned int sysctl_sched_min_granularity = 4000000ULL;
 static unsigned int sched_nr_latency = 5;
 
 /*
- * After fork, child runs first. (default) If set to 0 then
+ * After fork, child runs first. If set to 0 (default) then
  * parent will (try to) run first.
  */
-const_debug unsigned int sysctl_sched_child_runs_first = 1;
+unsigned int sysctl_sched_child_runs_first __read_mostly;
 
 /*
  * sys_sched_yield() compat mode
@@ -63,13 +63,13 @@ unsigned int __read_mostly sysctl_sched_compat_yield;
 
 /*
  * SCHED_OTHER wake-up granularity.
- * (default: 5 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
+unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -79,11 +79,6 @@ static const struct sched_class fair_sched_class;
  * CFS operations on generic schedulable entities:
  */
 
-static inline struct task_struct *task_of(struct sched_entity *se)
-{
-	return container_of(se, struct task_struct, se);
-}
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 /* cpu runqueue to which this cfs_rq is attached */
@@ -95,6 +90,14 @@ static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 /* An entity is a task if it doesn't "own" a runqueue */
 #define entity_is_task(se)	(!se->my_q)
 
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(!entity_is_task(se));
+#endif
+	return container_of(se, struct task_struct, se);
+}
+
 /* Walk up scheduling entities hierarchy */
 #define for_each_sched_entity(se) \
 		for (; se; se = se->parent)
@@ -186,7 +189,12 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 	}
 }
 
-#else	/* CONFIG_FAIR_GROUP_SCHED */
+#else	/* !CONFIG_FAIR_GROUP_SCHED */
+
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+	return container_of(se, struct task_struct, se);
+}
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 {
@@ -537,6 +545,12 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	schedstat_set(se->wait_count, se->wait_count + 1);
 	schedstat_set(se->wait_sum, se->wait_sum +
 			rq_of(cfs_rq)->clock - se->wait_start);
+#ifdef CONFIG_SCHEDSTATS
+	if (entity_is_task(se)) {
+		trace_sched_stat_wait(task_of(se),
+			rq_of(cfs_rq)->clock - se->wait_start);
+	}
+#endif
 	schedstat_set(se->wait_start, 0);
 }
 
@@ -628,8 +642,10 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		se->sleep_start = 0;
 		se->sum_sleep_runtime += delta;
 
-		if (tsk)
+		if (tsk) {
 			account_scheduler_latency(tsk, delta >> 10, 1);
+			trace_sched_stat_sleep(tsk, delta);
+		}
 	}
 	if (se->block_start) {
 		u64 delta = rq_of(cfs_rq)->clock - se->block_start;
@@ -644,6 +660,12 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		se->sum_sleep_runtime += delta;
 
 		if (tsk) {
+			if (tsk->in_iowait) {
+				se->iowait_sum += delta;
+				se->iowait_count++;
+				trace_sched_stat_iowait(tsk, delta);
+			}
+
 			/*
 			 * Blocking time is in units of nanosecs, so shift by
 			 * 20 to get a milliseconds-range estimation of the
@@ -705,11 +727,11 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 			vruntime -= thresh;
 		}
-
-		/* ensure we never gain time by being placed backwards. */
-		vruntime = max_vruntime(se->vruntime, vruntime);
 	}
 
+	/* ensure we never gain time by being placed backwards. */
+	vruntime = max_vruntime(se->vruntime, vruntime);
+
 	se->vruntime = vruntime;
 }
 
@@ -1046,17 +1068,21 @@ static void yield_task_fair(struct rq *rq)
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
  * Domains may include CPUs that are not usable for migration,
- * hence we need to mask them out (cpu_active_mask)
+ * hence we need to mask them out (rq->rd->online)
  *
  * Returns the CPU we should wake onto.
  */
 #if defined(ARCH_HAS_SCHED_WAKE_IDLE)
+
+#define cpu_rd_active(cpu, rq) cpumask_test_cpu(cpu, rq->rd->online)
+
 static int wake_idle(int cpu, struct task_struct *p)
 {
 	struct sched_domain *sd;
 	int i;
 	unsigned int chosen_wakeup_cpu;
 	int this_cpu;
+	struct rq *task_rq = task_rq(p);
 
 	/*
 	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
@@ -1089,10 +1115,10 @@ static int wake_idle(int cpu, struct task_struct *p)
 	for_each_domain(cpu, sd) {
 		if ((sd->flags & SD_WAKE_IDLE)
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
-			&& !task_hot(p, task_rq(p)->clock, sd))) {
+			&& !task_hot(p, task_rq->clock, sd))) {
 			for_each_cpu_and(i, sched_domain_span(sd),
 					 &p->cpus_allowed) {
-				if (cpu_active(i) && idle_cpu(i)) {
+				if (cpu_rd_active(i, task_rq) && idle_cpu(i)) {
 					if (i != task_cpu(p)) {
 						schedstat_inc(p,
 						       se.nr_wakeups_idle);
@@ -1235,7 +1261,17 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
-	balanced = 100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
+	/*
+	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
+	 * due to the sync cause above having dropped tl to 0, we'll always have
+	 * an imbalance, but there's really nothing you can do about that, so
+	 * that's good too.
+	 *
+	 * Otherwise check if either cpus are near enough in load to allow this
+	 * task to be woken on this_cpu.
+	 */
+	balanced = !tl ||
+		100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
 
 	/*
@@ -1278,8 +1314,6 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 	this_rq		= cpu_rq(this_cpu);
 	new_cpu		= prev_cpu;
 
-	if (prev_cpu == this_cpu)
-		goto out;
 	/*
 	 * 'this_sd' is the first domain that both
 	 * this_cpu and prev_cpu are present in:
@@ -1721,6 +1755,8 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 	sched_info_queued(p);
 
 	update_curr(cfs_rq);
+	if (curr)
+		se->vruntime = curr->vruntime;
 	place_entity(cfs_rq, se, 1);
 
 	/* 'curr' will be NULL if the child belongs to a different group */
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 4569bfa..e2dc63a 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,4 +1,4 @@
-SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
+SCHED_FEAT(NEW_FAIR_SLEEPERS, 0)
 SCHED_FEAT(NORMALIZED_SLEEPER, 0)
 SCHED_FEAT(ADAPTIVE_GRAN, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 3918e01..2eb4bd6 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -3,15 +3,18 @@
  * policies)
  */
 
+#ifdef CONFIG_RT_GROUP_SCHED
+
+#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
+
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 {
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
+#endif
 	return container_of(rt_se, struct task_struct, rt);
 }
 
-#ifdef CONFIG_RT_GROUP_SCHED
-
-#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
-
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return rt_rq->rq;
@@ -26,6 +29,11 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 
 #define rt_entity_is_task(rt_se) (1)
 
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+{
+	return container_of(rt_se, struct task_struct, rt);
+}
+
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return container_of(rt_rq, struct rq, rt);
@@ -128,6 +136,11 @@ static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
 	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
 }
 
+static inline int has_pushable_tasks(struct rq *rq)
+{
+	return !plist_head_empty(&rq->rt.pushable_tasks);
+}
+
 #else
 
 static inline void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
@@ -602,6 +615,8 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
+	sched_rt_avg_update(rq, delta_exec);
+
 	if (!rt_bandwidth_enabled())
 		return;
 
@@ -874,8 +889,6 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -886,8 +899,6 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
@@ -1064,6 +1075,14 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 	if (p)
 		dequeue_pushable_task(rq, p);
 
+#ifdef CONFIG_SMP
+	/*
+	 * We detect this state here so that we can avoid taking the RQ
+	 * lock again later if there is no need to push
+	 */
+	rq->post_schedule = has_pushable_tasks(rq);
+#endif
+
 	return p;
 }
 
@@ -1162,13 +1181,6 @@ static int find_lowest_rq(struct task_struct *task)
 		return -1; /* No targets found */
 
 	/*
-	 * Only consider CPUs that are usable for migration.
-	 * I guess we might want to change cpupri_find() to ignore those
-	 * in the first place.
-	 */
-	cpumask_and(lowest_mask, lowest_mask, cpu_active_mask);
-
-	/*
 	 * At this point we have built a mask of cpus representing the
 	 * lowest priority tasks in the system.  Now we want to elect
 	 * the best one based on our affinity and topology.
@@ -1262,11 +1274,6 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 	return lowest_rq;
 }
 
-static inline int has_pushable_tasks(struct rq *rq)
-{
-	return !plist_head_empty(&rq->rt.pushable_tasks);
-}
-
 static struct task_struct *pick_next_pushable_task(struct rq *rq)
 {
 	struct task_struct *p;
@@ -1466,23 +1473,9 @@ static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 		pull_rt_task(rq);
 }
 
-/*
- * assumes rq->lock is held
- */
-static int needs_post_schedule_rt(struct rq *rq)
-{
-	return has_pushable_tasks(rq);
-}
-
 static void post_schedule_rt(struct rq *rq)
 {
-	/*
-	 * This is only called if needs_post_schedule_rt() indicates that
-	 * we need to push tasks away
-	 */
-	spin_lock_irq(&rq->lock);
 	push_rt_tasks(rq);
-	spin_unlock_irq(&rq->lock);
 }
 
 /*
@@ -1758,7 +1751,6 @@ static const struct sched_class rt_sched_class = {
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
-	.needs_post_schedule	= needs_post_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_wake_up		= task_wake_up_rt,
 	.switched_from		= switched_from_rt,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 58be760..25d6bf3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -246,6 +246,14 @@ static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_child_runs_first",
+		.data		= &sysctl_sched_child_runs_first,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -300,14 +308,6 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_child_runs_first",
-		.data		= &sysctl_sched_child_runs_first,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_features",
 		.data		= &sysctl_sched_features,
 		.maxlen		= sizeof(unsigned int),
@@ -332,6 +332,14 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_time_avg",
+		.data		= &sysctl_sched_time_avg,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "timer_migration",
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0668795..ea1b4e7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -317,8 +317,6 @@ static int worker_thread(void *__cwq)
 	if (cwq->wq->freezeable)
 		set_freezable();
 
-	set_user_nice(current, -5);
-
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
