Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbYAZQHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbYAZQHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbYAZP5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:57:06 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757531AbYAZP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:57:01 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 05/52] [microblaze] Support for semaphores
Date: Thu, 24 Jan 2008 16:03:30 +0100
Message-Id: <e83ac9f205e3ef0524ded397faf91a7a0750100c.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <c4d02deb7e0a9a243a961bfe066e5d05e72a836e.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
 <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
 <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
 <990835fa238b139deac273e0573bcf5060e3ee80.1201107832.git.monstr@monstr.eu>
 <993cd20fd7ee4ec891f1354690f93ca62d7871ec.1201107832.git.monstr@monstr.eu>
 <e83ad9fcfb12993d8d20ce6663e563b8b496273e.1201107832.git.monstr@monstr.eu>
 <e22e05ebd297de6f7d5dd0bf2eecf20d6749d571.1201107832.git.monstr@monstr.eu>
 <62a6eb3ffa457cd0c126320a0e46509f06e00511.1201107832.git.monstr@monstr.eu>
 <c4d02deb7e0a9a243a961bfe066e5d05e72a836e.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/semaphore.c |  222 ++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/semaphore.h |  100 ++++++++++++++++
 2 files changed, 322 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/semaphore.c
 create mode 100644 include/asm-microblaze/semaphore.h

