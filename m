Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZLCUNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZLCUNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZLCUNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:13:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbZLCUNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:13:36 -0500
Date: Thu, 3 Dec 2009 21:13:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] sched/core for v2.6.33
Message-ID: <20091203201326.GA10994@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

Highlights:

 - task_u/stime fixes that ought to (finally) resolve some of the time 
   accounting bugs that were reported

 - Less verbose scheduler messages during bootup.

 - Various tweaks and small improvements.

 Thanks,

	Ingo

------------------>
Dhaval Giani (1):
      sched: Add USER_SCHED to feature removal list

Heiko Carstens (1):
      sched: Always show Cpus_allowed field in /proc/<pid>/status

Hidetoshi Seto (6):
      sched: Fix granularity of task_u/stime()
      sched: Introduce task_times() to replace task_{u,s}time() pair
      sched: Remove task_{u,s,g}time()
      sched, time: Define nsecs_to_jiffies()
      sched, cputime: Cleanups related to task_times()
      sched, cputime: Introduce thread_group_times()

Hiroshi Shimamoto (3):
      sched: Remove unused __schedule() declaration
      sched: Remove unused time_sync_thresh declaration
      sched: Remove unused cpu_nr_migrations()

Jan Blunck (1):
      sched_feat_write(): Update ppos instead of file->f_pos

Jayson R. King (1):
      sched: Remove obsolete comment in sched_init()

Lai Jiangshan (1):
      sched, no_hz: Remove unused rq->last_tick_seen field

Mike Galbraith (5):
      sched: Check for an idle shared cache in select_task_rq_fair()
      sched: Rate-limit newidle
      sched: Fix affinity logic in select_task_rq_fair()
      sched: Fix and clean up rate-limit newidle code
      sched: Fix/add missing update_rq_clock() calls

Mike Travis (1):
      sched: Limit the number of scheduler debug messages

Peter Zijlstra (4):
      sched: Make sure task has correct sched_class after policy change
      sched: Cleanup select_task_rq_fair()
      sched: More generic WAKE_AFFINE vs select_idle_sibling()
      sched: Sched_rt_periodic_timer vs cpu hotplug

Rusty Russell (3):
      cpumask: Simplify sched_rt.c
      cpumask: Partition_sched_domains takes array of cpumask_var_t
      sched: Fix isolcpus boot option

Ryota Ozaki (1):
      sched, cpuacct: Fix niced guest time accounting

Shmulik Ladkani (1):
      sched.c: Call debug_show_all_locks() when dumping all tasks

Tejun Heo (2):
      sched, kvm: Fix race condition involving sched_in_preempt_notifers
      sched: Revert 498657a478c60be092208422fefa9c7b248729c2

Tim Blechmann (4):
      sched: Optimize branch hint in pick_next_task_fair()
      sched: Optimize branch hint in context_switch()
      sched, x86: Optimize branch hint in __switch_to()
      Revert "sched, x86: Optimize branch hint in __switch_to()"


 Documentation/feature-removal-schedule.txt |   15 ++
 Documentation/filesystems/proc.txt         |    3 +-
 Documentation/kernel-parameters.txt        |    2 +
 fs/proc/array.c                            |   23 ++-
 fs/proc/stat.c                             |   19 ++-
 include/linux/jiffies.h                    |    1 +
 include/linux/kernel_stat.h                |    1 +
 include/linux/preempt.h                    |    5 +
 include/linux/sched.h                      |   22 ++-
 kernel/cpuset.c                            |   27 +--
 kernel/exit.c                              |   22 ++-
 kernel/fork.c                              |    5 +
 kernel/kgdb.c                              |    2 +-
 kernel/sched.c                             |  270 ++++++++++++++++++----------
 kernel/sched_debug.c                       |    4 +
 kernel/sched_fair.c                        |   65 ++++++-
 kernel/sched_rt.c                          |   61 +++----
 kernel/sys.c                               |   21 +--
 kernel/time.c                              |   30 +++
 19 files changed, 397 insertions(+), 201 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bc693ff..f613df8 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,21 @@ be removed from this file.
 
 ---------------------------
 
+What:	USER_SCHED
+When:	2.6.34
+
+Why:	USER_SCHED was implemented as a proof of concept for group scheduling.
+	The effect of USER_SCHED can already be achieved from userspace with
+	the help of libcgroup. The removal of USER_SCHED will also simplify
+	the scheduler code with the removal of one major ifdef. There are also
+	issues USER_SCHED has with USER_NS. A decision was taken not to fix
+	those and instead remove USER_SCHED. Also new group scheduling
+	features will not be implemented for USER_SCHED.
+
+Who:	Dhaval Giani <dhaval@linux.vnet.ibm.com>
+
+---------------------------
+
 What:	PRISM54
 When:	2.6.34
 
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 2c48f94..4af0018 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1072,7 +1072,8 @@ second).  The meanings of the columns are as follows, from left to right:
 - irq: servicing interrupts
 - softirq: servicing softirqs
 - steal: involuntary wait
-- guest: running a guest
+- guest: running a normal guest
+- guest_nice: running a niced guest
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..f2a9507 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2182,6 +2182,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	sbni=		[NET] Granch SBNI12 leased line adapter
 
