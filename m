Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbXLLVd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbXLLVd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXLLVdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:33:07 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:12621 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbXLLVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:33:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZLYYZpWG2CObhhVtd4vxz3SgYoPuZseppry7QVcc7AVE7zbhGbPZbYjsBWyEwgtqkN8hoZMEqQWhkKVGRDXUd3198Puyl4kd48S0oCNvx+oEKcMl8f9fH8msQf3zhP1gzmzj5jOe8MWEOP9m9CKCpJV0qZznL2sTAfGaGZ55cDg=
Subject: [PATCH] kernel: remove fastcall in kernel/*
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 13:33:01 -0800
Message-Id: <1197495181.21291.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastcall is always empty, remove it.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/exit.c        |    4 ++--
 kernel/fork.c        |    2 +-
 kernel/irq/chip.c    |   10 +++++-----
 kernel/irq/handle.c  |    4 ++--
 kernel/mutex-debug.c |    2 +-
 kernel/mutex.c       |   22 +++++++++++-----------
 kernel/pid.c         |   18 +++++++++---------
 kernel/rcupdate.c    |    4 ++--
 kernel/sched.c       |   16 ++++++++--------
 kernel/softirq.c     |    8 ++++----
 kernel/timer.c       |    6 +++---
 kernel/wait.c        |   26 +++++++++++++-------------
 kernel/workqueue.c   |   10 +++++-----
 13 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 549c055..0a0f8ce 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -460,7 +460,7 @@ struct files_struct *get_files_struct(struct task_struct *task)
 	return files;
 }
 
-void fastcall put_files_struct(struct files_struct *files)
+void put_files_struct(struct files_struct *files)
 {
 	struct fdtable *fdt;
 
@@ -907,7 +907,7 @@ static inline void exit_child_reaper(struct task_struct *tsk)
 	zap_pid_ns_processes(tsk->nsproxy->pid_ns);
 }
 
-fastcall NORET_TYPE void do_exit(long code)
+NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
diff --git a/kernel/fork.c b/kernel/fork.c
index 8dd8ff2..eb72219 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -385,7 +385,7 @@ struct mm_struct * mm_alloc(void)
  * is dropped: either by a lazy thread or by
  * mmput. Free the page directory and the mm.
  */
-void fastcall __mmdrop(struct mm_struct *mm)
+void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 9b5dff6..473686b 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -286,7 +286,7 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
  *	Note: The caller is expected to handle the ack, clear, mask and
  *	unmask issues if necessary.
  */
-void fastcall
+void
 handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct irqaction *action;
@@ -332,7 +332,7 @@ out_unlock:
  *	it after the associated handler has acknowledged the device, so the
  *	interrupt line is back to inactive.
  */
-void fastcall
+void
 handle_level_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpu = smp_processor_id();
@@ -380,7 +380,7 @@ out_unlock:
  *	for modern forms of interrupt handlers, which handle the flow
  *	details in hardware, transparently.
  */
-void fastcall
+void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpu = smp_processor_id();
@@ -439,7 +439,7 @@ out:
  *	the handler was running. If all pending interrupts are handled, the
  *	loop is left.
  */