diff --git a/arch/microblaze/kernel/semaphore.c b/arch/microblaze/kernel/semaphore.c
new file mode 100644
index 0000000..360fc7b
--- /dev/null
+++ b/arch/microblaze/kernel/semaphore.c
@@ -0,0 +1,222 @@
+/*
+ * arch/microblaze/kernel/semaphore.c
+ *
+ * Generic semaphore code. Buyer beware. Do your own specific changes
+ * in <asm/semaphore-helper.h>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 - 2005 Tensilica Inc.
+ *
+ * Joe Taylor	<joe@tensilica.com, joetylr@yahoo.com>
+ * Chris Zankel	<chris@zankel.net>
+ * Marc Gauthier<marc@tensilica.com, marc@alumni.uwaterloo.ca>
+ * Kevin Chea
+ */
+
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/init.h>
+#include <asm/semaphore.h>
+#include <asm/errno.h>
+
+/*
+ * These two _must_ execute atomically wrt each other.
+ */
+
+static inline void wake_one_more(struct semaphore *sem)
+{
+	atomic_inc((atomic_t *)&sem->sleepers);
+}
+
+static inline int waking_non_zero(struct semaphore *sem)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&semaphore_wake_lock, flags);
+	if (sem->sleepers > 0) {
+		sem->sleepers--;
+		ret = 1;
+	}
+	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
+	return ret;
+}
+
+/*
+ * waking_non_zero_interruptible:
+ *	1	got the lock
+ *	0	go to sleep
+ *	-EINTR	interrupted
+ *
+ * We must undo the sem->count down_interruptible() increment while we are
+ * protected by the spinlock in order to make atomic this atomic_inc() with the
+ * atomic_read() in wake_one_more(), otherwise we can race. -arca
+ */
+
+static inline int waking_non_zero_interruptible(struct semaphore *sem,
+						struct task_struct *tsk) {
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&semaphore_wake_lock, flags);
+	if (sem->sleepers > 0) {
+		sem->sleepers--;
+		ret = 1;
+	} else if (signal_pending(tsk)) {
+		atomic_inc(&sem->count);
+		ret = -EINTR;
+	}
+	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
+	return ret;
+}
+
+/*
+ * waking_non_zero_trylock:
+ *	1	failed to lock
+ *	0	got the lock
+ *
+ * We must undo the sem->count down_trylock() increment while we are
+ * protected by the spinlock in order to make atomic this atomic_inc() with the
+ * atomic_read() in wake_one_more(), otherwise we can race. -arca
+ */
+
+static inline int waking_non_zero_trylock(struct semaphore *sem)
+{
+	unsigned long flags;
+	int ret = 1;
+
+	spin_lock_irqsave(&semaphore_wake_lock, flags);
+	if (sem->sleepers <= 0)
+		atomic_inc(&sem->count);
+	else {
+		sem->sleepers--;
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
+	return ret;
+}
+
+spinlock_t semaphore_wake_lock;
+
+/*
+ * Semaphores are implemented using a two-way counter:
+ * The "count" variable is decremented for each process
+ * that tries to sleep, while the "waking" variable is
+ * incremented when the "up()" code goes to wake up waiting
+ * processes.
+ *
+ * Notably, the inline "up()" and "down()" functions can
+ * efficiently test if they need to do any extra work (up
+ * needs to do something only if count was negative before
+ * the increment operation.
+ *
+ * waking_non_zero() (from asm/semaphore.h) must execute
+ * atomically.
+ *
+ * When __up() is called, the count was negative before
+ * incrementing it, and we need to wake up somebody.
+ *
+ * This routine adds one to the count of processes that need to
+ * wake up and exit. ALL waiting processes actually wake up but
+ * only the one that gets to the "waking" field first will gate
+ * through and acquire the semaphore. The others will go back
+ * to sleep.
+ *
+ * Note that these functions are only called when there is
+ * contention on the lock, and as such all this is the
+ * "non-critical" part of the whole semaphore business. The
+ * critical part is the inline stuff in <asm/semaphore.h>
+ * where we want to avoid any extra jumps and calls.
+ */
+
+void __up(struct semaphore *sem)
+{
+	wake_one_more(sem);
+	wake_up(&sem->wait);
+}
+
+/*
+ * Perform the "down" function. Return zero for semaphore acquired,
+ * return negative for signalled out of the function.
+ *
+ * If called from __down, the return is ignored and the wait loop is
+ * not interruptible. This means that a task waiting on a semaphore
+ * using "down()" cannot be killed until someone does an "up()" on
+ * the semaphore.
+ *
+ * If called from __down_interruptible, the return value gets checked
+ * upon return. If the return value is negative then the task continues
+ * with the negative value in the return register (it can be tested by
+ * the caller).
+ *
+ * Either form may be used in conjunction with "up()".
+ *
+ */
+
+#define DOWN_VAR				\
+	struct task_struct *tsk = current;	\
+	wait_queue_t wait;			\
+	init_waitqueue_entry(&wait, tsk);
+
+#define DOWN_HEAD(task_state)						\
+									\
+									\
+	tsk->state = (task_state);					\
+	add_wait_queue(&sem->wait, &wait);				\
+									\
+	/*								\
+	 * Ok, we're set up. sem->count is known to be less than zero	\
+	 * so we must wait.						\
+	 *								\
+	 * We can let go the lock for purposes of waiting.		\
+	 * We re-acquire it after awaking so as to protect		\
+	 * all semaphore operations.					\
+	 *								\
+	 * If "up()" is called before we call waking_non_zero() then	\
+	 * we will catch it right away. If it is called later then	\
+	 * we will have to go through a wakeup cycle to catch it.	\
+	 *								\
+	 * Multiple waiters contend for the semaphore lock to see	\
+	 * who gets to gate through and who has to wait some more.	\
+	 */								\
+	for (;;) {
+
+#define DOWN_TAIL(task_state)			\
+		tsk->state = (task_state);	\
+	}					\
+	tsk->state = TASK_RUNNING;		\
+	remove_wait_queue(&sem->wait, &wait);
+
+void __sched __down(struct semaphore *sem) {
+	DOWN_VAR
+	DOWN_HEAD(TASK_UNINTERRUPTIBLE)
+	if (waking_non_zero(sem))
+		break;
+	schedule();
+	DOWN_TAIL(TASK_UNINTERRUPTIBLE)
+}
+
+int __sched __down_interruptible(struct semaphore *sem) {
+	int ret = 0;
+	DOWN_VAR
+	DOWN_HEAD(TASK_INTERRUPTIBLE)
+
+	ret = waking_non_zero_interruptible(sem, tsk);
+	if (ret) {
+		if (ret == 1)
+			/* ret != 0 only if we get interrupted -arca */
+			ret = 0;
+		break;
+	}
+	schedule();
+	DOWN_TAIL(TASK_INTERRUPTIBLE)
+	return ret;
+}
+
+int __down_trylock(struct semaphore *sem)
+{
+	return waking_non_zero_trylock(sem);
+}
diff --git a/include/asm-microblaze/semaphore.h b/include/asm-microblaze/semaphore.h
new file mode 100644
index 0000000..f59aae6
--- /dev/null
+++ b/include/asm-microblaze/semaphore.h
@@ -0,0 +1,100 @@
+/*
+ * include/asm-microblaze/semaphore.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SEMAPHORE_H
+#define _ASM_SEMAPHORE_H
+
+#include <asm/atomic.h>
+#include <asm/system.h>
+#include <linux/wait.h>
+#include <linux/rwsem.h>
+
+struct semaphore {
+	atomic_t count;
+	int sleepers;
+	wait_queue_head_t wait;
+};
+
+#define __SEMAPHORE_INITIALIZER(name,n)					\
+{									\
+	.count		= ATOMIC_INIT(n),				\
+	.sleepers	= 0,						\
+	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
+}
+
+#define __DECLARE_SEMAPHORE_GENERIC(name,count)				\
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
+
+#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name, 1)
+#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name, 0)
+
+static inline void sema_init(struct semaphore *sem, int val)
+{
+	atomic_set(&sem->count, val);
+	sem->sleepers = 0;
+	init_waitqueue_head(&sem->wait);
+}
+
+static inline void init_MUTEX(struct semaphore *sem)
+{
+	sema_init(sem, 1);
+}
+
+static inline void init_MUTEX_LOCKED(struct semaphore *sem)
+{
+	sema_init(sem, 0);
+}
+
+asmlinkage void __down(struct semaphore *sem);
+asmlinkage int __down_interruptible(struct semaphore *sem);
+asmlinkage int __down_trylock(struct semaphore *sem);
+asmlinkage void __up(struct semaphore *sem);
+
+extern spinlock_t semaphore_wake_lock;
+
+static inline void down(struct semaphore *sem)
+{
+	might_sleep();
+
+	if (atomic_sub_return(1, &sem->count) < 0)
+		__down(sem);
+}
+
+static inline int down_interruptible(struct semaphore *sem)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	if (atomic_sub_return(1, &sem->count) < 0)
+		ret = __down_interruptible(sem);
+	return ret;
+}
+
+static inline int down_trylock(struct semaphore *sem)
+{
+	int ret = 0;
+
+	if (atomic_sub_return(1, &sem->count) < 0)
+		ret = __down_trylock(sem);
+	return ret;
+}
+
+/*
+ * Note! This is subtle. We jump to wake people up only if
+ * the semaphore was negative (== somebody was waiting on it).
+ */
+static inline void up(struct semaphore *sem)
+{
+	if (atomic_add_return(1, &sem->count) <= 0)
+		__up(sem);
+}
+
+#endif /* _ASM_SEMAPHORE_H */
-- 
1.5.4.rc4.14.g6fc74