+	sched_debug	[KNL] Enables verbose scheduler debug messages.
+
 	sc1200wdt=	[HW,WDT] SC1200 WDT (watchdog) driver
 			Format: <io>[,<timeout>[,<isapnp>]]
 
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 07f77a7..2571da4 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -410,6 +410,16 @@ static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
 }
 #endif		/* CONFIG_MMU */
 
+static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
+{
+	seq_printf(m, "Cpus_allowed:\t");
+	seq_cpumask(m, &task->cpus_allowed);
+	seq_printf(m, "\n");
+	seq_printf(m, "Cpus_allowed_list:\t");
+	seq_cpumask_list(m, &task->cpus_allowed);
+	seq_printf(m, "\n");
+}
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -424,6 +434,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	}
 	task_sig(m, task);
 	task_cap(m, task);
+	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 #if defined(CONFIG_S390)
 	task_show_regs(m, task);
@@ -495,20 +506,17 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 		/* add up live thread stats at the group level */
 		if (whole) {
-			struct task_cputime cputime;
 			struct task_struct *t = task;
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				gtime = cputime_add(gtime, task_gtime(t));
+				gtime = cputime_add(gtime, t->gtime);
 				t = next_thread(t);
 			} while (t != task);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime(task, &cputime);
-			utime = cputime.utime;
-			stime = cputime.stime;
+			thread_group_times(task, &utime, &stime);
 			gtime = cputime_add(gtime, sig->gtime);
 		}
 
@@ -524,9 +532,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		utime = task_utime(task);
-		stime = task_stime(task);
-		gtime = task_gtime(task);
+		task_times(task, &utime, &stime);
+		gtime = task->gtime;
 	}
 
 	/* scale priority and nice values from timeslices to -20..20 */
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 7cc726c..b9b7aad 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -27,7 +27,7 @@ static int show_stat(struct seq_file *p, void *v)
 	int i, j;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
-	cputime64_t guest;
+	cputime64_t guest, guest_nice;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
@@ -36,7 +36,7 @@ static int show_stat(struct seq_file *p, void *v)
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
-	guest = cputime64_zero;
+	guest = guest_nice = cputime64_zero;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
@@ -51,6 +51,8 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
+		guest_nice = cputime64_add(guest_nice,
+			kstat_cpu(i).cpustat.guest_nice);
 		for_each_irq_nr(j) {
 			sum += kstat_irqs_cpu(j, i);
 		}
@@ -65,7 +67,8 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	sum += arch_irq_stat();
 
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
+	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
+		"%llu\n",
 		(unsigned long long)cputime64_to_clock_t(user),
 		(unsigned long long)cputime64_to_clock_t(nice),
 		(unsigned long long)cputime64_to_clock_t(system),
@@ -74,7 +77,8 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(irq),
 		(unsigned long long)cputime64_to_clock_t(softirq),
 		(unsigned long long)cputime64_to_clock_t(steal),
-		(unsigned long long)cputime64_to_clock_t(guest));
+		(unsigned long long)cputime64_to_clock_t(guest),
+		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -88,8 +92,10 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = kstat_cpu(i).cpustat.softirq;
 		steal = kstat_cpu(i).cpustat.steal;
 		guest = kstat_cpu(i).cpustat.guest;