-void fastcall
+void
 handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 {
 	const unsigned int cpu = smp_processor_id();
@@ -510,7 +510,7 @@ out_unlock:
  *
  *	Per CPU interrupts on SMP machines without locking requirements
  */
-void fastcall
+void
 handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irqreturn_t action_ret;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index dc335ad..5fa6198 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -25,7 +25,7 @@
  *
  * Handles spurious and unhandled IRQ's. It also prints a debugmessage.
  */
-void fastcall
+void
 handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
 	print_irq_desc(irq, desc);
@@ -163,7 +163,7 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
  * This is the original x86 implementation which is used for every
  * interrupt type.
  */
-fastcall unsigned int __do_IRQ(unsigned int irq)
+unsigned int __do_IRQ(unsigned int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	struct irqaction *action;
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index d17436c..3aaa06c 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -107,7 +107,7 @@ void debug_mutex_init(struct mutex *lock, const char *name,
  * use of the mutex is forbidden. The mutex must not be locked when
  * this function is called.
  */
-void fastcall mutex_destroy(struct mutex *lock)
+void mutex_destroy(struct mutex *lock)
 {
 	DEBUG_LOCKS_WARN_ON(mutex_is_locked(lock));
 	lock->magic = NULL;
diff --git a/kernel/mutex.c b/kernel/mutex.c
index d7fe50c..2625564 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -58,7 +58,7 @@ EXPORT_SYMBOL(__mutex_init);
  * We also put the fastpath first in the kernel image, to make sure the
  * branch is predicted by the CPU as default-untaken.
  */
-static void fastcall noinline __sched
+static void noinline __sched
 __mutex_lock_slowpath(atomic_t *lock_count);
 
 /***
@@ -82,7 +82,7 @@ __mutex_lock_slowpath(atomic_t *lock_count);
  *
  * This function is similar to (but not equivalent to) down().
  */
-void inline fastcall __sched mutex_lock(struct mutex *lock)
+void inline __sched mutex_lock(struct mutex *lock)
 {
 	might_sleep();
 	/*
@@ -95,7 +95,7 @@ void inline fastcall __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
-static void fastcall noinline __sched
+static void noinline __sched
 __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /***
@@ -109,7 +109,7 @@ __mutex_unlock_slowpath(atomic_t *lock_count);
  *
  * This function is similar to (but not equivalent to) up().
  */
-void fastcall __sched mutex_unlock(struct mutex *lock)
+void __sched mutex_unlock(struct mutex *lock)
 {
 	/*
 	 * The unlocking fastpath is the 0->1 transition from 'locked'
@@ -223,7 +223,7 @@ EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
 /*
  * Release the lock, slowpath:
  */
-static fastcall inline void
+static inline void
 __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
@@ -260,7 +260,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 /*
  * Release the lock, slowpath:
  */
-static fastcall noinline void
+static noinline void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
 	__mutex_unlock_common_slowpath(lock_count, 1);
@@ -271,7 +271,7 @@ __mutex_unlock_slowpath(atomic_t *lock_count)
  * Here come the less common (and hence less performance-critical) APIs:
  * mutex_lock_interruptible() and mutex_trylock().
  */
-static int fastcall noinline __sched
+static int noinline __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
 
 /***
@@ -285,7 +285,7 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
  *
  * This function is similar to (but not equivalent to) down_interruptible().
  */
-int fastcall __sched mutex_lock_interruptible(struct mutex *lock)
+int __sched mutex_lock_interruptible(struct mutex *lock)
 {
 	might_sleep();
 	return __mutex_fastpath_lock_retval
@@ -294,7 +294,7 @@ int fastcall __sched mutex_lock_interruptible(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
 
-static void fastcall noinline __sched
+static void noinline __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
@@ -302,7 +302,7 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
 }
 
-static int fastcall noinline __sched
+static int noinline __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
@@ -351,7 +351,7 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
  * This function must not be used in interrupt context. The
  * mutex must be released by the same task that acquired it.
  */
-int fastcall __sched mutex_trylock(struct mutex *lock)
+int __sched mutex_trylock(struct mutex *lock)
 {
 	return __mutex_fastpath_trylock(&lock->count,
 					__mutex_trylock_slowpath);
diff --git a/kernel/pid.c b/kernel/pid.c
index f815455..023d781 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -112,7 +112,7 @@ EXPORT_SYMBOL(is_container_init);
 
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(pidmap_lock);
 
-static fastcall void free_pidmap(struct pid_namespace *pid_ns, int pid)
+static void free_pidmap(struct pid_namespace *pid_ns, int pid)
 {
 	struct pidmap *map = pid_ns->pidmap + pid / BITS_PER_PAGE;
 	int offset = pid & BITS_PER_PAGE_MASK;
@@ -199,7 +199,7 @@ static int next_pidmap(struct pid_namespace *pid_ns, int last)
 	return -1;
 }
 
-fastcall void put_pid(struct pid *pid)
+void put_pid(struct pid *pid)
 {
 	struct pid_namespace *ns;
 
@@ -221,7 +221,7 @@ static void delayed_put_pid(struct rcu_head *rhp)
 	put_pid(pid);
 }
 
-fastcall void free_pid(struct pid *pid)
+void free_pid(struct pid *pid)
 {
 	/* We can be called with write_lock_irq(&tasklist_lock) held */
 	int i;
@@ -287,7 +287,7 @@ out_free:
 	goto out;
 }
 
-struct pid * fastcall find_pid_ns(int nr, struct pid_namespace *ns)
+struct pid * find_pid_ns(int nr, struct pid_namespace *ns)
 {
 	struct hlist_node *elem;
 	struct upid *pnr;
@@ -317,7 +317,7 @@ EXPORT_SYMBOL_GPL(find_pid);
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
-int fastcall attach_pid(struct task_struct *task, enum pid_type type,
+int attach_pid(struct task_struct *task, enum pid_type type,
 		struct pid *pid)
 {
 	struct pid_link *link;
@@ -329,7 +329,7 @@ int fastcall attach_pid(struct task_struct *task, enum pid_type type,
 	return 0;
 }
 
-void fastcall detach_pid(struct task_struct *task, enum pid_type type)
+void detach_pid(struct task_struct *task, enum pid_type type)
 {
 	struct pid_link *link;
 	struct pid *pid;
@@ -349,7 +349,7 @@ void fastcall detach_pid(struct task_struct *task, enum pid_type type)
 }
 
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
-void fastcall transfer_pid(struct task_struct *old, struct task_struct *new,
+void transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)
 {
 	new->pids[type].pid = old->pids[type].pid;
@@ -357,7 +357,7 @@ void fastcall transfer_pid(struct task_struct *old, struct task_struct *new,
 	old->pids[type].pid = NULL;
 }
 
-struct task_struct * fastcall pid_task(struct pid *pid, enum pid_type type)
+struct task_struct * pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result = NULL;
 	if (pid) {
@@ -408,7 +408,7 @@ struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 	return pid;
 }
 
-struct task_struct *fastcall get_pid_task(struct pid *pid, enum pid_type type)
+struct task_struct *get_pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result;
 	rcu_read_lock();
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a66d4d1..d4bd0d8 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -121,7 +121,7 @@ static inline void force_quiescent_state(struct rcu_data *rdp,
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
-void fastcall call_rcu(struct rcu_head *head,
+void call_rcu(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
 	unsigned long flags;
@@ -156,7 +156,7 @@ void fastcall call_rcu(struct rcu_head *head,
  * rcu_read_unlock(), * if in interrupt context or rcu_read_lock_bh()
  * and rcu_read_unlock_bh(), if in process context. These may be nested.
  */
-void fastcall call_rcu_bh(struct rcu_head *head,
+void call_rcu_bh(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
 	unsigned long flags;
diff --git a/kernel/sched.c b/kernel/sched.c
index c6e551d..7ab6cee 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1649,14 +1649,14 @@ out:
 	return success;
 }
 
-int fastcall wake_up_process(struct task_struct *p)
+int wake_up_process(struct task_struct *p)
 {
 	return try_to_wake_up(p, TASK_STOPPED | TASK_TRACED |
 				 TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
 
-int fastcall wake_up_state(struct task_struct *p, unsigned int state)
+int wake_up_state(struct task_struct *p, unsigned int state)
 {
 	return try_to_wake_up(p, state, 0);
 }
@@ -1743,7 +1743,7 @@ void sched_fork(struct task_struct *p, int clone_flags)
  * that must be done for every newly created context, then puts the task
  * on the runqueue and wakes it.
  */
-void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
+void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
 	unsigned long flags;
 	struct rq *rq;
@@ -3495,7 +3495,7 @@ void scheduler_tick(void)
 
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
 
-void fastcall add_preempt_count(int val)
+void add_preempt_count(int val)
 {
 	/*
 	 * Underflow?
@@ -3511,7 +3511,7 @@ void fastcall add_preempt_count(int val)
 }
 EXPORT_SYMBOL(add_preempt_count);
 
-void fastcall sub_preempt_count(int val)
+void sub_preempt_count(int val)
 {
 	/*
 	 * Underflow?
@@ -3806,7 +3806,7 @@ static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
  * @key: is directly passed to the wakeup function
  */
-void fastcall __wake_up(wait_queue_head_t *q, unsigned int mode,
+void __wake_up(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
 {
 	unsigned long flags;
@@ -3820,7 +3820,7 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
  */
-void fastcall __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
 {
 	__wake_up_common(q, mode, 1, 0, NULL);
 }
@@ -3838,7 +3838,7 @@ void fastcall __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
  *
  * On UP it can prevent extra preemption.
  */
-void fastcall
+void
 __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
 {
 	unsigned long flags;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 8fe1ff4..1f6406e 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -315,7 +315,7 @@ void irq_exit(void)
 /*
  * This function must run with irqs disabled!
  */
-inline fastcall void raise_softirq_irqoff(unsigned int nr)
+inline void raise_softirq_irqoff(unsigned int nr)
 {
 	__raise_softirq_irqoff(nr);
 
@@ -332,7 +332,7 @@ inline fastcall void raise_softirq_irqoff(unsigned int nr)
 		wakeup_softirqd();
 }
 
-void fastcall raise_softirq(unsigned int nr)
+void raise_softirq(unsigned int nr)
 {
 	unsigned long flags;
 
@@ -358,7 +358,7 @@ struct tasklet_head
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
 static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
 
-void fastcall __tasklet_schedule(struct tasklet_struct *t)
+void __tasklet_schedule(struct tasklet_struct *t)
 {
 	unsigned long flags;
 
@@ -371,7 +371,7 @@ void fastcall __tasklet_schedule(struct tasklet_struct *t)
 
 EXPORT_SYMBOL(__tasklet_schedule);
 
-void fastcall __tasklet_hi_schedule(struct tasklet_struct *t)
+void __tasklet_hi_schedule(struct tasklet_struct *t)
 {
 	unsigned long flags;
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 6a9d882..6db4a78 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -327,7 +327,7 @@ static void timer_stats_account_timer(struct timer_list *timer) {}
  * init_timer() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
-void fastcall init_timer(struct timer_list *timer)
+void init_timer(struct timer_list *timer)
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
@@ -339,7 +339,7 @@ void fastcall init_timer(struct timer_list *timer)
 }
 EXPORT_SYMBOL(init_timer);
 
-void fastcall init_timer_deferrable(struct timer_list *timer)
+void init_timer_deferrable(struct timer_list *timer)
 {
 	init_timer(timer);
 	timer_set_deferrable(timer);
@@ -1039,7 +1039,7 @@ static void process_timeout(unsigned long __data)
  *
  * In all cases the return value is guaranteed to be non-negative.
  */
-fastcall signed long __sched schedule_timeout(signed long timeout)
+signed long __sched schedule_timeout(signed long timeout)
 {
 	struct timer_list timer;
 	unsigned long expire;
diff --git a/kernel/wait.c b/kernel/wait.c
index 444ddbf..e129943 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -18,7 +18,7 @@ void init_waitqueue_head(wait_queue_head_t *q)
 
 EXPORT_SYMBOL(init_waitqueue_head);
 
-void fastcall add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
+void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
@@ -29,7 +29,7 @@ void fastcall add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 }
 EXPORT_SYMBOL(add_wait_queue);
 
-void fastcall add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
+void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
@@ -40,7 +40,7 @@ void fastcall add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive);
 
-void fastcall remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
+void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
@@ -63,7 +63,7 @@ EXPORT_SYMBOL(remove_wait_queue);
  * stops them from bleeding out - it would still allow subsequent
  * loads to move into the critical region).
  */
-void fastcall
+void
 prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
@@ -82,7 +82,7 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 }
 EXPORT_SYMBOL(prepare_to_wait);
 
-void fastcall
+void
 prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
@@ -101,7 +101,7 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
-void fastcall finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
+void finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
@@ -157,7 +157,7 @@ EXPORT_SYMBOL(wake_bit_function);
  * waiting, the actions of __wait_on_bit() and __wait_on_bit_lock() are
  * permitted return codes. Nonzero return codes halt waiting and return.
  */
-int __sched fastcall
+int __sched
 __wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
 			int (*action)(void *), unsigned mode)
 {
@@ -173,7 +173,7 @@ __wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
 }
 EXPORT_SYMBOL(__wait_on_bit);
 
-int __sched fastcall out_of_line_wait_on_bit(void *word, int bit,
+int __sched out_of_line_wait_on_bit(void *word, int bit,
 					int (*action)(void *), unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
@@ -183,7 +183,7 @@ int __sched fastcall out_of_line_wait_on_bit(void *word, int bit,
 }
 EXPORT_SYMBOL(out_of_line_wait_on_bit);
 
-int __sched fastcall
+int __sched
 __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 			int (*action)(void *), unsigned mode)
 {
@@ -201,7 +201,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 }
 EXPORT_SYMBOL(__wait_on_bit_lock);
 
-int __sched fastcall out_of_line_wait_on_bit_lock(void *word, int bit,
+int __sched out_of_line_wait_on_bit_lock(void *word, int bit,
 					int (*action)(void *), unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
@@ -211,7 +211,7 @@ int __sched fastcall out_of_line_wait_on_bit_lock(void *word, int bit,
 }
 EXPORT_SYMBOL(out_of_line_wait_on_bit_lock);
 
-void fastcall __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
+void __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
 {
 	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
 	if (waitqueue_active(wq))
@@ -236,13 +236,13 @@ EXPORT_SYMBOL(__wake_up_bit);
  * may need to use a less regular barrier, such fs/inode.c's smp_mb(),
  * because spin_unlock() does not guarantee a memory barrier.
  */
-void fastcall wake_up_bit(void *word, int bit)
+void wake_up_bit(void *word, int bit)
 {
 	__wake_up_bit(bit_waitqueue(word, bit), word, bit);
 }
 EXPORT_SYMBOL(wake_up_bit);
 
-fastcall wait_queue_head_t *bit_waitqueue(void *word, int bit)
+wait_queue_head_t *bit_waitqueue(void *word, int bit)
 {
 	const int shift = BITS_PER_LONG == 32 ? 5 : 6;
 	const struct zone *zone = page_zone(virt_to_page(word));
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52d5e7c..80248c3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -162,7 +162,7 @@ static void __queue_work(struct cpu_workqueue_struct *cwq,
  * We queue the work to the CPU it was submitted, but there is no
  * guarantee that it will be processed by that CPU.
  */
-int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
+int queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret = 0;
 
@@ -193,7 +193,7 @@ void delayed_work_timer_fn(unsigned long __data)
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  */
-int fastcall queue_delayed_work(struct workqueue_struct *wq,
+int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
 	timer_stats_timer_set_start_info(&dwork->timer);
@@ -389,7 +389,7 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  * This function used to run the workqueues itself.  Now we just wait for the
  * helper threads to do it.
  */
-void fastcall flush_workqueue(struct workqueue_struct *wq)
+void flush_workqueue(struct workqueue_struct *wq)
 {
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	int cpu;
@@ -547,7 +547,7 @@ static struct workqueue_struct *keventd_wq __read_mostly;
  *
  * This puts a job in the kernel-global workqueue.
  */
-int fastcall schedule_work(struct work_struct *work)
+int schedule_work(struct work_struct *work)
 {
 	return queue_work(keventd_wq, work);
 }
@@ -561,7 +561,7 @@ EXPORT_SYMBOL(schedule_work);
  * After waiting for a given time this puts a job in the kernel-global
  * workqueue.
  */
-int fastcall schedule_delayed_work(struct delayed_work *dwork,
+int schedule_delayed_work(struct delayed_work *dwork,
 					unsigned long delay)
 {
 	timer_stats_timer_set_start_info(&dwork->timer);
-- 
1.5.3.7.2212.gd092



