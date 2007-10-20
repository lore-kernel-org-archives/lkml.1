Return-Path: <linux-kernel-owner+w=401wt.eu-S1751201AbXJUBcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbXJUBcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbXJUBcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:32:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:60716 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXJUBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:32:41 -0400
Date: Sun, 21 Oct 2007 03:56:19 +0400
To: torvalds@osdl.org, akpm@osdl.org, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 2/2] irq_flags_t: annotate kernel/
Message-ID: <20071020235619.GC1825@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/sched.h        |    4 +-
 kernel/audit.c               |   10 +++---
 kernel/cpu_acct.c            |    2 -
 kernel/delayacct.c           |    6 +--
 kernel/hrtimer.c             |   16 ++++-----
 kernel/irq/chip.c            |   16 ++++-----
 kernel/irq/manage.c          |   12 +++----
 kernel/irq/migration.c       |    2 -
 kernel/irq/proc.c            |    2 -
 kernel/latency.c             |    6 +--
 kernel/mutex.c               |    6 +--
 kernel/notifier.c            |    4 +-
 kernel/panic.c               |    2 -
 kernel/pid.c                 |    2 -
 kernel/posix-cpu-timers.c    |    2 -
 kernel/posix-timers.c        |   24 +++++++-------
 kernel/power/process.c       |    4 +-
 kernel/printk.c              |   10 +++---
 kernel/profile.c             |    3 +
 kernel/ptrace.c              |    2 -
 kernel/rcupdate.c            |    4 +-
 kernel/rtmutex.c             |   14 ++++----
 kernel/sched.c               |   54 ++++++++++++++++-----------------
 kernel/sched_debug.c         |    4 +-
 kernel/signal.c              |   28 ++++++++---------
 kernel/softirq.c             |    8 ++--
 kernel/sys.c                 |    2 -
 kernel/taskstats.c           |    4 +-
 kernel/time/clockevents.c    |    2 -
 kernel/time/clocksource.c    |   12 +++----
 kernel/time/tick-broadcast.c |   17 +++++-----
 kernel/time/tick-common.c    |    8 ++--
 kernel/time/tick-sched.c     |    5 +--
 kernel/time/timekeeping.c    |    8 ++--
 kernel/time/timer_list.c     |    2 -
 kernel/time/timer_stats.c    |    4 +-
 kernel/timer.c               |   10 +++---
 kernel/user.c                |   12 +++----
 kernel/wait.c                |   12 +++----
 kernel/workqueue.c           |    2 -
 40 files changed, 175 insertions(+), 172 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1767,10 +1767,10 @@ static inline void task_unlock(struct task_struct *p)
 }
 
 extern struct sighand_struct *lock_task_sighand(struct task_struct *tsk,
-							unsigned long *flags);
+							irq_flags_t *flags);
 
 static inline void unlock_task_sighand(struct task_struct *tsk,
-						unsigned long *flags)
+						irq_flags_t *flags)
 {
 	spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
 }
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -176,7 +176,7 @@ static inline int audit_rate_check(void)
 	static unsigned long	last_check = 0;
 	static int		messages   = 0;
 	static DEFINE_SPINLOCK(lock);
-	unsigned long		flags;
+	irq_flags_t		flags;
 	unsigned long		now;
 	unsigned long		elapsed;
 	int			retval	   = 0;
@@ -212,7 +212,7 @@ void audit_log_lost(const char *message)
 {
 	static unsigned long	last_msg = 0;
 	static DEFINE_SPINLOCK(lock);
-	unsigned long		flags;
+	irq_flags_t		flags;
 	unsigned long		now;
 	int			print;
 
@@ -914,7 +914,7 @@ __setup("audit=", audit_enable);
 
 static void audit_buffer_free(struct audit_buffer *ab)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (!ab)
 		return;
@@ -935,7 +935,7 @@ static void audit_buffer_free(struct audit_buffer *ab)
 static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
 						gfp_t gfp_mask, int type)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	struct audit_buffer *ab = NULL;
 	struct nlmsghdr *nlh;
 
@@ -993,7 +993,7 @@ unsigned int audit_serial(void)
 	static DEFINE_SPINLOCK(serial_lock);
 	static unsigned int serial = 0;
 
-	unsigned long flags;
+	irq_flags_t flags;
 	unsigned int ret;
 
 	spin_lock_irqsave(&serial_lock, flags);