+		guest_nice = kstat_cpu(i).cpustat.guest_nice;
 		seq_printf(p,
-			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
+			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
+			"%llu\n",
 			i,
 			(unsigned long long)cputime64_to_clock_t(user),
 			(unsigned long long)cputime64_to_clock_t(nice),
@@ -99,7 +105,8 @@ static int show_stat(struct seq_file *p, void *v)
 			(unsigned long long)cputime64_to_clock_t(irq),
 			(unsigned long long)cputime64_to_clock_t(softirq),
 			(unsigned long long)cputime64_to_clock_t(steal),
-			(unsigned long long)cputime64_to_clock_t(guest));
+			(unsigned long long)cputime64_to_clock_t(guest),
+			(unsigned long long)cputime64_to_clock_t(guest_nice));
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1a9cf78..6811f4b 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -307,6 +307,7 @@ extern clock_t jiffies_to_clock_t(long x);
 extern unsigned long clock_t_to_jiffies(unsigned long x);
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
+extern unsigned long nsecs_to_jiffies(u64 n);
 
 #define TIMESTAMP_SIZE	30
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 348fa88..c059044 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -25,6 +25,7 @@ struct cpu_usage_stat {
 	cputime64_t iowait;
 	cputime64_t steal;
 	cputime64_t guest;
+	cputime64_t guest_nice;
 };
 
 struct kernel_stat {
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 72b1a10..2e681d9 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -105,6 +105,11 @@ struct preempt_notifier;
  * @sched_out: we've just been preempted
  *    notifier: struct preempt_notifier for the task being preempted
  *    next: the task that's kicking us out
+ *
+ * Please note that sched_in and out are called under different
+ * contexts.  sched_out is called with rq lock held and irq disabled
+ * while sched_in is called without rq lock and irq enabled.  This
+ * difference is intentional and depended upon by its users.
  */
 struct preempt_ops {
 	void (*sched_in)(struct preempt_notifier *notifier, int cpu);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..34238bd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -145,7 +145,6 @@ extern unsigned long this_cpu_load(void);
 
 
 extern void calc_global_load(void);
-extern u64 cpu_nr_migrations(int cpu);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
@@ -171,8 +170,6 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 }
 #endif
 
-extern unsigned long long time_sync_thresh;
-
 /*
  * Task state bitmask. NOTE! These bits are also
  * encoded in fs/proc/array.c: get_task_state().
@@ -349,7 +346,6 @@ extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
-asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
 extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
@@ -628,6 +624,9 @@ struct signal_struct {
 	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	cputime_t prev_utime, prev_stime;
+#endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
@@ -1013,9 +1012,13 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 	return to_cpumask(sd->span);
 }
 
-extern void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
+extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 				    struct sched_domain_attr *dattr_new);
 
+/* Allocate an array of sched domains, for partition_sched_domains(). */
+cpumask_var_t *alloc_sched_domains(unsigned int ndoms);
+void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
+
 /* Test a flag in parent sched domain */
 static inline int test_sd_parent(struct sched_domain *sd, int flag)
 {
@@ -1033,7 +1036,7 @@ unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
 struct sched_domain_attr;
 
 static inline void
-partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
+partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 			struct sched_domain_attr *dattr_new)
 {
 }
@@ -1331,7 +1334,9 @@ struct task_struct {
 
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
+#endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
@@ -1720,9 +1725,8 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
-extern cputime_t task_utime(struct task_struct *p);
-extern cputime_t task_stime(struct task_struct *p);
-extern cputime_t task_gtime(struct task_struct *p);
+extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
 /*
  * Per process flags
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b5cb469..3cf2183 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -537,8 +537,7 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
  *	element of the partition (one sched domain) to be passed to
  *	partition_sched_domains().
  */
-/* FIXME: see the FIXME in partition_sched_domains() */
-static int generate_sched_domains(struct cpumask **domains,
+static int generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes)
 {
 	LIST_HEAD(q);		/* queue of cpusets to be scanned */
@@ -546,7 +545,7 @@ static int generate_sched_domains(struct cpumask **domains,
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j, k;		/* indices for partition finding loops */
-	struct cpumask *doms;	/* resulting partition; i.e. sched domains */
+	cpumask_var_t *doms;	/* resulting partition; i.e. sched domains */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
 	int ndoms = 0;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] struct cpumask slot */
@@ -557,7 +556,8 @@ static int generate_sched_domains(struct cpumask **domains,
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
-		doms = kmalloc(cpumask_size(), GFP_KERNEL);
+		ndoms = 1;
+		doms = alloc_sched_domains(ndoms);
 		if (!doms)
 			goto done;
 
@@ -566,9 +566,8 @@ static int generate_sched_domains(struct cpumask **domains,
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		cpumask_copy(doms, top_cpuset.cpus_allowed);
+		cpumask_copy(doms[0], top_cpuset.cpus_allowed);
 
-		ndoms = 1;
 		goto done;
 	}
 
@@ -636,7 +635,7 @@ restart:
 	 * Now we know how many domains to create.
 	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
 	 */
-	doms = kmalloc(ndoms * cpumask_size(), GFP_KERNEL);
+	doms = alloc_sched_domains(ndoms);
 	if (!doms)
 		goto done;
 
@@ -656,7 +655,7 @@ restart:
 			continue;
 		}
 
-		dp = doms + nslot;
+		dp = doms[nslot];
 
 		if (nslot == ndoms) {
 			static int warnings = 10;
@@ -718,7 +717,7 @@ done:
 static void do_rebuild_sched_domains(struct work_struct *unused)
 {
 	struct sched_domain_attr *attr;
-	struct cpumask *doms;
+	cpumask_var_t *doms;
 	int ndoms;
 
 	get_online_cpus();
@@ -2052,7 +2051,7 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 				unsigned long phase, void *unused_cpu)
 {
 	struct sched_domain_attr *attr;
-	struct cpumask *doms;
+	cpumask_var_t *doms;
 	int ndoms;
 
 	switch (phase) {
@@ -2537,15 +2536,9 @@ const struct file_operations proc_cpuset_operations = {
 };
 #endif /* CONFIG_PROC_PID_CPUSET */
 
-/* Display task cpus_allowed, mems_allowed in /proc/<pid>/status file. */
+/* Display task mems_allowed in /proc/<pid>/status file. */
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_printf(m, "Cpus_allowed:\t");
-	seq_cpumask(m, &task->cpus_allowed);
-	seq_printf(m, "\n");
-	seq_printf(m, "Cpus_allowed_list:\t");
-	seq_cpumask_list(m, &task->cpus_allowed);
-	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
 	seq_nodemask(m, &task->mems_allowed);
 	seq_printf(m, "\n");
diff --git a/kernel/exit.c b/kernel/exit.c
index f7864ac..b221ad6 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -110,9 +110,9 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, task_utime(tsk));
-		sig->stime = cputime_add(sig->stime, task_stime(tsk));
-		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
+		sig->utime = cputime_add(sig->utime, tsk->utime);
+		sig->stime = cputime_add(sig->stime, tsk->stime);
+		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
@@ -1205,6 +1205,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;
+		cputime_t tgutime, tgstime;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1220,20 +1221,23 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * need to protect the access to parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
+		 *
+		 * We use thread_group_times() to get times for the thread
+		 * group, which consolidates times for all threads in the
+		 * group including the group leader.
 		 */
+		thread_group_times(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
-			cputime_add(p->utime,
-			cputime_add(sig->utime,
-				    sig->cutime)));
+			cputime_add(tgutime,
+				    sig->cutime));
 		psig->cstime =
 			cputime_add(psig->cstime,
-			cputime_add(p->stime,
-			cputime_add(sig->stime,
-				    sig->cstime)));
+			cputime_add(tgstime,
+				    sig->cstime));
 		psig->cgtime =
 			cputime_add(psig->cgtime,
 			cputime_add(p->gtime,
diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..3d6f121 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -884,6 +884,9 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
 	sig->cgtime = cputime_zero;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	sig->prev_utime = sig->prev_stime = cputime_zero;
+#endif
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
@@ -1066,8 +1069,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->gtime = cputime_zero;
 	p->utimescaled = cputime_zero;
 	p->stimescaled = cputime_zero;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
+#endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 9147a31..7d70146 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -870,7 +870,7 @@ static void gdb_cmd_getregs(struct kgdb_state *ks)
 
 	/*
 	 * All threads that don't have debuggerinfo should be
-	 * in __schedule() sleeping, since all other CPUs
+	 * in schedule() sleeping, since all other CPUs
 	 * are in kgdb_wait, and thus have debuggerinfo.
 	 */
 	if (local_debuggerinfo) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..e6ba726 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -535,14 +535,12 @@ struct rq {
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 #ifdef CONFIG_NO_HZ
-	unsigned long last_tick_seen;
 	unsigned char in_nohz_recently;
 #endif
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
 	unsigned long nr_load_updates;
 	u64 nr_switches;
-	u64 nr_migrations_in;
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
@@ -591,6 +589,8 @@ struct rq {
 
 	u64 rt_avg;
 	u64 age_stamp;
+	u64 idle_stamp;
+	u64 avg_idle;
 #endif
 
 	/* calc_load related fields */
@@ -772,7 +772,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	if (!sched_feat_names[i])
 		return -EINVAL;
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
@@ -2017,6 +2017,7 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
 	}
 
 	spin_lock_irqsave(&rq->lock, flags);
+	update_rq_clock(rq);
 	set_task_cpu(p, cpu);
 	p->cpus_allowed = cpumask_of_cpu(cpu);
 	p->rt.nr_cpus_allowed = 1;
@@ -2078,7 +2079,6 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 #endif
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
-		new_rq->nr_migrations_in++;
 #ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
@@ -2115,6 +2115,7 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 	 * it is sufficient to simply update the task's cpu field.
 	 */
 	if (!p->se.on_rq && !task_running(rq, p)) {
+		update_rq_clock(rq);
 		set_task_cpu(p, dest_cpu);
 		return 0;
 	}
@@ -2376,14 +2377,15 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	task_rq_unlock(rq, &flags);
 
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
+	if (cpu != orig_cpu) {
+		local_irq_save(flags);
+		rq = cpu_rq(cpu);
+		update_rq_clock(rq);
 		set_task_cpu(p, cpu);
-
+		local_irq_restore(flags);
+	}
 	rq = task_rq_lock(p, &flags);
 
-	if (rq != orig_rq)
-		update_rq_clock(rq);
-
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
@@ -2440,6 +2442,17 @@ out_running:
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
+
+	if (unlikely(rq->idle_stamp)) {
+		u64 delta = rq->clock - rq->idle_stamp;
+		u64 max = 2*sysctl_sched_migration_cost;
+
+		if (delta > max)
+			rq->avg_idle = max;
+		else
+			update_avg(&rq->avg_idle, delta);
+		rq->idle_stamp = 0;
+	}
 #endif
 out:
 	task_rq_unlock(rq, &flags);
@@ -2545,6 +2558,7 @@ static void __sched_fork(struct task_struct *p)
 void sched_fork(struct task_struct *p, int clone_flags)
 {
 	int cpu = get_cpu();
+	unsigned long flags;
 
 	__sched_fork(p);
 
@@ -2581,7 +2595,10 @@ void sched_fork(struct task_struct *p, int clone_flags)
 #ifdef CONFIG_SMP
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
 #endif
+	local_irq_save(flags);
+	update_rq_clock(cpu_rq(cpu));
 	set_task_cpu(p, cpu);
+	local_irq_restore(flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
@@ -2848,14 +2865,14 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 */
 	arch_start_context_switch(prev);
 
-	if (unlikely(!mm)) {
+	if (likely(!mm)) {
 		next->active_mm = oldmm;
 		atomic_inc(&oldmm->mm_count);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm(oldmm, mm, next);
 
-	if (unlikely(!prev->mm)) {
+	if (likely(!prev->mm)) {
 		prev->active_mm = NULL;
 		rq->prev_mm = oldmm;
 	}
@@ -3018,15 +3035,6 @@ static void calc_load_account_active(struct rq *this_rq)
 }
 
 /*
- * Externally visible per-cpu scheduler statistics:
- * cpu_nr_migrations(cpu) - number of migrations into that cpu
- */
-u64 cpu_nr_migrations(int cpu)
-{
-	return cpu_rq(cpu)->nr_migrations_in;
-}
-
-/*
  * Update rq->cpu_load[] statistics. This function is usually called every
  * scheduler tick (TICK_NSEC).
  */
@@ -4126,7 +4134,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4289,7 +4297,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	int all_pinned = 0;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_setall(cpus);
+	cpumask_copy(cpus, cpu_online_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4429,6 +4437,11 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 
+	this_rq->idle_stamp = this_rq->clock;
+
+	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+		return;
+
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 
@@ -4443,8 +4456,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task)
+		if (pulled_task) {
+			this_rq->idle_stamp = 0;
 			break;
+		}
 	}
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -5046,8 +5061,13 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	p->gtime = cputime_add(p->gtime, cputime);
 
 	/* Add guest time to cpustat. */
-	cpustat->user = cputime64_add(cpustat->user, tmp);
-	cpustat->guest = cputime64_add(cpustat->guest, tmp);
+	if (TASK_NICE(p) > 0) {
+		cpustat->nice = cputime64_add(cpustat->nice, tmp);
+		cpustat->guest_nice = cputime64_add(cpustat->guest_nice, tmp);
+	} else {
+		cpustat->user = cputime64_add(cpustat->user, tmp);
+		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+	}
 }
 
 /*
@@ -5162,60 +5182,86 @@ void account_idle_ticks(unsigned long ticks)
  * Use precise platform statistics if available:
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-cputime_t task_utime(struct task_struct *p)
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	return p->utime;
+	*ut = p->utime;
+	*st = p->stime;
 }
 
-cputime_t task_stime(struct task_struct *p)
+void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	return p->stime;
+	struct task_cputime cputime;
+
+	thread_group_cputime(p, &cputime);
+
+	*ut = cputime.utime;
+	*st = cputime.stime;
 }
 #else
-cputime_t task_utime(struct task_struct *p)
+
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
+#endif
+
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	clock_t utime = cputime_to_clock_t(p->utime),
-		total = utime + cputime_to_clock_t(p->stime);
-	u64 temp;
+	cputime_t rtime, utime = p->utime, total = cputime_add(utime, p->stime);
 
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
+	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		temp *= utime;
+		u64 temp;
+
+		temp = (u64)(rtime * utime);
 		do_div(temp, total);
-	}
-	utime = (clock_t)temp;
+		utime = (cputime_t)temp;
+	} else
+		utime = rtime;
+
+	/*
+	 * Compare with previous values, to keep monotonicity:
+	 */
+	p->prev_utime = max(p->prev_utime, utime);
+	p->prev_stime = max(p->prev_stime, cputime_sub(rtime, p->prev_utime));
 
-	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
-	return p->prev_utime;
+	*ut = p->prev_utime;
+	*st = p->prev_stime;
 }
 
-cputime_t task_stime(struct task_struct *p)
+/*
+ * Must be called with siglock held.
+ */
+void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	clock_t stime;
+	struct signal_struct *sig = p->signal;
+	struct task_cputime cputime;
+	cputime_t rtime, utime, total;
 
-	/*
-	 * Use CFS's precise accounting. (we subtract utime from
-	 * the total, to make sure the total observed by userspace
-	 * grows monotonically - apps rely on that):
-	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
-			cputime_to_clock_t(task_utime(p));
+	thread_group_cputime(p, &cputime);
 
-	if (stime >= 0)
-		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+	total = cputime_add(cputime.utime, cputime.stime);
+	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
-	return p->prev_stime;
-}
-#endif
+	if (total) {
+		u64 temp;
 
-inline cputime_t task_gtime(struct task_struct *p)
-{
-	return p->gtime;
+		temp = (u64)(rtime * cputime.utime);
+		do_div(temp, total);
+		utime = (cputime_t)temp;
+	} else
+		utime = rtime;
+
+	sig->prev_utime = max(sig->prev_utime, utime);
+	sig->prev_stime = max(sig->prev_stime,
+			      cputime_sub(rtime, sig->prev_utime));
+
+	*ut = sig->prev_utime;
+	*st = sig->prev_stime;
 }
+#endif
 
 /*
  * This function gets called by the timer code, with HZ frequency.
@@ -6175,22 +6221,14 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 	BUG_ON(p->se.on_rq);
 
 	p->policy = policy;
-	switch (p->policy) {
-	case SCHED_NORMAL:
-	case SCHED_BATCH:
-	case SCHED_IDLE:
-		p->sched_class = &fair_sched_class;
-		break;
-	case SCHED_FIFO:
-	case SCHED_RR:
-		p->sched_class = &rt_sched_class;
-		break;
-	}
-
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
+	if (rt_prio(p->prio))
+		p->sched_class = &rt_sched_class;
+	else
+		p->sched_class = &fair_sched_class;
 	set_load_weight(p);
 }
 
@@ -6935,7 +6973,7 @@ void show_state_filter(unsigned long state_filter)
 	/*
 	 * Only show locks if all tasks are dumped:
 	 */
-	if (state_filter == -1)
+	if (!state_filter)
 		debug_show_all_locks();
 }
 
@@ -7740,6 +7778,16 @@ early_initcall(migration_init);
 
 #ifdef CONFIG_SCHED_DEBUG
 
+static __read_mostly int sched_domain_debug_enabled;
+
+static int __init sched_domain_debug_setup(char *str)
+{
+	sched_domain_debug_enabled = 1;
+
+	return 0;
+}
+early_param("sched_debug", sched_domain_debug_setup);
+
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
 {
@@ -7826,6 +7874,9 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 	cpumask_var_t groupmask;
 	int level = 0;
 
+	if (!sched_domain_debug_enabled)
+		return;
+
 	if (!sd) {
 		printk(KERN_DEBUG "CPU%d attaching NULL sched-domain.\n", cpu);
 		return;
@@ -7905,6 +7956,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 
 static void free_rootdomain(struct root_domain *rd)
 {
+	synchronize_sched();
+
 	cpupri_cleanup(&rd->cpupri);
 
 	free_cpumask_var(rd->rto_mask);
@@ -8045,6 +8098,7 @@ static cpumask_var_t cpu_isolated_map;
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
+	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 	cpulist_parse(str, cpu_isolated_map);
 	return 1;
 }
@@ -8881,7 +8935,7 @@ static int build_sched_domains(const struct cpumask *cpu_map)
 	return __build_sched_domains(cpu_map, NULL);
 }
 
-static struct cpumask *doms_cur;	/* current sched domains */
+static cpumask_var_t *doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 static struct sched_domain_attr *dattr_cur;
 				/* attribues of custom domains in 'doms_cur' */
@@ -8903,6 +8957,31 @@ int __attribute__((weak)) arch_update_cpu_topology(void)
 	return 0;
 }
 
+cpumask_var_t *alloc_sched_domains(unsigned int ndoms)
+{
+	int i;
+	cpumask_var_t *doms;
+
+	doms = kmalloc(sizeof(*doms) * ndoms, GFP_KERNEL);
+	if (!doms)
+		return NULL;
+	for (i = 0; i < ndoms; i++) {
+		if (!alloc_cpumask_var(&doms[i], GFP_KERNEL)) {
+			free_sched_domains(doms, i);
+			return NULL;
+		}
+	}
+	return doms;
+}
+
+void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms)
+{
+	unsigned int i;
+	for (i = 0; i < ndoms; i++)
+		free_cpumask_var(doms[i]);
+	kfree(doms);
+}
+
 /*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
@@ -8914,12 +8993,12 @@ static int arch_init_sched_domains(const struct cpumask *cpu_map)
 
 	arch_update_cpu_topology();
 	ndoms_cur = 1;
-	doms_cur = kmalloc(cpumask_size(), GFP_KERNEL);
+	doms_cur = alloc_sched_domains(ndoms_cur);
 	if (!doms_cur)
-		doms_cur = fallback_doms;
-	cpumask_andnot(doms_cur, cpu_map, cpu_isolated_map);
+		doms_cur = &fallback_doms;
+	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
-	err = build_sched_domains(doms_cur);
+	err = build_sched_domains(doms_cur[0]);
 	register_sched_domain_sysctl();
 
 	return err;
@@ -8969,19 +9048,19 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * doms_new[] to the current sched domain partitioning, doms_cur[].
  * It destroys each deleted domain and builds each new domain.
  *
- * 'doms_new' is an array of cpumask's of length 'ndoms_new'.
+ * 'doms_new' is an array of cpumask_var_t's of length 'ndoms_new'.
  * The masks don't intersect (don't overlap.) We should setup one
  * sched domain for each mask. CPUs not in any of the cpumasks will
  * not be load balanced. If the same cpumask appears both in the
  * current 'doms_cur' domains and in the new 'doms_new', we can leave
  * it as it is.
  *
- * The passed in 'doms_new' should be kmalloc'd. This routine takes
- * ownership of it and will kfree it when done with it. If the caller
- * failed the kmalloc call, then it can pass in doms_new == NULL &&
- * ndoms_new == 1, and partition_sched_domains() will fallback to
- * the single partition 'fallback_doms', it also forces the domains
- * to be rebuilt.
+ * The passed in 'doms_new' should be allocated using
+ * alloc_sched_domains.  This routine takes ownership of it and will
+ * free_sched_domains it when done with it. If the caller failed the
+ * alloc call, then it can pass in doms_new == NULL && ndoms_new == 1,
+ * and partition_sched_domains() will fallback to the single partition
+ * 'fallback_doms', it also forces the domains to be rebuilt.
  *
  * If doms_new == NULL it will be replaced with cpu_online_mask.
  * ndoms_new == 0 is a special case for destroying existing domains,
@@ -8989,8 +9068,7 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  *
  * Call with hotplug lock held
  */
-/* FIXME: Change to struct cpumask *doms_new[] */
-void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
+void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 			     struct sched_domain_attr *dattr_new)
 {
 	int i, j, n;
@@ -9009,40 +9087,40 @@ void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < n && !new_topology; j++) {
-			if (cpumask_equal(&doms_cur[i], &doms_new[j])
+			if (cpumask_equal(doms_cur[i], doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
 		}
 		/* no match - a current sched domain not in new doms_new[] */
-		detach_destroy_domains(doms_cur + i);
+		detach_destroy_domains(doms_cur[i]);
 match1:
 		;
 	}
 
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
-		doms_new = fallback_doms;
-		cpumask_andnot(&doms_new[0], cpu_online_mask, cpu_isolated_map);
+		doms_new = &fallback_doms;
+		cpumask_andnot(doms_new[0], cpu_online_mask, cpu_isolated_map);
 		WARN_ON_ONCE(dattr_new);
 	}
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur && !new_topology; j++) {
-			if (cpumask_equal(&doms_new[i], &doms_cur[j])
+			if (cpumask_equal(doms_new[i], doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
 		}
 		/* no match - add a new doms_new */
-		__build_sched_domains(doms_new + i,
+		__build_sched_domains(doms_new[i],
 					dattr_new ? dattr_new + i : NULL);
 match2:
 		;
 	}
 
 	/* Remember the new sched domains */
-	if (doms_cur != fallback_doms)
-		kfree(doms_cur);
+	if (doms_cur != &fallback_doms)
+		free_sched_domains(doms_cur, ndoms_cur);
 	kfree(dattr_cur);	/* kfree(NULL) is safe */
 	doms_cur = doms_new;
 	dattr_cur = dattr_new;
@@ -9364,10 +9442,6 @@ void __init sched_init(void)
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
-	/*
-	 * As sched_init() is called before page_alloc is setup,
-	 * we use alloc_bootmem().
-	 */
 	if (alloc_size) {
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
@@ -9522,6 +9596,8 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->online = 0;
 		rq->migration_thread = NULL;
+		rq->idle_stamp = 0;
+		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
 #endif
@@ -9571,7 +9647,9 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	/* May be allocated at isolcpus cmdline parse time */
+	if (cpu_isolated_map == NULL)
+		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	perf_event_init();
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index efb8440..6988cf0 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -285,12 +285,16 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
+#define P64(n) SEQ_printf(m, "  .%-30s: %Ld\n", #n, rq->n);
 
 	P(yld_count);
 
 	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
+#ifdef CONFIG_SMP
+	P64(avg_idle);
+#endif
 
 	P(ttwu_count);
 	P(ttwu_local);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37087a7..f61837a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1345,6 +1345,37 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 }
 
 /*
+ * Try and locate an idle CPU in the sched_domain.
+ */
+static int
+select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+{
+	int cpu = smp_processor_id();
+	int prev_cpu = task_cpu(p);
+	int i;
+
+	/*
+	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
+	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
+	 * always a better target than the current cpu.
+	 */
+	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
+		return prev_cpu;
+
+	/*
+	 * Otherwise, iterate the domain and find an elegible idle cpu.
+	 */
+	for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+		if (!cpu_rq(i)->cfs.nr_running) {
+			target = i;
+			break;
+		}
+	}
+
+	return target;
+}
+
+/*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
@@ -1398,11 +1429,35 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				want_sd = 0;
 		}
 
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
+		/*
+		 * While iterating the domains looking for a spanning
+		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
+		 * in cache sharing domains along the way.
+		 */
+		if (want_affine) {
+			int target = -1;
 
-			affine_sd = tmp;
-			want_affine = 0;
+			/*
+			 * If both cpu and prev_cpu are part of this domain,
+			 * cpu is a valid SD_WAKE_AFFINE target.
+			 */
+			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
+				target = cpu;
+
+			/*
+			 * If there's an idle sibling in this domain, make that
+			 * the wake_affine target instead of the current cpu.
+			 */
+			if (tmp->flags & SD_PREFER_SIBLING)
+				target = select_idle_sibling(p, tmp, target);
+
+			if (target >= 0) {
+				if (tmp->flags & SD_WAKE_AFFINE) {
+					affine_sd = tmp;
+					want_affine = 0;
+				}
+				cpu = target;
+			}
 		}
 
 		if (!want_sd && !want_affine)
@@ -1679,7 +1734,7 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 
-	if (unlikely(!cfs_rq->nr_running))
+	if (!cfs_rq->nr_running)
 		return NULL;
 
 	do {
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..5c5fef3 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1153,29 +1153,12 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
-static inline int pick_optimal_cpu(int this_cpu,
-				   const struct cpumask *mask)
-{
-	int first;
-
-	/* "this_cpu" is cheaper to preempt than a remote processor */
-	if ((this_cpu != -1) && cpumask_test_cpu(this_cpu, mask))
-		return this_cpu;
-
-	first = cpumask_first(mask);
-	if (first < nr_cpu_ids)
-		return first;
-
-	return -1;
-}
-
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
 	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
-	cpumask_var_t domain_mask;
 
 	if (task->rt.nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
@@ -1198,28 +1181,26 @@ static int find_lowest_rq(struct task_struct *task)
 	 * Otherwise, we consult the sched_domains span maps to figure
 	 * out which cpu is logically closest to our hot cache data.
 	 */
-	if (this_cpu == cpu)
-		this_cpu = -1; /* Skip this_cpu opt if the same */
-
-	if (alloc_cpumask_var(&domain_mask, GFP_ATOMIC)) {
-		for_each_domain(cpu, sd) {
-			if (sd->flags & SD_WAKE_AFFINE) {
-				int best_cpu;
+	if (!cpumask_test_cpu(this_cpu, lowest_mask))
+		this_cpu = -1; /* Skip this_cpu opt if not among lowest */
 
-				cpumask_and(domain_mask,
-					    sched_domain_span(sd),
-					    lowest_mask);
+	for_each_domain(cpu, sd) {
+		if (sd->flags & SD_WAKE_AFFINE) {
+			int best_cpu;
 
-				best_cpu = pick_optimal_cpu(this_cpu,
-							    domain_mask);
-
-				if (best_cpu != -1) {
-					free_cpumask_var(domain_mask);
-					return best_cpu;
-				}
-			}
+			/*
+			 * "this_cpu" is cheaper to preempt than a
+			 * remote processor.
+			 */
+			if (this_cpu != -1 &&
+			    cpumask_test_cpu(this_cpu, sched_domain_span(sd)))
+				return this_cpu;
+
+			best_cpu = cpumask_first_and(lowest_mask,
+						     sched_domain_span(sd));
+			if (best_cpu < nr_cpu_ids)
+				return best_cpu;
 		}
-		free_cpumask_var(domain_mask);
 	}
 
 	/*
@@ -1227,7 +1208,13 @@ static int find_lowest_rq(struct task_struct *task)
 	 * just give the caller *something* to work with from the compatible
 	 * locations.
 	 */
-	return pick_optimal_cpu(this_cpu, lowest_mask);
+	if (this_cpu != -1)
+		return this_cpu;
+
+	cpu = cpumask_any(lowest_mask);
+	if (cpu < nr_cpu_ids)
+		return cpu;
+	return -1;
 }
 
 /* Will lock the rq it finds */
diff --git a/kernel/sys.c b/kernel/sys.c
index ce17760..9968c5f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -911,16 +911,15 @@ change_okay:
 
 void do_sys_times(struct tms *tms)
 {
-	struct task_cputime cputime;
-	cputime_t cutime, cstime;
+	cputime_t tgutime, tgstime, cutime, cstime;
 
-	thread_group_cputime(current, &cputime);
 	spin_lock_irq(&current->sighand->siglock);
+	thread_group_times(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
-	tms->tms_utime = cputime_to_clock_t(cputime.utime);
-	tms->tms_stime = cputime_to_clock_t(cputime.stime);
+	tms->tms_utime = cputime_to_clock_t(tgutime);
+	tms->tms_stime = cputime_to_clock_t(tgstime);
 	tms->tms_cutime = cputime_to_clock_t(cutime);
 	tms->tms_cstime = cputime_to_clock_t(cstime);
 }
@@ -1338,16 +1337,14 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 {
 	struct task_struct *t;
 	unsigned long flags;
-	cputime_t utime, stime;
-	struct task_cputime cputime;
+	cputime_t tgutime, tgstime, utime, stime;
 	unsigned long maxrss = 0;
 
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
 
 	if (who == RUSAGE_THREAD) {
-		utime = task_utime(current);
-		stime = task_stime(current);
+		task_times(current, &utime, &stime);
 		accumulate_thread_rusage(p, r);
 		maxrss = p->signal->maxrss;
 		goto out;
@@ -1373,9 +1370,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_cputime(p, &cputime);
-			utime = cputime_add(utime, cputime.utime);
-			stime = cputime_add(stime, cputime.stime);
+			thread_group_times(p, &tgutime, &tgstime);
+			utime = cputime_add(utime, tgutime);
+			stime = cputime_add(stime, tgstime);
 			r->ru_nvcsw += p->signal->nvcsw;
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
diff --git a/kernel/time.c b/kernel/time.c
index 2e2e469..8047980 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -662,6 +662,36 @@ u64 nsec_to_clock_t(u64 x)
 #endif
 }
 
+/**
+ * nsecs_to_jiffies - Convert nsecs in u64 to jiffies
+ *
+ * @n:	nsecs in u64
+ *
+ * Unlike {m,u}secs_to_jiffies, type of input is not unsigned int but u64.
+ * And this doesn't return MAX_JIFFY_OFFSET since this function is designed
+ * for scheduler, not for use in device drivers to calculate timeout value.
+ *
+ * note:
+ *   NSEC_PER_SEC = 10^9 = (5^9 * 2^9) = (1953125 * 512)
+ *   ULLONG_MAX ns = 18446744073.709551615 secs = about 584 years
+ */
+unsigned long nsecs_to_jiffies(u64 n)
+{
+#if (NSEC_PER_SEC % HZ) == 0
+	/* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
+	return div_u64(n, NSEC_PER_SEC / HZ);
+#elif (HZ % 512) == 0
+	/* overflow after 292 years if HZ = 1024 */
+	return div_u64(n * HZ / 512, NSEC_PER_SEC / 512);
+#else
+	/*
+	 * Generic case - optimized for cases where HZ is a multiple of 3.
+	 * overflow after 64.99 years, exact for HZ = 60, 72, 90, 120 etc.
+	 */
+	return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
+#endif
+}
+
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
 {