--- a/kernel/cpu_acct.c
+++ b/kernel/cpu_acct.c
@@ -160,7 +160,7 @@ void cpuacct_charge(struct task_struct *task, cputime_t cputime)
 {
 
 	struct cpuacct *ca;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (!cpuacct_subsys.active)
 		return;
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -62,7 +62,7 @@ static void delayacct_end(struct timespec *start, struct timespec *end,
 {
 	struct timespec ts;
 	s64 ns;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	do_posix_clock_monotonic_gettime(end);
 	ts = timespec_sub(*end, *start);
@@ -101,7 +101,7 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	s64 tmp;
 	unsigned long t1;
 	unsigned long long t2, t3;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct timespec ts;
 
 	/* Though tsk->delays accessed later, early exit avoids
@@ -156,7 +156,7 @@ done:
 __u64 __delayacct_blkio_ticks(struct task_struct *tsk)
 {
 	__u64 ret;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&tsk->delays->lock, flags);
 	ret = nsec_to_clock_t(tsk->delays->blkio_delay +
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -181,7 +181,7 @@ static inline int hrtimer_callback_running(struct hrtimer *timer)
  */
 static
 struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
-					     unsigned long *flags)
+					     irq_flags_t *flags)
 {
 	struct hrtimer_clock_base *base;
 
@@ -235,7 +235,7 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base)
 #else /* CONFIG_SMP */
 
 static inline struct hrtimer_clock_base *
-lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
+lock_hrtimer_base(const struct hrtimer *timer, irq_flags_t *flags)
 {
 	struct hrtimer_clock_base *base = timer->base;
 
@@ -580,7 +580,7 @@ static int hrtimer_switch_to_hres(void)
 {
 	int cpu = smp_processor_id();
 	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (base->hres_active)
 		return 1;
@@ -641,7 +641,7 @@ void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
  * Counterpart to lock_hrtimer_base above:
  */
 static inline
-void unlock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
+void unlock_hrtimer_base(const struct hrtimer *timer, irq_flags_t *flags)
 {
 	spin_unlock_irqrestore(&timer->base->cpu_base->lock, *flags);
 }
@@ -827,7 +827,7 @@ int
 hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 {
 	struct hrtimer_clock_base *base, *new_base;
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret;
 
 	base = lock_hrtimer_base(timer, &flags);
@@ -881,7 +881,7 @@ EXPORT_SYMBOL_GPL(hrtimer_start);
 int hrtimer_try_to_cancel(struct hrtimer *timer)
 {
 	struct hrtimer_clock_base *base;
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = -1;
 
 	base = lock_hrtimer_base(timer, &flags);
@@ -923,7 +923,7 @@ EXPORT_SYMBOL_GPL(hrtimer_cancel);
 ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 {
 	struct hrtimer_clock_base *base;
-	unsigned long flags;
+	irq_flags_t flags;
 	ktime_t rem;
 
 	base = lock_hrtimer_base(timer, &flags);
@@ -946,7 +946,7 @@ ktime_t hrtimer_get_next_event(void)
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
-	unsigned long flags;
+	irq_flags_t flags;
 	int i;
 
 	spin_lock_irqsave(&cpu_base->lock, flags);
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -25,7 +25,7 @@
 void dynamic_irq_init(unsigned int irq)
 {
 	struct irq_desc *desc;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
@@ -59,7 +59,7 @@ void dynamic_irq_init(unsigned int irq)
 void dynamic_irq_cleanup(unsigned int irq)
 {
 	struct irq_desc *desc;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
@@ -93,7 +93,7 @@ void dynamic_irq_cleanup(unsigned int irq)
 int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 {
 	struct irq_desc *desc;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_ERR "Trying to install chip for IRQ%d\n", irq);
@@ -122,7 +122,7 @@ EXPORT_SYMBOL(set_irq_chip);
 int set_irq_type(unsigned int irq, unsigned int type)
 {
 	struct irq_desc *desc;
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = -ENXIO;
 
 	if (irq >= NR_IRQS) {
@@ -150,7 +150,7 @@ EXPORT_SYMBOL(set_irq_type);
 int set_irq_data(unsigned int irq, void *data)
 {
 	struct irq_desc *desc;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_ERR
@@ -176,7 +176,7 @@ EXPORT_SYMBOL(set_irq_data);
 int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 {
 	struct irq_desc *desc;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_ERR
@@ -202,7 +202,7 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 int set_irq_chip_data(unsigned int irq, void *data)
 {
 	struct irq_desc *desc = irq_desc + irq;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS || !desc->chip) {
 		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
@@ -533,7 +533,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
 {
 	struct irq_desc *desc;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_ERR
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -94,7 +94,7 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 void disable_irq_nosync(unsigned int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS)
 		return;
@@ -146,7 +146,7 @@ EXPORT_SYMBOL(disable_irq);
 void enable_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (irq >= NR_IRQS)
 		return;
@@ -187,7 +187,7 @@ EXPORT_SYMBOL(enable_irq);
 int set_irq_wake(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_desc + irq;
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = -ENXIO;
 	int (*set_wake)(unsigned, unsigned) = desc->chip->set_wake;
 
@@ -257,7 +257,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	struct irq_desc *desc = irq_desc + irq;
 	struct irqaction *old, **p;
 	const char *old_name = NULL;
-	unsigned long flags;
+	irq_flags_t flags;
 	int shared = 0;
 
 	if (irq >= NR_IRQS)
@@ -404,7 +404,7 @@ void free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc;
 	struct irqaction **p;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	WARN_ON(in_interrupt());
 	if (irq >= NR_IRQS)
@@ -546,7 +546,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 		 * We do this before actually registering it, to make sure that
 		 * a 'real' IRQ doesn't run in parallel with our fake
 		 */
-		unsigned long flags;
+		irq_flags_t flags;
 
 		local_irq_save(flags);
 		handler(irq, dev_id);
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -4,7 +4,7 @@
 void set_pending_irq(unsigned int irq, cpumask_t mask)
 {
 	struct irq_desc *desc = irq_desc + irq;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_MOVE_PENDING;
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -81,7 +81,7 @@ static int name_unique(unsigned int irq, struct irqaction *new_action)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	struct irqaction *action;
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = 1;
 
 	spin_lock_irqsave(&desc->lock, flags);
--- a/kernel/latency.c
+++ b/kernel/latency.c
@@ -90,7 +90,7 @@ static int __find_max_latency(void)
 void set_acceptable_latency(char *identifier, int usecs)
 {
 	struct latency_info *info, *iter;
-	unsigned long flags;
+	irq_flags_t flags;
 	int found_old = 0;
 
 	info = kzalloc(sizeof(struct latency_info), GFP_KERNEL);
@@ -152,7 +152,7 @@ EXPORT_SYMBOL_GPL(set_acceptable_latency);
 void modify_acceptable_latency(char *identifier, int usecs)
 {
 	struct latency_info *iter;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&latency_lock, flags);
 	list_for_each_entry(iter, &latency_list, list) {
@@ -180,7 +180,7 @@ EXPORT_SYMBOL_GPL(modify_acceptable_latency);
  */
 void remove_acceptable_latency(char *identifier)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int newmax = 0;
 	struct latency_info *iter, *temp;
 
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -130,7 +130,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned int old_val;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_mutex(&lock->wait_lock, flags);
 
@@ -227,7 +227,7 @@ static fastcall inline void
 __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_mutex(&lock->wait_lock, flags);
 	mutex_release(&lock->dep_map, nested, _RET_IP_);
@@ -318,7 +318,7 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
 static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
-	unsigned long flags;
+	irq_flags_t flags;
 	int prev;
 
 	spin_lock_mutex(&lock->wait_lock, flags);
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -96,7 +96,7 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 int atomic_notifier_chain_register(struct atomic_notifier_head *nh,
 		struct notifier_block *n)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret;
 
 	spin_lock_irqsave(&nh->lock, flags);
@@ -118,7 +118,7 @@ EXPORT_SYMBOL_GPL(atomic_notifier_chain_register);
 int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
 		struct notifier_block *n)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret;
 
 	spin_lock_irqsave(&nh->lock, flags);
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -204,7 +204,7 @@ static void spin_msec(int msecs)
  */
 static void do_oops_enter_exit(void)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	static int spin_counter;
 
 	if (!pause_on_oops)
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -225,7 +225,7 @@ fastcall void free_pid(struct pid *pid)
 {
 	/* We can be called with write_lock_irq(&tasklist_lock) held */
 	int i;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&pidmap_lock, flags);
 	for (i = 0; i <= pid->level; i++)
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -266,7 +266,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 				  union cpu_time_count *cpu)
 {
 	int ret;
-	unsigned long flags;
+	irq_flags_t flags;
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 	ret = cpu_clock_sample_group_locked(CPUCLOCK_WHICH(which_clock), p,
 					    cpu);
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -146,9 +146,9 @@ static int common_timer_del(struct k_itimer *timer);
 
 static enum hrtimer_restart posix_timer_fn(struct hrtimer *data);
 
-static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags);
+static struct k_itimer *lock_timer(timer_t timer_id, irq_flags_t *flags);
 
-static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
+static inline void unlock_timer(struct k_itimer *timr, irq_flags_t flags)
 {
 	spin_unlock_irqrestore(&timr->it_lock, flags);
 }
@@ -279,7 +279,7 @@ static void schedule_next_timer(struct k_itimer *timr)
 void do_schedule_next_timer(struct siginfo *info)
 {
 	struct k_itimer *timr;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	timr = lock_timer(info->si_tid, &flags);
 
@@ -337,7 +337,7 @@ EXPORT_SYMBOL_GPL(posix_timer_event);
 static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 {
 	struct k_itimer *timr;
-	unsigned long flags;
+	irq_flags_t flags;
 	int si_private = 0;
 	enum hrtimer_restart ret = HRTIMER_NORESTART;
 
@@ -445,7 +445,7 @@ static struct k_itimer * alloc_posix_timer(void)
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
 	if (it_id_set) {
-		unsigned long flags;
+		irq_flags_t flags;
 		spin_lock_irqsave(&idr_lock, flags);
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
@@ -468,7 +468,7 @@ sys_timer_create(const clockid_t which_clock,
 	struct k_itimer *new_timer = NULL;
 	int new_timer_id;
 	struct task_struct *process = NULL;
-	unsigned long flags;
+	irq_flags_t flags;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
@@ -593,7 +593,7 @@ out:
  * the find to the timer lock.  To avoid a dead lock, the timer id MUST
  * be release with out holding the timer lock.
  */
-static struct k_itimer * lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer * lock_timer(timer_t timer_id, irq_flags_t *flags)
 {
 	struct k_itimer *timr;
 	/*
@@ -683,7 +683,7 @@ sys_timer_gettime(timer_t timer_id, struct itimerspec __user *setting)
 {
 	struct k_itimer *timr;
 	struct itimerspec cur_setting;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	timr = lock_timer(timer_id, &flags);
 	if (!timr)
@@ -713,7 +713,7 @@ sys_timer_getoverrun(timer_t timer_id)
 {
 	struct k_itimer *timr;
 	int overrun;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	timr = lock_timer(timer_id, &flags);
 	if (!timr)
@@ -785,7 +785,7 @@ sys_timer_settime(timer_t timer_id, int flags,
 	struct k_itimer *timr;
 	struct itimerspec new_spec, old_spec;
 	int error = 0;
-	unsigned long flag;
+	irq_flags_t flag;
 	struct itimerspec *rtn = old_setting ? &old_spec : NULL;
 
 	if (!new_setting)
@@ -837,7 +837,7 @@ asmlinkage long
 sys_timer_delete(timer_t timer_id)
 {
 	struct k_itimer *timer;
-	unsigned long flags;
+	irq_flags_t flags;
 
 retry_delete:
 	timer = lock_timer(timer_id, &flags);
@@ -871,7 +871,7 @@ retry_delete:
  */
 static void itimer_delete(struct k_itimer *timer)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 retry_delete:
 	spin_lock_irqsave(&timer->it_lock, flags);
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -77,7 +77,7 @@ void refrigerator(void)
 
 static void fake_signal_wake_up(struct task_struct *p, int resume)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 	signal_wake_up(p, resume);
@@ -152,7 +152,7 @@ static int freeze_task(struct task_struct *p, int with_mm_only)
 
 static void cancel_freezing(struct task_struct *p)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (freezing(p)) {
 		pr_debug("  clean up: %s\n", p->comm);
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -126,7 +126,7 @@ static unsigned long logged_chars; /* Number of chars produced since last read+c
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned long size = memparse(str, &str);
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (size)
 		size = roundup_pow_of_two(size);
@@ -630,7 +630,7 @@ static volatile unsigned int printk_cpu = UINT_MAX;
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int printed_len;
 	char *p;
 	static char printk_buf[1024];
@@ -952,7 +952,7 @@ void wake_up_klogd(void)
  */
 void release_console_sem(void)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	unsigned long _con_start, _log_end;
 	unsigned long wake_klogd = 0;
 
@@ -1077,7 +1077,7 @@ EXPORT_SYMBOL(console_start);
 void register_console(struct console *console)
 {
 	int i;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct console *bootconsole = NULL;
 
 	if (console_drivers) {
@@ -1248,7 +1248,7 @@ int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst)
 	static unsigned long toks = 10 * 5 * HZ;
 	static unsigned long last_msg;
 	static int missed;
-	unsigned long flags;
+	irq_flags_t flags;
 	unsigned long now = jiffies;
 
 	spin_lock_irqsave(&ratelimit_lock, flags);
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -284,7 +284,8 @@ static void profile_discard_flip_buffers(void)
 
 void profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
-	unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
+	unsigned long primary, secondary, pc = (unsigned long)__pc;
+	irq_flags_t flags;
 	int i, j, cpu;
 	struct profile_hit *hits;
 
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -162,7 +162,7 @@ int ptrace_may_attach(struct task_struct *task)
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	audit_ptrace(task);
 
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -124,7 +124,7 @@ static inline void force_quiescent_state(struct rcu_data *rdp,
 void fastcall call_rcu(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rcu_data *rdp;
 
 	head->func = func;
@@ -159,7 +159,7 @@ void fastcall call_rcu(struct rcu_head *head,
 void fastcall call_rcu_bh(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rcu_data *rdp;
 
 	head->func = func;
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -136,7 +136,7 @@ static void __rt_mutex_adjust_prio(struct task_struct *task)
  */
 static void rt_mutex_adjust_prio(struct task_struct *task)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&task->pi_lock, flags);
 	__rt_mutex_adjust_prio(task);
@@ -162,7 +162,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	struct rt_mutex *lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
 	int detect_deadlock, ret = 0, depth = 0;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	detect_deadlock = debug_rt_mutex_detect_deadlock(orig_waiter,
 							 deadlock_detect);
@@ -304,7 +304,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
 {
 	struct task_struct *pendowner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *next;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (!rt_mutex_owner_pending(lock))
 		return 0;
@@ -415,7 +415,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
-	unsigned long flags;
+	irq_flags_t flags;
 	int chain_walk = 0, res;
 
 	spin_lock_irqsave(&current->pi_lock, flags);
@@ -479,7 +479,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *waiter;
 	struct task_struct *pendowner;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&current->pi_lock, flags);
 
@@ -536,7 +536,7 @@ static void remove_waiter(struct rt_mutex *lock,
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
-	unsigned long flags;
+	irq_flags_t flags;
 	int chain_walk = 0;
 
 	spin_lock_irqsave(&current->pi_lock, flags);
@@ -588,7 +588,7 @@ static void remove_waiter(struct rt_mutex *lock,
 void rt_mutex_adjust_pi(struct task_struct *task)
 {
 	struct rt_mutex_waiter *waiter;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&task->pi_lock, flags);
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -479,7 +479,7 @@ const_debug unsigned int sysctl_sched_features =
 unsigned long long cpu_clock(int cpu)
 {
 	unsigned long long now;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 
 	local_irq_save(flags);
@@ -590,7 +590,7 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
  * interrupts.  Note the ordering: we can safely lookup the task_rq without
  * explicitly disabling preemption.
  */
-static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
+static struct rq *task_rq_lock(struct task_struct *p, irq_flags_t *flags)
 	__acquires(rq->lock)
 {
 	struct rq *rq;
@@ -611,7 +611,7 @@ static void __task_rq_unlock(struct rq *rq)
 	spin_unlock(&rq->lock);
 }
 
-static inline void task_rq_unlock(struct rq *rq, unsigned long *flags)
+static inline void task_rq_unlock(struct rq *rq, irq_flags_t *flags)
 	__releases(rq->lock)
 {
 	spin_unlock_irqrestore(&rq->lock, *flags);
@@ -705,7 +705,7 @@ static void resched_task(struct task_struct *p)
 static void resched_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (!spin_trylock_irqsave(&rq->lock, flags))
 		return;
@@ -1116,7 +1116,7 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
  */
 void wait_task_inactive(struct task_struct *p)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int running, on_rq;
 	struct rq *rq;
 
@@ -1473,7 +1473,7 @@ static inline int wake_idle(int cpu, struct task_struct *p)
 static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
-	unsigned long flags;
+	irq_flags_t flags;
 	long old_state;
 	struct rq *rq;
 #ifdef CONFIG_SMP
@@ -1717,7 +1717,7 @@ void sched_fork(struct task_struct *p, int clone_flags)
  */
 void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
@@ -2119,7 +2119,7 @@ static void double_lock_balance(struct rq *this_rq, struct rq *busiest)
 static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 {
 	struct migration_req req;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
@@ -2690,7 +2690,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	unsigned long imbalance;
 	struct rq *busiest;
 	cpumask_t cpus = CPU_MASK_ALL;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3290,7 +3290,7 @@ EXPORT_PER_CPU_SYMBOL(kstat);
  */
 unsigned long long task_sched_runtime(struct task_struct *p)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	u64 ns, delta_exec;
 	struct rq *rq;
 
@@ -3774,7 +3774,7 @@ static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 void fastcall __wake_up(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&q->lock, flags);
 	__wake_up_common(q, mode, nr_exclusive, 0, key);
@@ -3806,7 +3806,7 @@ void fastcall __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
 void fastcall
 __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int sync = 1;
 
 	if (unlikely(!q))
@@ -3823,7 +3823,7 @@ EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
 void fastcall complete(struct completion *x)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
@@ -3835,7 +3835,7 @@ EXPORT_SYMBOL(complete);
 
 void fastcall complete_all(struct completion *x)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
@@ -3918,7 +3918,7 @@ EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
 static long __sched
 sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	wait_queue_t wait;
 
 	init_waitqueue_entry(&wait, current);
@@ -3975,7 +3975,7 @@ EXPORT_SYMBOL(sleep_on_timeout);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int oldprio, on_rq, running;
 	struct rq *rq;
 
@@ -4024,7 +4024,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 void set_user_nice(struct task_struct *p, long nice)
 {
 	int old_prio, delta, on_rq;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 
 	if (TASK_NICE(p) == nice || nice < -20 || nice > 19)
@@ -4216,7 +4216,7 @@ int sched_setscheduler(struct task_struct *p, int policy,
 		       struct sched_param *param)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 
 	/* may grab non-irq protected spin_locks */
@@ -4826,7 +4826,7 @@ long sys_sched_rr_get_interval(pid_t pid, struct timespec __user *interval)
 		time_slice = DEF_TIMESLICE;
 	else {
 		struct sched_entity *se = &p->se;
-		unsigned long flags;
+		irq_flags_t flags;
 		struct rq *rq;
 
 		rq = task_rq_lock(p, &flags);
@@ -4930,7 +4930,7 @@ void __cpuinit init_idle_bootup_task(struct task_struct *idle)
 void __cpuinit init_idle(struct task_struct *idle, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
+	irq_flags_t flags;
 
 	__sched_fork(idle);
 	idle->se.exec_start = sched_clock();
@@ -4996,7 +4996,7 @@ cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
 int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
 	struct migration_req req;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 	int ret = 0;
 
@@ -5150,7 +5150,7 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	cpumask_t mask;
 	struct rq *rq;
 	int dest_cpu;
@@ -5203,7 +5203,7 @@ static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
 	struct rq *rq_dest = cpu_rq(any_online_cpu(CPU_MASK_ALL));
-	unsigned long flags;
+	irq_flags_t flags;
 
 	local_irq_save(flags);
 	double_rq_lock(rq_src, rq_dest);
@@ -5255,7 +5255,7 @@ void sched_idle_next(void)
 	int this_cpu = smp_processor_id();
 	struct rq *rq = cpu_rq(this_cpu);
 	struct task_struct *p = rq->idle;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	/* cpu has to be offline */
 	BUG_ON(cpu_online(this_cpu));
@@ -5501,7 +5501,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	struct task_struct *p;
 	int cpu = (long)hcpu;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 
 	switch (action) {
@@ -6814,7 +6814,7 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 void normalize_rt_tasks(void)
 {
 	struct task_struct *g, *p;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 
 	read_lock_irq(&tasklist_lock);
@@ -7023,7 +7023,7 @@ void sched_destroy_group(struct task_group *tg)
 void sched_move_task(struct task_struct *tsk)
 {
 	int on_rq, running;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct rq *rq;
 
 	rq = task_rq_lock(tsk, &flags);
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -106,7 +106,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 		spread, rq0_min_vruntime, spread0;
 	struct rq *rq = &per_cpu(runqueues, cpu);
 	struct sched_entity *last;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	SEQ_printf(m, "\ncfs_rq\n");
 
@@ -261,7 +261,7 @@ __initcall(init_sched_debug_procfs);
 void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
 	unsigned long nr_switches;
-	unsigned long flags;
+	irq_flags_t flags;
 	int num_threads = 1;
 
 	rcu_read_lock();
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -217,7 +217,7 @@ void flush_sigqueue(struct sigpending *queue)
  */
 void flush_signals(struct task_struct *t)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&t->sighand->siglock, flags);
 	clear_tsk_thread_flag(t,TIF_SIGPENDING);
@@ -276,7 +276,7 @@ int unhandled_signal(struct task_struct *tsk, int sig)
 void
 block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&current->sighand->siglock, flags);
 	current->notifier_mask = mask;
@@ -290,7 +290,7 @@ block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
 void
 unblock_all_signals(void)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&current->sighand->siglock, flags);
 	current->notifier = NULL;
@@ -795,7 +795,7 @@ out:
 int
 force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
-	unsigned long int flags;
+	irq_flags_t flags;
 	int ret, blocked, ignored;
 	struct k_sigaction *action;
 
@@ -997,7 +997,7 @@ void zap_other_threads(struct task_struct *p)
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
  */
-struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
+struct sighand_struct *lock_task_sighand(struct task_struct *tsk, irq_flags_t *flags)
 {
 	struct sighand_struct *sighand;
 
@@ -1017,7 +1017,7 @@ struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long
 
 int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret;
 
 	ret = check_kill_permission(sig, info, p);
@@ -1120,7 +1120,7 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 	if (ret)
 		goto out_unlock;
 	if (sig && p->sighand) {
-		unsigned long flags;
+		irq_flags_t flags;
 		spin_lock_irqsave(&p->sighand->siglock, flags);
 		ret = __group_send_sig_info(sig, info, p);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
@@ -1180,7 +1180,7 @@ int
 send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
 	int ret;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	/*
 	 * Make sure legacy kernel users don't send in bad values
@@ -1242,7 +1242,7 @@ int
 force_sigsegv(int sig, struct task_struct *p)
 {
 	if (sig == SIGSEGV) {
-		unsigned long flags;
+		irq_flags_t flags;
 		spin_lock_irqsave(&p->sighand->siglock, flags);
 		p->sighand->action[sig - 1].sa.sa_handler = SIG_DFL;
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
@@ -1295,7 +1295,7 @@ struct sigqueue *sigqueue_alloc(void)
 
 void sigqueue_free(struct sigqueue *q)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	spinlock_t *lock = &current->sighand->siglock;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
@@ -1315,7 +1315,7 @@ void sigqueue_free(struct sigqueue *q)
 
 int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = 0;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
@@ -1371,7 +1371,7 @@ out_err:
 int
 send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = 0;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
@@ -1435,7 +1435,7 @@ static inline void __wake_up_parent(struct task_struct *p,
 void do_notify_parent(struct task_struct *tsk, int sig)
 {
 	struct siginfo info;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct sighand_struct *psig;
 
 	BUG_ON(sig == -1);
@@ -1515,7 +1515,7 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 {
 	struct siginfo info;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
 
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -256,7 +256,7 @@ restart:
 asmlinkage void do_softirq(void)
 {
 	__u32 pending;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (in_interrupt())
 		return;
@@ -332,7 +332,7 @@ inline fastcall void raise_softirq_irqoff(unsigned int nr)
 
 void fastcall raise_softirq(unsigned int nr)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	local_irq_save(flags);
 	raise_softirq_irqoff(nr);
@@ -358,7 +358,7 @@ static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
 
 void fastcall __tasklet_schedule(struct tasklet_struct *t)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	local_irq_save(flags);
 	t->next = __get_cpu_var(tasklet_vec).list;
@@ -371,7 +371,7 @@ EXPORT_SYMBOL(__tasklet_schedule);
 
 void fastcall __tasklet_hi_schedule(struct tasklet_struct *t)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	local_irq_save(flags);
 	t->next = __get_cpu_var(tasklet_hi_vec).list;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1557,7 +1557,7 @@ out:
 static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 {
 	struct task_struct *t;
-	unsigned long flags;
+	irq_flags_t flags;
 	cputime_t utime, stime;
 
 	memset((char *) r, 0, sizeof *r);
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -221,7 +221,7 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 		struct taskstats *stats)
 {
 	struct task_struct *tsk;
-	unsigned long flags;
+	irq_flags_t flags;
 	int rc = -ESRCH;
 
 	/*
@@ -272,7 +272,7 @@ out:
 
 static void fill_tgid_exit(struct task_struct *tsk)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
 	if (!tsk->signal->stats)
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -173,7 +173,7 @@ static void clockevents_handle_noop(struct clock_event_device *dev)
 void clockevents_exchange_device(struct clock_event_device *old,
 				 struct clock_event_device *new)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	local_irq_save(flags);
 	/*
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -155,7 +155,7 @@ static void clocksource_resume_watchdog(void)
 static void clocksource_check_watchdog(struct clocksource *cs)
 {
 	struct clocksource *cse;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&watchdog_lock, flags);
 	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
@@ -208,7 +208,7 @@ static inline void clocksource_resume_watchdog(void) { }
 void clocksource_resume(void)
 {
 	struct clocksource *cs;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 
@@ -228,7 +228,7 @@ void clocksource_resume(void)
  */
 struct clocksource *clocksource_get_next(void)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 	if (next_clocksource && finished_booting) {
@@ -301,7 +301,7 @@ static int clocksource_enqueue(struct clocksource *c)
  */
 int clocksource_register(struct clocksource *c)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
@@ -321,7 +321,7 @@ EXPORT_SYMBOL(clocksource_register);
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 	list_del(&cs->list);
@@ -478,7 +478,7 @@ device_initcall(init_clocksource_sysfs);
  */
 static int __init boot_override_clocksource(char* str)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	spin_lock_irqsave(&clocksource_lock, flags);
 	if (str)
 		strlcpy(override_name, str, sizeof(override_name));
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -90,7 +90,7 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
  */
 int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
@@ -206,7 +206,8 @@ static void tick_do_broadcast_on_off(void *why)
 {
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
-	unsigned long flags, *reason = why;
+	unsigned long *reason = why;
+	irq_flags_t flags;
 	int cpu;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
@@ -289,7 +290,7 @@ void tick_set_periodic_handler(struct clock_event_device *dev, int broadcast)
 void tick_shutdown_broadcast(unsigned int *cpup)
 {
 	struct clock_event_device *bc;
-	unsigned long flags;
+	irq_flags_t flags;
 	unsigned int cpu = *cpup;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
@@ -308,7 +309,7 @@ void tick_shutdown_broadcast(unsigned int *cpup)
 void tick_suspend_broadcast(void)
 {
 	struct clock_event_device *bc;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -322,7 +323,7 @@ void tick_suspend_broadcast(void)
 int tick_resume_broadcast(void)
 {
 	struct clock_event_device *bc;
-	unsigned long flags;
+	irq_flags_t flags;
 	int broadcast = 0;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
@@ -457,7 +458,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 {
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
-	unsigned long flags;
+	irq_flags_t flags;
 	int cpu;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
@@ -523,7 +524,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 void tick_broadcast_switch_to_oneshot(void)
 {
 	struct clock_event_device *bc;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -540,7 +541,7 @@ void tick_broadcast_switch_to_oneshot(void)
  */
 void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	unsigned int cpu = *cpup;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -193,7 +193,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	struct clock_event_device *curdev;
 	struct tick_device *td;
 	int cpu, ret = NOTIFY_OK;
-	unsigned long flags;
+	irq_flags_t flags;
 	cpumask_t cpumask;
 
 	spin_lock_irqsave(&tick_device_lock, flags);
@@ -282,7 +282,7 @@ static void tick_shutdown(unsigned int *cpup)
 {
 	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
 	struct clock_event_device *dev = td->evtdev;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&tick_device_lock, flags);
 	td->mode = TICKDEV_MODE_PERIODIC;
@@ -307,7 +307,7 @@ static void tick_shutdown(unsigned int *cpup)
 static void tick_suspend(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&tick_device_lock, flags);
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_SHUTDOWN);
@@ -317,7 +317,7 @@ static void tick_suspend(void)
 static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	unsigned long flags;
+	irq_flags_t flags;
 	int broadcast = tick_resume_broadcast();
 
 	spin_lock_irqsave(&tick_device_lock, flags);
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -127,7 +127,7 @@ void tick_nohz_update_jiffies(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	unsigned long flags;
+	irq_flags_t flags;
 	ktime_t now;
 
 	if (!ts->tick_stopped)
@@ -150,7 +150,8 @@ void tick_nohz_update_jiffies(void)
  */
 void tick_nohz_stop_sched_tick(void)
 {
-	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
+	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
+	irq_flags_t flags;
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now, delta;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -141,7 +141,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(struct timespec *tv)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	time_t wtm_sec, sec = tv->tv_sec;
 	long wtm_nsec, nsec = tv->tv_nsec;
 
@@ -247,7 +247,7 @@ unsigned long __attribute__((weak)) read_persistent_clock(void)
  */
 void __init timekeeping_init(void)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	unsigned long sec = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
@@ -284,7 +284,7 @@ static s64 timekeeping_suspend_nsecs;
  */
 static int timekeeping_resume(struct sys_device *dev)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	unsigned long now = read_persistent_clock();
 
 	clocksource_resume();
@@ -318,7 +318,7 @@ static int timekeeping_resume(struct sys_device *dev)
 
 static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	timekeeping_suspend_time = read_persistent_clock();
 
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -77,7 +77,7 @@ print_active_timers(struct seq_file *m, struct hrtimer_clock_base *base,
 	struct hrtimer *timer, tmp;
 	unsigned long next = 0, i;
 	struct rb_node *curr;
-	unsigned long flags;
+	irq_flags_t flags;
 
 next_one:
 	i = 0;
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -240,7 +240,7 @@ void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 	 */
 	spinlock_t *lock;
 	struct entry *entry, input;
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (likely(!active))
 		return;
@@ -344,7 +344,7 @@ static int tstats_show(struct seq_file *m, void *v)
  */
 static void sync_access(void)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 	int cpu;
 
 	for_each_online_cpu(cpu) {
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -372,7 +372,7 @@ static inline void detach_timer(struct timer_list *timer,
  * locked.
  */
 static tvec_base_t *lock_timer_base(struct timer_list *timer,
-					unsigned long *flags)
+					irq_flags_t *flags)
 	__acquires(timer->base->lock)
 {
 	tvec_base_t *base;
@@ -394,7 +394,7 @@ static tvec_base_t *lock_timer_base(struct timer_list *timer,
 int __mod_timer(struct timer_list *timer, unsigned long expires)
 {
 	tvec_base_t *base, *new_base;
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = 0;
 
 	timer_stats_timer_set_start_info(timer);
@@ -446,7 +446,7 @@ EXPORT_SYMBOL(__mod_timer);
 void add_timer_on(struct timer_list *timer, int cpu)
 {
 	tvec_base_t *base = per_cpu(tvec_bases, cpu);
-	unsigned long flags;
+	irq_flags_t flags;
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(timer_pending(timer) || !timer->function);
@@ -509,7 +509,7 @@ EXPORT_SYMBOL(mod_timer);
 int del_timer(struct timer_list *timer)
 {
 	tvec_base_t *base;
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = 0;
 
 	timer_stats_timer_clear_start_info(timer);
@@ -540,7 +540,7 @@ EXPORT_SYMBOL(del_timer);
 int try_to_del_timer_sync(struct timer_list *timer)
 {
 	tvec_base_t *base;
-	unsigned long flags;
+	irq_flags_t flags;
 	int ret = -1;
 
 	base = lock_timer_base(timer, &flags);
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -216,7 +216,7 @@ static void remove_user_sysfs_dir(struct work_struct *w)
 {
 	struct user_struct *up = container_of(w, struct user_struct, work);
 	struct kobject *kobj = &up->kset.kobj;
-	unsigned long flags;
+	irq_flags_t flags;
 	int remove_user = 0;
 
 	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
@@ -254,7 +254,7 @@ done:
  * IRQ state (as stored in flags) is restored and uidhash_lock released
  * upon function exit.
  */
-static inline void free_user(struct user_struct *up, unsigned long flags)
+static inline void free_user(struct user_struct *up, irq_flags_t flags)
 {
 	/* restore back the count */
 	atomic_inc(&up->__count);
@@ -274,7 +274,7 @@ static inline void uids_mutex_unlock(void) { }
  * IRQ state (as stored in flags) is restored and uidhash_lock released
  * upon function exit.
  */
-static inline void free_user(struct user_struct *up, unsigned long flags)
+static inline void free_user(struct user_struct *up, irq_flags_t flags)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
@@ -295,7 +295,7 @@ static inline void free_user(struct user_struct *up, unsigned long flags)
 struct user_struct *find_user(uid_t uid)
 {
 	struct user_struct *ret;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct user_namespace *ns = current->nsproxy->user_ns;
 
 	spin_lock_irqsave(&uidhash_lock, flags);
@@ -306,7 +306,7 @@ struct user_struct *find_user(uid_t uid)
 
 void free_uid(struct user_struct *up)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	if (!up)
 		return;
@@ -434,7 +434,7 @@ void switch_uid(struct user_struct *new_user)
 void release_uids(struct user_namespace *ns)
 {
 	int i;
-	unsigned long flags;
+	irq_flags_t flags;
 	struct hlist_head *head;
 	struct hlist_node *nd;
 
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -20,7 +20,7 @@ EXPORT_SYMBOL(init_waitqueue_head);
 
 void fastcall add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
@@ -31,7 +31,7 @@ EXPORT_SYMBOL(add_wait_queue);
 
 void fastcall add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
@@ -42,7 +42,7 @@ EXPORT_SYMBOL(add_wait_queue_exclusive);
 
 void fastcall remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&q->lock, flags);
 	__remove_wait_queue(q, wait);
@@ -66,7 +66,7 @@ EXPORT_SYMBOL(remove_wait_queue);
 void fastcall
 prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
@@ -85,7 +85,7 @@ EXPORT_SYMBOL(prepare_to_wait);
 void fastcall
 prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
@@ -103,7 +103,7 @@ EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
 void fastcall finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	__set_current_state(TASK_RUNNING);
 	/*
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -145,7 +145,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 static void __queue_work(struct cpu_workqueue_struct *cwq,
 			 struct work_struct *work)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	spin_lock_irqsave(&cwq->lock, flags);
 	insert_work(cwq, work, 1);
