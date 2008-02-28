Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYB1Gtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYB1Gtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbYB1GqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:46:04 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52736 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751605AbYB1Gps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:48 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 11/12] Generic semaphore implementation
Date: Thu, 28 Feb 2008 01:34:00 -0500
Message-Id: <1204180441-8540-11-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-10-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
 <1204180441-8540-4-git-send-email-matthew@wil.cx>
 <1204180441-8540-5-git-send-email-matthew@wil.cx>
 <1204180441-8540-6-git-send-email-matthew@wil.cx>
 <1204180441-8540-7-git-send-email-matthew@wil.cx>
 <1204180441-8540-8-git-send-email-matthew@wil.cx>
 <1204180441-8540-9-git-send-email-matthew@wil.cx>
 <1204180441-8540-10-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semaphores are no longer performance-critical, so a generic C
implementation is better for maintainability, debuggability and
extensibility.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/alpha/kernel/Makefile               |    2 +-
 arch/alpha/kernel/alpha_ksyms.c          |    9 -
 arch/alpha/kernel/semaphore.c            |  224 --------------------------
 arch/arm/kernel/Makefile                 |    2 +-
 arch/arm/kernel/semaphore.c              |  221 --------------------------
 arch/avr32/kernel/Makefile               |    2 +-
 arch/avr32/kernel/semaphore.c            |  148 -----------------
 arch/blackfin/Kconfig                    |    4 -
 arch/blackfin/kernel/bfin_ksyms.c        |    5 -
 arch/cris/kernel/Makefile                |    3 +-
 arch/cris/kernel/crisksyms.c             |    7 -
 arch/cris/kernel/semaphore.c             |  129 ---------------
 arch/frv/kernel/Makefile                 |    2 +-
 arch/frv/kernel/frv_ksyms.c              |    1 -
 arch/frv/kernel/semaphore.c              |  155 ------------------
 arch/h8300/kernel/Makefile               |    2 +-
 arch/h8300/kernel/h8300_ksyms.c          |    1 -
 arch/h8300/kernel/semaphore.c            |  132 ----------------
 arch/ia64/kernel/Makefile                |    2 +-
 arch/ia64/kernel/ia64_ksyms.c            |    6 -
 arch/ia64/kernel/semaphore.c             |  165 -------------------
 arch/m32r/kernel/Makefile                |    2 +-
 arch/m32r/kernel/m32r_ksyms.c            |    5 -
 arch/m32r/kernel/semaphore.c             |  185 ----------------------
 arch/m68k/kernel/Makefile                |    2 +-
 arch/m68k/kernel/m68k_ksyms.c            |    6 -
 arch/m68k/kernel/semaphore.c             |  132 ----------------
 arch/m68k/lib/Makefile                   |    2 +-
 arch/m68k/lib/semaphore.S                |   53 ------
 arch/m68knommu/kernel/Makefile           |    2 +-
 arch/m68knommu/kernel/m68k_ksyms.c       |    6 -
 arch/m68knommu/kernel/semaphore.c        |  133 ----------------
 arch/m68knommu/lib/Makefile              |    2 +-
 arch/m68knommu/lib/semaphore.S           |   66 --------
 arch/mips/kernel/Makefile                |    2 +-
 arch/mips/kernel/semaphore.c             |  168 --------------------
 arch/mn10300/kernel/Makefile             |    2 +-
 arch/mn10300/kernel/semaphore.c          |  149 -----------------
 arch/parisc/kernel/Makefile              |    2 +-
 arch/parisc/kernel/parisc_ksyms.c        |    5 -
 arch/parisc/kernel/semaphore.c           |  102 ------------
 arch/powerpc/kernel/Makefile             |    2 +-
 arch/powerpc/kernel/ppc_ksyms.c          |    1 -
 arch/powerpc/kernel/semaphore.c          |  135 ----------------
 arch/ppc/kernel/semaphore.c              |  131 ---------------
 arch/s390/kernel/Makefile                |    2 +-
 arch/s390/kernel/s390_ksyms.c            |    7 -
 arch/s390/kernel/semaphore.c             |  108 -------------
 arch/sh/kernel/Makefile_32               |    2 +-
 arch/sh/kernel/Makefile_64               |    2 +-
 arch/sh/kernel/semaphore.c               |  139 ----------------
 arch/sh/kernel/sh_ksyms_32.c             |    7 -
 arch/sh/kernel/sh_ksyms_64.c             |    4 -
 arch/sparc/kernel/Makefile               |    2 +-
 arch/sparc/kernel/semaphore.c            |  155 ------------------
 arch/sparc/kernel/sparc_ksyms.c          |    5 -
 arch/sparc64/kernel/Makefile             |    2 +-
 arch/sparc64/kernel/semaphore.c          |  254 ------------------------------
 arch/sparc64/kernel/sparc64_ksyms.c      |    6 -
 arch/um/Kconfig.i386                     |   39 +++++-
 arch/um/Kconfig.x86_64                   |    6 +-
 arch/um/sys-i386/ksyms.c                 |   12 --
 arch/um/sys-ppc/Makefile                 |    8 +-
 arch/um/sys-x86_64/ksyms.c               |   13 +--
 arch/v850/kernel/Makefile                |    2 +-
 arch/v850/kernel/semaphore.c             |  166 -------------------
 arch/v850/kernel/v850_ksyms.c            |    7 -
 arch/x86/Kconfig                         |    7 -
 arch/x86/kernel/i386_ksyms_32.c          |    5 -
 arch/x86/kernel/x8664_ksyms_64.c         |    6 -
 arch/x86/lib/semaphore_32.S              |   83 ----------
 arch/x86/lib/thunk_64.S                  |    5 -
 arch/xtensa/kernel/Makefile              |    2 +-
 arch/xtensa/kernel/semaphore.c           |  226 --------------------------
 arch/xtensa/kernel/xtensa_ksyms.c        |    9 -
 include/asm-alpha/semaphore.h            |  150 +-----------------
 include/asm-arm/semaphore-helper.h       |   84 ----------
 include/asm-arm/semaphore.h              |   99 +------------
 include/asm-avr32/semaphore.h            |  109 +-------------
 include/asm-blackfin/semaphore-helper.h  |   82 ----------
 include/asm-blackfin/semaphore.h         |  106 +------------
 include/asm-cris/semaphore-helper.h      |   78 ---------
 include/asm-cris/semaphore.h             |  134 +----------------
 include/asm-frv/semaphore.h              |  156 +------------------
 include/asm-h8300/semaphore-helper.h     |   85 ----------
 include/asm-h8300/semaphore.h            |  191 +----------------------
 include/asm-ia64/semaphore.h             |  100 +------------
 include/asm-m32r/semaphore.h             |  145 +-----------------
 include/asm-m68k/semaphore-helper.h      |  142 -----------------
 include/asm-m68k/semaphore.h             |  164 +-------------------
 include/asm-m68knommu/semaphore-helper.h |   82 ----------
 include/asm-m68knommu/semaphore.h        |  154 +------------------
 include/asm-mips/semaphore.h             |  109 +-------------
 include/asm-mn10300/semaphore.h          |  170 +--------------------
 include/asm-parisc/semaphore-helper.h    |   89 -----------
 include/asm-parisc/semaphore.h           |  146 +-----------------
 include/asm-powerpc/semaphore.h          |   95 +-----------
 include/asm-s390/semaphore.h             |  108 +-------------
 include/asm-sh/semaphore-helper.h        |   89 -----------
 include/asm-sh/semaphore.h               |  116 +--------------
 include/asm-sparc/semaphore.h            |  193 +----------------------
 include/asm-sparc64/semaphore.h          |   54 +------
 include/asm-um/semaphore.h               |    7 +-
 include/asm-v850/semaphore.h             |   85 +----------
 include/asm-x86/semaphore.h              |    6 +-
 include/asm-x86/semaphore_32.h           |  175 --------------------
 include/asm-x86/semaphore_64.h           |  180 ---------------------
 include/asm-xtensa/semaphore.h           |  100 +------------
 include/linux/semaphore.h                |   81 ++++++++++
 kernel/Makefile                          |    2 +-
 kernel/semaphore.c                       |  204 ++++++++++++++++++++++++
 lib/Makefile                             |    1 -
 lib/semaphore-sleepers.c                 |  176 ---------------------
 113 files changed, 374 insertions(+), 7681 deletions(-)
 delete mode 100644 arch/alpha/kernel/semaphore.c
 delete mode 100644 arch/arm/kernel/semaphore.c
 delete mode 100644 arch/avr32/kernel/semaphore.c
 delete mode 100644 arch/cris/kernel/semaphore.c
 delete mode 100644 arch/frv/kernel/semaphore.c
 delete mode 100644 arch/h8300/kernel/semaphore.c
 delete mode 100644 arch/ia64/kernel/semaphore.c
 delete mode 100644 arch/m32r/kernel/semaphore.c
 delete mode 100644 arch/m68k/kernel/semaphore.c
 delete mode 100644 arch/m68k/lib/semaphore.S
 delete mode 100644 arch/m68knommu/kernel/semaphore.c
 delete mode 100644 arch/m68knommu/lib/semaphore.S
 delete mode 100644 arch/mips/kernel/semaphore.c
 delete mode 100644 arch/mn10300/kernel/semaphore.c
 delete mode 100644 arch/parisc/kernel/semaphore.c
 delete mode 100644 arch/powerpc/kernel/semaphore.c
 delete mode 100644 arch/ppc/kernel/semaphore.c
 delete mode 100644 arch/s390/kernel/semaphore.c
 delete mode 100644 arch/sh/kernel/semaphore.c
 delete mode 100644 arch/sparc/kernel/semaphore.c
 delete mode 100644 arch/sparc64/kernel/semaphore.c
 delete mode 100644 arch/v850/kernel/semaphore.c
 delete mode 100644 arch/xtensa/kernel/semaphore.c
 delete mode 100644 include/asm-arm/semaphore-helper.h
 delete mode 100644 include/asm-blackfin/semaphore-helper.h
 delete mode 100644 include/asm-cris/semaphore-helper.h
 delete mode 100644 include/asm-h8300/semaphore-helper.h
 delete mode 100644 include/asm-m68k/semaphore-helper.h
 delete mode 100644 include/asm-m68knommu/semaphore-helper.h
 delete mode 100644 include/asm-parisc/semaphore-helper.h
 delete mode 100644 include/asm-sh/semaphore-helper.h
 delete mode 100644 include/asm-x86/semaphore_32.h
 delete mode 100644 include/asm-x86/semaphore_64.h
 create mode 100644 include/linux/semaphore.h
 create mode 100644 kernel/semaphore.c
 delete mode 100644 lib/semaphore-sleepers.c

diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index dccf052..ac706c1 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -7,7 +7,7 @@ EXTRA_AFLAGS	:= $(KBUILD_CFLAGS)
 EXTRA_CFLAGS	:= -Werror -Wno-sign-compare
 
 obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
-	    irq_alpha.o signal.o setup.o ptrace.o time.o semaphore.o \
+	    irq_alpha.o signal.o setup.o ptrace.o time.o \
 	    alpha_ksyms.o systbls.o err_common.o io.o
 
 obj-$(CONFIG_VGA_HOSE)	+= console.o
diff --git a/arch/alpha/kernel/alpha_ksyms.c b/arch/alpha/kernel/alpha_ksyms.c
index e9762a3..d96e742 100644
--- a/arch/alpha/kernel/alpha_ksyms.c
+++ b/arch/alpha/kernel/alpha_ksyms.c
@@ -77,15 +77,6 @@ EXPORT_SYMBOL(__do_clear_user);
 EXPORT_SYMBOL(__strncpy_from_user);
 EXPORT_SYMBOL(__strnlen_user);
 
-/* Semaphore helper functions.  */
-EXPORT_SYMBOL(__down_failed);
-EXPORT_SYMBOL(__down_failed_interruptible);
-EXPORT_SYMBOL(__up_wakeup);
-EXPORT_SYMBOL(down);
-EXPORT_SYMBOL(down_interruptible);
-EXPORT_SYMBOL(down_trylock);
-EXPORT_SYMBOL(up);
-
 /* 
  * SMP-specific symbols.
  */
diff --git a/arch/alpha/kernel/semaphore.c b/arch/alpha/kernel/semaphore.c
deleted file mode 100644
index 8d2982a..0000000
--- a/arch/alpha/kernel/semaphore.c
+++ /dev/null
@@ -1,224 +0,0 @@
-/*
- * Alpha semaphore implementation.
- *
- * (C) Copyright 1996 Linus Torvalds
- * (C) Copyright 1999, 2000 Richard Henderson
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-
-/*
- * This is basically the PPC semaphore scheme ported to use
- * the Alpha ll/sc sequences, so see the PPC code for
- * credits.
- */
-
-/*
- * Atomically update sem->count.
- * This does the equivalent of the following:
- *
- *	old_count = sem->count;
- *	tmp = MAX(old_count, 0) + incr;
- *	sem->count = tmp;
- *	return old_count;
- */
-static inline int __sem_update_count(struct semaphore *sem, int incr)
-{
-	long old_count, tmp = 0;
-
-	__asm__ __volatile__(
-	"1:	ldl_l	%0,%2\n"
-	"	cmovgt	%0,%0,%1\n"
-	"	addl	%1,%3,%1\n"
-	"	stl_c	%1,%2\n"
-	"	beq	%1,2f\n"
-	"	mb\n"
-	".subsection 2\n"
-	"2:	br	1b\n"
-	".previous"
-	: "=&r" (old_count), "=&r" (tmp), "=m" (sem->count)
-	: "Ir" (incr), "1" (tmp), "m" (sem->count));
-
-	return old_count;
-}
-
-/*
- * Perform the "down" function.  Return zero for semaphore acquired,
- * return negative for signalled out of the function.
- *
- * If called from down, the return is ignored and the wait loop is
- * not interruptible.  This means that a task waiting on a semaphore
- * using "down()" cannot be killed until someone does an "up()" on
- * the semaphore.
- *
- * If called from down_interruptible, the return value gets checked
- * upon return.  If the return value is negative then the task continues
- * with the negative value in the return register (it can be tested by
- * the caller).
- *
- * Either form may be used in conjunction with "up()".
- */
-
-void __sched
-__down_failed(struct semaphore *sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	printk("%s(%d): down failed(%p)\n",
-	       tsk->comm, task_pid_nr(tsk), sem);
-#endif
-
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	wmb();
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	/*
-	 * Try to get the semaphore.  If the count is > 0, then we've
-	 * got the semaphore; we decrement count and exit the loop.
-	 * If the count is 0 or negative, we set it to -1, indicating
-	 * that we are asleep, and then sleep.
-	 */
-	while (__sem_update_count(sem, -1) <= 0) {
-		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	tsk->state = TASK_RUNNING;
-
-	/*
-	 * If there are any more sleepers, wake one of them up so
-	 * that it can either get the semaphore, or set count to -1
-	 * indicating that there are still processes sleeping.
-	 */
-	wake_up(&sem->wait);
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	printk("%s(%d): down acquired(%p)\n",
-	       tsk->comm, task_pid_nr(tsk), sem);
-#endif
-}
-
-int __sched
-__down_failed_interruptible(struct semaphore *sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	long ret = 0;
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	printk("%s(%d): down failed(%p)\n",
-	       tsk->comm, task_pid_nr(tsk), sem);
-#endif
-
-	tsk->state = TASK_INTERRUPTIBLE;
-	wmb();
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	while (__sem_update_count(sem, -1) <= 0) {
-		if (signal_pending(current)) {
-			/*
-			 * A signal is pending - give up trying.
-			 * Set sem->count to 0 if it is negative,
-			 * since we are no longer sleeping.
-			 */
-			__sem_update_count(sem, 0);
-			ret = -EINTR;
-			break;
-		}
-		schedule();
-		set_task_state(tsk, TASK_INTERRUPTIBLE);
-	}
-
-	remove_wait_queue(&sem->wait, &wait);
-	tsk->state = TASK_RUNNING;
-	wake_up(&sem->wait);
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	printk("%s(%d): down %s(%p)\n",
-	       current->comm, task_pid_nr(current),
-	       (ret < 0 ? "interrupted" : "acquired"), sem);
-#endif
-	return ret;
-}
-
-void
-__up_wakeup(struct semaphore *sem)
-{
-	/*
-	 * Note that we incremented count in up() before we came here,
-	 * but that was ineffective since the result was <= 0, and
-	 * any negative value of count is equivalent to 0.
-	 * This ends up setting count to 1, unless count is now > 0
-	 * (i.e. because some other cpu has called up() in the meantime),
-	 * in which case we just increment count.
-	 */
-	__sem_update_count(sem, 1);
-	wake_up(&sem->wait);
-}
-
-void __sched
-down(struct semaphore *sem)
-{
-#ifdef WAITQUEUE_DEBUG
-	CHECK_MAGIC(sem->__magic);
-#endif
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	printk("%s(%d): down(%p) <count=%d> from %p\n",
-	       current->comm, task_pid_nr(current), sem,
-	       atomic_read(&sem->count), __builtin_return_address(0));
-#endif
-	__down(sem);
-}
-
-int __sched
-down_interruptible(struct semaphore *sem)
-{
-#ifdef WAITQUEUE_DEBUG
-	CHECK_MAGIC(sem->__magic);
-#endif
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	printk("%s(%d): down(%p) <count=%d> from %p\n",
-	       current->comm, task_pid_nr(current), sem,
-	       atomic_read(&sem->count), __builtin_return_address(0));
-#endif
-	return __down_interruptible(sem);
-}
-
-int
-down_trylock(struct semaphore *sem)
-{
-	int ret;
-
-#ifdef WAITQUEUE_DEBUG
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	ret = __down_trylock(sem);
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	printk("%s(%d): down_trylock %s from %p\n",
-	       current->comm, task_pid_nr(current),
-	       ret ? "failed" : "acquired",
-	       __builtin_return_address(0));
-#endif
-
-	return ret;
-}
-
-void
-up(struct semaphore *sem)
-{
-#ifdef WAITQUEUE_DEBUG
-	CHECK_MAGIC(sem->__magic);
-#endif
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	printk("%s(%d): up(%p) <count=%d> from %p\n",
-	       current->comm, task_pid_nr(current), sem,
-	       atomic_read(&sem->count), __builtin_return_address(0));
-#endif
-	__up(sem);
-}
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 00d44c6..6235f72 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -7,7 +7,7 @@ AFLAGS_head.o := -DTEXT_OFFSET=$(TEXT_OFFSET)
 # Object file lists.
 
 obj-y		:= compat.o entry-armv.o entry-common.o irq.o \
-		   process.o ptrace.o semaphore.o setup.o signal.o \
+		   process.o ptrace.o setup.o signal.o \
 		   sys_arm.o stacktrace.o time.o traps.o
 
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
diff --git a/arch/arm/kernel/semaphore.c b/arch/arm/kernel/semaphore.c
deleted file mode 100644
index 981fe5c..0000000
--- a/arch/arm/kernel/semaphore.c
+++ /dev/null
@@ -1,221 +0,0 @@
-/*
- *  ARM semaphore implementation, taken from
- *
- *  i386 semaphore implementation.
- *
- *  (C) Copyright 1999 Linus Torvalds
- *
- *  Modified for ARM by Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-
-#include <asm/semaphore.h>
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to acquire the semaphore, while the "sleeping"
- * variable is a count of such acquires.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * "sleeping" and the contention routine ordering is
- * protected by the semaphore spinlock.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-
-/*
- * Logic:
- *  - only on a boundary condition do we need to care. When we go
- *    from a negative count to a non-negative, we wake people up.
- *  - when we go from a non-negative count to a negative do we
- *    (a) synchronize with the "sleeper" count and (b) make sure
- *    that we're on the wakeup list before we synchronize so that
- *    we cannot lose wakeup events.
- */
-
-void __up(struct semaphore *sem)
-{
-	wake_up(&sem->wait);
-}
-
-static DEFINE_SPINLOCK(semaphore_lock);
-
-void __sched __down(struct semaphore * sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	spin_lock_irq(&semaphore_lock);
-	sem->sleepers++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irq(&semaphore_lock);
-
-		schedule();
-		tsk->state = TASK_UNINTERRUPTIBLE;
-		spin_lock_irq(&semaphore_lock);
-	}
-	spin_unlock_irq(&semaphore_lock);
-	remove_wait_queue(&sem->wait, &wait);
-	tsk->state = TASK_RUNNING;
-	wake_up(&sem->wait);
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	tsk->state = TASK_INTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	spin_lock_irq(&semaphore_lock);
-	sem->sleepers ++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * With signals pending, this turns into
-		 * the trylock failure case - we won't be
-		 * sleeping, and we* can't get the lock as
-		 * it has contention. Just correct the count
-		 * and exit.
-		 */
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			sem->sleepers = 0;
-			atomic_add(sleepers, &sem->count);
-			break;
-		}
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock. The
-		 * "-1" is because we're still hoping to get
-		 * the lock.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irq(&semaphore_lock);
-
-		schedule();
-		tsk->state = TASK_INTERRUPTIBLE;
-		spin_lock_irq(&semaphore_lock);
-	}
-	spin_unlock_irq(&semaphore_lock);
-	tsk->state = TASK_RUNNING;
-	remove_wait_queue(&sem->wait, &wait);
-	wake_up(&sem->wait);
-	return retval;
-}
-
-/*
- * Trylock failed - make sure we correct for
- * having decremented the count.
- *
- * We could have done the trylock with a
- * single "cmpxchg" without failure cases,
- * but then it wouldn't work on a 386.
- */
-int __down_trylock(struct semaphore * sem)
-{
-	int sleepers;
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_lock, flags);
-	sleepers = sem->sleepers + 1;
-	sem->sleepers = 0;
-
-	/*
-	 * Add "everybody else" and us into it. They aren't
-	 * playing, because we own the spinlock.
-	 */
-	if (!atomic_add_negative(sleepers, &sem->count))
-		wake_up(&sem->wait);
-
-	spin_unlock_irqrestore(&semaphore_lock, flags);
-	return 1;
-}
-
-/*
- * The semaphore operations have a special calling sequence that
- * allow us to do a simpler in-line version of them. These routines
- * need to convert that sequence back into the C sequence when
- * there is contention on the semaphore.
- *
- * ip contains the semaphore pointer on entry. Save the C-clobbered
- * registers (r0 to r3 and lr), but not ip, as we use it as a return
- * value in some cases..
- * To remain AAPCS compliant (64-bit stack align) we save r4 as well.
- */
-asm("	.section .sched.text,\"ax\",%progbits	\n\
-	.align	5				\n\
-	.globl	__down_failed			\n\
-__down_failed:					\n\
-	stmfd	sp!, {r0 - r4, lr}		\n\
-	mov	r0, ip				\n\
-	bl	__down				\n\
-	ldmfd	sp!, {r0 - r4, pc}		\n\
-						\n\
-	.align	5				\n\
-	.globl	__down_interruptible_failed	\n\
-__down_interruptible_failed:			\n\
-	stmfd	sp!, {r0 - r4, lr}		\n\
-	mov	r0, ip				\n\
-	bl	__down_interruptible		\n\
-	mov	ip, r0				\n\
-	ldmfd	sp!, {r0 - r4, pc}		\n\
-						\n\
-	.align	5				\n\
-	.globl	__down_trylock_failed		\n\
-__down_trylock_failed:				\n\
-	stmfd	sp!, {r0 - r4, lr}		\n\
-	mov	r0, ip				\n\
-	bl	__down_trylock			\n\
-	mov	ip, r0				\n\
-	ldmfd	sp!, {r0 - r4, pc}		\n\
-						\n\
-	.align	5				\n\
-	.globl	__up_wakeup			\n\
-__up_wakeup:					\n\
-	stmfd	sp!, {r0 - r4, lr}		\n\
-	mov	r0, ip				\n\
-	bl	__up				\n\
-	ldmfd	sp!, {r0 - r4, pc}		\n\
-	");
-
-EXPORT_SYMBOL(__down_failed);
-EXPORT_SYMBOL(__down_interruptible_failed);
-EXPORT_SYMBOL(__down_trylock_failed);
-EXPORT_SYMBOL(__up_wakeup);
diff --git a/arch/avr32/kernel/Makefile b/arch/avr32/kernel/Makefile
index e4b6d12..18229d0 100644
--- a/arch/avr32/kernel/Makefile
+++ b/arch/avr32/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y				:= head.o vmlinux.lds
 
 obj-$(CONFIG_SUBARCH_AVR32B)	+= entry-avr32b.o
 obj-y				+= syscall_table.o syscall-stubs.o irq.o
-obj-y				+= setup.o traps.o semaphore.o ocd.o ptrace.o
+obj-y				+= setup.o traps.o ocd.o ptrace.o
 obj-y				+= signal.o sys_avr32.o process.o time.o
 obj-y				+= init_task.o switch_to.o cpu.o
 obj-$(CONFIG_MODULES)		+= module.o avr32_ksyms.o
diff --git a/arch/avr32/kernel/semaphore.c b/arch/avr32/kernel/semaphore.c
deleted file mode 100644
index 1e2705a..0000000
--- a/arch/avr32/kernel/semaphore.c
+++ /dev/null
@@ -1,148 +0,0 @@
-/*
- * AVR32 sempahore implementation.
- *
- * Copyright (C) 2004-2006 Atmel Corporation
- *
- * Based on linux/arch/i386/kernel/semaphore.c
- *  Copyright (C) 1999 Linus Torvalds
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/sched.h>
-#include <linux/errno.h>
-#include <linux/module.h>
-
-#include <asm/semaphore.h>
-#include <asm/atomic.h>
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to acquire the semaphore, while the "sleeping"
- * variable is a count of such acquires.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * "sleeping" and the contention routine ordering is protected
- * by the spinlock in the semaphore's waitqueue head.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-
-/*
- * Logic:
- *  - only on a boundary condition do we need to care. When we go
- *    from a negative count to a non-negative, we wake people up.
- *  - when we go from a non-negative count to a negative do we
- *    (a) synchronize with the "sleeper" count and (b) make sure
- *    that we're on the wakeup list before we synchronize so that
- *    we cannot lose wakeup events.
- */
-
-void __up(struct semaphore *sem)
-{
-	wake_up(&sem->wait);
-}
-EXPORT_SYMBOL(__up);
-
-void __sched __down(struct semaphore *sem)
-{
-	struct task_struct *tsk = current;
-        DECLARE_WAITQUEUE(wait, tsk);
-        unsigned long flags;
-
-        tsk->state = TASK_UNINTERRUPTIBLE;
-        spin_lock_irqsave(&sem->wait.lock, flags);
-        add_wait_queue_exclusive_locked(&sem->wait, &wait);
-
-        sem->sleepers++;
-        for (;;) {
-                int sleepers = sem->sleepers;
-
-                /*
-                 * Add "everybody else" into it. They aren't
-                 * playing, because we own the spinlock in
-                 * the wait_queue_head.
-                 */
-                if (atomic_add_return(sleepers - 1, &sem->count) >= 0) {
-                        sem->sleepers = 0;
-                        break;
-                }
-                sem->sleepers = 1;      /* us - see -1 above */
-                spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-                schedule();
-
-                spin_lock_irqsave(&sem->wait.lock, flags);
-                tsk->state = TASK_UNINTERRUPTIBLE;
-        }
-        remove_wait_queue_locked(&sem->wait, &wait);
-        wake_up_locked(&sem->wait);
-        spin_unlock_irqrestore(&sem->wait.lock, flags);
-        tsk->state = TASK_RUNNING;
-}
-EXPORT_SYMBOL(__down);
-
-int __sched __down_interruptible(struct semaphore *sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-        DECLARE_WAITQUEUE(wait, tsk);
-        unsigned long flags;
-
-        tsk->state = TASK_INTERRUPTIBLE;
-        spin_lock_irqsave(&sem->wait.lock, flags);
-        add_wait_queue_exclusive_locked(&sem->wait, &wait);
-
-        sem->sleepers++;
-        for (;;) {
-                int sleepers = sem->sleepers;
-
-		/*
-		 * With signals pending, this turns into the trylock
-		 * failure case - we won't be sleeping, and we can't
-		 * get the lock as it has contention. Just correct the
-		 * count and exit.
-		 */
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			sem->sleepers = 0;
-			atomic_add(sleepers, &sem->count);
-			break;
-		}
-
-                /*
-                 * Add "everybody else" into it. They aren't
-                 * playing, because we own the spinlock in
-                 * the wait_queue_head.
-                 */
-                if (atomic_add_return(sleepers - 1, &sem->count) >= 0) {
-                        sem->sleepers = 0;
-                        break;
-                }
-                sem->sleepers = 1;      /* us - see -1 above */
-                spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-                schedule();
-
-                spin_lock_irqsave(&sem->wait.lock, flags);
-                tsk->state = TASK_INTERRUPTIBLE;
-        }
-        remove_wait_queue_locked(&sem->wait, &wait);
-        wake_up_locked(&sem->wait);
-        spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-        tsk->state = TASK_RUNNING;
-	return retval;
-}
-EXPORT_SYMBOL(__down_interruptible);
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 589c6ac..2dd1f30 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -31,10 +31,6 @@ config ZONE_DMA
 	bool
 	default y
 
-config SEMAPHORE_SLEEPERS
-	bool
-	default y
-
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index 0bfbb26..053edff 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -42,11 +42,6 @@ EXPORT_SYMBOL(ip_fast_csum);
 
 EXPORT_SYMBOL(kernel_thread);
 
-EXPORT_SYMBOL(__up);
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_trylock);
-EXPORT_SYMBOL(__down_interruptible);
-
 EXPORT_SYMBOL(is_in_rom);
 EXPORT_SYMBOL(bfin_return_from_exception);
 
diff --git a/arch/cris/kernel/Makefile b/arch/cris/kernel/Makefile
index c8e8ea5..ee7bcd4 100644
--- a/arch/cris/kernel/Makefile
+++ b/arch/cris/kernel/Makefile
@@ -5,8 +5,7 @@
 
 extra-y	:= vmlinux.lds
 
-obj-y   := process.o traps.o irq.o ptrace.o setup.o \
-	   time.o sys_cris.o semaphore.o
+obj-y   := process.o traps.o irq.o ptrace.o setup.o time.o sys_cris.o
 
 obj-$(CONFIG_MODULES)    += crisksyms.o
 obj-$(CONFIG_MODULES)	 += module.o
diff --git a/arch/cris/kernel/crisksyms.c b/arch/cris/kernel/crisksyms.c
index 62f0e75..7ac000f 100644
--- a/arch/cris/kernel/crisksyms.c
+++ b/arch/cris/kernel/crisksyms.c
@@ -9,7 +9,6 @@
 #include <linux/string.h>
 #include <linux/tty.h>
 
-#include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/checksum.h>
@@ -49,12 +48,6 @@ EXPORT_SYMBOL(__negdi2);
 EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(iounmap);
 
-/* Semaphore functions */
-EXPORT_SYMBOL(__up);
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_interruptible);
-EXPORT_SYMBOL(__down_trylock);
-
 /* Userspace access functions */
 EXPORT_SYMBOL(__copy_user_zeroing);
 EXPORT_SYMBOL(__copy_user);
diff --git a/arch/cris/kernel/semaphore.c b/arch/cris/kernel/semaphore.c
deleted file mode 100644
index f137a43..0000000
--- a/arch/cris/kernel/semaphore.c
+++ /dev/null
@@ -1,129 +0,0 @@
-/*
- *  Generic semaphore code. Buyer beware. Do your own
- * specific changes in <asm/semaphore-helper.h>
- */
-
-#include <linux/sched.h>
-#include <asm/semaphore-helper.h>
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to sleep, while the "waking" variable is
- * incremented when the "up()" code goes to wake up waiting
- * processes.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * waking_non_zero() (from asm/semaphore.h) must execute
- * atomically.
- *
- * When __up() is called, the count was negative before
- * incrementing it, and we need to wake up somebody.
- *
- * This routine adds one to the count of processes that need to
- * wake up and exit.  ALL waiting processes actually wake up but
- * only the one that gets to the "waking" field first will gate
- * through and acquire the semaphore.  The others will go back
- * to sleep.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-void __up(struct semaphore *sem)
-{
-	wake_one_more(sem);
-	wake_up(&sem->wait);
-}
-
-/*
- * Perform the "down" function.  Return zero for semaphore acquired,
- * return negative for signalled out of the function.
- *
- * If called from __down, the return is ignored and the wait loop is
- * not interruptible.  This means that a task waiting on a semaphore
- * using "down()" cannot be killed until someone does an "up()" on
- * the semaphore.
- *
- * If called from __down_interruptible, the return value gets checked
- * upon return.  If the return value is negative then the task continues
- * with the negative value in the return register (it can be tested by
- * the caller).
- *
- * Either form may be used in conjunction with "up()".
- *
- */
-
-#define DOWN_VAR				\
-	struct task_struct *tsk = current;	\
-	wait_queue_t wait;			\
-	init_waitqueue_entry(&wait, tsk);
-
-#define DOWN_HEAD(task_state)						\
-									\
-									\
-	tsk->state = (task_state);					\
-	add_wait_queue(&sem->wait, &wait);				\
-									\
-	/*								\
-	 * Ok, we're set up.  sem->count is known to be less than zero	\
-	 * so we must wait.						\
-	 *								\
-	 * We can let go the lock for purposes of waiting.		\
-	 * We re-acquire it after awaking so as to protect		\
-	 * all semaphore operations.					\
-	 *								\
-	 * If "up()" is called before we call waking_non_zero() then	\
-	 * we will catch it right away.  If it is called later then	\
-	 * we will have to go through a wakeup cycle to catch it.	\
-	 *								\
-	 * Multiple waiters contend for the semaphore lock to see	\
-	 * who gets to gate through and who has to wait some more.	\
-	 */								\
-	for (;;) {
-
-#define DOWN_TAIL(task_state)			\
-		tsk->state = (task_state);	\
-	}					\
-	tsk->state = TASK_RUNNING;		\
-	remove_wait_queue(&sem->wait, &wait);
-
-void __sched __down(struct semaphore * sem)
-{
-	DOWN_VAR
-	DOWN_HEAD(TASK_UNINTERRUPTIBLE)
-	if (waking_non_zero(sem))
-		break;
-	schedule();
-	DOWN_TAIL(TASK_UNINTERRUPTIBLE)
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-	DOWN_VAR
-	DOWN_HEAD(TASK_INTERRUPTIBLE)
-
-	ret = waking_non_zero_interruptible(sem, tsk);
-	if (ret)
-	{
-		if (ret == 1)
-			/* ret != 0 only if we get interrupted -arca */
-			ret = 0;
-		break;
-	}
-	schedule();
-	DOWN_TAIL(TASK_INTERRUPTIBLE)
-	return ret;
-}
-
-int __down_trylock(struct semaphore * sem)
-{
-	return waking_non_zero_trylock(sem);
-}
diff --git a/arch/frv/kernel/Makefile b/arch/frv/kernel/Makefile
index e8f73ed..c36f70b 100644
--- a/arch/frv/kernel/Makefile
+++ b/arch/frv/kernel/Makefile
@@ -9,7 +9,7 @@ extra-y:= head.o init_task.o vmlinux.lds
 
 obj-y := $(heads-y) entry.o entry-table.o break.o switch_to.o kernel_thread.o \
 	 kernel_execve.o process.o traps.o ptrace.o signal.o dma.o \
-	 sys_frv.o time.o semaphore.o setup.o frv_ksyms.o \
+	 sys_frv.o time.o setup.o frv_ksyms.o \
 	 debug-stub.o irq.o sleep.o uaccess.o
 
 obj-$(CONFIG_GDBSTUB)		+= gdb-stub.o gdb-io.o
diff --git a/arch/frv/kernel/frv_ksyms.c b/arch/frv/kernel/frv_ksyms.c
index f772704..0316b3c 100644
--- a/arch/frv/kernel/frv_ksyms.c
+++ b/arch/frv/kernel/frv_ksyms.c
@@ -12,7 +12,6 @@
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/hardirq.h>
 #include <asm/cacheflush.h>
diff --git a/arch/frv/kernel/semaphore.c b/arch/frv/kernel/semaphore.c
deleted file mode 100644
index 7ee3a14..0000000
--- a/arch/frv/kernel/semaphore.c
+++ /dev/null
@@ -1,155 +0,0 @@
-/* semaphore.c: FR-V semaphores
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- * - Derived from lib/rwsem-spinlock.c
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/sched.h>
-#include <linux/module.h>
-#include <asm/semaphore.h>
-
-struct sem_waiter {
-	struct list_head	list;
-	struct task_struct	*task;
-};
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-void semtrace(struct semaphore *sem, const char *str)
-{
-	if (sem->debug)
-		printk("[%d] %s({%d,%d})\n",
-		       current->pid,
-		       str,
-		       sem->counter,
-		       list_empty(&sem->wait_list) ? 0 : 1);
-}
-#else
-#define semtrace(SEM,STR) do { } while(0)
-#endif
-
-/*
- * wait for a token to be granted from a semaphore
- * - entered with lock held and interrupts disabled
- */
-void __down(struct semaphore *sem, unsigned long flags)
-{
-	struct task_struct *tsk = current;
-	struct sem_waiter waiter;
-
-	semtrace(sem, "Entering __down");
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	get_task_struct(tsk);
-
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	/* wait to be given the semaphore */
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-
-	for (;;) {
-		if (list_empty(&waiter.list))
-			break;
-		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	}
-
-	tsk->state = TASK_RUNNING;
-	semtrace(sem, "Leaving __down");
-}
-
-EXPORT_SYMBOL(__down);
-
-/*
- * interruptibly wait for a token to be granted from a semaphore
- * - entered with lock held and interrupts disabled
- */
-int __down_interruptible(struct semaphore *sem, unsigned long flags)
-{
-	struct task_struct *tsk = current;
-	struct sem_waiter waiter;
-	int ret;
-
-	semtrace(sem,"Entering __down_interruptible");
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	get_task_struct(tsk);
-
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we don't need to touch the semaphore struct anymore */
-	set_task_state(tsk, TASK_INTERRUPTIBLE);
-
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	/* wait to be given the semaphore */
-	ret = 0;
-	for (;;) {
-		if (list_empty(&waiter.list))
-			break;
-		if (unlikely(signal_pending(current)))
-			goto interrupted;
-		schedule();
-		set_task_state(tsk, TASK_INTERRUPTIBLE);
-	}
-
- out:
-	tsk->state = TASK_RUNNING;
-	semtrace(sem, "Leaving __down_interruptible");
-	return ret;
-
- interrupted:
-	spin_lock_irqsave(&sem->wait_lock, flags);
-
-	if (!list_empty(&waiter.list)) {
-		list_del(&waiter.list);
-		ret = -EINTR;
-	}
-
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-	if (ret == -EINTR)
-		put_task_struct(current);
-	goto out;
-}
-
-EXPORT_SYMBOL(__down_interruptible);
-
-/*
- * release a single token back to a semaphore
- * - entered with lock held and interrupts disabled
- */
-void __up(struct semaphore *sem)
-{
-	struct task_struct *tsk;
-	struct sem_waiter *waiter;
-
-	semtrace(sem,"Entering __up");
-
-	/* grant the token to the process at the front of the queue */
-	waiter = list_entry(sem->wait_list.next, struct sem_waiter, list);
-
-	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
-	 * It is allocated on the waiter's stack and may become invalid at
-	 * any time after that point (due to a wakeup from another source).
-	 */
-	list_del_init(&waiter->list);
-	tsk = waiter->task;
-	mb();
-	waiter->task = NULL;
-	wake_up_process(tsk);
-	put_task_struct(tsk);
-
-	semtrace(sem,"Leaving __up");
-}
-
-EXPORT_SYMBOL(__up);
diff --git a/arch/h8300/kernel/Makefile b/arch/h8300/kernel/Makefile
index 874f6ae..6c248c3 100644
--- a/arch/h8300/kernel/Makefile
+++ b/arch/h8300/kernel/Makefile
@@ -5,7 +5,7 @@
 extra-y := vmlinux.lds
 
 obj-y := process.o traps.o ptrace.o irq.o \
-	 sys_h8300.o time.o semaphore.o signal.o \
+	 sys_h8300.o time.o signal.o \
          setup.o gpio.o init_task.o syscalls.o \
 	 entry.o
 
diff --git a/arch/h8300/kernel/h8300_ksyms.c b/arch/h8300/kernel/h8300_ksyms.c
index d1b1526..6866bd9 100644
--- a/arch/h8300/kernel/h8300_ksyms.c
+++ b/arch/h8300/kernel/h8300_ksyms.c
@@ -12,7 +12,6 @@
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/current.h>
 #include <asm/gpio.h>
diff --git a/arch/h8300/kernel/semaphore.c b/arch/h8300/kernel/semaphore.c
deleted file mode 100644
index d12cbbf..0000000
--- a/arch/h8300/kernel/semaphore.c
+++ /dev/null
@@ -1,132 +0,0 @@
-/*
- *  Generic semaphore code. Buyer beware. Do your own
- * specific changes in <asm/semaphore-helper.h>
- */
-
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <asm/semaphore-helper.h>
-
-#ifndef CONFIG_RMW_INSNS
-spinlock_t semaphore_wake_lock;
-#endif
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to sleep, while the "waking" variable is
- * incremented when the "up()" code goes to wake up waiting
- * processes.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * waking_non_zero() (from asm/semaphore.h) must execute
- * atomically.
- *
- * When __up() is called, the count was negative before
- * incrementing it, and we need to wake up somebody.
- *
- * This routine adds one to the count of processes that need to
- * wake up and exit.  ALL waiting processes actually wake up but
- * only the one that gets to the "waking" field first will gate
- * through and acquire the semaphore.  The others will go back
- * to sleep.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-void __up(struct semaphore *sem)
-{
-	wake_one_more(sem);
-	wake_up(&sem->wait);
-}
-
-/*
- * Perform the "down" function.  Return zero for semaphore acquired,
- * return negative for signalled out of the function.
- *
- * If called from __down, the return is ignored and the wait loop is
- * not interruptible.  This means that a task waiting on a semaphore
- * using "down()" cannot be killed until someone does an "up()" on
- * the semaphore.
- *
- * If called from __down_interruptible, the return value gets checked
- * upon return.  If the return value is negative then the task continues
- * with the negative value in the return register (it can be tested by
- * the caller).
- *
- * Either form may be used in conjunction with "up()".
- *
- */
-
-
-#define DOWN_HEAD(task_state)						\
-									\
-									\
-	current->state = (task_state);					\
-	add_wait_queue(&sem->wait, &wait);				\
-									\
-	/*								\
-	 * Ok, we're set up.  sem->count is known to be less than zero	\
-	 * so we must wait.						\
-	 *								\
-	 * We can let go the lock for purposes of waiting.		\
-	 * We re-acquire it after awaking so as to protect		\
-	 * all semaphore operations.					\
-	 *								\
-	 * If "up()" is called before we call waking_non_zero() then	\
-	 * we will catch it right away.  If it is called later then	\
-	 * we will have to go through a wakeup cycle to catch it.	\
-	 *								\
-	 * Multiple waiters contend for the semaphore lock to see	\
-	 * who gets to gate through and who has to wait some more.	\
-	 */								\
-	for (;;) {
-
-#define DOWN_TAIL(task_state)			\
-		current->state = (task_state);	\
-	}					\
-	current->state = TASK_RUNNING;		\
-	remove_wait_queue(&sem->wait, &wait);
-
-void __sched __down(struct semaphore * sem)
-{
-	DECLARE_WAITQUEUE(wait, current);
-
-	DOWN_HEAD(TASK_UNINTERRUPTIBLE)
-	if (waking_non_zero(sem))
-		break;
-	schedule();
-	DOWN_TAIL(TASK_UNINTERRUPTIBLE)
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	DECLARE_WAITQUEUE(wait, current);
-	int ret = 0;
-
-	DOWN_HEAD(TASK_INTERRUPTIBLE)
-
-	ret = waking_non_zero_interruptible(sem, current);
-	if (ret)
-	{
-		if (ret == 1)
-			/* ret != 0 only if we get interrupted -arca */
-			ret = 0;
-		break;
-	}
-	schedule();
-	DOWN_TAIL(TASK_INTERRUPTIBLE)
-	return ret;
-}
-
-int __down_trylock(struct semaphore * sem)
-{
-	return waking_non_zero_trylock(sem);
-}
diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index 33e5a59..13fd10e 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y	:= head.o init_task.o vmlinux.lds
 
 obj-y := acpi.o entry.o efi.o efi_stub.o gate-data.o fsys.o ia64_ksyms.o irq.o irq_ia64.o	\
 	 irq_lsapic.o ivt.o machvec.o pal.o patch.o process.o perfmon.o ptrace.o sal.o		\
-	 salinfo.o semaphore.o setup.o signal.o sys_ia64.o time.o traps.o unaligned.o \
+	 salinfo.o setup.o signal.o sys_ia64.o time.o traps.o unaligned.o \
 	 unwind.o mca.o mca_asm.o topology.o
 
 obj-$(CONFIG_IA64_BRL_EMU)	+= brl_emu.o
diff --git a/arch/ia64/kernel/ia64_ksyms.c b/arch/ia64/kernel/ia64_ksyms.c
index 8e7193d..6da1f20 100644
--- a/arch/ia64/kernel/ia64_ksyms.c
+++ b/arch/ia64/kernel/ia64_ksyms.c
@@ -19,12 +19,6 @@ EXPORT_SYMBOL_GPL(empty_zero_page);
 EXPORT_SYMBOL(ip_fast_csum);		/* hand-coded assembly */
 EXPORT_SYMBOL(csum_ipv6_magic);
 
-#include <asm/semaphore.h>
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_interruptible);
-EXPORT_SYMBOL(__down_trylock);
-EXPORT_SYMBOL(__up);
-
 #include <asm/page.h>
 EXPORT_SYMBOL(clear_page);
 
diff --git a/arch/ia64/kernel/semaphore.c b/arch/ia64/kernel/semaphore.c
deleted file mode 100644
index 2724ef3..0000000
--- a/arch/ia64/kernel/semaphore.c
+++ /dev/null
@@ -1,165 +0,0 @@
-/*
- * IA-64 semaphore implementation (derived from x86 version).
- *
- * Copyright (C) 1999-2000, 2002 Hewlett-Packard Co
- *	David Mosberger-Tang <davidm@hpl.hp.com>
- */
-
-/*
- * Semaphores are implemented using a two-way counter: The "count"
- * variable is decremented for each process that tries to acquire the
- * semaphore, while the "sleepers" variable is a count of such
- * acquires.
- *
- * Notably, the inline "up()" and "down()" functions can efficiently
- * test if they need to do any extra work (up needs to do something
- * only if count was negative before the increment operation.
- *
- * "sleeping" and the contention routine ordering is protected
- * by the spinlock in the semaphore's waitqueue head.
- *
- * Note that these functions are only called when there is contention
- * on the lock, and as such all this is the "non-critical" part of the
- * whole semaphore business. The critical part is the inline stuff in
- * <asm/semaphore.h> where we want to avoid any extra jumps and calls.
- */
-#include <linux/sched.h>
-#include <linux/init.h>
-
-#include <asm/errno.h>
-#include <asm/semaphore.h>
-
-/*
- * Logic:
- *  - Only on a boundary condition do we need to care. When we go
- *    from a negative count to a non-negative, we wake people up.
- *  - When we go from a non-negative count to a negative do we
- *    (a) synchronize with the "sleepers" count and (b) make sure
- *    that we're on the wakeup list before we synchronize so that
- *    we cannot lose wakeup events.
- */
-
-void
-__up (struct semaphore *sem)
-{
-	wake_up(&sem->wait);
-}
-
-void __sched __down (struct semaphore *sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	unsigned long flags;
-
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	add_wait_queue_exclusive_locked(&sem->wait, &wait);
-
-	sem->sleepers++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock in
-		 * the wait_queue_head.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-		schedule();
-
-		spin_lock_irqsave(&sem->wait.lock, flags);
-		tsk->state = TASK_UNINTERRUPTIBLE;
-	}
-	remove_wait_queue_locked(&sem->wait, &wait);
-	wake_up_locked(&sem->wait);
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-	tsk->state = TASK_RUNNING;
-}
-
-int __sched __down_interruptible (struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	unsigned long flags;
-
-	tsk->state = TASK_INTERRUPTIBLE;
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	add_wait_queue_exclusive_locked(&sem->wait, &wait);
-
-	sem->sleepers ++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * With signals pending, this turns into
-		 * the trylock failure case - we won't be
-		 * sleeping, and we* can't get the lock as
-		 * it has contention. Just correct the count
-		 * and exit.
-		 */
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			sem->sleepers = 0;
-			atomic_add(sleepers, &sem->count);
-			break;
-		}
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock in
-		 * wait_queue_head. The "-1" is because we're
-		 * still hoping to get the semaphore.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-		schedule();
-
-		spin_lock_irqsave(&sem->wait.lock, flags);
-		tsk->state = TASK_INTERRUPTIBLE;
-	}
-	remove_wait_queue_locked(&sem->wait, &wait);
-	wake_up_locked(&sem->wait);
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-	tsk->state = TASK_RUNNING;
-	return retval;
-}
-
-/*
- * Trylock failed - make sure we correct for having decremented the
- * count.
- */
-int
-__down_trylock (struct semaphore *sem)
-{
-	unsigned long flags;
-	int sleepers;
-
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	sleepers = sem->sleepers + 1;
-	sem->sleepers = 0;
-
-	/*
-	 * Add "everybody else" and us into it. They aren't
-	 * playing, because we own the spinlock in the
-	 * wait_queue_head.
-	 */
-	if (!atomic_add_negative(sleepers, &sem->count)) {
-		wake_up_locked(&sem->wait);
-	}
-
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-	return 1;
-}
diff --git a/arch/m32r/kernel/Makefile b/arch/m32r/kernel/Makefile
index e97e26e..09200d4 100644
--- a/arch/m32r/kernel/Makefile
+++ b/arch/m32r/kernel/Makefile
@@ -5,7 +5,7 @@
 extra-y	:= head.o init_task.o vmlinux.lds
 
 obj-y	:= process.o entry.o traps.o align.o irq.o setup.o time.o \
-	m32r_ksyms.o sys_m32r.o semaphore.o signal.o ptrace.o
+	m32r_ksyms.o sys_m32r.o signal.o ptrace.o
 
 obj-$(CONFIG_SMP)		+= smp.o smpboot.o
 obj-$(CONFIG_MODULES)		+= module.o
diff --git a/arch/m32r/kernel/m32r_ksyms.c b/arch/m32r/kernel/m32r_ksyms.c
index 41a4c95..e6709fe 100644
--- a/arch/m32r/kernel/m32r_ksyms.c
+++ b/arch/m32r/kernel/m32r_ksyms.c
@@ -7,7 +7,6 @@
 #include <linux/interrupt.h>
 #include <linux/string.h>
 
-#include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/checksum.h>
@@ -22,10 +21,6 @@ EXPORT_SYMBOL(dump_fpu);
 EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(iounmap);
 EXPORT_SYMBOL(kernel_thread);
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_interruptible);
-EXPORT_SYMBOL(__up);
-EXPORT_SYMBOL(__down_trylock);
 
 /* Networking helper routines. */
 /* Delay loops */
diff --git a/arch/m32r/kernel/semaphore.c b/arch/m32r/kernel/semaphore.c
deleted file mode 100644
index 940c2d3..0000000
--- a/arch/m32r/kernel/semaphore.c
+++ /dev/null
@@ -1,185 +0,0 @@
-/*
- *  linux/arch/m32r/semaphore.c
- *    orig : i386 2.6.4
- *
- *  M32R semaphore implementation.
- *
- *	Copyright (c) 2002 - 2004 Hitoshi Yamamoto
- */
-
-/*
- * i386 semaphore implementation.
- *
- * (C) Copyright 1999 Linus Torvalds
- *
- * Portions Copyright 1999 Red Hat, Inc.
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- * rw semaphores implemented November 1999 by Benjamin LaHaise <bcrl@kvack.org>
- */
-#include <linux/sched.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <asm/semaphore.h>
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to acquire the semaphore, while the "sleeping"
- * variable is a count of such acquires.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * "sleeping" and the contention routine ordering is protected
- * by the spinlock in the semaphore's waitqueue head.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-
-/*
- * Logic:
- *  - only on a boundary condition do we need to care. When we go
- *    from a negative count to a non-negative, we wake people up.
- *  - when we go from a non-negative count to a negative do we
- *    (a) synchronize with the "sleeper" count and (b) make sure
- *    that we're on the wakeup list before we synchronize so that
- *    we cannot lose wakeup events.
- */
-
-asmlinkage void __up(struct semaphore *sem)
-{
-	wake_up(&sem->wait);
-}
-
-asmlinkage void __sched __down(struct semaphore * sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	unsigned long flags;
-
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	add_wait_queue_exclusive_locked(&sem->wait, &wait);
-
-	sem->sleepers++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock in
-		 * the wait_queue_head.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-		schedule();
-
-		spin_lock_irqsave(&sem->wait.lock, flags);
-		tsk->state = TASK_UNINTERRUPTIBLE;
-	}
-	remove_wait_queue_locked(&sem->wait, &wait);
-	wake_up_locked(&sem->wait);
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-	tsk->state = TASK_RUNNING;
-}
-
-asmlinkage int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	unsigned long flags;
-
-	tsk->state = TASK_INTERRUPTIBLE;
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	add_wait_queue_exclusive_locked(&sem->wait, &wait);
-
-	sem->sleepers++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * With signals pending, this turns into
-		 * the trylock failure case - we won't be
-		 * sleeping, and we* can't get the lock as
-		 * it has contention. Just correct the count
-		 * and exit.
-		 */
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			sem->sleepers = 0;
-			atomic_add(sleepers, &sem->count);
-			break;
-		}
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock in
-		 * wait_queue_head. The "-1" is because we're
-		 * still hoping to get the semaphore.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-		schedule();
-
-		spin_lock_irqsave(&sem->wait.lock, flags);
-		tsk->state = TASK_INTERRUPTIBLE;
-	}
-	remove_wait_queue_locked(&sem->wait, &wait);
-	wake_up_locked(&sem->wait);
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-	tsk->state = TASK_RUNNING;
-	return retval;
-}
-
-/*
- * Trylock failed - make sure we correct for
- * having decremented the count.
- *
- * We could have done the trylock with a
- * single "cmpxchg" without failure cases,
- * but then it wouldn't work on a 386.
- */
-asmlinkage int __down_trylock(struct semaphore * sem)
-{
-	int sleepers;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	sleepers = sem->sleepers + 1;
-	sem->sleepers = 0;
-
-	/*
-	 * Add "everybody else" and us into it. They aren't
-	 * playing, because we own the spinlock in the
-	 * wait_queue_head.
-	 */
-	if (!atomic_add_negative(sleepers, &sem->count)) {
-		wake_up_locked(&sem->wait);
-	}
-
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-	return 1;
-}
diff --git a/arch/m68k/kernel/Makefile b/arch/m68k/kernel/Makefile
index a806208..7a62a71 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -10,7 +10,7 @@ endif
 extra-y	+= vmlinux.lds
 
 obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o module.o \
-	   sys_m68k.o time.o semaphore.o setup.o m68k_ksyms.o devres.o
+	   sys_m68k.o time.o setup.o m68k_ksyms.o devres.o
 
 devres-y = ../../../kernel/irq/devres.o
 
diff --git a/arch/m68k/kernel/m68k_ksyms.c b/arch/m68k/kernel/m68k_ksyms.c
index 6fc69c7..d900e77 100644
--- a/arch/m68k/kernel/m68k_ksyms.c
+++ b/arch/m68k/kernel/m68k_ksyms.c
@@ -1,5 +1,4 @@
 #include <linux/module.h>
-#include <asm/semaphore.h>
 
 asmlinkage long long __ashldi3 (long long, int);
 asmlinkage long long __ashrdi3 (long long, int);
@@ -15,8 +14,3 @@ EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__lshrdi3);
 EXPORT_SYMBOL(__muldi3);
 
-EXPORT_SYMBOL(__down_failed);
-EXPORT_SYMBOL(__down_failed_interruptible);
-EXPORT_SYMBOL(__down_failed_trylock);
-EXPORT_SYMBOL(__up_wakeup);
-
diff --git a/arch/m68k/kernel/semaphore.c b/arch/m68k/kernel/semaphore.c
deleted file mode 100644
index d12cbbf..0000000
--- a/arch/m68k/kernel/semaphore.c
+++ /dev/null
@@ -1,132 +0,0 @@
-/*
- *  Generic semaphore code. Buyer beware. Do your own
- * specific changes in <asm/semaphore-helper.h>
- */
-
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <asm/semaphore-helper.h>
-
-#ifndef CONFIG_RMW_INSNS
-spinlock_t semaphore_wake_lock;
-#endif
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to sleep, while the "waking" variable is
- * incremented when the "up()" code goes to wake up waiting
- * processes.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * waking_non_zero() (from asm/semaphore.h) must execute
- * atomically.
- *
- * When __up() is called, the count was negative before
- * incrementing it, and we need to wake up somebody.
- *
- * This routine adds one to the count of processes that need to
- * wake up and exit.  ALL waiting processes actually wake up but
- * only the one that gets to the "waking" field first will gate
- * through and acquire the semaphore.  The others will go back
- * to sleep.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-void __up(struct semaphore *sem)
-{
-	wake_one_more(sem);
-	wake_up(&sem->wait);
-}
-
-/*
- * Perform the "down" function.  Return zero for semaphore acquired,
- * return negative for signalled out of the function.
- *
- * If called from __down, the return is ignored and the wait loop is
- * not interruptible.  This means that a task waiting on a semaphore
- * using "down()" cannot be killed until someone does an "up()" on
- * the semaphore.
- *
- * If called from __down_interruptible, the return value gets checked
- * upon return.  If the return value is negative then the task continues
- * with the negative value in the return register (it can be tested by
- * the caller).
- *
- * Either form may be used in conjunction with "up()".
- *
- */
-
-
-#define DOWN_HEAD(task_state)						\
-									\
-									\
-	current->state = (task_state);					\
-	add_wait_queue(&sem->wait, &wait);				\
-									\
-	/*								\
-	 * Ok, we're set up.  sem->count is known to be less than zero	\
-	 * so we must wait.						\
-	 *								\
-	 * We can let go the lock for purposes of waiting.		\
-	 * We re-acquire it after awaking so as to protect		\
-	 * all semaphore operations.					\
-	 *								\
-	 * If "up()" is called before we call waking_non_zero() then	\
-	 * we will catch it right away.  If it is called later then	\
-	 * we will have to go through a wakeup cycle to catch it.	\
-	 *								\
-	 * Multiple waiters contend for the semaphore lock to see	\
-	 * who gets to gate through and who has to wait some more.	\
-	 */								\
-	for (;;) {
-
-#define DOWN_TAIL(task_state)			\
-		current->state = (task_state);	\
-	}					\
-	current->state = TASK_RUNNING;		\
-	remove_wait_queue(&sem->wait, &wait);
-
-void __sched __down(struct semaphore * sem)
-{
-	DECLARE_WAITQUEUE(wait, current);
-
-	DOWN_HEAD(TASK_UNINTERRUPTIBLE)
-	if (waking_non_zero(sem))
-		break;
-	schedule();
-	DOWN_TAIL(TASK_UNINTERRUPTIBLE)
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	DECLARE_WAITQUEUE(wait, current);
-	int ret = 0;
-
-	DOWN_HEAD(TASK_INTERRUPTIBLE)
-
-	ret = waking_non_zero_interruptible(sem, current);
-	if (ret)
-	{
-		if (ret == 1)
-			/* ret != 0 only if we get interrupted -arca */
-			ret = 0;
-		break;
-	}
-	schedule();
-	DOWN_TAIL(TASK_INTERRUPTIBLE)
-	return ret;
-}
-
-int __down_trylock(struct semaphore * sem)
-{
-	return waking_non_zero_trylock(sem);
-}
diff --git a/arch/m68k/lib/Makefile b/arch/m68k/lib/Makefile
index 6bbf19f..a18af09 100644
--- a/arch/m68k/lib/Makefile
+++ b/arch/m68k/lib/Makefile
@@ -5,4 +5,4 @@
 EXTRA_AFLAGS := -traditional
 
 lib-y	:= ashldi3.o ashrdi3.o lshrdi3.o muldi3.o \
-	   checksum.o string.o semaphore.o uaccess.o
+	   checksum.o string.o uaccess.o
diff --git a/arch/m68k/lib/semaphore.S b/arch/m68k/lib/semaphore.S
deleted file mode 100644
index 0215624..0000000
--- a/arch/m68k/lib/semaphore.S
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- *  linux/arch/m68k/lib/semaphore.S
- *
- *  Copyright (C) 1996  Linus Torvalds
- *
- *  m68k version by Andreas Schwab
- */
-
-#include <linux/linkage.h>
-#include <asm/semaphore.h>
-
-/*
- * The semaphore operations have a special calling sequence that
- * allow us to do a simpler in-line version of them. These routines
- * need to convert that sequence back into the C sequence when
- * there is contention on the semaphore.
- */
-ENTRY(__down_failed)
-	moveml %a0/%d0/%d1,-(%sp)
-	movel %a1,-(%sp)
-	jbsr __down
-	movel (%sp)+,%a1
-	moveml (%sp)+,%a0/%d0/%d1
-	rts
-
-ENTRY(__down_failed_interruptible)
-	movel %a0,-(%sp)
-	movel %d1,-(%sp)
-	movel %a1,-(%sp)
-	jbsr __down_interruptible
-	movel (%sp)+,%a1
-	movel (%sp)+,%d1
-	movel (%sp)+,%a0
-	rts
-
-ENTRY(__down_failed_trylock)
-	movel %a0,-(%sp)
-	movel %d1,-(%sp)
-	movel %a1,-(%sp)
-	jbsr __down_trylock
-	movel (%sp)+,%a1
-	movel (%sp)+,%d1
-	movel (%sp)+,%a0
-	rts
-
-ENTRY(__up_wakeup)
-	moveml %a0/%d0/%d1,-(%sp)
-	movel %a1,-(%sp)
-	jbsr __up
-	movel (%sp)+,%a1
-	moveml (%sp)+,%a0/%d0/%d1
-	rts
-
diff --git a/arch/m68knommu/kernel/Makefile b/arch/m68knommu/kernel/Makefile
index 1524b39..f0eab3d 100644
--- a/arch/m68knommu/kernel/Makefile
+++ b/arch/m68knommu/kernel/Makefile
@@ -5,7 +5,7 @@
 extra-y := vmlinux.lds
 
 obj-y += dma.o entry.o init_task.o irq.o m68k_ksyms.o process.o ptrace.o \
-	 semaphore.o setup.o signal.o syscalltable.o sys_m68k.o time.o traps.o
+	 setup.o signal.o syscalltable.o sys_m68k.o time.o traps.o
 
 obj-$(CONFIG_MODULES)	+= module.o
 obj-$(CONFIG_COMEMPCI)	+= comempci.o
diff --git a/arch/m68knommu/kernel/m68k_ksyms.c b/arch/m68knommu/kernel/m68k_ksyms.c
index 53fad14..39fe0a7 100644
--- a/arch/m68knommu/kernel/m68k_ksyms.c
+++ b/arch/m68knommu/kernel/m68k_ksyms.c
@@ -13,7 +13,6 @@
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/current.h>
 
@@ -39,11 +38,6 @@ EXPORT_SYMBOL(csum_partial_copy_nocheck);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
 
-EXPORT_SYMBOL(__down_failed);
-EXPORT_SYMBOL(__down_failed_interruptible);
-EXPORT_SYMBOL(__down_failed_trylock);
-EXPORT_SYMBOL(__up_wakeup);
-
 /*
  * libgcc functions - functions that are used internally by the
  * compiler...  (prototypes are not correct though, but that
diff --git a/arch/m68knommu/kernel/semaphore.c b/arch/m68knommu/kernel/semaphore.c
deleted file mode 100644
index bce2bc7..0000000
--- a/arch/m68knommu/kernel/semaphore.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- *  Generic semaphore code. Buyer beware. Do your own
- * specific changes in <asm/semaphore-helper.h>
- */
-
-#include <linux/sched.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <asm/semaphore-helper.h>
-
-#ifndef CONFIG_RMW_INSNS
-spinlock_t semaphore_wake_lock;
-#endif
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to sleep, while the "waking" variable is
- * incremented when the "up()" code goes to wake up waiting
- * processes.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * waking_non_zero() (from asm/semaphore.h) must execute
- * atomically.
- *
- * When __up() is called, the count was negative before
- * incrementing it, and we need to wake up somebody.
- *
- * This routine adds one to the count of processes that need to
- * wake up and exit.  ALL waiting processes actually wake up but
- * only the one that gets to the "waking" field first will gate
- * through and acquire the semaphore.  The others will go back
- * to sleep.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-void __up(struct semaphore *sem)
-{
-	wake_one_more(sem);
-	wake_up(&sem->wait);
-}
-
-/*
- * Perform the "down" function.  Return zero for semaphore acquired,
- * return negative for signalled out of the function.
- *
- * If called from __down, the return is ignored and the wait loop is
- * not interruptible.  This means that a task waiting on a semaphore
- * using "down()" cannot be killed until someone does an "up()" on
- * the semaphore.
- *
- * If called from __down_interruptible, the return value gets checked
- * upon return.  If the return value is negative then the task continues
- * with the negative value in the return register (it can be tested by
- * the caller).
- *
- * Either form may be used in conjunction with "up()".
- *
- */
-
-
-#define DOWN_HEAD(task_state)						\
-									\
-									\
-	current->state = (task_state);					\
-	add_wait_queue(&sem->wait, &wait);				\
-									\
-	/*								\
-	 * Ok, we're set up.  sem->count is known to be less than zero	\
-	 * so we must wait.						\
-	 *								\
-	 * We can let go the lock for purposes of waiting.		\
-	 * We re-acquire it after awaking so as to protect		\
-	 * all semaphore operations.					\
-	 *								\
-	 * If "up()" is called before we call waking_non_zero() then	\
-	 * we will catch it right away.  If it is called later then	\
-	 * we will have to go through a wakeup cycle to catch it.	\
-	 *								\
-	 * Multiple waiters contend for the semaphore lock to see	\
-	 * who gets to gate through and who has to wait some more.	\
-	 */								\
-	for (;;) {
-
-#define DOWN_TAIL(task_state)			\
-		current->state = (task_state);	\
-	}					\
-	current->state = TASK_RUNNING;		\
-	remove_wait_queue(&sem->wait, &wait);
-
-void __sched __down(struct semaphore * sem)
-{
-	DECLARE_WAITQUEUE(wait, current);
-
-	DOWN_HEAD(TASK_UNINTERRUPTIBLE)
-	if (waking_non_zero(sem))
-		break;
-	schedule();
-	DOWN_TAIL(TASK_UNINTERRUPTIBLE)
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	DECLARE_WAITQUEUE(wait, current);
-	int ret = 0;
-
-	DOWN_HEAD(TASK_INTERRUPTIBLE)
-
-	ret = waking_non_zero_interruptible(sem, current);
-	if (ret)
-	{
-		if (ret == 1)
-			/* ret != 0 only if we get interrupted -arca */
-			ret = 0;
-		break;
-	}
-	schedule();
-	DOWN_TAIL(TASK_INTERRUPTIBLE)
-	return ret;
-}
-
-int __down_trylock(struct semaphore * sem)
-{
-	return waking_non_zero_trylock(sem);
-}
diff --git a/arch/m68knommu/lib/Makefile b/arch/m68knommu/lib/Makefile
index e051a79..d94d709 100644
--- a/arch/m68knommu/lib/Makefile
+++ b/arch/m68knommu/lib/Makefile
@@ -4,4 +4,4 @@
 
 lib-y	:= ashldi3.o ashrdi3.o lshrdi3.o \
 	   muldi3.o mulsi3.o divsi3.o udivsi3.o modsi3.o umodsi3.o \
-	   checksum.o semaphore.o memcpy.o memset.o delay.o
+	   checksum.o memcpy.o memset.o delay.o
diff --git a/arch/m68knommu/lib/semaphore.S b/arch/m68knommu/lib/semaphore.S
deleted file mode 100644
index 87c7460..0000000
--- a/arch/m68knommu/lib/semaphore.S
+++ /dev/null
@@ -1,66 +0,0 @@
-/*
- *  linux/arch/m68k/lib/semaphore.S
- *
- *  Copyright (C) 1996  Linus Torvalds
- *
- *  m68k version by Andreas Schwab
- *
- *  MAR/1999 -- modified to support ColdFire (gerg@snapgear.com)
- */
-
-#include <linux/linkage.h>
-#include <asm/semaphore.h>
-
-/*
- * "down_failed" is called with the eventual return address
- * in %a0, and the address of the semaphore in %a1. We need
- * to increment the number of waiters on the semaphore,
- * call "__down()", and then eventually return to try again.
- */
-ENTRY(__down_failed)
-#ifdef CONFIG_COLDFIRE
-	subl #12,%sp
-	moveml %a0/%d0/%d1,(%sp)
-#else
-	moveml %a0/%d0/%d1,-(%sp)
-#endif
-	movel %a1,-(%sp)
-	jbsr __down
-	movel (%sp)+,%a1
-	movel (%sp)+,%d0
-	movel (%sp)+,%d1
-	rts
-
-ENTRY(__down_failed_interruptible)
-	movel %a0,-(%sp)
-	movel %d1,-(%sp)
-	movel %a1,-(%sp)
-	jbsr __down_interruptible
-	movel (%sp)+,%a1
-	movel (%sp)+,%d1
-	rts
-
-ENTRY(__up_wakeup)
-#ifdef CONFIG_COLDFIRE
-	subl #12,%sp
-	moveml %a0/%d0/%d1,(%sp)
-#else
-	moveml %a0/%d0/%d1,-(%sp)
-#endif
-	movel %a1,-(%sp)
-	jbsr __up
-	movel (%sp)+,%a1
-	movel (%sp)+,%d0
-	movel (%sp)+,%d1
-	rts
-
-ENTRY(__down_failed_trylock)
-	movel %a0,-(%sp)
-	movel %d1,-(%sp)
-	movel %a1,-(%sp)
-	jbsr __down_trylock
-	movel (%sp)+,%a1
-	movel (%sp)+,%d1
-	movel (%sp)+,%a0
-	rts
-
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index ffa0836..6da8bbb 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -5,7 +5,7 @@
 extra-y		:= head.o init_task.o vmlinux.lds
 
 obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
-		   ptrace.o reset.o semaphore.o setup.o signal.o syscall.o \
+		   ptrace.o reset.o setup.o signal.o syscall.o \
 		   time.o topology.o traps.o unaligned.o
 
 obj-$(CONFIG_CEVT_BCM1480)	+= cevt-bcm1480.o
diff --git a/arch/mips/kernel/semaphore.c b/arch/mips/kernel/semaphore.c
deleted file mode 100644
index 1265358..0000000
--- a/arch/mips/kernel/semaphore.c
+++ /dev/null
@@ -1,168 +0,0 @@
-/*
- * MIPS-specific semaphore code.
- *
- * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
- * Copyright (C) 2004 Ralf Baechle <ralf@linux-mips.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- * April 2001 - Reworked by Paul Mackerras <paulus@samba.org>
- * to eliminate the SMP races in the old version between the updates
- * of `count' and `waking'.  Now we use negative `count' values to
- * indicate that some process(es) are waiting for the semaphore.
- */
-
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <asm/atomic.h>
-#include <asm/cpu-features.h>
-#include <asm/errno.h>
-#include <asm/semaphore.h>
-#include <asm/war.h>
-/*
- * Atomically update sem->count.
- * This does the equivalent of the following:
- *
- *	old_count = sem->count;
- *	tmp = MAX(old_count, 0) + incr;
- *	sem->count = tmp;
- *	return old_count;
- *
- * On machines without lld/scd we need a spinlock to make the manipulation of
- * sem->count and sem->waking atomic.  Scalability isn't an issue because
- * this lock is used on UP only so it's just an empty variable.
- */
-static inline int __sem_update_count(struct semaphore *sem, int incr)
-{
-	int old_count, tmp;
-
-	if (cpu_has_llsc && R10000_LLSC_WAR) {
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%0, %2		# __sem_update_count	\n"
-		"	sra	%1, %0, 31				\n"
-		"	not	%1					\n"
-		"	and	%1, %0, %1				\n"
-		"	addu	%1, %1, %3				\n"
-		"	sc	%1, %2					\n"
-		"	beqzl	%1, 1b					\n"
-		"	.set	mips0					\n"
-		: "=&r" (old_count), "=&r" (tmp), "=m" (sem->count)
-		: "r" (incr), "m" (sem->count));
-	} else if (cpu_has_llsc) {
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%0, %2		# __sem_update_count	\n"
-		"	sra	%1, %0, 31				\n"
-		"	not	%1					\n"
-		"	and	%1, %0, %1				\n"
-		"	addu	%1, %1, %3				\n"
-		"	sc	%1, %2					\n"
-		"	beqz	%1, 1b					\n"
-		"	.set	mips0					\n"
-		: "=&r" (old_count), "=&r" (tmp), "=m" (sem->count)
-		: "r" (incr), "m" (sem->count));
-	} else {
-		static DEFINE_SPINLOCK(semaphore_lock);
-		unsigned long flags;
-
-		spin_lock_irqsave(&semaphore_lock, flags);
-		old_count = atomic_read(&sem->count);
-		tmp = max_t(int, old_count, 0) + incr;
-		atomic_set(&sem->count, tmp);
-		spin_unlock_irqrestore(&semaphore_lock, flags);
-	}
-
-	return old_count;
-}
-
-void __up(struct semaphore *sem)
-{
-	/*
-	 * Note that we incremented count in up() before we came here,
-	 * but that was ineffective since the result was <= 0, and
-	 * any negative value of count is equivalent to 0.
-	 * This ends up setting count to 1, unless count is now > 0
-	 * (i.e. because some other cpu has called up() in the meantime),
-	 * in which case we just increment count.
-	 */
-	__sem_update_count(sem, 1);
-	wake_up(&sem->wait);
-}
-
-EXPORT_SYMBOL(__up);
-
-/*
- * Note that when we come in to __down or __down_interruptible,
- * we have already decremented count, but that decrement was
- * ineffective since the result was < 0, and any negative value
- * of count is equivalent to 0.
- * Thus it is only when we decrement count from some value > 0
- * that we have actually got the semaphore.
- */
-void __sched __down(struct semaphore *sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	/*
-	 * Try to get the semaphore.  If the count is > 0, then we've
-	 * got the semaphore; we decrement count and exit the loop.
-	 * If the count is 0 or negative, we set it to -1, indicating
-	 * that we are asleep, and then sleep.
-	 */
-	while (__sem_update_count(sem, -1) <= 0) {
-		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	__set_task_state(tsk, TASK_RUNNING);
-
-	/*
-	 * If there are any more sleepers, wake one of them up so
-	 * that it can either get the semaphore, or set count to -1
-	 * indicating that there are still processes sleeping.
-	 */
-	wake_up(&sem->wait);
-}
-
-EXPORT_SYMBOL(__down);
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	__set_task_state(tsk, TASK_INTERRUPTIBLE);
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	while (__sem_update_count(sem, -1) <= 0) {
-		if (signal_pending(current)) {
-			/*
-			 * A signal is pending - give up trying.
-			 * Set sem->count to 0 if it is negative,
-			 * since we are no longer sleeping.
-			 */
-			__sem_update_count(sem, 0);
-			retval = -EINTR;
-			break;
-		}
-		schedule();
-		set_task_state(tsk, TASK_INTERRUPTIBLE);
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	__set_task_state(tsk, TASK_RUNNING);
-
-	wake_up(&sem->wait);
-	return retval;
-}
-
-EXPORT_SYMBOL(__down_interruptible);
diff --git a/arch/mn10300/kernel/Makefile b/arch/mn10300/kernel/Makefile
index ef07c95..23f2ab6 100644
--- a/arch/mn10300/kernel/Makefile
+++ b/arch/mn10300/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 extra-y := head.o init_task.o vmlinux.lds
 
-obj-y   := process.o semaphore.o signal.o entry.o fpu.o traps.o irq.o \
+obj-y   := process.o signal.o entry.o fpu.o traps.o irq.o \
 	   ptrace.o setup.o time.o sys_mn10300.o io.o kthread.o \
 	   switch_to.o mn10300_ksyms.o kernel_execve.o
 
diff --git a/arch/mn10300/kernel/semaphore.c b/arch/mn10300/kernel/semaphore.c
deleted file mode 100644
index 9153c40..0000000
--- a/arch/mn10300/kernel/semaphore.c
+++ /dev/null
@@ -1,149 +0,0 @@
-/* MN10300 Semaphore implementation
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <linux/sched.h>
-#include <linux/module.h>
-#include <asm/semaphore.h>
-
-struct sem_waiter {
-	struct list_head	list;
-	struct task_struct	*task;
-};
-
-#if SEMAPHORE_DEBUG
-void semtrace(struct semaphore *sem, const char *str)
-{
-	if (sem->debug)
-		printk(KERN_DEBUG "[%d] %s({%d,%d})\n",
-		       current->pid,
-		       str,
-		       atomic_read(&sem->count),
-		       list_empty(&sem->wait_list) ? 0 : 1);
-}
-#else
-#define semtrace(SEM, STR) do { } while (0)
-#endif
-
-/*
- * wait for a token to be granted from a semaphore
- * - entered with lock held and interrupts disabled
- */
-void __down(struct semaphore *sem, unsigned long flags)
-{
-	struct task_struct *tsk = current;
-	struct sem_waiter waiter;
-
-	semtrace(sem, "Entering __down");
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	get_task_struct(tsk);
-
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	/* wait to be given the semaphore */
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-
-	for (;;) {
-		if (!waiter.task)
-			break;
-		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	}
-
-	tsk->state = TASK_RUNNING;
-	semtrace(sem, "Leaving __down");
-}
-EXPORT_SYMBOL(__down);
-
-/*
- * interruptibly wait for a token to be granted from a semaphore
- * - entered with lock held and interrupts disabled
- */
-int __down_interruptible(struct semaphore *sem, unsigned long flags)
-{
-	struct task_struct *tsk = current;
-	struct sem_waiter waiter;
-	int ret;
-
-	semtrace(sem, "Entering __down_interruptible");
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	get_task_struct(tsk);
-
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we don't need to touch the semaphore struct anymore */
-	set_task_state(tsk, TASK_INTERRUPTIBLE);
-
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	/* wait to be given the semaphore */
-	ret = 0;
-	for (;;) {
-		if (!waiter.task)
-			break;
-		if (unlikely(signal_pending(current)))
-			goto interrupted;
-		schedule();
-		set_task_state(tsk, TASK_INTERRUPTIBLE);
-	}
-
- out:
-	tsk->state = TASK_RUNNING;
-	semtrace(sem, "Leaving __down_interruptible");
-	return ret;
-
- interrupted:
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	list_del(&waiter.list);
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	ret = 0;
-	if (!waiter.task) {
-		put_task_struct(current);
-		ret = -EINTR;
-	}
-	goto out;
-}
-EXPORT_SYMBOL(__down_interruptible);
-
-/*
- * release a single token back to a semaphore
- * - entered with lock held and interrupts disabled
- */
-void __up(struct semaphore *sem)
-{
-	struct task_struct *tsk;
-	struct sem_waiter *waiter;
-
-	semtrace(sem, "Entering __up");
-
-	/* grant the token to the process at the front of the queue */
-	waiter = list_entry(sem->wait_list.next, struct sem_waiter, list);
-
-	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
-	 * It is an allocated on the waiter's stack and may become invalid at
-	 * any time after that point (due to a wakeup from another source).
-	 */
-	list_del_init(&waiter->list);
-	tsk = waiter->task;
-	smp_mb();
-	waiter->task = NULL;
-	wake_up_process(tsk);
-	put_task_struct(tsk);
-
-	semtrace(sem, "Leaving __up");
-}
-EXPORT_SYMBOL(__up);
diff --git a/arch/parisc/kernel/Makefile b/arch/parisc/kernel/Makefile
index 27827bc..1f6585a 100644
--- a/arch/parisc/kernel/Makefile
+++ b/arch/parisc/kernel/Makefile
@@ -9,7 +9,7 @@ AFLAGS_pacache.o := -traditional
 
 obj-y	     	:= cache.o pacache.o setup.o traps.o time.o irq.o \
 		   pa7300lc.o syscall.o entry.o sys_parisc.o firmware.o \
-		   ptrace.o hardware.o inventory.o drivers.o semaphore.o \
+		   ptrace.o hardware.o inventory.o drivers.o \
 		   signal.o hpmc.o real2.o parisc_ksyms.o unaligned.o \
 		   process.o processor.o pdc_cons.o pdc_chassis.o unwind.o \
 		   topology.o
diff --git a/arch/parisc/kernel/parisc_ksyms.c b/arch/parisc/kernel/parisc_ksyms.c
index 7aca704..5b7fc4a 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -69,11 +69,6 @@ EXPORT_SYMBOL(memcpy_toio);
 EXPORT_SYMBOL(memcpy_fromio);
 EXPORT_SYMBOL(memset_io);
 
-#include <asm/semaphore.h>
-EXPORT_SYMBOL(__up);
-EXPORT_SYMBOL(__down_interruptible);
-EXPORT_SYMBOL(__down);
-
 extern void $$divI(void);
 extern void $$divU(void);
 extern void $$remI(void);
diff --git a/arch/parisc/kernel/semaphore.c b/arch/parisc/kernel/semaphore.c
deleted file mode 100644
index ee806bc..0000000
--- a/arch/parisc/kernel/semaphore.c
+++ /dev/null
@@ -1,102 +0,0 @@
-/*
- * Semaphore implementation Copyright (c) 2001 Matthew Wilcox, Hewlett-Packard
- */
-
-#include <linux/sched.h>
-#include <linux/spinlock.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-
-/*
- * Semaphores are complex as we wish to avoid using two variables.
- * `count' has multiple roles, depending on its value.  If it is positive
- * or zero, there are no waiters.  The functions here will never be
- * called; see <asm/semaphore.h>
- *
- * When count is -1 it indicates there is at least one task waiting
- * for the semaphore.
- *
- * When count is less than that, there are '- count - 1' wakeups
- * pending.  ie if it has value -3, there are 2 wakeups pending.
- *
- * Note that these functions are only called when there is contention
- * on the lock, and as such all this is the "non-critical" part of the
- * whole semaphore business. The critical part is the inline stuff in
- * <asm/semaphore.h> where we want to avoid any extra jumps and calls.
- */
-void __up(struct semaphore *sem)
-{
-	sem->count--;
-	wake_up(&sem->wait);
-}
-
-#define wakers(count) (-1 - count)
-
-#define DOWN_HEAD							\
-	int ret = 0;							\
-	DECLARE_WAITQUEUE(wait, current);				\
-									\
-	/* Note that someone is waiting */				\
-	if (sem->count == 0)						\
-		sem->count = -1;					\
-									\
-	/* protected by the sentry still -- use unlocked version */	\
-	wait.flags = WQ_FLAG_EXCLUSIVE;					\
-	__add_wait_queue_tail(&sem->wait, &wait);			\
- lost_race:								\
-	spin_unlock_irq(&sem->sentry);					\
-
-#define DOWN_TAIL							\
-	spin_lock_irq(&sem->sentry);					\
-	if (wakers(sem->count) == 0 && ret == 0)			\
-		goto lost_race;	/* Someone stole our wakeup */		\
-	__remove_wait_queue(&sem->wait, &wait);				\
-	current->state = TASK_RUNNING;					\
-	if (!waitqueue_active(&sem->wait) && (sem->count < 0))		\
-		sem->count = wakers(sem->count);
-
-#define UPDATE_COUNT							\
-	sem->count += (sem->count < 0) ? 1 : - 1;
-	
-
-void __sched __down(struct semaphore * sem)
-{
-	DOWN_HEAD
-
-	for(;;) {
-		set_task_state(current, TASK_UNINTERRUPTIBLE);
-		/* we can _read_ this without the sentry */
-		if (sem->count != -1)
-			break;
- 		schedule();
- 	}
-
-	DOWN_TAIL
-	UPDATE_COUNT
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	DOWN_HEAD
-
-	for(;;) {
-		set_task_state(current, TASK_INTERRUPTIBLE);
-		/* we can _read_ this without the sentry */
-		if (sem->count != -1)
-			break;
-
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-		schedule();
-	}
-
-	DOWN_TAIL
-
-	if (!ret) {
-		UPDATE_COUNT
-	}
-
-	return ret;
-}
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index c1baf9d..b9dbfff 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -12,7 +12,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
-obj-y				:= semaphore.o cputable.o ptrace.o syscalls.o \
+obj-y				:= cputable.o ptrace.o syscalls.o \
 				   irq.o align.o signal_32.o pmc.o vdso.o \
 				   init_task.o process.o systbl.o idle.o \
 				   signal.o
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index aa9ff35..21c1ca2 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 
 #include <asm/page.h>
-#include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <asm/cacheflush.h>
 #include <asm/uaccess.h>
diff --git a/arch/powerpc/kernel/semaphore.c b/arch/powerpc/kernel/semaphore.c
deleted file mode 100644
index 2f8c3c9..0000000
--- a/arch/powerpc/kernel/semaphore.c
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * PowerPC-specific semaphore code.
- *
- * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- * April 2001 - Reworked by Paul Mackerras <paulus@samba.org>
- * to eliminate the SMP races in the old version between the updates
- * of `count' and `waking'.  Now we use negative `count' values to
- * indicate that some process(es) are waiting for the semaphore.
- */
-
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/module.h>
-
-#include <asm/atomic.h>
-#include <asm/semaphore.h>
-#include <asm/errno.h>
-
-/*
- * Atomically update sem->count.
- * This does the equivalent of the following:
- *
- *	old_count = sem->count;
- *	tmp = MAX(old_count, 0) + incr;
- *	sem->count = tmp;
- *	return old_count;
- */
-static inline int __sem_update_count(struct semaphore *sem, int incr)
-{
-	int old_count, tmp;
-
-	__asm__ __volatile__("\n"
-"1:	lwarx	%0,0,%3\n"
-"	srawi	%1,%0,31\n"
-"	andc	%1,%0,%1\n"
-"	add	%1,%1,%4\n"
-	PPC405_ERR77(0,%3)
-"	stwcx.	%1,0,%3\n"
-"	bne	1b"
-	: "=&r" (old_count), "=&r" (tmp), "=m" (sem->count)
-	: "r" (&sem->count), "r" (incr), "m" (sem->count)
-	: "cc");
-
-	return old_count;
-}
-
-void __up(struct semaphore *sem)
-{
-	/*
-	 * Note that we incremented count in up() before we came here,
-	 * but that was ineffective since the result was <= 0, and
-	 * any negative value of count is equivalent to 0.
-	 * This ends up setting count to 1, unless count is now > 0
-	 * (i.e. because some other cpu has called up() in the meantime),
-	 * in which case we just increment count.
-	 */
-	__sem_update_count(sem, 1);
-	wake_up(&sem->wait);
-}
-EXPORT_SYMBOL(__up);
-
-/*
- * Note that when we come in to __down or __down_interruptible,
- * we have already decremented count, but that decrement was
- * ineffective since the result was < 0, and any negative value
- * of count is equivalent to 0.
- * Thus it is only when we decrement count from some value > 0
- * that we have actually got the semaphore.
- */
-void __sched __down(struct semaphore *sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	/*
-	 * Try to get the semaphore.  If the count is > 0, then we've
-	 * got the semaphore; we decrement count and exit the loop.
-	 * If the count is 0 or negative, we set it to -1, indicating
-	 * that we are asleep, and then sleep.
-	 */
-	while (__sem_update_count(sem, -1) <= 0) {
-		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	__set_task_state(tsk, TASK_RUNNING);
-
-	/*
-	 * If there are any more sleepers, wake one of them up so
-	 * that it can either get the semaphore, or set count to -1
-	 * indicating that there are still processes sleeping.
-	 */
-	wake_up(&sem->wait);
-}
-EXPORT_SYMBOL(__down);
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	__set_task_state(tsk, TASK_INTERRUPTIBLE);
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	while (__sem_update_count(sem, -1) <= 0) {
-		if (signal_pending(current)) {
-			/*
-			 * A signal is pending - give up trying.
-			 * Set sem->count to 0 if it is negative,
-			 * since we are no longer sleeping.
-			 */
-			__sem_update_count(sem, 0);
-			retval = -EINTR;
-			break;
-		}
-		schedule();
-		set_task_state(tsk, TASK_INTERRUPTIBLE);
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	__set_task_state(tsk, TASK_RUNNING);
-
-	wake_up(&sem->wait);
-	return retval;
-}
-EXPORT_SYMBOL(__down_interruptible);
diff --git a/arch/ppc/kernel/semaphore.c b/arch/ppc/kernel/semaphore.c
deleted file mode 100644
index 2fe429b..0000000
--- a/arch/ppc/kernel/semaphore.c
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * PowerPC-specific semaphore code.
- *
- * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- * April 2001 - Reworked by Paul Mackerras <paulus@samba.org>
- * to eliminate the SMP races in the old version between the updates
- * of `count' and `waking'.  Now we use negative `count' values to
- * indicate that some process(es) are waiting for the semaphore.
- */
-
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <asm/atomic.h>
-#include <asm/semaphore.h>
-#include <asm/errno.h>
-
-/*
- * Atomically update sem->count.
- * This does the equivalent of the following:
- *
- *	old_count = sem->count;
- *	tmp = MAX(old_count, 0) + incr;
- *	sem->count = tmp;
- *	return old_count;
- */
-static inline int __sem_update_count(struct semaphore *sem, int incr)
-{
-	int old_count, tmp;
-
-	__asm__ __volatile__("\n"
-"1:	lwarx	%0,0,%3\n"
-"	srawi	%1,%0,31\n"
-"	andc	%1,%0,%1\n"
-"	add	%1,%1,%4\n"
-	PPC405_ERR77(0,%3)
-"	stwcx.	%1,0,%3\n"
-"	bne	1b"
-	: "=&r" (old_count), "=&r" (tmp), "=m" (sem->count)
-	: "r" (&sem->count), "r" (incr), "m" (sem->count)
-	: "cc");
-
-	return old_count;
-}
-
-void __up(struct semaphore *sem)
-{
-	/*
-	 * Note that we incremented count in up() before we came here,
-	 * but that was ineffective since the result was <= 0, and
-	 * any negative value of count is equivalent to 0.
-	 * This ends up setting count to 1, unless count is now > 0
-	 * (i.e. because some other cpu has called up() in the meantime),
-	 * in which case we just increment count.
-	 */
-	__sem_update_count(sem, 1);
-	wake_up(&sem->wait);
-}
-
-/*
- * Note that when we come in to __down or __down_interruptible,
- * we have already decremented count, but that decrement was
- * ineffective since the result was < 0, and any negative value
- * of count is equivalent to 0.
- * Thus it is only when we decrement count from some value > 0
- * that we have actually got the semaphore.
- */
-void __sched __down(struct semaphore *sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-	smp_wmb();
-
-	/*
-	 * Try to get the semaphore.  If the count is > 0, then we've
-	 * got the semaphore; we decrement count and exit the loop.
-	 * If the count is 0 or negative, we set it to -1, indicating
-	 * that we are asleep, and then sleep.
-	 */
-	while (__sem_update_count(sem, -1) <= 0) {
-		schedule();
-		tsk->state = TASK_UNINTERRUPTIBLE;
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	tsk->state = TASK_RUNNING;
-
-	/*
-	 * If there are any more sleepers, wake one of them up so
-	 * that it can either get the semaphore, or set count to -1
-	 * indicating that there are still processes sleeping.
-	 */
-	wake_up(&sem->wait);
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	tsk->state = TASK_INTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-	smp_wmb();
-
-	while (__sem_update_count(sem, -1) <= 0) {
-		if (signal_pending(current)) {
-			/*
-			 * A signal is pending - give up trying.
-			 * Set sem->count to 0 if it is negative,
-			 * since we are no longer sleeping.
-			 */
-			__sem_update_count(sem, 0);
-			retval = -EINTR;
-			break;
-		}
-		schedule();
-		tsk->state = TASK_INTERRUPTIBLE;
-	}
-	tsk->state = TASK_RUNNING;
-	remove_wait_queue(&sem->wait, &wait);
-	wake_up(&sem->wait);
-	return retval;
-}
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index b3b650a..d426c11 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -6,7 +6,7 @@ EXTRA_AFLAGS	:= -traditional
 
 obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o \
             setup.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
-	    semaphore.o s390_ext.o debug.o irq.o ipl.o dis.o diag.o
+	    s390_ext.o debug.o irq.o ipl.o dis.o diag.o
 
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
diff --git a/arch/s390/kernel/s390_ksyms.c b/arch/s390/kernel/s390_ksyms.c
index 7234c73..48238a1 100644
--- a/arch/s390/kernel/s390_ksyms.c
+++ b/arch/s390/kernel/s390_ksyms.c
@@ -27,13 +27,6 @@ EXPORT_SYMBOL(_zb_findmap);
 EXPORT_SYMBOL(_sb_findmap);
 
 /*
- * semaphore ops
- */
-EXPORT_SYMBOL(__up);
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_interruptible);
-
-/*
  * binfmt_elf loader 
  */
 extern int dump_fpu (struct pt_regs * regs, s390_fp_regs *fpregs);
diff --git a/arch/s390/kernel/semaphore.c b/arch/s390/kernel/semaphore.c
deleted file mode 100644
index 191303f..0000000
--- a/arch/s390/kernel/semaphore.c
+++ /dev/null
@@ -1,108 +0,0 @@
-/*
- *  linux/arch/s390/kernel/semaphore.c
- *
- *  S390 version
- *    Copyright (C) 1998-2000 IBM Corporation
- *    Author(s): Martin Schwidefsky
- *
- *  Derived from "linux/arch/i386/kernel/semaphore.c
- *    Copyright (C) 1999, Linus Torvalds
- *
- */
-#include <linux/sched.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-
-#include <asm/semaphore.h>
-
-/*
- * Atomically update sem->count. Equivalent to:
- *   old_val = sem->count.counter;
- *   new_val = ((old_val >= 0) ? old_val : 0) + incr;
- *   sem->count.counter = new_val;
- *   return old_val;
- */
-static inline int __sem_update_count(struct semaphore *sem, int incr)
-{
-	int old_val, new_val;
-
-	asm volatile(
-		"	l	%0,0(%3)\n"
-		"0:	ltr	%1,%0\n"
-		"	jhe	1f\n"
-		"	lhi	%1,0\n"
-		"1:	ar	%1,%4\n"
-		"	cs	%0,%1,0(%3)\n"
-		"	jl	0b\n"
-		: "=&d" (old_val), "=&d" (new_val), "=m" (sem->count)
-		: "a" (&sem->count), "d" (incr), "m" (sem->count)
-		: "cc");
-	return old_val;
-}
-
-/*
- * The inline function up() incremented count but the result
- * was <= 0. This indicates that some process is waiting on
- * the semaphore. The semaphore is free and we'll wake the
- * first sleeping process, so we set count to 1 unless some
- * other cpu has called up in the meantime in which case
- * we just increment count by 1.
- */
-void __up(struct semaphore *sem)
-{
-	__sem_update_count(sem, 1);
-	wake_up(&sem->wait);
-}
-
-/*
- * The inline function down() decremented count and the result
- * was < 0. The wait loop will atomically test and update the
- * semaphore counter following the rules:
- *   count > 0: decrement count, wake up queue and exit.
- *   count <= 0: set count to -1, go to sleep.
- */
-void __sched __down(struct semaphore * sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	add_wait_queue_exclusive(&sem->wait, &wait);
-	while (__sem_update_count(sem, -1) <= 0) {
-		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	__set_task_state(tsk, TASK_RUNNING);
-	wake_up(&sem->wait);
-}
-
-/*
- * Same as __down() with an additional test for signals.
- * If a signal is pending the count is updated as follows:
- *   count > 0: wake up queue and exit.
- *   count <= 0: set count to 0, wake up queue and exit.
- */
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	__set_task_state(tsk, TASK_INTERRUPTIBLE);
-	add_wait_queue_exclusive(&sem->wait, &wait);
-	while (__sem_update_count(sem, -1) <= 0) {
-		if (signal_pending(current)) {
-			__sem_update_count(sem, 0);
-			retval = -EINTR;
-			break;
-		}
-		schedule();
-		set_task_state(tsk, TASK_INTERRUPTIBLE);
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	__set_task_state(tsk, TASK_RUNNING);
-	wake_up(&sem->wait);
-	return retval;
-}
-
diff --git a/arch/sh/kernel/Makefile_32 b/arch/sh/kernel/Makefile_32
index 62bf373..4bbdce3 100644
--- a/arch/sh/kernel/Makefile_32
+++ b/arch/sh/kernel/Makefile_32
@@ -5,7 +5,7 @@
 extra-y	:= head_32.o init_task.o vmlinux.lds
 
 obj-y	:= debugtraps.o io.o io_generic.o irq.o machvec.o process_32.o \
-	   ptrace_32.o semaphore.o setup.o signal_32.o sys_sh.o sys_sh32.o \
+	   ptrace_32.o setup.o signal_32.o sys_sh.o sys_sh32.o \
 	   syscalls_32.o time_32.o topology.o traps.o traps_32.o
 
 obj-y				+= cpu/ timers/
diff --git a/arch/sh/kernel/Makefile_64 b/arch/sh/kernel/Makefile_64
index e01283d..6edf53b 100644
--- a/arch/sh/kernel/Makefile_64
+++ b/arch/sh/kernel/Makefile_64
@@ -1,7 +1,7 @@
 extra-y	:= head_64.o init_task.o vmlinux.lds
 
 obj-y	:= debugtraps.o io.o io_generic.o irq.o machvec.o process_64.o \
-	   ptrace_64.o semaphore.o setup.o signal_64.o sys_sh.o sys_sh64.o \
+	   ptrace_64.o setup.o signal_64.o sys_sh.o sys_sh64.o \
 	   syscalls_64.o time_64.o topology.o traps.o traps_64.o
 
 obj-y				+= cpu/ timers/
diff --git a/arch/sh/kernel/semaphore.c b/arch/sh/kernel/semaphore.c
deleted file mode 100644
index 184119e..0000000
--- a/arch/sh/kernel/semaphore.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * Just taken from alpha implementation.
- * This can't work well, perhaps.
- */
-/*
- *  Generic semaphore code. Buyer beware. Do your own
- * specific changes in <asm/semaphore-helper.h>
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/wait.h>
-#include <linux/init.h>
-#include <asm/semaphore.h>
-#include <asm/semaphore-helper.h>
-
-DEFINE_SPINLOCK(semaphore_wake_lock);
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to sleep, while the "waking" variable is
- * incremented when the "up()" code goes to wake up waiting
- * processes.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * waking_non_zero() (from asm/semaphore.h) must execute
- * atomically.
- *
- * When __up() is called, the count was negative before
- * incrementing it, and we need to wake up somebody.
- *
- * This routine adds one to the count of processes that need to
- * wake up and exit.  ALL waiting processes actually wake up but
- * only the one that gets to the "waking" field first will gate
- * through and acquire the semaphore.  The others will go back
- * to sleep.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-void __up(struct semaphore *sem)
-{
-	wake_one_more(sem);
-	wake_up(&sem->wait);
-}
-
-/*
- * Perform the "down" function.  Return zero for semaphore acquired,
- * return negative for signalled out of the function.
- *
- * If called from __down, the return is ignored and the wait loop is
- * not interruptible.  This means that a task waiting on a semaphore
- * using "down()" cannot be killed until someone does an "up()" on
- * the semaphore.
- *
- * If called from __down_interruptible, the return value gets checked
- * upon return.  If the return value is negative then the task continues
- * with the negative value in the return register (it can be tested by
- * the caller).
- *
- * Either form may be used in conjunction with "up()".
- *
- */
-
-#define DOWN_VAR				\
-	struct task_struct *tsk = current;	\
-	wait_queue_t wait;			\
-	init_waitqueue_entry(&wait, tsk);
-
-#define DOWN_HEAD(task_state)						\
-									\
-									\
-	tsk->state = (task_state);					\
-	add_wait_queue(&sem->wait, &wait);				\
-									\
-	/*								\
-	 * Ok, we're set up.  sem->count is known to be less than zero	\
-	 * so we must wait.						\
-	 *								\
-	 * We can let go the lock for purposes of waiting.		\
-	 * We re-acquire it after awaking so as to protect		\
-	 * all semaphore operations.					\
-	 *								\
-	 * If "up()" is called before we call waking_non_zero() then	\
-	 * we will catch it right away.  If it is called later then	\
-	 * we will have to go through a wakeup cycle to catch it.	\
-	 *								\
-	 * Multiple waiters contend for the semaphore lock to see	\
-	 * who gets to gate through and who has to wait some more.	\
-	 */								\
-	for (;;) {
-
-#define DOWN_TAIL(task_state)			\
-		tsk->state = (task_state);	\
-	}					\
-	tsk->state = TASK_RUNNING;		\
-	remove_wait_queue(&sem->wait, &wait);
-
-void __sched __down(struct semaphore * sem)
-{
-	DOWN_VAR
-	DOWN_HEAD(TASK_UNINTERRUPTIBLE)
-	if (waking_non_zero(sem))
-		break;
-	schedule();
-	DOWN_TAIL(TASK_UNINTERRUPTIBLE)
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-	DOWN_VAR
-	DOWN_HEAD(TASK_INTERRUPTIBLE)
-
-	ret = waking_non_zero_interruptible(sem, tsk);
-	if (ret)
-	{
-		if (ret == 1)
-			/* ret != 0 only if we get interrupted -arca */
-			ret = 0;
-		break;
-	}
-	schedule();
-	DOWN_TAIL(TASK_INTERRUPTIBLE)
-	return ret;
-}
-
-int __down_trylock(struct semaphore * sem)
-{
-	return waking_non_zero_trylock(sem);
-}
diff --git a/arch/sh/kernel/sh_ksyms_32.c b/arch/sh/kernel/sh_ksyms_32.c
index e1a6de9..c011ad0 100644
--- a/arch/sh/kernel/sh_ksyms_32.c
+++ b/arch/sh/kernel/sh_ksyms_32.c
@@ -9,7 +9,6 @@
 #include <linux/pci.h>
 #include <linux/irq.h>
 #include <asm/sections.h>
-#include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/checksum.h>
@@ -48,12 +47,6 @@ EXPORT_SYMBOL(__copy_user);
 EXPORT_SYMBOL(get_vm_area);
 #endif
 
-/* semaphore exports */
-EXPORT_SYMBOL(__up);
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_interruptible);
-EXPORT_SYMBOL(__down_trylock);
-
 EXPORT_SYMBOL(__udelay);
 EXPORT_SYMBOL(__ndelay);
 EXPORT_SYMBOL(__const_udelay);
diff --git a/arch/sh/kernel/sh_ksyms_64.c b/arch/sh/kernel/sh_ksyms_64.c
index 8004c38..c1a3555 100644
--- a/arch/sh/kernel/sh_ksyms_64.c
+++ b/arch/sh/kernel/sh_ksyms_64.c
@@ -16,7 +16,6 @@
 #include <linux/in6.h>
 #include <linux/interrupt.h>
 #include <linux/screen_info.h>
-#include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/checksum.h>
@@ -37,9 +36,6 @@ EXPORT_SYMBOL(csum_partial_copy_nocheck);
 EXPORT_SYMBOL(screen_info);
 #endif
 
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_trylock);
-EXPORT_SYMBOL(__up);
 EXPORT_SYMBOL(__put_user_asm_l);
 EXPORT_SYMBOL(__get_user_asm_l);
 EXPORT_SYMBOL(__copy_user);
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index e795f28..9b16cd3 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -12,7 +12,7 @@ obj-y    := entry.o wof.o wuf.o etrap.o rtrap.o traps.o $(IRQ_OBJS) \
 	    sys_sparc.o sunos_asm.o systbls.o \
 	    time.o windows.o cpu.o devices.o sclow.o \
 	    tadpole.o tick14.o ptrace.o sys_solaris.o \
-	    unaligned.o muldiv.o semaphore.o prom.o of_device.o devres.o
+	    unaligned.o muldiv.o prom.o of_device.o devres.o
 
 devres-y = ../../../kernel/irq/devres.o
 
diff --git a/arch/sparc/kernel/semaphore.c b/arch/sparc/kernel/semaphore.c
deleted file mode 100644
index 0c37c1a..0000000
--- a/arch/sparc/kernel/semaphore.c
+++ /dev/null
@@ -1,155 +0,0 @@
-/* $Id: semaphore.c,v 1.7 2001/04/18 21:06:05 davem Exp $ */
-
-/* sparc32 semaphore implementation, based on i386 version */
-
-#include <linux/sched.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-
-#include <asm/semaphore.h>
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to acquire the semaphore, while the "sleeping"
- * variable is a count of such acquires.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * "sleeping" and the contention routine ordering is
- * protected by the semaphore spinlock.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-
-/*
- * Logic:
- *  - only on a boundary condition do we need to care. When we go
- *    from a negative count to a non-negative, we wake people up.
- *  - when we go from a non-negative count to a negative do we
- *    (a) synchronize with the "sleeper" count and (b) make sure
- *    that we're on the wakeup list before we synchronize so that
- *    we cannot lose wakeup events.
- */
-
-void __up(struct semaphore *sem)
-{
-	wake_up(&sem->wait);
-}
-
-static DEFINE_SPINLOCK(semaphore_lock);
-
-void __sched __down(struct semaphore * sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	spin_lock_irq(&semaphore_lock);
-	sem->sleepers++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock.
-		 */
-		if (!atomic24_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irq(&semaphore_lock);
-
-		schedule();
-		tsk->state = TASK_UNINTERRUPTIBLE;
-		spin_lock_irq(&semaphore_lock);
-	}
-	spin_unlock_irq(&semaphore_lock);
-	remove_wait_queue(&sem->wait, &wait);
-	tsk->state = TASK_RUNNING;
-	wake_up(&sem->wait);
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	tsk->state = TASK_INTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	spin_lock_irq(&semaphore_lock);
-	sem->sleepers ++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * With signals pending, this turns into
-		 * the trylock failure case - we won't be
-		 * sleeping, and we* can't get the lock as
-		 * it has contention. Just correct the count
-		 * and exit.
-		 */
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			sem->sleepers = 0;
-			atomic24_add(sleepers, &sem->count);
-			break;
-		}
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock. The
-		 * "-1" is because we're still hoping to get
-		 * the lock.
-		 */
-		if (!atomic24_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irq(&semaphore_lock);
-
-		schedule();
-		tsk->state = TASK_INTERRUPTIBLE;
-		spin_lock_irq(&semaphore_lock);
-	}
-	spin_unlock_irq(&semaphore_lock);
-	tsk->state = TASK_RUNNING;
-	remove_wait_queue(&sem->wait, &wait);
-	wake_up(&sem->wait);
-	return retval;
-}
-
-/*
- * Trylock failed - make sure we correct for
- * having decremented the count.
- */
-int __down_trylock(struct semaphore * sem)
-{
-	int sleepers;
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_lock, flags);
-	sleepers = sem->sleepers + 1;
-	sem->sleepers = 0;
-
-	/*
-	 * Add "everybody else" and us into it. They aren't
-	 * playing, because we own the spinlock.
-	 */
-	if (!atomic24_add_negative(sleepers, &sem->count))
-		wake_up(&sem->wait);
-
-	spin_unlock_irqrestore(&semaphore_lock, flags);
-	return 1;
-}
diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index c1025e5..97b1de0 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -107,11 +107,6 @@ EXPORT_SYMBOL(___rw_read_try);
 EXPORT_SYMBOL(___rw_read_exit);
 EXPORT_SYMBOL(___rw_write_enter);
 #endif
-/* semaphores */
-EXPORT_SYMBOL(__up);
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_trylock);
-EXPORT_SYMBOL(__down_interruptible);
 
 EXPORT_SYMBOL(sparc_valid_addr_bitmap);
 EXPORT_SYMBOL(phys_base);
diff --git a/arch/sparc64/kernel/Makefile b/arch/sparc64/kernel/Makefile
index 1bf5b18..459462e 100644
--- a/arch/sparc64/kernel/Makefile
+++ b/arch/sparc64/kernel/Makefile
@@ -10,7 +10,7 @@ extra-y		:= head.o init_task.o vmlinux.lds
 obj-y		:= process.o setup.o cpu.o idprom.o \
 		   traps.o auxio.o una_asm.o sysfs.o iommu.o \
 		   irq.o ptrace.o time.o sys_sparc.o signal.o \
-		   unaligned.o central.o pci.o starfire.o semaphore.o \
+		   unaligned.o central.o pci.o starfire.o \
 		   power.o sbus.o sparc64_ksyms.o chmc.o \
 		   visemul.o prom.o of_device.o hvapi.o sstate.o mdesc.o
 
diff --git a/arch/sparc64/kernel/semaphore.c b/arch/sparc64/kernel/semaphore.c
deleted file mode 100644
index 9974a68..0000000
--- a/arch/sparc64/kernel/semaphore.c
+++ /dev/null
@@ -1,254 +0,0 @@
-/* semaphore.c: Sparc64 semaphore implementation.
- *
- * This is basically the PPC semaphore scheme ported to use
- * the sparc64 atomic instructions, so see the PPC code for
- * credits.
- */
-
-#include <linux/sched.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-
-/*
- * Atomically update sem->count.
- * This does the equivalent of the following:
- *
- *	old_count = sem->count;
- *	tmp = MAX(old_count, 0) + incr;
- *	sem->count = tmp;
- *	return old_count;
- */
-static inline int __sem_update_count(struct semaphore *sem, int incr)
-{
-	int old_count, tmp;
-
-	__asm__ __volatile__("\n"
-"	! __sem_update_count old_count(%0) tmp(%1) incr(%4) &sem->count(%3)\n"
-"1:	ldsw	[%3], %0\n"
-"	mov	%0, %1\n"
-"	cmp	%0, 0\n"
-"	movl	%%icc, 0, %1\n"
-"	add	%1, %4, %1\n"
-"	cas	[%3], %0, %1\n"
-"	cmp	%0, %1\n"
-"	membar	#StoreLoad | #StoreStore\n"
-"	bne,pn	%%icc, 1b\n"
-"	 nop\n"
-	: "=&r" (old_count), "=&r" (tmp), "=m" (sem->count)
-	: "r" (&sem->count), "r" (incr), "m" (sem->count)
-	: "cc");
-
-	return old_count;
-}
-
-static void __up(struct semaphore *sem)
-{
-	__sem_update_count(sem, 1);
-	wake_up(&sem->wait);
-}
-
-void up(struct semaphore *sem)
-{
-	/* This atomically does:
-	 * 	old_val = sem->count;
-	 *	new_val = sem->count + 1;
-	 *	sem->count = new_val;
-	 *	if (old_val < 0)
-	 *		__up(sem);
-	 *
-	 * The (old_val < 0) test is equivalent to
-	 * the more straightforward (new_val <= 0),
-	 * but it is easier to test the former because
-	 * of how the CAS instruction works.
-	 */
-
-	__asm__ __volatile__("\n"
-"	! up sem(%0)\n"
-"	membar	#StoreLoad | #LoadLoad\n"
-"1:	lduw	[%0], %%g1\n"
-"	add	%%g1, 1, %%g7\n"
-"	cas	[%0], %%g1, %%g7\n"
-"	cmp	%%g1, %%g7\n"
-"	bne,pn	%%icc, 1b\n"
-"	 addcc	%%g7, 1, %%g0\n"
-"	membar	#StoreLoad | #StoreStore\n"
-"	ble,pn	%%icc, 3f\n"
-"	 nop\n"
-"2:\n"
-"	.subsection 2\n"
-"3:	mov	%0, %%g1\n"
-"	save	%%sp, -160, %%sp\n"
-"	call	%1\n"
-"	 mov	%%g1, %%o0\n"
-"	ba,pt	%%xcc, 2b\n"
-"	 restore\n"
-"	.previous\n"
-	: : "r" (sem), "i" (__up)
-	: "g1", "g2", "g3", "g7", "memory", "cc");
-}
-
-static void __sched __down(struct semaphore * sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	while (__sem_update_count(sem, -1) <= 0) {
-		schedule();
-		tsk->state = TASK_UNINTERRUPTIBLE;
-	}
-	remove_wait_queue(&sem->wait, &wait);
-	tsk->state = TASK_RUNNING;
-
-	wake_up(&sem->wait);
-}
-
-void __sched down(struct semaphore *sem)
-{
-	might_sleep();
-	/* This atomically does:
-	 * 	old_val = sem->count;
-	 *	new_val = sem->count - 1;
-	 *	sem->count = new_val;
-	 *	if (old_val < 1)
-	 *		__down(sem);
-	 *
-	 * The (old_val < 1) test is equivalent to
-	 * the more straightforward (new_val < 0),
-	 * but it is easier to test the former because
-	 * of how the CAS instruction works.
-	 */
-
-	__asm__ __volatile__("\n"
-"	! down sem(%0)\n"
-"1:	lduw	[%0], %%g1\n"
-"	sub	%%g1, 1, %%g7\n"
-"	cas	[%0], %%g1, %%g7\n"
-"	cmp	%%g1, %%g7\n"
-"	bne,pn	%%icc, 1b\n"
-"	 cmp	%%g7, 1\n"
-"	membar	#StoreLoad | #StoreStore\n"
-"	bl,pn	%%icc, 3f\n"
-"	 nop\n"
-"2:\n"
-"	.subsection 2\n"
-"3:	mov	%0, %%g1\n"
-"	save	%%sp, -160, %%sp\n"
-"	call	%1\n"
-"	 mov	%%g1, %%o0\n"
-"	ba,pt	%%xcc, 2b\n"
-"	 restore\n"
-"	.previous\n"
-	: : "r" (sem), "i" (__down)
-	: "g1", "g2", "g3", "g7", "memory", "cc");
-}
-
-int down_trylock(struct semaphore *sem)
-{
-	int ret;
-
-	/* This atomically does:
-	 * 	old_val = sem->count;
-	 *	new_val = sem->count - 1;
-	 *	if (old_val < 1) {
-	 *		ret = 1;
-	 *	} else {
-	 *		sem->count = new_val;
-	 *		ret = 0;
-	 *	}
-	 *
-	 * The (old_val < 1) test is equivalent to
-	 * the more straightforward (new_val < 0),
-	 * but it is easier to test the former because
-	 * of how the CAS instruction works.
-	 */
-
-	__asm__ __volatile__("\n"
-"	! down_trylock sem(%1) ret(%0)\n"
-"1:	lduw	[%1], %%g1\n"
-"	sub	%%g1, 1, %%g7\n"
-"	cmp	%%g1, 1\n"
-"	bl,pn	%%icc, 2f\n"
-"	 mov	1, %0\n"
-"	cas	[%1], %%g1, %%g7\n"
-"	cmp	%%g1, %%g7\n"
-"	bne,pn	%%icc, 1b\n"
-"	 mov	0, %0\n"
-"	membar	#StoreLoad | #StoreStore\n"
-"2:\n"
-	: "=&r" (ret)
-	: "r" (sem)
-	: "g1", "g7", "memory", "cc");
-
-	return ret;
-}
-
-static int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-
-	tsk->state = TASK_INTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	while (__sem_update_count(sem, -1) <= 0) {
-		if (signal_pending(current)) {
-			__sem_update_count(sem, 0);
-			retval = -EINTR;
-			break;
-		}
-		schedule();
-		tsk->state = TASK_INTERRUPTIBLE;
-	}
-	tsk->state = TASK_RUNNING;
-	remove_wait_queue(&sem->wait, &wait);
-	wake_up(&sem->wait);
-	return retval;
-}
-
-int __sched down_interruptible(struct semaphore *sem)
-{
-	int ret = 0;
-	
-	might_sleep();
-	/* This atomically does:
-	 * 	old_val = sem->count;
-	 *	new_val = sem->count - 1;
-	 *	sem->count = new_val;
-	 *	if (old_val < 1)
-	 *		ret = __down_interruptible(sem);
-	 *
-	 * The (old_val < 1) test is equivalent to
-	 * the more straightforward (new_val < 0),
-	 * but it is easier to test the former because
-	 * of how the CAS instruction works.
-	 */
-
-	__asm__ __volatile__("\n"
-"	! down_interruptible sem(%2) ret(%0)\n"
-"1:	lduw	[%2], %%g1\n"
-"	sub	%%g1, 1, %%g7\n"
-"	cas	[%2], %%g1, %%g7\n"
-"	cmp	%%g1, %%g7\n"
-"	bne,pn	%%icc, 1b\n"
-"	 cmp	%%g7, 1\n"
-"	membar	#StoreLoad | #StoreStore\n"
-"	bl,pn	%%icc, 3f\n"
-"	 nop\n"
-"2:\n"
-"	.subsection 2\n"
-"3:	mov	%2, %%g1\n"
-"	save	%%sp, -160, %%sp\n"
-"	call	%3\n"
-"	 mov	%%g1, %%o0\n"
-"	ba,pt	%%xcc, 2b\n"
-"	 restore\n"
-"	.previous\n"
-	: "=r" (ret)
-	: "0" (ret), "r" (sem), "i" (__down_interruptible)
-	: "g1", "g2", "g3", "g7", "memory", "cc");
-	return ret;
-}
diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index 51fa773..051b8d9 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -130,12 +130,6 @@ EXPORT_SYMBOL(_mcount);
 
 EXPORT_SYMBOL(sparc64_get_clock_tick);
 
-/* semaphores */
-EXPORT_SYMBOL(down);
-EXPORT_SYMBOL(down_trylock);
-EXPORT_SYMBOL(down_interruptible);
-EXPORT_SYMBOL(up);
-
 /* RW semaphores */
 EXPORT_SYMBOL(__down_read);
 EXPORT_SYMBOL(__down_read_trylock);
diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index 3cd8a04..e28b66c 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -19,9 +19,42 @@ config 64BIT
 	bool
 	default n
 
-config SEMAPHORE_SLEEPERS
-	bool
-	default y
+choice
+	prompt "Host memory split"
+	default HOST_VMSPLIT_3G
+	help
+        This is needed when the host kernel on which you run has a non-default
+	(like 2G/2G) memory split, instead of the customary 3G/1G. If you did
+	not recompile your own kernel but use the default distro's one, you can
+	safely accept the "Default split" option.
+
+	It can be enabled on recent (>=2.6.16-rc2) vanilla kernels via
+	CONFIG_VM_SPLIT_*, or on previous kernels with special patches (-ck
+	patchset by Con Kolivas, or other ones) - option names match closely the
+	host CONFIG_VM_SPLIT_* ones.
+
+	A lower setting (where 1G/3G is lowest and 3G/1G is higher) will
+	tolerate even more "normal" host kernels, but an higher setting will be
+	stricter.
+
+	So, if you do not know what to do here, say 'Default split'.
+
+config HOST_VMSPLIT_3G
+	bool "Default split (3G/1G user/kernel host split)"
+config HOST_VMSPLIT_3G_OPT
+	bool "3G/1G user/kernel host split (for full 1G low memory)"
+config HOST_VMSPLIT_2G
+	bool "2G/2G user/kernel host split"
+config HOST_VMSPLIT_1G
+	bool "1G/3G user/kernel host split"
+endchoice
+
+config TOP_ADDR
+	hex
+	default 0xB0000000 if HOST_VMSPLIT_3G_OPT
+	default 0x78000000 if HOST_VMSPLIT_2G
+	default 0x40000000 if HOST_VMSPLIT_1G
+	default 0xC0000000
 
 config 3_LEVEL_PGTABLES
 	bool "Three-level pagetables (EXPERIMENTAL)"
diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
index 6533b34..9961e52 100644
--- a/arch/um/Kconfig.x86_64
+++ b/arch/um/Kconfig.x86_64
@@ -11,9 +11,9 @@ config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
 
-config SEMAPHORE_SLEEPERS
-	bool
-	default y
+config TOP_ADDR
+ 	hex
+	default 0x7fc0000000
 
 config 3_LEVEL_PGTABLES
        bool
diff --git a/arch/um/sys-i386/ksyms.c b/arch/um/sys-i386/ksyms.c
index 2a1eac1..bfbefd3 100644
--- a/arch/um/sys-i386/ksyms.c
+++ b/arch/um/sys-i386/ksyms.c
@@ -1,17 +1,5 @@
 #include "linux/module.h"
-#include "linux/in6.h"
-#include "linux/rwsem.h"
-#include "asm/byteorder.h"
-#include "asm/delay.h"
-#include "asm/semaphore.h"
-#include "asm/uaccess.h"
 #include "asm/checksum.h"
-#include "asm/errno.h"
-
-EXPORT_SYMBOL(__down_failed);
-EXPORT_SYMBOL(__down_failed_interruptible);
-EXPORT_SYMBOL(__down_failed_trylock);
-EXPORT_SYMBOL(__up_wakeup);
 
 /* Networking helper routines. */
 EXPORT_SYMBOL(csum_partial);
diff --git a/arch/um/sys-ppc/Makefile b/arch/um/sys-ppc/Makefile
index 0890152..b8bc844 100644
--- a/arch/um/sys-ppc/Makefile
+++ b/arch/um/sys-ppc/Makefile
@@ -3,7 +3,7 @@ OBJ = built-in.o
 .S.o:
 	$(CC) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 
-OBJS = ptrace.o sigcontext.o semaphore.o checksum.o miscthings.o misc.o \
+OBJS = ptrace.o sigcontext.o checksum.o miscthings.o misc.o \
 	ptrace_user.o sysrq.o
 
 EXTRA_AFLAGS := -DCONFIG_PPC32 -I. -I$(srctree)/arch/ppc/kernel
@@ -20,10 +20,6 @@ ptrace_user.o: ptrace_user.c
 sigcontext.o: sigcontext.c
 	$(CC) $(USER_CFLAGS) $(EXTRA_CFLAGS) -c -o $@ $<
 
-semaphore.c:
-	rm -f $@
-	ln -s $(srctree)/arch/ppc/kernel/$@ $@
-
 checksum.S:
 	rm -f $@
 	ln -s $(srctree)/arch/ppc/lib/$@ $@
@@ -66,4 +62,4 @@ misc.o: misc.S ppc_defs.h
 	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
-clean-files := $(OBJS) ppc_defs.h checksum.S semaphore.c mk_defs.c
+clean-files := $(OBJS) ppc_defs.h checksum.S mk_defs.c
diff --git a/arch/um/sys-x86_64/ksyms.c b/arch/um/sys-x86_64/ksyms.c
index 12c5936..4d7d1a8 100644
--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86_64/ksyms.c
@@ -1,16 +1,5 @@
 #include "linux/module.h"
-#include "linux/in6.h"
-#include "linux/rwsem.h"
-#include "asm/byteorder.h"
-#include "asm/semaphore.h"
-#include "asm/uaccess.h"
-#include "asm/checksum.h"
-#include "asm/errno.h"
-
-EXPORT_SYMBOL(__down_failed);
-EXPORT_SYMBOL(__down_failed_interruptible);
-EXPORT_SYMBOL(__down_failed_trylock);
-EXPORT_SYMBOL(__up_wakeup);
+#include "asm/string.h"
 
 /*XXX: we need them because they would be exported by x86_64 */
 EXPORT_SYMBOL(__memcpy);
diff --git a/arch/v850/kernel/Makefile b/arch/v850/kernel/Makefile
index 3930482..da5889c 100644
--- a/arch/v850/kernel/Makefile
+++ b/arch/v850/kernel/Makefile
@@ -11,7 +11,7 @@
 
 extra-y := head.o init_task.o vmlinux.lds
 
-obj-y += intv.o entry.o process.o syscalls.o time.o semaphore.o setup.o \
+obj-y += intv.o entry.o process.o syscalls.o time.o setup.o \
 	 signal.o irq.o mach.o ptrace.o bug.o
 obj-$(CONFIG_MODULES)		+= module.o v850_ksyms.o
 # chip-specific code
diff --git a/arch/v850/kernel/semaphore.c b/arch/v850/kernel/semaphore.c
deleted file mode 100644
index fc89fd6..0000000
--- a/arch/v850/kernel/semaphore.c
+++ /dev/null
@@ -1,166 +0,0 @@
-/*
- * arch/v850/kernel/semaphore.c -- Semaphore support
- *
- *  Copyright (C) 1998-2000  IBM Corporation
- *  Copyright (C) 1999  Linus Torvalds
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License.  See the file COPYING in the main directory of this
- * archive for more details.
- *
- * This file is a copy of the s390 version, arch/s390/kernel/semaphore.c
- *    Author(s): Martin Schwidefsky
- * which was derived from the i386 version, linux/arch/i386/kernel/semaphore.c
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-
-#include <asm/semaphore.h>
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to acquire the semaphore, while the "sleeping"
- * variable is a count of such acquires.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * "sleeping" and the contention routine ordering is
- * protected by the semaphore spinlock.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-
-/*
- * Logic:
- *  - only on a boundary condition do we need to care. When we go
- *    from a negative count to a non-negative, we wake people up.
- *  - when we go from a non-negative count to a negative do we
- *    (a) synchronize with the "sleeper" count and (b) make sure
- *    that we're on the wakeup list before we synchronize so that
- *    we cannot lose wakeup events.
- */
-
-void __up(struct semaphore *sem)
-{
-	wake_up(&sem->wait);
-}
-
-static DEFINE_SPINLOCK(semaphore_lock);
-
-void __sched __down(struct semaphore * sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	spin_lock_irq(&semaphore_lock);
-	sem->sleepers++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irq(&semaphore_lock);
-
-		schedule();
-		tsk->state = TASK_UNINTERRUPTIBLE;
-		spin_lock_irq(&semaphore_lock);
-	}
-	spin_unlock_irq(&semaphore_lock);
-	remove_wait_queue(&sem->wait, &wait);
-	tsk->state = TASK_RUNNING;
-	wake_up(&sem->wait);
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	tsk->state = TASK_INTERRUPTIBLE;
-	add_wait_queue_exclusive(&sem->wait, &wait);
-
-	spin_lock_irq(&semaphore_lock);
-	sem->sleepers ++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * With signals pending, this turns into
-		 * the trylock failure case - we won't be
-		 * sleeping, and we* can't get the lock as
-		 * it has contention. Just correct the count
-		 * and exit.
-		 */
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			sem->sleepers = 0;
-			atomic_add(sleepers, &sem->count);
-			break;
-		}
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock. The
-		 * "-1" is because we're still hoping to get
-		 * the lock.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irq(&semaphore_lock);
-
-		schedule();
-		tsk->state = TASK_INTERRUPTIBLE;
-		spin_lock_irq(&semaphore_lock);
-	}
-	spin_unlock_irq(&semaphore_lock);
-	tsk->state = TASK_RUNNING;
-	remove_wait_queue(&sem->wait, &wait);
-	wake_up(&sem->wait);
-	return retval;
-}
-
-/*
- * Trylock failed - make sure we correct for
- * having decremented the count.
- */
-int __down_trylock(struct semaphore * sem)
-{
-        unsigned long flags;
-	int sleepers;
-
-	spin_lock_irqsave(&semaphore_lock, flags);
-	sleepers = sem->sleepers + 1;
-	sem->sleepers = 0;
-
-	/*
-	 * Add "everybody else" and us into it. They aren't
-	 * playing, because we own the spinlock.
-	 */
-	if (!atomic_add_negative(sleepers, &sem->count))
-		wake_up(&sem->wait);
-
-	spin_unlock_irqrestore(&semaphore_lock, flags);
-	return 1;
-}
diff --git a/arch/v850/kernel/v850_ksyms.c b/arch/v850/kernel/v850_ksyms.c
index 93575fd..8d386a5 100644
--- a/arch/v850/kernel/v850_ksyms.c
+++ b/arch/v850/kernel/v850_ksyms.c
@@ -11,7 +11,6 @@
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/current.h>
 
@@ -34,12 +33,6 @@ EXPORT_SYMBOL (memset);
 EXPORT_SYMBOL (memcpy);
 EXPORT_SYMBOL (memmove);
 
-/* semaphores */
-EXPORT_SYMBOL (__down);
-EXPORT_SYMBOL (__down_interruptible);
-EXPORT_SYMBOL (__down_trylock);
-EXPORT_SYMBOL (__up);
-
 /*
  * libgcc functions - functions that are used internally by the
  * compiler...  (prototypes are not correct though, but that
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4a88cf7..e975fe7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -52,13 +52,6 @@ config STACKTRACE_SUPPORT
 config HAVE_LATENCYTOP_SUPPORT
 	def_bool y
 
-config SEMAPHORE_SLEEPERS
-	def_bool y
-
-config FAST_CMPXCHG_LOCAL
-	bool
-	default y
-
 config MMU
 	def_bool y
 
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 0616278..deb4378 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -1,13 +1,8 @@
 #include <linux/module.h>
-#include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 
-EXPORT_SYMBOL(__down_failed);
-EXPORT_SYMBOL(__down_failed_interruptible);
-EXPORT_SYMBOL(__down_failed_trylock);
-EXPORT_SYMBOL(__up_wakeup);
 /* Networking helper routines. */
 EXPORT_SYMBOL(csum_partial_copy_generic);
 
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index a66e9c1..95a993e 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -4,7 +4,6 @@
 #include <linux/module.h>
 #include <linux/smp.h>
 
-#include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -12,11 +11,6 @@
 
 EXPORT_SYMBOL(kernel_thread);
 
-EXPORT_SYMBOL(__down_failed);
-EXPORT_SYMBOL(__down_failed_interruptible);
-EXPORT_SYMBOL(__down_failed_trylock);
-EXPORT_SYMBOL(__up_wakeup);
-
 EXPORT_SYMBOL(__get_user_1);
 EXPORT_SYMBOL(__get_user_2);
 EXPORT_SYMBOL(__get_user_4);
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 3899bd3..648fe47 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -30,89 +30,6 @@
  * value or just clobbered..
  */
 	.section .sched.text, "ax"
-ENTRY(__down_failed)
-	CFI_STARTPROC
-	FRAME
-	pushl %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edx,0
-	pushl %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx,0
-	call __down
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE ecx
-	popl %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE edx
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__down_failed)
-
-ENTRY(__down_failed_interruptible)
-	CFI_STARTPROC
-	FRAME
-	pushl %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edx,0
-	pushl %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx,0
-	call __down_interruptible
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE ecx
-	popl %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE edx
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__down_failed_interruptible)
-
-ENTRY(__down_failed_trylock)
-	CFI_STARTPROC
-	FRAME
-	pushl %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edx,0
-	pushl %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx,0
-	call __down_trylock
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE ecx
-	popl %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE edx
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__down_failed_trylock)
-
-ENTRY(__up_wakeup)
-	CFI_STARTPROC
-	FRAME
-	pushl %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edx,0
-	pushl %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx,0
-	call __up
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE ecx
-	popl %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	CFI_RESTORE edx
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__up_wakeup)
 
 /*
  * rw spinlock fallbacks
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index 8b92d42..e009251 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -41,11 +41,6 @@
 	thunk rwsem_downgrade_thunk,rwsem_downgrade_wake
 #endif	
 	
-	thunk __down_failed,__down
-	thunk_retrax __down_failed_interruptible,__down_interruptible
-	thunk_retrax __down_failed_trylock,__down_trylock
-	thunk __up_wakeup,__up
-
 #ifdef CONFIG_TRACE_IRQFLAGS
 	thunk trace_hardirqs_on_thunk,trace_hardirqs_on
 	thunk trace_hardirqs_off_thunk,trace_hardirqs_off
diff --git a/arch/xtensa/kernel/Makefile b/arch/xtensa/kernel/Makefile
index f582d6a..7419dbc 100644
--- a/arch/xtensa/kernel/Makefile
+++ b/arch/xtensa/kernel/Makefile
@@ -5,7 +5,7 @@
 extra-y := head.o vmlinux.lds
 
 
-obj-y := align.o entry.o irq.o coprocessor.o process.o ptrace.o semaphore.o  \
+obj-y := align.o entry.o irq.o coprocessor.o process.o ptrace.o \
 	 setup.o signal.o syscall.o time.o traps.o vectors.o platform.o  \
 	 pci-dma.o init_task.o io.o
 
diff --git a/arch/xtensa/kernel/semaphore.c b/arch/xtensa/kernel/semaphore.c
deleted file mode 100644
index 995c641..0000000
--- a/arch/xtensa/kernel/semaphore.c
+++ /dev/null
@@ -1,226 +0,0 @@
-/*
- * arch/xtensa/kernel/semaphore.c
- *
- * Generic semaphore code. Buyer beware. Do your own specific changes
- * in <asm/semaphore-helper.h>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- *
- * Joe Taylor	<joe@tensilica.com, joetylr@yahoo.com>
- * Chris Zankel	<chris@zankel.net>
- * Marc Gauthier<marc@tensilica.com, marc@alumni.uwaterloo.ca>
- * Kevin Chea
- */
-
-#include <linux/sched.h>
-#include <linux/wait.h>
-#include <linux/init.h>
-#include <asm/semaphore.h>
-#include <asm/errno.h>
-
-/*
- * These two _must_ execute atomically wrt each other.
- */
-
-static __inline__ void wake_one_more(struct semaphore * sem)
-{
-	atomic_inc((atomic_t *)&sem->sleepers);
-}
-
-static __inline__ int waking_non_zero(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->sleepers > 0) {
-		sem->sleepers--;
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_interruptible:
- *	1	got the lock
- *	0	go to sleep
- *	-EINTR	interrupted
- *
- * We must undo the sem->count down_interruptible() increment while we are
- * protected by the spinlock in order to make atomic this atomic_inc() with the
- * atomic_read() in wake_one_more(), otherwise we can race. -arca
- */
-
-static __inline__ int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->sleepers > 0) {
-		sem->sleepers--;
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_trylock:
- *	1	failed to lock
- *	0	got the lock
- *
- * We must undo the sem->count down_trylock() increment while we are
- * protected by the spinlock in order to make atomic this atomic_inc() with the
- * atomic_read() in wake_one_more(), otherwise we can race. -arca
- */
-
-static __inline__ int waking_non_zero_trylock(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->sleepers <= 0)
-		atomic_inc(&sem->count);
-	else {
-		sem->sleepers--;
-		ret = 0;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-DEFINE_SPINLOCK(semaphore_wake_lock);
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to sleep, while the "waking" variable is
- * incremented when the "up()" code goes to wake up waiting
- * processes.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * waking_non_zero() (from asm/semaphore.h) must execute
- * atomically.
- *
- * When __up() is called, the count was negative before
- * incrementing it, and we need to wake up somebody.
- *
- * This routine adds one to the count of processes that need to
- * wake up and exit.  ALL waiting processes actually wake up but
- * only the one that gets to the "waking" field first will gate
- * through and acquire the semaphore.  The others will go back
- * to sleep.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-
-void __up(struct semaphore *sem)
-{
-	wake_one_more(sem);
-	wake_up(&sem->wait);
-}
-
-/*
- * Perform the "down" function.  Return zero for semaphore acquired,
- * return negative for signalled out of the function.
- *
- * If called from __down, the return is ignored and the wait loop is
- * not interruptible.  This means that a task waiting on a semaphore
- * using "down()" cannot be killed until someone does an "up()" on
- * the semaphore.
- *
- * If called from __down_interruptible, the return value gets checked
- * upon return.  If the return value is negative then the task continues
- * with the negative value in the return register (it can be tested by
- * the caller).
- *
- * Either form may be used in conjunction with "up()".
- *
- */
-
-#define DOWN_VAR				\
-	struct task_struct *tsk = current;	\
-	wait_queue_t wait;			\
-	init_waitqueue_entry(&wait, tsk);
-
-#define DOWN_HEAD(task_state)						\
-									\
-									\
-	tsk->state = (task_state);					\
-	add_wait_queue(&sem->wait, &wait);				\
-									\
-	/*								\
-	 * Ok, we're set up.  sem->count is known to be less than zero	\
-	 * so we must wait.						\
-	 *								\
-	 * We can let go the lock for purposes of waiting.		\
-	 * We re-acquire it after awaking so as to protect		\
-	 * all semaphore operations.					\
-	 *								\
-	 * If "up()" is called before we call waking_non_zero() then	\
-	 * we will catch it right away.  If it is called later then	\
-	 * we will have to go through a wakeup cycle to catch it.	\
-	 *								\
-	 * Multiple waiters contend for the semaphore lock to see	\
-	 * who gets to gate through and who has to wait some more.	\
-	 */								\
-	for (;;) {
-
-#define DOWN_TAIL(task_state)			\
-		tsk->state = (task_state);	\
-	}					\
-	tsk->state = TASK_RUNNING;		\
-	remove_wait_queue(&sem->wait, &wait);
-
-void __sched __down(struct semaphore * sem)
-{
-	DOWN_VAR
-	DOWN_HEAD(TASK_UNINTERRUPTIBLE)
-	if (waking_non_zero(sem))
-		break;
-	schedule();
-	DOWN_TAIL(TASK_UNINTERRUPTIBLE)
-}
-
-int __sched __down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-	DOWN_VAR
-	DOWN_HEAD(TASK_INTERRUPTIBLE)
-
-	ret = waking_non_zero_interruptible(sem, tsk);
-	if (ret)
-	{
-		if (ret == 1)
-			/* ret != 0 only if we get interrupted -arca */
-			ret = 0;
-		break;
-	}
-	schedule();
-	DOWN_TAIL(TASK_INTERRUPTIBLE)
-	return ret;
-}
-
-int __down_trylock(struct semaphore * sem)
-{
-	return waking_non_zero_trylock(sem);
-}
diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
index 60dbdb4..6e52cdd 100644
--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -26,7 +26,6 @@
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/semaphore.h>
 #ifdef CONFIG_BLK_DEV_FD
 #include <asm/floppy.h>
 #endif
@@ -71,14 +70,6 @@ EXPORT_SYMBOL(__umodsi3);
 EXPORT_SYMBOL(__udivdi3);
 EXPORT_SYMBOL(__umoddi3);
 
-/*
- * Semaphore operations
- */
-EXPORT_SYMBOL(__down);
-EXPORT_SYMBOL(__down_interruptible);
-EXPORT_SYMBOL(__down_trylock);
-EXPORT_SYMBOL(__up);
-
 #ifdef CONFIG_NET
 /*
  * Networking support
diff --git a/include/asm-alpha/semaphore.h b/include/asm-alpha/semaphore.h
index f1e9278..d9b2034 100644
--- a/include/asm-alpha/semaphore.h
+++ b/include/asm-alpha/semaphore.h
@@ -1,149 +1 @@
-#ifndef _ALPHA_SEMAPHORE_H
-#define _ALPHA_SEMAPHORE_H
-
-/*
- * SMP- and interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- * (C) Copyright 1996, 2000 Richard Henderson
- */
-
-#include <asm/current.h>
-#include <asm/system.h>
-#include <asm/atomic.h>
-#include <linux/compiler.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	atomic_t count;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)			\
-{								\
-	.count	= ATOMIC_INIT(n),				\
-  	.wait	= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait),	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count)		\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-	/*
-	 * Logically, 
-	 *   *sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
-	 * except that gcc produces better initializing by parts yet.
-	 */
-
-	atomic_set(&sem->count, val);
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern void down(struct semaphore *);
-extern void __down_failed(struct semaphore *);
-extern int  down_interruptible(struct semaphore *);
-extern int  __down_failed_interruptible(struct semaphore *);
-extern int  down_trylock(struct semaphore *);
-extern void up(struct semaphore *);
-extern void __up_wakeup(struct semaphore *);
-
-/*
- * Hidden out of line code is fun, but extremely messy.  Rely on newer
- * compilers to do a respectable job with this.  The contention cases
- * are handled out of line in arch/alpha/kernel/semaphore.c.
- */
-
-static inline void __down(struct semaphore *sem)
-{
-	long count;
-	might_sleep();
-	count = atomic_dec_return(&sem->count);
-	if (unlikely(count < 0))
-		__down_failed(sem);
-}
-
-static inline int __down_interruptible(struct semaphore *sem)
-{
-	long count;
-	might_sleep();
-	count = atomic_dec_return(&sem->count);
-	if (unlikely(count < 0))
-		return __down_failed_interruptible(sem);
-	return 0;
-}
-
-/*
- * down_trylock returns 0 on success, 1 if we failed to get the lock.
- */
-
-static inline int __down_trylock(struct semaphore *sem)
-{
-	long ret;
-
-	/* "Equivalent" C:
-
-	   do {
-		ret = ldl_l;
-		--ret;
-		if (ret < 0)
-			break;
-		ret = stl_c = ret;
-	   } while (ret == 0);
-	*/
-	__asm__ __volatile__(
-		"1:	ldl_l	%0,%1\n"
-		"	subl	%0,1,%0\n"
-		"	blt	%0,2f\n"
-		"	stl_c	%0,%1\n"
-		"	beq	%0,3f\n"
-		"	mb\n"
-		"2:\n"
-		".subsection 2\n"
-		"3:	br	1b\n"
-		".previous"
-		: "=&r" (ret), "=m" (sem->count)
-		: "m" (sem->count));
-
-	return ret < 0;
-}
-
-static inline void __up(struct semaphore *sem)
-{
-	if (unlikely(atomic_inc_return(&sem->count) <= 0))
-		__up_wakeup(sem);
-}
-
-#if !defined(CONFIG_DEBUG_SEMAPHORE)
-extern inline void down(struct semaphore *sem)
-{
-	__down(sem);
-}
-extern inline int down_interruptible(struct semaphore *sem)
-{
-	return __down_interruptible(sem);
-}
-extern inline int down_trylock(struct semaphore *sem)
-{
-	return __down_trylock(sem);
-}
-extern inline void up(struct semaphore *sem)
-{
-	__up(sem);
-}
-#endif
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-arm/semaphore-helper.h b/include/asm-arm/semaphore-helper.h
deleted file mode 100644
index 1d7f198..0000000
--- a/include/asm-arm/semaphore-helper.h
+++ /dev/null
@@ -1,84 +0,0 @@
-#ifndef ASMARM_SEMAPHORE_HELPER_H
-#define ASMARM_SEMAPHORE_HELPER_H
-
-/*
- * These two _must_ execute atomically wrt each other.
- */
-static inline void wake_one_more(struct semaphore * sem)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (atomic_read(&sem->count) <= 0)
-		sem->waking++;
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-}
-
-static inline int waking_non_zero(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->waking > 0) {
-		sem->waking--;
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking non zero interruptible
- *	1	got the lock
- *	0	go to sleep
- *	-EINTR	interrupted
- *
- * We must undo the sem->count down_interruptible() increment while we are
- * protected by the spinlock in order to make this atomic_inc() with the
- * atomic_read() in wake_one_more(), otherwise we can race. -arca
- */
-static inline int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->waking > 0) {
-		sem->waking--;
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;	
-}
-
-/*
- * waking_non_zero_try_lock:
- *	1	failed to lock
- *	0	got the lock
- *
- * We must undo the sem->count down_interruptible() increment while we are
- * protected by the spinlock in order to make this atomic_inc() with the
- * atomic_read() in wake_one_more(), otherwise we can race. -arca
- */
-static inline int waking_non_zero_trylock(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->waking <= 0)
-		atomic_inc(&sem->count);
-	else {
-		sem->waking--;
-		ret = 0;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-#endif
diff --git a/include/asm-arm/semaphore.h b/include/asm-arm/semaphore.h
index 1c8b441..d9b2034 100644
--- a/include/asm-arm/semaphore.h
+++ b/include/asm-arm/semaphore.h
@@ -1,98 +1 @@
-/*
- * linux/include/asm-arm/semaphore.h
- */
-#ifndef __ASM_ARM_SEMAPHORE_H
-#define __ASM_ARM_SEMAPHORE_H
-
-#include <linux/linkage.h>
-#include <linux/spinlock.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-#include <asm/atomic.h>
-#include <asm/locks.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INIT(name, cnt)				\
-{								\
-	.count	= ATOMIC_INIT(cnt),				\
-	.wait	= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait),	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count)	\
-	struct semaphore name = __SEMAPHORE_INIT(name,count)
-
-#define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX(struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED(struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-/*
- * special register calling convention
- */
-asmlinkage void __down_failed(void);
-asmlinkage int  __down_interruptible_failed(void);
-asmlinkage int  __down_trylock_failed(void);
-asmlinkage void __up_wakeup(void);
-
-extern void __down(struct semaphore * sem);
-extern int  __down_interruptible(struct semaphore * sem);
-extern int  __down_trylock(struct semaphore * sem);
-extern void __up(struct semaphore * sem);
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "__down" is the actual routine that waits...
- */
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-	__down_op(sem, __down_failed);
-}
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "__down_interruptible" is the actual routine that waits...
- */
-static inline int down_interruptible (struct semaphore * sem)
-{
-	might_sleep();
-	return __down_op_ret(sem, __down_interruptible_failed);
-}
-
-static inline int down_trylock(struct semaphore *sem)
-{
-	return __down_op_ret(sem, __down_trylock_failed);
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore * sem)
-{
-	__up_op(sem, __up_wakeup);
-}
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-avr32/semaphore.h b/include/asm-avr32/semaphore.h
index feaf1d4..d9b2034 100644
--- a/include/asm-avr32/semaphore.h
+++ b/include/asm-avr32/semaphore.h
@@ -1,108 +1 @@
-/*
- * SMP- and interrupt-safe semaphores.
- *
- * Copyright (C) 2006 Atmel Corporation
- *
- * Based on include/asm-i386/semaphore.h
- *   Copyright (C) 1996 Linus Torvalds
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ASM_AVR32_SEMAPHORE_H
-#define __ASM_AVR32_SEMAPHORE_H
-
-#include <linux/linkage.h>
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-void __down(struct semaphore * sem);
-int  __down_interruptible(struct semaphore * sem);
-void __up(struct semaphore * sem);
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "__down_failed" is a special asm handler that calls the C
- * routine that actually waits. See arch/i386/kernel/semaphore.c
- */
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-	if (unlikely(atomic_dec_return (&sem->count) < 0))
-		__down (sem);
-}
-
-/*
- * Interruptible try to acquire a semaphore.  If we obtained
- * it, return zero.  If we were interrupted, returns -EINTR
- */
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-
-	might_sleep();
-	if (unlikely(atomic_dec_return (&sem->count) < 0))
-		ret = __down_interruptible (sem);
-	return ret;
-}
-
-/*
- * Non-blockingly attempt to down() a semaphore.
- * Returns zero if we acquired it
- */
-static inline int down_trylock(struct semaphore * sem)
-{
-	return atomic_dec_if_positive(&sem->count) < 0;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore * sem)
-{
-	if (unlikely(atomic_inc_return (&sem->count) <= 0))
-		__up (sem);
-}
-
-#endif /*__ASM_AVR32_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/asm-blackfin/semaphore-helper.h b/include/asm-blackfin/semaphore-helper.h
deleted file mode 100644
index 9082b0d..0000000
--- a/include/asm-blackfin/semaphore-helper.h
+++ /dev/null
@@ -1,82 +0,0 @@
-/* Based on M68K version,	Lineo Inc.	May 2001 */
-
-#ifndef _BFIN_SEMAPHORE_HELPER_H
-#define _BFIN_SEMAPHORE_HELPER_H
-
-/*
- * SMP- and interrupt-safe semaphores helper functions.
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- */
-
-#include <asm/errno.h>
-
-/*
- * These two _must_ execute atomically wrt each other.
- */
-static inline void wake_one_more(struct semaphore *sem)
-{
-	atomic_inc(&sem->waking);
-}
-
-static inline int waking_non_zero(struct semaphore *sem)
-{
-	int ret;
-	unsigned long flags = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 0;
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_interruptible:
- *	1	got the lock
- *	0	go to sleep
- *	-EINTR	interrupted
- */
-static inline int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	int ret = 0;
-	unsigned long flags = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_trylock:
- *	1	failed to lock
- *	0	got the lock
- */
-static inline int waking_non_zero_trylock(struct semaphore *sem)
-{
-	int ret = 1;
-	unsigned long flags = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 0;
-	} else
-		atomic_inc(&sem->count);
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-#endif				/* _BFIN_SEMAPHORE_HELPER_H */
diff --git a/include/asm-blackfin/semaphore.h b/include/asm-blackfin/semaphore.h
index 533f90f..d9b2034 100644
--- a/include/asm-blackfin/semaphore.h
+++ b/include/asm-blackfin/semaphore.h
@@ -1,105 +1 @@
-#ifndef _BFIN_SEMAPHORE_H
-#define _BFIN_SEMAPHORE_H
-
-#ifndef __ASSEMBLY__
-
-#include <linux/linkage.h>
-#include <linux/wait.h>
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-#include <asm/atomic.h>
-
-/*
- * Interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * BFIN version by akbar hussain Lineo Inc  April 2001
- *
- */
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER(*sem, val);
-}
-
-static inline void init_MUTEX(struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED(struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down(struct semaphore *sem);
-asmlinkage int __down_interruptible(struct semaphore *sem);
-asmlinkage int __down_trylock(struct semaphore *sem);
-asmlinkage void __up(struct semaphore *sem);
-
-extern spinlock_t semaphore_wake_lock;
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "down_failed" is a special asm handler that calls the C
- * routine that actually waits.
- */
-static inline void down(struct semaphore *sem)
-{
-	might_sleep();
-	if (atomic_dec_return(&sem->count) < 0)
-		__down(sem);
-}
-
-static inline int down_interruptible(struct semaphore *sem)
-{
-	int ret = 0;
-
-	might_sleep();
-	if (atomic_dec_return(&sem->count) < 0)
-		ret = __down_interruptible(sem);
-	return (ret);
-}
-
-static inline int down_trylock(struct semaphore *sem)
-{
-	int ret = 0;
-
-	if (atomic_dec_return(&sem->count) < 0)
-		ret = __down_trylock(sem);
-	return ret;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore *sem)
-{
-	if (atomic_inc_return(&sem->count) <= 0)
-		__up(sem);
-}
-
-#endif				/* __ASSEMBLY__ */
-#endif				/* _BFIN_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/asm-cris/semaphore-helper.h b/include/asm-cris/semaphore-helper.h
deleted file mode 100644
index 27bfeca..0000000
--- a/include/asm-cris/semaphore-helper.h
+++ /dev/null
@@ -1,78 +0,0 @@
-/* $Id: semaphore-helper.h,v 1.3 2001/03/26 15:00:33 orjanf Exp $
- *
- * SMP- and interrupt-safe semaphores helper functions. Generic versions, no
- * optimizations whatsoever... 
- *
- */
-
-#ifndef _ASM_SEMAPHORE_HELPER_H
-#define _ASM_SEMAPHORE_HELPER_H
-
-#include <asm/atomic.h>
-#include <linux/errno.h>
-
-#define read(a) ((a)->counter)
-#define inc(a) (((a)->counter)++)
-#define dec(a) (((a)->counter)--)
-
-#define count_inc(a) ((*(a))++)
-
-/*
- * These two _must_ execute atomically wrt each other.
- */
-static inline void wake_one_more(struct semaphore * sem)
-{
-	atomic_inc(&sem->waking);
-}
-
-static inline int waking_non_zero(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	local_irq_save(flags);
-	if (read(&sem->waking) > 0) {
-		dec(&sem->waking);
-		ret = 1;
-	}
-	local_irq_restore(flags);
-	return ret;
-}
-
-static inline int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	if (read(&sem->waking) > 0) {
-		dec(&sem->waking);
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		inc(&sem->count);
-		ret = -EINTR;
-	}
-	local_irq_restore(flags);
-	return ret;
-}
-
-static inline int waking_non_zero_trylock(struct semaphore *sem)
-{
-        int ret = 1;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	if (read(&sem->waking) <= 0)
-		inc(&sem->count);
-	else {
-		dec(&sem->waking);
-		ret = 0;
-	}
-	local_irq_restore(flags);
-	return ret;
-}
-
-#endif /* _ASM_SEMAPHORE_HELPER_H */
-
-
diff --git a/include/asm-cris/semaphore.h b/include/asm-cris/semaphore.h
index 31a4ac4..d9b2034 100644
--- a/include/asm-cris/semaphore.h
+++ b/include/asm-cris/semaphore.h
@@ -1,133 +1 @@
-/* $Id: semaphore.h,v 1.3 2001/05/08 13:54:09 bjornw Exp $ */
-
-/* On the i386 these are coded in asm, perhaps we should as well. Later.. */
-
-#ifndef _CRIS_SEMAPHORE_H
-#define _CRIS_SEMAPHORE_H
-
-#define RW_LOCK_BIAS             0x01000000
-
-#include <linux/wait.h>
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-
-/*
- * CRIS semaphores, implemented in C-only so far. 
- */
-
-struct semaphore {
-	atomic_t count;
-	atomic_t waking;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.waking		= ATOMIC_INIT(0),				\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)    \
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-        struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-        sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-        sema_init(sem, 0);
-}
-
-extern void __down(struct semaphore * sem);
-extern int __down_interruptible(struct semaphore * sem);
-extern int __down_trylock(struct semaphore * sem);
-extern void __up(struct semaphore * sem);
-
-/* notice - we probably can do cli/sti here instead of saving */
-
-static inline void down(struct semaphore * sem)
-{
-	unsigned long flags;
-	int failed;
-
-	might_sleep();
-
-	/* atomically decrement the semaphores count, and if its negative, we wait */
-	cris_atomic_save(sem, flags);
-	failed = --(sem->count.counter) < 0;
-	cris_atomic_restore(sem, flags);
-	if(failed) {
-		__down(sem);
-	}
-}
-
-/*
- * This version waits in interruptible state so that the waiting
- * process can be killed.  The down_interruptible routine
- * returns negative for signalled and zero for semaphore acquired.
- */
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	unsigned long flags;
-	int failed;
-
-	might_sleep();
-
-	/* atomically decrement the semaphores count, and if its negative, we wait */
-	cris_atomic_save(sem, flags);
-	failed = --(sem->count.counter) < 0;
-	cris_atomic_restore(sem, flags);
-	if(failed)
-		failed = __down_interruptible(sem);
-	return(failed);
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	unsigned long flags;
-	int failed;
-
-	cris_atomic_save(sem, flags);
-	failed = --(sem->count.counter) < 0;
-	cris_atomic_restore(sem, flags);
-	if(failed)
-		failed = __down_trylock(sem);
-	return(failed);
-
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore * sem)
-{  
-	unsigned long flags;
-	int wakeup;
-
-	/* atomically increment the semaphores count, and if it was negative, we wake people */
-	cris_atomic_save(sem, flags);
-	wakeup = ++(sem->count.counter) <= 0;
-	cris_atomic_restore(sem, flags);
-	if(wakeup) {
-		__up(sem);
-	}
-}
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-frv/semaphore.h b/include/asm-frv/semaphore.h
index d7aaa19..d9b2034 100644
--- a/include/asm-frv/semaphore.h
+++ b/include/asm-frv/semaphore.h
@@ -1,155 +1 @@
-/* semaphore.h: semaphores for the FR-V
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_SEMAPHORE_H
-#define _ASM_SEMAPHORE_H
-
-#define RW_LOCK_BIAS		 0x01000000
-
-#ifndef __ASSEMBLY__
-
-#include <linux/linkage.h>
-#include <linux/wait.h>
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-
-/*
- * the semaphore definition
- * - if counter is >0 then there are tokens available on the semaphore for down to collect
- * - if counter is <=0 then there are no spare tokens, and anyone that wants one must wait
- * - if wait_list is not empty, then there are processes waiting for the semaphore
- */
-struct semaphore {
-	unsigned		counter;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	unsigned		__magic;
-#endif
-};
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-# define __SEM_DEBUG_INIT(name) , (long)&(name).__magic
-#else
-# define __SEM_DEBUG_INIT(name)
-#endif
-
-
-#define __SEMAPHORE_INITIALIZER(name,count) \
-{ count, SPIN_LOCK_UNLOCKED, LIST_HEAD_INIT((name).wait_list) __SEM_DEBUG_INIT(name) }
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore) __SEMAPHORE_INITIALIZER(*sem, val);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern void __down(struct semaphore *sem, unsigned long flags);
-extern int  __down_interruptible(struct semaphore *sem, unsigned long flags);
-extern void __up(struct semaphore *sem);
-
-static inline void down(struct semaphore *sem)
-{
-	unsigned long flags;
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	if (likely(sem->counter > 0)) {
-		sem->counter--;
-		spin_unlock_irqrestore(&sem->wait_lock, flags);
-	}
-	else {
-		__down(sem, flags);
-	}
-}
-
-static inline int down_interruptible(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 0;
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	if (likely(sem->counter > 0)) {
-		sem->counter--;
-		spin_unlock_irqrestore(&sem->wait_lock, flags);
-	}
-	else {
-		ret = __down_interruptible(sem, flags);
-	}
-	return ret;
-}
-
-/*
- * non-blockingly attempt to down() a semaphore.
- * - returns zero if we acquired it
- */
-static inline int down_trylock(struct semaphore *sem)
-{
-	unsigned long flags;
-	int success = 0;
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	if (sem->counter > 0) {
-		sem->counter--;
-		success = 1;
-	}
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-	return !success;
-}
-
-static inline void up(struct semaphore *sem)
-{
-	unsigned long flags;
-
-#ifdef CONFIG_DEBUG_SEMAPHORE
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	if (!list_empty(&sem->wait_list))
-		__up(sem);
-	else
-		sem->counter++;
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-}
-
-static inline int sem_getcount(struct semaphore *sem)
-{
-	return sem->counter;
-}
-
-#endif /* __ASSEMBLY__ */
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-h8300/semaphore-helper.h b/include/asm-h8300/semaphore-helper.h
deleted file mode 100644
index 4fea36b..0000000
--- a/include/asm-h8300/semaphore-helper.h
+++ /dev/null
@@ -1,85 +0,0 @@
-#ifndef _H8300_SEMAPHORE_HELPER_H
-#define _H8300_SEMAPHORE_HELPER_H
-
-/*
- * SMP- and interrupt-safe semaphores helper functions.
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * based on
- * m68k version by Andreas Schwab
- */
-
-#include <linux/errno.h>
-
-/*
- * These two _must_ execute atomically wrt each other.
- */
-static inline void wake_one_more(struct semaphore * sem)
-{
-	atomic_inc((atomic_t *)&sem->sleepers);
-}
-
-static inline int waking_non_zero(struct semaphore *sem)
-{
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 0;
-	if (sem->sleepers > 0) {
-		sem->sleepers--;
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_interruptible:
- *	1	got the lock
- *	0	go to sleep
- *	-EINTR	interrupted
- */
-static inline int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 0;
-	if (sem->sleepers > 0) {
-		sem->sleepers--;
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_trylock:
- *	1	failed to lock
- *	0	got the lock
- */
-static inline int waking_non_zero_trylock(struct semaphore *sem)
-{
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 1;
-	if (sem->sleepers <= 0)
-		atomic_inc(&sem->count);
-	else {
-		sem->sleepers--;
-		ret = 0;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-#endif
diff --git a/include/asm-h8300/semaphore.h b/include/asm-h8300/semaphore.h
index f3ffff8..d9b2034 100644
--- a/include/asm-h8300/semaphore.h
+++ b/include/asm-h8300/semaphore.h
@@ -1,190 +1 @@
-#ifndef _H8300_SEMAPHORE_H
-#define _H8300_SEMAPHORE_H
-
-#define RW_LOCK_BIAS		 0x01000000
-
-#ifndef __ASSEMBLY__
-
-#include <linux/linkage.h>
-#include <linux/wait.h>
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-
-/*
- * Interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * H8/300 version by Yoshinori Sato
- */
-
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER(*sem, val);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down_failed(void /* special register calling convention */);
-asmlinkage int  __down_failed_interruptible(void  /* params in registers */);
-asmlinkage int  __down_failed_trylock(void  /* params in registers */);
-asmlinkage void __up_wakeup(void /* special register calling convention */);
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-extern spinlock_t semaphore_wake_lock;
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "down_failed" is a special asm handler that calls the C
- * routine that actually waits. See arch/m68k/lib/semaphore.S
- */
-static inline void down(struct semaphore * sem)
-{
-	register atomic_t *count asm("er0");
-
-	might_sleep();
-
-	count = &(sem->count);
-	__asm__ __volatile__(
-		"stc ccr,r3l\n\t"
-		"orc #0x80,ccr\n\t"
-		"mov.l %2, er1\n\t"
-		"dec.l #1,er1\n\t"
-		"mov.l er1,%0\n\t"
-		"bpl 1f\n\t"
-		"ldc r3l,ccr\n\t"
-		"mov.l %1,er0\n\t"
-		"jsr @___down\n\t"
-		"bra 2f\n"
-		"1:\n\t"
-		"ldc r3l,ccr\n"
-		"2:"
-		: "=m"(*count)
-		: "g"(sem),"m"(*count)
-		: "cc",  "er1", "er2", "er3");
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	register atomic_t *count asm("er0");
-
-	might_sleep();
-
-	count = &(sem->count);
-	__asm__ __volatile__(
-		"stc ccr,r1l\n\t"
-		"orc #0x80,ccr\n\t"
-		"mov.l %3, er2\n\t"
-		"dec.l #1,er2\n\t"
-		"mov.l er2,%1\n\t"
-		"bpl 1f\n\t"
-		"ldc r1l,ccr\n\t"
-		"mov.l %2,er0\n\t"
-		"jsr @___down_interruptible\n\t"
-		"bra 2f\n"
-		"1:\n\t"
-		"ldc r1l,ccr\n\t"
-		"sub.l %0,%0\n\t"
-		"2:\n\t"
-		: "=r" (count),"=m" (*count)
-		: "g"(sem),"m"(*count)
-		: "cc", "er1", "er2", "er3");
-	return (int)count;
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	register atomic_t *count asm("er0");
-
-	count = &(sem->count);
-	__asm__ __volatile__(
-		"stc ccr,r3l\n\t"
-		"orc #0x80,ccr\n\t"
-		"mov.l %3,er2\n\t"
-		"dec.l #1,er2\n\t"
-		"mov.l er2,%0\n\t"
-		"bpl 1f\n\t"
-		"ldc r3l,ccr\n\t"
-		"jmp @3f\n\t"
-		LOCK_SECTION_START(".align 2\n\t")
-		"3:\n\t"
-		"mov.l %2,er0\n\t"
-		"jsr @___down_trylock\n\t"
-		"jmp @2f\n\t"
-		LOCK_SECTION_END
-		"1:\n\t"
-		"ldc r3l,ccr\n\t"
-		"sub.l %1,%1\n"
-		"2:"
-		: "=m" (*count),"=r"(count)
-		: "g"(sem),"m"(*count)
-		: "cc", "er1","er2", "er3");
-	return (int)count;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore * sem)
-{
-	register atomic_t *count asm("er0");
-
-	count = &(sem->count);
-	__asm__ __volatile__(
-		"stc ccr,r3l\n\t"
-		"orc #0x80,ccr\n\t"
-		"mov.l %2,er1\n\t"
-		"inc.l #1,er1\n\t"
-		"mov.l er1,%0\n\t"
-		"ldc r3l,ccr\n\t"
-		"sub.l er2,er2\n\t"
-		"cmp.l er2,er1\n\t"
-		"bgt 1f\n\t"
-		"mov.l %1,er0\n\t"
-		"jsr @___up\n"
-		"1:"
-		: "=m"(*count)
-		: "g"(sem),"m"(*count)
-		: "cc", "er1", "er2", "er3");
-}
-
-#endif /* __ASSEMBLY__ */
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-ia64/semaphore.h b/include/asm-ia64/semaphore.h
index d8393d1..d9b2034 100644
--- a/include/asm-ia64/semaphore.h
+++ b/include/asm-ia64/semaphore.h
@@ -1,99 +1 @@
-#ifndef _ASM_IA64_SEMAPHORE_H
-#define _ASM_IA64_SEMAPHORE_H
-
-/*
- * Copyright (C) 1998-2000 Hewlett-Packard Co
- * Copyright (C) 1998-2000 David Mosberger-Tang <davidm@hpl.hp.com>
- */
-
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-#include <asm/atomic.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count)					\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
-
-#define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-
-static inline void
-sema_init (struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore) __SEMAPHORE_INITIALIZER(*sem, val);
-}
-
-static inline void
-init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void
-init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern void __down (struct semaphore * sem);
-extern int  __down_interruptible (struct semaphore * sem);
-extern int  __down_trylock (struct semaphore * sem);
-extern void __up (struct semaphore * sem);
-
-/*
- * Atomically decrement the semaphore's count.  If it goes negative,
- * block the calling thread in the TASK_UNINTERRUPTIBLE state.
- */
-static inline void
-down (struct semaphore *sem)
-{
-	might_sleep();
-	if (ia64_fetchadd(-1, &sem->count.counter, acq) < 1)
-		__down(sem);
-}
-
-/*
- * Atomically decrement the semaphore's count.  If it goes negative,
- * block the calling thread in the TASK_INTERRUPTIBLE state.
- */
-static inline int
-down_interruptible (struct semaphore * sem)
-{
-	int ret = 0;
-
-	might_sleep();
-	if (ia64_fetchadd(-1, &sem->count.counter, acq) < 1)
-		ret = __down_interruptible(sem);
-	return ret;
-}
-
-static inline int
-down_trylock (struct semaphore *sem)
-{
-	int ret = 0;
-
-	if (ia64_fetchadd(-1, &sem->count.counter, acq) < 1)
-		ret = __down_trylock(sem);
-	return ret;
-}
-
-static inline void
-up (struct semaphore * sem)
-{
-	if (ia64_fetchadd(1, &sem->count.counter, rel) <= -1)
-		__up(sem);
-}
-
-#endif /* _ASM_IA64_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/asm-m32r/semaphore.h b/include/asm-m32r/semaphore.h
index b5bf95a..d9b2034 100644
--- a/include/asm-m32r/semaphore.h
+++ b/include/asm-m32r/semaphore.h
@@ -1,144 +1 @@
-#ifndef _ASM_M32R_SEMAPHORE_H
-#define _ASM_M32R_SEMAPHORE_H
-
-#include <linux/linkage.h>
-
-#ifdef __KERNEL__
-
-/*
- * SMP- and interrupt-safe semaphores..
- *
- * Copyright (C) 1996  Linus Torvalds
- * Copyright (C) 2004, 2006  Hirokazu Takata <takata at linux-m32r.org>
- */
-
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-#include <asm/assembler.h>
-#include <asm/system.h>
-#include <asm/atomic.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-/*
- *	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
- *
- * i'd rather use the more flexible initialization above, but sadly
- * GCC 2.7.2.3 emits a bogus warning. EGCS doesnt. Oh well.
- */
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down_failed(void /* special register calling convention */);
-asmlinkage int  __down_failed_interruptible(void  /* params in registers */);
-asmlinkage int  __down_failed_trylock(void  /* params in registers */);
-asmlinkage void __up_wakeup(void /* special register calling convention */);
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-/*
- * Atomically decrement the semaphore's count.  If it goes negative,
- * block the calling thread in the TASK_UNINTERRUPTIBLE state.
- */
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-	if (unlikely(atomic_dec_return(&sem->count) < 0))
-		__down(sem);
-}
-
-/*
- * Interruptible try to acquire a semaphore.  If we obtained
- * it, return zero.  If we were interrupted, returns -EINTR
- */
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int result = 0;
-
-	might_sleep();
-	if (unlikely(atomic_dec_return(&sem->count) < 0))
-		result = __down_interruptible(sem);
-
-	return result;
-}
-
-/*
- * Non-blockingly attempt to down() a semaphore.
- * Returns zero if we acquired it
- */
-static inline int down_trylock(struct semaphore * sem)
-{
-	unsigned long flags;
-	long count;
-	int result = 0;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-		"# down_trylock			\n\t"
-		DCACHE_CLEAR("%0", "r4", "%1")
-		M32R_LOCK" %0, @%1;		\n\t"
-		"addi	%0, #-1;		\n\t"
-		M32R_UNLOCK" %0, @%1;		\n\t"
-		: "=&r" (count)
-		: "r" (&sem->count)
-		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
-	);
-	local_irq_restore(flags);
-
-	if (unlikely(count < 0))
-		result = __down_trylock(sem);
-
-	return result;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore * sem)
-{
-	if (unlikely(atomic_inc_return(&sem->count) <= 0))
-		__up(sem);
-}
-
-#endif  /* __KERNEL__ */
-
-#endif  /* _ASM_M32R_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/asm-m68k/semaphore-helper.h b/include/asm-m68k/semaphore-helper.h
deleted file mode 100644
index eef30ba..0000000
--- a/include/asm-m68k/semaphore-helper.h
+++ /dev/null
@@ -1,142 +0,0 @@
-#ifndef _M68K_SEMAPHORE_HELPER_H
-#define _M68K_SEMAPHORE_HELPER_H
-
-/*
- * SMP- and interrupt-safe semaphores helper functions.
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * m68k version by Andreas Schwab
- */
-
-#include <linux/errno.h>
-
-/*
- * These two _must_ execute atomically wrt each other.
- */
-static inline void wake_one_more(struct semaphore * sem)
-{
-	atomic_inc(&sem->waking);
-}
-
-#ifndef CONFIG_RMW_INSNS
-extern spinlock_t semaphore_wake_lock;
-#endif
-
-static inline int waking_non_zero(struct semaphore *sem)
-{
-	int ret;
-#ifndef CONFIG_RMW_INSNS
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 0;
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-#else
-	int tmp1, tmp2;
-
-	__asm__ __volatile__
-	  ("1:	movel	%1,%2\n"
-	   "    jle	2f\n"
-	   "	subql	#1,%2\n"
-	   "	casl	%1,%2,%3\n"
-	   "	jne	1b\n"
-	   "	moveq	#1,%0\n"
-	   "2:"
-	   : "=d" (ret), "=d" (tmp1), "=d" (tmp2)
-	   : "m" (sem->waking), "0" (0), "1" (sem->waking));
-#endif
-
-	return ret;
-}
-
-/*
- * waking_non_zero_interruptible:
- *	1	got the lock
- *	0	go to sleep
- *	-EINTR	interrupted
- */
-static inline int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	int ret;
-#ifndef CONFIG_RMW_INSNS
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 0;
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-#else
-	int tmp1, tmp2;
-
-	__asm__ __volatile__
-	  ("1:	movel	%1,%2\n"
-	   "	jle	2f\n"
-	   "	subql	#1,%2\n"
-	   "	casl	%1,%2,%3\n"
-	   "	jne	1b\n"
-	   "	moveq	#1,%0\n"
-	   "	jra	%a4\n"
-	   "2:"
-	   : "=d" (ret), "=d" (tmp1), "=d" (tmp2)
-	   : "m" (sem->waking), "i" (&&next), "0" (0), "1" (sem->waking));
-	if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-next:
-#endif
-
-	return ret;
-}
-
-/*
- * waking_non_zero_trylock:
- *	1	failed to lock
- *	0	got the lock
- */
-static inline int waking_non_zero_trylock(struct semaphore *sem)
-{
-	int ret;
-#ifndef CONFIG_RMW_INSNS
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 1;
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 0;
-	} else
-		atomic_inc(&sem->count);
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-#else
-	int tmp1, tmp2;
-
-	__asm__ __volatile__
-	  ("1:	movel	%1,%2\n"
-	   "    jle	2f\n"
-	   "	subql	#1,%2\n"
-	   "	casl	%1,%2,%3\n"
-	   "	jne	1b\n"
-	   "	moveq	#0,%0\n"
-	   "2:"
-	   : "=d" (ret), "=d" (tmp1), "=d" (tmp2)
-	   : "m" (sem->waking), "0" (1), "1" (sem->waking));
-	if (ret)
-		atomic_inc(&sem->count);
-#endif
-	return ret;
-}
-
-#endif
diff --git a/include/asm-m68k/semaphore.h b/include/asm-m68k/semaphore.h
index 64d6b11..d9b2034 100644
--- a/include/asm-m68k/semaphore.h
+++ b/include/asm-m68k/semaphore.h
@@ -1,163 +1 @@
-#ifndef _M68K_SEMAPHORE_H
-#define _M68K_SEMAPHORE_H
-
-#define RW_LOCK_BIAS		 0x01000000
-
-#ifndef __ASSEMBLY__
-
-#include <linux/linkage.h>
-#include <linux/wait.h>
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-#include <linux/stringify.h>
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-
-/*
- * Interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * m68k version by Andreas Schwab
- */
-
-
-struct semaphore {
-	atomic_t count;
-	atomic_t waking;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.waking		= ATOMIC_INIT(0),				\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER(*sem, val);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down_failed(void /* special register calling convention */);
-asmlinkage int  __down_failed_interruptible(void  /* params in registers */);
-asmlinkage int  __down_failed_trylock(void  /* params in registers */);
-asmlinkage void __up_wakeup(void /* special register calling convention */);
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "down_failed" is a special asm handler that calls the C
- * routine that actually waits. See arch/m68k/lib/semaphore.S
- */
-static inline void down(struct semaphore *sem)
-{
-	register struct semaphore *sem1 __asm__ ("%a1") = sem;
-
-	might_sleep();
-	__asm__ __volatile__(
-		"| atomic down operation\n\t"
-		"subql #1,%0@\n\t"
-		"jmi 2f\n\t"
-		"1:\n"
-		LOCK_SECTION_START(".even\n\t")
-		"2:\tpea 1b\n\t"
-		"jbra __down_failed\n"
-		LOCK_SECTION_END
-		: /* no outputs */
-		: "a" (sem1)
-		: "memory");
-}
-
-static inline int down_interruptible(struct semaphore *sem)
-{
-	register struct semaphore *sem1 __asm__ ("%a1") = sem;
-	register int result __asm__ ("%d0");
-
-	might_sleep();
-	__asm__ __volatile__(
-		"| atomic interruptible down operation\n\t"
-		"subql #1,%1@\n\t"
-		"jmi 2f\n\t"
-		"clrl %0\n"
-		"1:\n"
-		LOCK_SECTION_START(".even\n\t")
-		"2:\tpea 1b\n\t"
-		"jbra __down_failed_interruptible\n"
-		LOCK_SECTION_END
-		: "=d" (result)
-		: "a" (sem1)
-		: "memory");
-	return result;
-}
-
-static inline int down_trylock(struct semaphore *sem)
-{
-	register struct semaphore *sem1 __asm__ ("%a1") = sem;
-	register int result __asm__ ("%d0");
-
-	__asm__ __volatile__(
-		"| atomic down trylock operation\n\t"
-		"subql #1,%1@\n\t"
-		"jmi 2f\n\t"
-		"clrl %0\n"
-		"1:\n"
-		LOCK_SECTION_START(".even\n\t")
-		"2:\tpea 1b\n\t"
-		"jbra __down_failed_trylock\n"
-		LOCK_SECTION_END
-		: "=d" (result)
-		: "a" (sem1)
-		: "memory");
-	return result;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore *sem)
-{
-	register struct semaphore *sem1 __asm__ ("%a1") = sem;
-
-	__asm__ __volatile__(
-		"| atomic up operation\n\t"
-		"addql #1,%0@\n\t"
-		"jle 2f\n"
-		"1:\n"
-		LOCK_SECTION_START(".even\n\t")
-		"2:\t"
-		"pea 1b\n\t"
-		"jbra __up_wakeup\n"
-		LOCK_SECTION_END
-		: /* no outputs */
-		: "a" (sem1)
-		: "memory");
-}
-
-#endif /* __ASSEMBLY__ */
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-m68knommu/semaphore-helper.h b/include/asm-m68knommu/semaphore-helper.h
deleted file mode 100644
index 43da7bc..0000000
--- a/include/asm-m68knommu/semaphore-helper.h
+++ /dev/null
@@ -1,82 +0,0 @@
-#ifndef _M68K_SEMAPHORE_HELPER_H
-#define _M68K_SEMAPHORE_HELPER_H
-
-/*
- * SMP- and interrupt-safe semaphores helper functions.
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * m68k version by Andreas Schwab
- */
-
-
-/*
- * These two _must_ execute atomically wrt each other.
- */
-static inline void wake_one_more(struct semaphore * sem)
-{
-	atomic_inc(&sem->waking);
-}
-
-static inline int waking_non_zero(struct semaphore *sem)
-{
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 0;
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_interruptible:
- *	1	got the lock
- *	0	go to sleep
- *	-EINTR	interrupted
- */
-static inline int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 0;
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_trylock:
- *	1	failed to lock
- *	0	got the lock
- */
-static inline int waking_non_zero_trylock(struct semaphore *sem)
-{
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	ret = 1;
-	if (atomic_read(&sem->waking) > 0) {
-		atomic_dec(&sem->waking);
-		ret = 0;
-	} else
-		atomic_inc(&sem->count);
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-#endif
diff --git a/include/asm-m68knommu/semaphore.h b/include/asm-m68knommu/semaphore.h
index 5779eb6..d9b2034 100644
--- a/include/asm-m68knommu/semaphore.h
+++ b/include/asm-m68knommu/semaphore.h
@@ -1,153 +1 @@
-#ifndef _M68K_SEMAPHORE_H
-#define _M68K_SEMAPHORE_H
-
-#define RW_LOCK_BIAS		 0x01000000
-
-#ifndef __ASSEMBLY__
-
-#include <linux/linkage.h>
-#include <linux/wait.h>
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-
-/*
- * Interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * m68k version by Andreas Schwab
- */
-
-
-struct semaphore {
-	atomic_t count;
-	atomic_t waking;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.waking		= ATOMIC_INIT(0),				\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER(*sem, val);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down_failed(void /* special register calling convention */);
-asmlinkage int  __down_failed_interruptible(void  /* params in registers */);
-asmlinkage int  __down_failed_trylock(void  /* params in registers */);
-asmlinkage void __up_wakeup(void /* special register calling convention */);
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-extern spinlock_t semaphore_wake_lock;
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "down_failed" is a special asm handler that calls the C
- * routine that actually waits. See arch/m68k/lib/semaphore.S
- */
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-	__asm__ __volatile__(
-		"| atomic down operation\n\t"
-		"movel	%0, %%a1\n\t"
-		"lea	%%pc@(1f), %%a0\n\t"
-		"subql	#1, %%a1@\n\t"
-		"jmi __down_failed\n"
-		"1:"
-		: /* no outputs */
-		: "g" (sem)
-		: "cc", "%a0", "%a1", "memory");
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int ret;
-
-	might_sleep();
-	__asm__ __volatile__(
-		"| atomic down operation\n\t"
-		"movel	%1, %%a1\n\t"
-		"lea	%%pc@(1f), %%a0\n\t"
-		"subql	#1, %%a1@\n\t"
-		"jmi __down_failed_interruptible\n\t"
-		"clrl	%%d0\n"
-		"1: movel	%%d0, %0\n"
-		: "=d" (ret)
-		: "g" (sem)
-		: "cc", "%d0", "%a0", "%a1", "memory");
-	return(ret);
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	register struct semaphore *sem1 __asm__ ("%a1") = sem;
-	register int result __asm__ ("%d0");
-
-	__asm__ __volatile__(
-		"| atomic down trylock operation\n\t"
-		"subql #1,%1@\n\t"
-		"jmi 2f\n\t"
-		"clrl %0\n"
-		"1:\n"
-		".section .text.lock,\"ax\"\n"
-		".even\n"
-		"2:\tpea 1b\n\t"
-		"jbra __down_failed_trylock\n"
-		".previous"
-		: "=d" (result)
-		: "a" (sem1)
-		: "memory");
-	return result;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore * sem)
-{
-	__asm__ __volatile__(
-		"| atomic up operation\n\t"
-		"movel	%0, %%a1\n\t"
-		"lea	%%pc@(1f), %%a0\n\t"
-		"addql	#1, %%a1@\n\t"
-		"jle __up_wakeup\n"
-		"1:"
-		: /* no outputs */
-		: "g" (sem)
-		: "cc", "%a0", "%a1", "memory");
-}
-
-#endif /* __ASSEMBLY__ */
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-mips/semaphore.h b/include/asm-mips/semaphore.h
index fdf8042..d9b2034 100644
--- a/include/asm-mips/semaphore.h
+++ b/include/asm-mips/semaphore.h
@@ -1,108 +1 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1996  Linus Torvalds
- * Copyright (C) 1998, 99, 2000, 01, 04  Ralf Baechle
- * Copyright (C) 1999, 2000, 01  Silicon Graphics, Inc.
- * Copyright (C) 2000, 01 MIPS Technologies, Inc.
- *
- * In all honesty, little of the old MIPS code left - the PPC64 variant was
- * just looking nice and portable so I ripped it.  Credits to whoever wrote
- * it.
- */
-#ifndef __ASM_SEMAPHORE_H
-#define __ASM_SEMAPHORE_H
-
-/*
- * Remove spinlock-based RW semaphores; RW semaphore definitions are
- * now in rwsem.h and we use the generic lib/rwsem.c implementation.
- * Rework semaphores to use atomic_dec_if_positive.
- * -- Paul Mackerras (paulus@samba.org)
- */
-
-#ifdef __KERNEL__
-
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	/*
-	 * Note that any negative value of count is equivalent to 0,
-	 * but additionally indicates that some process(es) might be
-	 * sleeping on `wait'.
-	 */
-	atomic_t count;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name, count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
-
-#define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-	atomic_set(&sem->count, val);
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX(struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED(struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern void __down(struct semaphore * sem);
-extern int  __down_interruptible(struct semaphore * sem);
-extern void __up(struct semaphore * sem);
-
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-
-	/*
-	 * Try to get the semaphore, take the slow path if we fail.
-	 */
-	if (unlikely(atomic_dec_return(&sem->count) < 0))
-		__down(sem);
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-
-	might_sleep();
-
-	if (unlikely(atomic_dec_return(&sem->count) < 0))
-		ret = __down_interruptible(sem);
-	return ret;
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	return atomic_dec_if_positive(&sem->count) < 0;
-}
-
-static inline void up(struct semaphore * sem)
-{
-	if (unlikely(atomic_inc_return(&sem->count) <= 0))
-		__up(sem);
-}
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASM_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/asm-mn10300/semaphore.h b/include/asm-mn10300/semaphore.h
index 5a9e1ad..d9b2034 100644
--- a/include/asm-mn10300/semaphore.h
+++ b/include/asm-mn10300/semaphore.h
@@ -1,169 +1 @@
-/* MN10300 Semaphores
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_SEMAPHORE_H
-#define _ASM_SEMAPHORE_H
-
-#ifndef __ASSEMBLY__
-
-#include <linux/linkage.h>
-#include <linux/wait.h>
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-
-#define SEMAPHORE_DEBUG		0
-
-/*
- * the semaphore definition
- * - if count is >0 then there are tokens available on the semaphore for down
- *   to collect
- * - if count is <=0 then there are no spare tokens, and anyone that wants one
- *   must wait
- * - if wait_list is not empty, then there are processes waiting for the
- *   semaphore
- */
-struct semaphore {
-	atomic_t		count;		/* it's not really atomic, it's
-						 * just that certain modules
-						 * expect to be able to access
-						 * it directly */
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#if SEMAPHORE_DEBUG
-	unsigned		__magic;
-#endif
-};
-
-#if SEMAPHORE_DEBUG
-# define __SEM_DEBUG_INIT(name) , (long)&(name).__magic
-#else
-# define __SEM_DEBUG_INIT(name)
-#endif
-
-
-#define __SEMAPHORE_INITIALIZER(name, init_count)			\
-{									\
-	.count		= ATOMIC_INIT(init_count),			\
-	.wait_lock	= __SPIN_LOCK_UNLOCKED((name).wait_lock),	\
-	.wait_list	= LIST_HEAD_INIT((name).wait_list)		\
-	__SEM_DEBUG_INIT(name)						\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name, 1)
-#define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name, 0)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore) __SEMAPHORE_INITIALIZER(*sem, val);
-}
-
-static inline void init_MUTEX(struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED(struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern void __down(struct semaphore *sem, unsigned long flags);
-extern int  __down_interruptible(struct semaphore *sem, unsigned long flags);
-extern void __up(struct semaphore *sem);
-
-static inline void down(struct semaphore *sem)
-{
-	unsigned long flags;
-	int count;
-
-#if SEMAPHORE_DEBUG
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	count = atomic_read(&sem->count);
-	if (likely(count > 0)) {
-		atomic_set(&sem->count, count - 1);
-		spin_unlock_irqrestore(&sem->wait_lock, flags);
-	} else {
-		__down(sem, flags);
-	}
-}
-
-static inline int down_interruptible(struct semaphore *sem)
-{
-	unsigned long flags;
-	int count, ret = 0;
-
-#if SEMAPHORE_DEBUG
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	count = atomic_read(&sem->count);
-	if (likely(count > 0)) {
-		atomic_set(&sem->count, count - 1);
-		spin_unlock_irqrestore(&sem->wait_lock, flags);
-	} else {
-		ret = __down_interruptible(sem, flags);
-	}
-	return ret;
-}
-
-/*
- * non-blockingly attempt to down() a semaphore.
- * - returns zero if we acquired it
- */
-static inline int down_trylock(struct semaphore *sem)
-{
-	unsigned long flags;
-	int count, success = 0;
-
-#if SEMAPHORE_DEBUG
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	count = atomic_read(&sem->count);
-	if (likely(count > 0)) {
-		atomic_set(&sem->count, count - 1);
-		success = 1;
-	}
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-	return !success;
-}
-
-static inline void up(struct semaphore *sem)
-{
-	unsigned long flags;
-
-#if SEMAPHORE_DEBUG
-	CHECK_MAGIC(sem->__magic);
-#endif
-
-	spin_lock_irqsave(&sem->wait_lock, flags);
-	if (!list_empty(&sem->wait_list))
-		__up(sem);
-	else
-		atomic_set(&sem->count, atomic_read(&sem->count) + 1);
-	spin_unlock_irqrestore(&sem->wait_lock, flags);
-}
-
-static inline int sem_getcount(struct semaphore *sem)
-{
-	return atomic_read(&sem->count);
-}
-
-#endif /* __ASSEMBLY__ */
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-parisc/semaphore-helper.h b/include/asm-parisc/semaphore-helper.h
deleted file mode 100644
index 387f7c1..0000000
--- a/include/asm-parisc/semaphore-helper.h
+++ /dev/null
@@ -1,89 +0,0 @@
-#ifndef _ASM_PARISC_SEMAPHORE_HELPER_H
-#define _ASM_PARISC_SEMAPHORE_HELPER_H
-
-/*
- * SMP- and interrupt-safe semaphores helper functions.
- *
- * (C) Copyright 1996 Linus Torvalds
- * (C) Copyright 1999 Andrea Arcangeli
- */
-
-/*
- * These two _must_ execute atomically wrt each other.
- *
- * This is trivially done with load_locked/store_cond,
- * which we have.  Let the rest of the losers suck eggs.
- */
-static __inline__ void wake_one_more(struct semaphore * sem)
-{
-	atomic_inc((atomic_t *)&sem->waking);
-}
-
-static __inline__ int waking_non_zero(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->waking > 0) {
-		sem->waking--;
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_interruptible:
- *	1	got the lock
- *	0	go to sleep
- *	-EINTR	interrupted
- *
- * We must undo the sem->count down_interruptible() increment while we are
- * protected by the spinlock in order to make atomic this atomic_inc() with the
- * atomic_read() in wake_one_more(), otherwise we can race. -arca
- */
-static __inline__ int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->waking > 0) {
-		sem->waking--;
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_trylock:
- *	1	failed to lock
- *	0	got the lock
- *
- * We must undo the sem->count down_trylock() increment while we are
- * protected by the spinlock in order to make atomic this atomic_inc() with the
- * atomic_read() in wake_one_more(), otherwise we can race. -arca
- */
-static __inline__ int waking_non_zero_trylock(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->waking <= 0)
-		atomic_inc(&sem->count);
-	else {
-		sem->waking--;
-		ret = 0;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-#endif /* _ASM_PARISC_SEMAPHORE_HELPER_H */
diff --git a/include/asm-parisc/semaphore.h b/include/asm-parisc/semaphore.h
index a16271c..d9b2034 100644
--- a/include/asm-parisc/semaphore.h
+++ b/include/asm-parisc/semaphore.h
@@ -1,145 +1 @@
-/*    SMP- and interrupt-safe semaphores.
- *    PA-RISC version by Matthew Wilcox
- *
- *    Linux/PA-RISC Project (http://www.parisc-linux.org/)
- *    Copyright (C) 1996 Linus Torvalds
- *    Copyright (C) 1999-2001 Matthew Wilcox < willy at debian d0T org >
- *    Copyright (C) 2000 Grant Grundler < grundler a debian org >
- *
- *    This program is free software; you can redistribute it and/or modify
- *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
- *
- *    This program is distributed in the hope that it will be useful,
- *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#ifndef _ASM_PARISC_SEMAPHORE_H
-#define _ASM_PARISC_SEMAPHORE_H
-
-#include <linux/spinlock.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-#include <asm/system.h>
-
-/*
- * The `count' is initialised to the number of people who are allowed to
- * take the lock.  (Normally we want a mutex, so this is `1').  if
- * `count' is positive, the lock can be taken.  if it's 0, no-one is
- * waiting on it.  if it's -1, at least one task is waiting.
- */
-struct semaphore {
-	spinlock_t	sentry;
-	int		count;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.sentry		= SPIN_LOCK_UNLOCKED,				\
-	.count		= n,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-static inline int sem_getcount(struct semaphore *sem)
-{
-	return sem->count;
-}
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-/* Semaphores can be `tried' from irq context.  So we have to disable
- * interrupts while we're messing with the semaphore.  Sorry.
- */
-
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-	spin_lock_irq(&sem->sentry);
-	if (sem->count > 0) {
-		sem->count--;
-	} else {
-		__down(sem);
-	}
-	spin_unlock_irq(&sem->sentry);
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-	might_sleep();
-	spin_lock_irq(&sem->sentry);
-	if (sem->count > 0) {
-		sem->count--;
-	} else {
-		ret = __down_interruptible(sem);
-	}
-	spin_unlock_irq(&sem->sentry);
-	return ret;
-}
-
-/*
- * down_trylock returns 0 on success, 1 if we failed to get the lock.
- * May not sleep, but must preserve irq state
- */
-static inline int down_trylock(struct semaphore * sem)
-{
-	unsigned long flags;
-	int count;
-
-	spin_lock_irqsave(&sem->sentry, flags);
-	count = sem->count - 1;
-	if (count >= 0)
-		sem->count = count;
-	spin_unlock_irqrestore(&sem->sentry, flags);
-	return (count < 0);
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- */
-static inline void up(struct semaphore * sem)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sem->sentry, flags);
-	if (sem->count < 0) {
-		__up(sem);
-	} else {
-		sem->count++;
-	}
-	spin_unlock_irqrestore(&sem->sentry, flags);
-}
-
-#endif /* _ASM_PARISC_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/asm-powerpc/semaphore.h b/include/asm-powerpc/semaphore.h
index 48dd32e..d9b2034 100644
--- a/include/asm-powerpc/semaphore.h
+++ b/include/asm-powerpc/semaphore.h
@@ -1,94 +1 @@
-#ifndef _ASM_POWERPC_SEMAPHORE_H
-#define _ASM_POWERPC_SEMAPHORE_H
-
-/*
- * Remove spinlock-based RW semaphores; RW semaphore definitions are
- * now in rwsem.h and we use the generic lib/rwsem.c implementation.
- * Rework semaphores to use atomic_dec_if_positive.
- * -- Paul Mackerras (paulus@samba.org)
- */
-
-#ifdef __KERNEL__
-
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	/*
-	 * Note that any negative value of count is equivalent to 0,
-	 * but additionally indicates that some process(es) might be
-	 * sleeping on `wait'.
-	 */
-	atomic_t count;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name, count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	atomic_set(&sem->count, val);
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern void __down(struct semaphore * sem);
-extern int  __down_interruptible(struct semaphore * sem);
-extern void __up(struct semaphore * sem);
-
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-
-	/*
-	 * Try to get the semaphore, take the slow path if we fail.
-	 */
-	if (unlikely(atomic_dec_return(&sem->count) < 0))
-		__down(sem);
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-
-	might_sleep();
-
-	if (unlikely(atomic_dec_return(&sem->count) < 0))
-		ret = __down_interruptible(sem);
-	return ret;
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	return atomic_dec_if_positive(&sem->count) < 0;
-}
-
-static inline void up(struct semaphore * sem)
-{
-	if (unlikely(atomic_inc_return(&sem->count) <= 0))
-		__up(sem);
-}
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_POWERPC_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/asm-s390/semaphore.h b/include/asm-s390/semaphore.h
index 0e7001a..d9b2034 100644
--- a/include/asm-s390/semaphore.h
+++ b/include/asm-s390/semaphore.h
@@ -1,107 +1 @@
-/*
- *  include/asm-s390/semaphore.h
- *
- *  S390 version
- *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
- *
- *  Derived from "include/asm-i386/semaphore.h"
- *    (C) Copyright 1996 Linus Torvalds
- */
-
-#ifndef _S390_SEMAPHORE_H
-#define _S390_SEMAPHORE_H
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	/*
-	 * Note that any negative value of count is equivalent to 0,
-	 * but additionally indicates that some process(es) might be
-	 * sleeping on `wait'.
-	 */
-	atomic_t count;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name,count) \
-	{ ATOMIC_INIT(count), __WAIT_QUEUE_HEAD_INITIALIZER((name).wait) }
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	atomic_set(&sem->count, val);
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-	if (atomic_dec_return(&sem->count) < 0)
-		__down(sem);
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-
-	might_sleep();
-	if (atomic_dec_return(&sem->count) < 0)
-		ret = __down_interruptible(sem);
-	return ret;
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	int old_val, new_val;
-
-	/*
-	 * This inline assembly atomically implements the equivalent
-	 * to the following C code:
-	 *   old_val = sem->count.counter;
-	 *   if ((new_val = old_val) > 0)
-	 *       sem->count.counter = --new_val;
-	 * In the ppc code this is called atomic_dec_if_positive.
-	 */
-	asm volatile(
-		"	l	%0,0(%3)\n"
-		"0:	ltr	%1,%0\n"
-		"	jle	1f\n"
-		"	ahi	%1,-1\n"
-		"	cs	%0,%1,0(%3)\n"
-		"	jl	0b\n"
-		"1:"
-		: "=&d" (old_val), "=&d" (new_val), "=m" (sem->count.counter)
-		: "a" (&sem->count.counter), "m" (sem->count.counter)
-		: "cc", "memory");
-	return old_val <= 0;
-}
-
-static inline void up(struct semaphore * sem)
-{
-	if (atomic_inc_return(&sem->count) <= 0)
-		__up(sem);
-}
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-sh/semaphore-helper.h b/include/asm-sh/semaphore-helper.h
deleted file mode 100644
index bd8230c..0000000
--- a/include/asm-sh/semaphore-helper.h
+++ /dev/null
@@ -1,89 +0,0 @@
-#ifndef __ASM_SH_SEMAPHORE_HELPER_H
-#define __ASM_SH_SEMAPHORE_HELPER_H
-
-/*
- * SMP- and interrupt-safe semaphores helper functions.
- *
- * (C) Copyright 1996 Linus Torvalds
- * (C) Copyright 1999 Andrea Arcangeli
- */
-
-/*
- * These two _must_ execute atomically wrt each other.
- *
- * This is trivially done with load_locked/store_cond,
- * which we have.  Let the rest of the losers suck eggs.
- */
-static __inline__ void wake_one_more(struct semaphore * sem)
-{
-	atomic_inc((atomic_t *)&sem->sleepers);
-}
-
-static __inline__ int waking_non_zero(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->sleepers > 0) {
-		sem->sleepers--;
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_interruptible:
- *	1	got the lock
- *	0	go to sleep
- *	-EINTR	interrupted
- *
- * We must undo the sem->count down_interruptible() increment while we are
- * protected by the spinlock in order to make atomic this atomic_inc() with the
- * atomic_read() in wake_one_more(), otherwise we can race. -arca
- */
-static __inline__ int waking_non_zero_interruptible(struct semaphore *sem,
-						struct task_struct *tsk)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->sleepers > 0) {
-		sem->sleepers--;
-		ret = 1;
-	} else if (signal_pending(tsk)) {
-		atomic_inc(&sem->count);
-		ret = -EINTR;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-/*
- * waking_non_zero_trylock:
- *	1	failed to lock
- *	0	got the lock
- *
- * We must undo the sem->count down_trylock() increment while we are
- * protected by the spinlock in order to make atomic this atomic_inc() with the
- * atomic_read() in wake_one_more(), otherwise we can race. -arca
- */
-static __inline__ int waking_non_zero_trylock(struct semaphore *sem)
-{
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&semaphore_wake_lock, flags);
-	if (sem->sleepers <= 0)
-		atomic_inc(&sem->count);
-	else {
-		sem->sleepers--;
-		ret = 0;
-	}
-	spin_unlock_irqrestore(&semaphore_wake_lock, flags);
-	return ret;
-}
-
-#endif /* __ASM_SH_SEMAPHORE_HELPER_H */
diff --git a/include/asm-sh/semaphore.h b/include/asm-sh/semaphore.h
index 9e5a37c..d9b2034 100644
--- a/include/asm-sh/semaphore.h
+++ b/include/asm-sh/semaphore.h
@@ -1,115 +1 @@
-#ifndef __ASM_SH_SEMAPHORE_H
-#define __ASM_SH_SEMAPHORE_H
-
-#include <linux/linkage.h>
-
-#ifdef __KERNEL__
-/*
- * SMP- and interrupt-safe semaphores.
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * SuperH verison by Niibe Yutaka
- *  (Currently no asm implementation but generic C code...)
- */
-
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-#include <linux/wait.h>
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-/*
- *	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
- *
- * i'd rather use the more flexible initialization above, but sadly
- * GCC 2.7.2.3 emits a bogus warning. EGCS doesn't. Oh well.
- */
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-#if 0
-asmlinkage void __down_failed(void /* special register calling convention */);
-asmlinkage int  __down_failed_interruptible(void  /* params in registers */);
-asmlinkage int  __down_failed_trylock(void  /* params in registers */);
-asmlinkage void __up_wakeup(void /* special register calling convention */);
-#endif
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-extern spinlock_t semaphore_wake_lock;
-
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-	if (atomic_dec_return(&sem->count) < 0)
-		__down(sem);
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-
-	might_sleep();
-	if (atomic_dec_return(&sem->count) < 0)
-		ret = __down_interruptible(sem);
-	return ret;
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	int ret = 0;
-
-	if (atomic_dec_return(&sem->count) < 0)
-		ret = __down_trylock(sem);
-	return ret;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- */
-static inline void up(struct semaphore * sem)
-{
-	if (atomic_inc_return(&sem->count) <= 0)
-		__up(sem);
-}
-
-#endif
-#endif /* __ASM_SH_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/asm-sparc/semaphore.h b/include/asm-sparc/semaphore.h
index 8018f9f..d9b2034 100644
--- a/include/asm-sparc/semaphore.h
+++ b/include/asm-sparc/semaphore.h
@@ -1,192 +1 @@
-#ifndef _SPARC_SEMAPHORE_H
-#define _SPARC_SEMAPHORE_H
-
-/* Dinky, good for nothing, just barely irq safe, Sparc semaphores. */
-
-#ifdef __KERNEL__
-
-#include <asm/atomic.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	atomic24_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC24_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	atomic24_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern void __down(struct semaphore * sem);
-extern int __down_interruptible(struct semaphore * sem);
-extern int __down_trylock(struct semaphore * sem);
-extern void __up(struct semaphore * sem);
-
-static inline void down(struct semaphore * sem)
-{
-	register volatile int *ptr asm("g1");
-	register int increment asm("g2");
-
-	might_sleep();
-
-	ptr = &(sem->count.counter);
-	increment = 1;
-
-	__asm__ __volatile__(
-	"mov	%%o7, %%g4\n\t"
-	"call	___atomic24_sub\n\t"
-	" add	%%o7, 8, %%o7\n\t"
-	"tst	%%g2\n\t"
-	"bl	2f\n\t"
-	" nop\n"
-	"1:\n\t"
-	".subsection 2\n"
-	"2:\n\t"
-	"save	%%sp, -64, %%sp\n\t"
-	"mov	%%g1, %%l1\n\t"
-	"mov	%%g5, %%l5\n\t"
-	"call	%3\n\t"
-	" mov	%%g1, %%o0\n\t"
-	"mov	%%l1, %%g1\n\t"
-	"ba	1b\n\t"
-	" restore %%l5, %%g0, %%g5\n\t"
-	".previous\n"
-	: "=&r" (increment)
-	: "0" (increment), "r" (ptr), "i" (__down)
-	: "g3", "g4", "g7", "memory", "cc");
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	register volatile int *ptr asm("g1");
-	register int increment asm("g2");
-
-	might_sleep();
-
-	ptr = &(sem->count.counter);
-	increment = 1;
-
-	__asm__ __volatile__(
-	"mov	%%o7, %%g4\n\t"
-	"call	___atomic24_sub\n\t"
-	" add	%%o7, 8, %%o7\n\t"
-	"tst	%%g2\n\t"
-	"bl	2f\n\t"
-	" clr	%%g2\n"
-	"1:\n\t"
-	".subsection 2\n"
-	"2:\n\t"
-	"save	%%sp, -64, %%sp\n\t"
-	"mov	%%g1, %%l1\n\t"
-	"mov	%%g5, %%l5\n\t"
-	"call	%3\n\t"
-	" mov	%%g1, %%o0\n\t"
-	"mov	%%l1, %%g1\n\t"
-	"mov	%%l5, %%g5\n\t"
-	"ba	1b\n\t"
-	" restore %%o0, %%g0, %%g2\n\t"
-	".previous\n"
-	: "=&r" (increment)
-	: "0" (increment), "r" (ptr), "i" (__down_interruptible)
-	: "g3", "g4", "g7", "memory", "cc");
-
-	return increment;
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	register volatile int *ptr asm("g1");
-	register int increment asm("g2");
-
-	ptr = &(sem->count.counter);
-	increment = 1;
-
-	__asm__ __volatile__(
-	"mov	%%o7, %%g4\n\t"
-	"call	___atomic24_sub\n\t"
-	" add	%%o7, 8, %%o7\n\t"
-	"tst	%%g2\n\t"
-	"bl	2f\n\t"
-	" clr	%%g2\n"
-	"1:\n\t"
-	".subsection 2\n"
-	"2:\n\t"
-	"save	%%sp, -64, %%sp\n\t"
-	"mov	%%g1, %%l1\n\t"
-	"mov	%%g5, %%l5\n\t"
-	"call	%3\n\t"
-	" mov	%%g1, %%o0\n\t"
-	"mov	%%l1, %%g1\n\t"
-	"mov	%%l5, %%g5\n\t"
-	"ba	1b\n\t"
-	" restore %%o0, %%g0, %%g2\n\t"
-	".previous\n"
-	: "=&r" (increment)
-	: "0" (increment), "r" (ptr), "i" (__down_trylock)
-	: "g3", "g4", "g7", "memory", "cc");
-
-	return increment;
-}
-
-static inline void up(struct semaphore * sem)
-{
-	register volatile int *ptr asm("g1");
-	register int increment asm("g2");
-
-	ptr = &(sem->count.counter);
-	increment = 1;
-
-	__asm__ __volatile__(
-	"mov	%%o7, %%g4\n\t"
-	"call	___atomic24_add\n\t"
-	" add	%%o7, 8, %%o7\n\t"
-	"tst	%%g2\n\t"
-	"ble	2f\n\t"
-	" nop\n"
-	"1:\n\t"
-	".subsection 2\n"
-	"2:\n\t"
-	"save	%%sp, -64, %%sp\n\t"
-	"mov	%%g1, %%l1\n\t"
-	"mov	%%g5, %%l5\n\t"
-	"call	%3\n\t"
-	" mov	%%g1, %%o0\n\t"
-	"mov	%%l1, %%g1\n\t"
-	"ba	1b\n\t"
-	" restore %%l5, %%g0, %%g5\n\t"
-	".previous\n"
-	: "=&r" (increment)
-	: "0" (increment), "r" (ptr), "i" (__up)
-	: "g3", "g4", "g7", "memory", "cc");
-}	
-
-#endif /* __KERNEL__ */
-
-#endif /* !(_SPARC_SEMAPHORE_H) */
+#include <linux/semaphore.h>
diff --git a/include/asm-sparc64/semaphore.h b/include/asm-sparc64/semaphore.h
index 7f7c0c4..d9b2034 100644
--- a/include/asm-sparc64/semaphore.h
+++ b/include/asm-sparc64/semaphore.h
@@ -1,53 +1 @@
-#ifndef _SPARC64_SEMAPHORE_H
-#define _SPARC64_SEMAPHORE_H
-
-/* These are actually reasonable on the V9.
- *
- * See asm-ppc/semaphore.h for implementation commentary,
- * only sparc64 specific issues are commented here.
- */
-#ifdef __KERNEL__
-
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	atomic_t count;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, count) \
-	{ ATOMIC_INIT(count), \
-	  __WAIT_QUEUE_HEAD_INITIALIZER((name).wait) }
-
-#define __DECLARE_SEMAPHORE_GENERIC(name, count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC(name, 1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	atomic_set(&sem->count, val);
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern void up(struct semaphore *sem);
-extern void down(struct semaphore *sem);
-extern int down_trylock(struct semaphore *sem);
-extern int down_interruptible(struct semaphore *sem);
-
-#endif /* __KERNEL__ */
-
-#endif /* !(_SPARC64_SEMAPHORE_H) */
+#include <linux/semaphore.h>
diff --git a/include/asm-um/semaphore.h b/include/asm-um/semaphore.h
index ff13c34..d9b2034 100644
--- a/include/asm-um/semaphore.h
+++ b/include/asm-um/semaphore.h
@@ -1,6 +1 @@
-#ifndef __UM_SEMAPHORE_H
-#define __UM_SEMAPHORE_H
-
-#include "asm/arch/semaphore.h"
-
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-v850/semaphore.h b/include/asm-v850/semaphore.h
index 10ed0cc..d9b2034 100644
--- a/include/asm-v850/semaphore.h
+++ b/include/asm-v850/semaphore.h
@@ -1,84 +1 @@
-#ifndef __V850_SEMAPHORE_H__
-#define __V850_SEMAPHORE_H__
-
-#include <linux/linkage.h>
-#include <linux/spinlock.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-#include <asm/atomic.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name,count)				      \
-	{ ATOMIC_INIT (count), 0,					      \
-	  __WAIT_QUEUE_HEAD_INITIALIZER ((name).wait) }
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count)	\
-	struct semaphore name = __SEMAPHORE_INITIALIZER (name,count)
-
-#define DECLARE_MUTEX(name)		__DECLARE_SEMAPHORE_GENERIC (name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init (sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init (sem, 0);
-}
-
-/*
- * special register calling convention
- */
-asmlinkage void __down_failed (void);
-asmlinkage int  __down_interruptible_failed (void);
-asmlinkage int  __down_trylock_failed (void);
-asmlinkage void __up_wakeup (void);
-
-extern void __down (struct semaphore * sem);
-extern int  __down_interruptible (struct semaphore * sem);
-extern int  __down_trylock (struct semaphore * sem);
-extern void __up (struct semaphore * sem);
-
-static inline void down (struct semaphore * sem)
-{
-	might_sleep();
-	if (atomic_dec_return (&sem->count) < 0)
-		__down (sem);
-}
-
-static inline int down_interruptible (struct semaphore * sem)
-{
-	int ret = 0;
-	might_sleep();
-	if (atomic_dec_return (&sem->count) < 0)
-		ret = __down_interruptible (sem);
-	return ret;
-}
-
-static inline int down_trylock (struct semaphore *sem)
-{
-	int ret = 0;
-	if (atomic_dec_return (&sem->count) < 0)
-		ret = __down_trylock (sem);
-	return ret;
-}
-
-static inline void up (struct semaphore * sem)
-{
-	if (atomic_inc_return (&sem->count) <= 0)
-		__up (sem);
-}
-
-#endif /* __V850_SEMAPHORE_H__ */
+#include <linux/semaphore.h>
diff --git a/include/asm-x86/semaphore.h b/include/asm-x86/semaphore.h
index 572c0b6..d9b2034 100644
--- a/include/asm-x86/semaphore.h
+++ b/include/asm-x86/semaphore.h
@@ -1,5 +1 @@
-#ifdef CONFIG_X86_32
-# include "semaphore_32.h"
-#else
-# include "semaphore_64.h"
-#endif
+#include <linux/semaphore.h>
diff --git a/include/asm-x86/semaphore_32.h b/include/asm-x86/semaphore_32.h
deleted file mode 100644
index ac96d38..0000000
--- a/include/asm-x86/semaphore_32.h
+++ /dev/null
@@ -1,175 +0,0 @@
-#ifndef _I386_SEMAPHORE_H
-#define _I386_SEMAPHORE_H
-
-#include <linux/linkage.h>
-
-#ifdef __KERNEL__
-
-/*
- * SMP- and interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * Modified 1996-12-23 by Dave Grothe <dave@gcom.com> to fix bugs in
- *                     the original code and to make semaphore waits
- *                     interruptible so that processes waiting on
- *                     semaphores can be killed.
- * Modified 1999-02-14 by Andrea Arcangeli, split the sched.c helper
- *		       functions in asm/sempahore-helper.h while fixing a
- *		       potential and subtle race discovered by Ulrich Schmid
- *		       in down_interruptible(). Since I started to play here I
- *		       also implemented the `trylock' semaphore operation.
- *          1999-07-02 Artur Skawina <skawina@geocities.com>
- *                     Optimized "0(ecx)" -> "(ecx)" (the assembler does not
- *                     do this). Changed calling sequences from push/jmp to
- *                     traditional call/ret.
- * Modified 2001-01-01 Andreas Franck <afranck@gmx.de>
- *		       Some hacks to ensure compatibility with recent
- *		       GCC snapshots, to avoid stack corruption when compiling
- *		       with -fomit-frame-pointer. It's not sure if this will
- *		       be fixed in GCC, as our previous implementation was a
- *		       bit dubious.
- *
- * If you would like to see an analysis of this implementation, please
- * ftp to gcom.com and download the file
- * /pub/linux/src/semaphore/semaphore-2.0.24.tar.gz.
- *
- */
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-/*
- *	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
- *
- * i'd rather use the more flexible initialization above, but sadly
- * GCC 2.7.2.3 emits a bogus warning. EGCS doesn't. Oh well.
- */
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern asmregparm void __down_failed(atomic_t *count_ptr);
-extern asmregparm int  __down_failed_interruptible(atomic_t *count_ptr);
-extern asmregparm int  __down_failed_trylock(atomic_t *count_ptr);
-extern asmregparm void __up_wakeup(atomic_t *count_ptr);
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "__down_failed" is a special asm handler that calls the C
- * routine that actually waits. See arch/i386/kernel/semaphore.c
- */
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-	__asm__ __volatile__(
-		"# atomic down operation\n\t"
-		LOCK_PREFIX "decl %0\n\t"     /* --sem->count */
-		"jns 2f\n"
-		"\tlea %0,%%eax\n\t"
-		"call __down_failed\n"
-		"2:"
-		:"+m" (sem->count)
-		:
-		:"memory","ax");
-}
-
-/*
- * Interruptible try to acquire a semaphore.  If we obtained
- * it, return zero.  If we were interrupted, returns -EINTR
- */
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int result;
-
-	might_sleep();
-	__asm__ __volatile__(
-		"# atomic interruptible down operation\n\t"
-		"xorl %0,%0\n\t"
-		LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
-		"jns 2f\n\t"
-		"lea %1,%%eax\n\t"
-		"call __down_failed_interruptible\n"
-		"2:"
-		:"=&a" (result), "+m" (sem->count)
-		:
-		:"memory");
-	return result;
-}
-
-/*
- * Non-blockingly attempt to down() a semaphore.
- * Returns zero if we acquired it
- */
-static inline int down_trylock(struct semaphore * sem)
-{
-	int result;
-
-	__asm__ __volatile__(
-		"# atomic interruptible down operation\n\t"
-		"xorl %0,%0\n\t"
-		LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
-		"jns 2f\n\t"
-		"lea %1,%%eax\n\t"
-		"call __down_failed_trylock\n\t"
-		"2:\n"
-		:"=&a" (result), "+m" (sem->count)
-		:
-		:"memory");
-	return result;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- */
-static inline void up(struct semaphore * sem)
-{
-	__asm__ __volatile__(
-		"# atomic up operation\n\t"
-		LOCK_PREFIX "incl %0\n\t"     /* ++sem->count */
-		"jg 1f\n\t"
-		"lea %0,%%eax\n\t"
-		"call __up_wakeup\n"
-		"1:"
-		:"+m" (sem->count)
-		:
-		:"memory","ax");
-}
-
-#endif
-#endif
diff --git a/include/asm-x86/semaphore_64.h b/include/asm-x86/semaphore_64.h
deleted file mode 100644
index 7969430..0000000
--- a/include/asm-x86/semaphore_64.h
+++ /dev/null
@@ -1,180 +0,0 @@
-#ifndef _X86_64_SEMAPHORE_H
-#define _X86_64_SEMAPHORE_H
-
-#include <linux/linkage.h>
-
-#ifdef __KERNEL__
-
-/*
- * SMP- and interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * Modified 1996-12-23 by Dave Grothe <dave@gcom.com> to fix bugs in
- *                     the original code and to make semaphore waits
- *                     interruptible so that processes waiting on
- *                     semaphores can be killed.
- * Modified 1999-02-14 by Andrea Arcangeli, split the sched.c helper
- *		       functions in asm/sempahore-helper.h while fixing a
- *		       potential and subtle race discovered by Ulrich Schmid
- *		       in down_interruptible(). Since I started to play here I
- *		       also implemented the `trylock' semaphore operation.
- *          1999-07-02 Artur Skawina <skawina@geocities.com>
- *                     Optimized "0(ecx)" -> "(ecx)" (the assembler does not
- *                     do this). Changed calling sequences from push/jmp to
- *                     traditional call/ret.
- * Modified 2001-01-01 Andreas Franck <afranck@gmx.de>
- *		       Some hacks to ensure compatibility with recent
- *		       GCC snapshots, to avoid stack corruption when compiling
- *		       with -fomit-frame-pointer. It's not sure if this will
- *		       be fixed in GCC, as our previous implementation was a
- *		       bit dubious.
- *
- * If you would like to see an analysis of this implementation, please
- * ftp to gcom.com and download the file
- * /pub/linux/src/semaphore/semaphore-2.0.24.tar.gz.
- *
- */
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-#include <asm/rwlock.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-#include <linux/stringify.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-/*
- *	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
- *
- * i'd rather use the more flexible initialization above, but sadly
- * GCC 2.7.2.3 emits a bogus warning. EGCS doesn't. Oh well.
- */
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down_failed(void /* special register calling convention */);
-asmlinkage int  __down_failed_interruptible(void  /* params in registers */);
-asmlinkage int  __down_failed_trylock(void  /* params in registers */);
-asmlinkage void __up_wakeup(void /* special register calling convention */);
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "__down_failed" is a special asm handler that calls the C
- * routine that actually waits. See arch/x86_64/kernel/semaphore.c
- */
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-
-	__asm__ __volatile__(
-		"# atomic down operation\n\t"
-		LOCK_PREFIX "decl %0\n\t"     /* --sem->count */
-		"jns 1f\n\t"
-		"call __down_failed\n"
-		"1:"
-		:"=m" (sem->count)
-		:"D" (sem)
-		:"memory");
-}
-
-/*
- * Interruptible try to acquire a semaphore.  If we obtained
- * it, return zero.  If we were interrupted, returns -EINTR
- */
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int result;
-
-	might_sleep();
-
-	__asm__ __volatile__(
-		"# atomic interruptible down operation\n\t"
-		"xorl %0,%0\n\t"
-		LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
-		"jns 2f\n\t"
-		"call __down_failed_interruptible\n"
-		"2:\n"
-		:"=&a" (result), "=m" (sem->count)
-		:"D" (sem)
-		:"memory");
-	return result;
-}
-
-/*
- * Non-blockingly attempt to down() a semaphore.
- * Returns zero if we acquired it
- */
-static inline int down_trylock(struct semaphore * sem)
-{
-	int result;
-
-	__asm__ __volatile__(
-		"# atomic interruptible down operation\n\t"
-		"xorl %0,%0\n\t"
-		LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
-		"jns 2f\n\t"
-		"call __down_failed_trylock\n\t"
-		"2:\n"
-		:"=&a" (result), "=m" (sem->count)
-		:"D" (sem)
-		:"memory","cc");
-	return result;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore * sem)
-{
-	__asm__ __volatile__(
-		"# atomic up operation\n\t"
-		LOCK_PREFIX "incl %0\n\t"     /* ++sem->count */
-		"jg 1f\n\t"
-		"call __up_wakeup\n"
-		"1:"
-		:"=m" (sem->count)
-		:"D" (sem)
-		:"memory");
-}
-#endif /* __KERNEL__ */
-#endif
diff --git a/include/asm-xtensa/semaphore.h b/include/asm-xtensa/semaphore.h
index 3e04167..d9b2034 100644
--- a/include/asm-xtensa/semaphore.h
+++ b/include/asm-xtensa/semaphore.h
@@ -1,99 +1 @@
-/*
- * linux/include/asm-xtensa/semaphore.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_SEMAPHORE_H
-#define _XTENSA_SEMAPHORE_H
-
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name,n)					\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) 			\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
-
-static inline void sema_init (struct semaphore *sem, int val)
-{
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX (struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
-
-extern spinlock_t semaphore_wake_lock;
-
-static inline void down(struct semaphore * sem)
-{
-	might_sleep();
-
-	if (atomic_sub_return(1, &sem->count) < 0)
-		__down(sem);
-}
-
-static inline int down_interruptible(struct semaphore * sem)
-{
-	int ret = 0;
-
-	might_sleep();
-
-	if (atomic_sub_return(1, &sem->count) < 0)
-		ret = __down_interruptible(sem);
-	return ret;
-}
-
-static inline int down_trylock(struct semaphore * sem)
-{
-	int ret = 0;
-
-	if (atomic_sub_return(1, &sem->count) < 0)
-		ret = __down_trylock(sem);
-	return ret;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- */
-static inline void up(struct semaphore * sem)
-{
-	if (atomic_add_return(1, &sem->count) <= 0)
-		__up(sem);
-}
-
-#endif /* _XTENSA_SEMAPHORE_H */
+#include <linux/semaphore.h>
diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
new file mode 100644
index 0000000..af3b1cf
--- /dev/null
+++ b/include/linux/semaphore.h
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * Distributed under the terms of the GNU GPL, version 2
+ *
+ * Counting semaphores allow up to <n> tasks to acquire the semaphore
+ * simultaneously.
+ */
+#ifndef __LINUX_SEMAPHORE_H
+#define __LINUX_SEMAPHORE_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+/*
+ * The spinlock controls access to the other members of the semaphore.
+ * 'count' is decremented by every task which calls down*() and incremented
+ * by every call to up().  Thus, if it is positive, it indicates how many
+ * more tasks may acquire the lock.  If it is negative, it indicates how
+ * many tasks are waiting for the lock.  Tasks waiting for the lock are
+ * kept on the wait_list.
+ */
+struct semaphore {
+	spinlock_t		lock;
+	int			count;
+	struct list_head	wait_list;
+};
+
+#define __SEMAPHORE_INITIALIZER(name, n)				\
+{									\
+	.lock		= __SPIN_LOCK_UNLOCKED((name).lock),		\
+	.count		= n,						\
+	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
+}
+
+#define __DECLARE_SEMAPHORE_GENERIC(name, count) \
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
+
+#define DECLARE_MUTEX(name)	__DECLARE_SEMAPHORE_GENERIC(name, 1)
+ 
+static inline void sema_init(struct semaphore *sem, int val)
+{
+	*sem = (struct semaphore) __SEMAPHORE_INITIALIZER(*sem, val);
+}
+
+#define init_MUTEX(sem)		sema_init(sem, 1)
+#define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)
+
+/*
+ * Attempt to acquire the semaphore.  If another task is already holding the
+ * semaphore, sleep until the semaphore is released.
+ */
+extern void down(struct semaphore *sem);
+
+/*
+ * As down(), except the sleep may be interrupted by a signal.  If it is,
+ * this function will return -EINTR.
+ */
+extern int __must_check down_interruptible(struct semaphore *sem);
+
+/*
+ * As down_interruptible(), except the sleep may only be interrupted by
+ * signals which are fatal to this process.
+ */
+extern int __must_check down_killable(struct semaphore *sem);
+
+/*
+ * As down, except this function will not sleep.  It will return 0 if it
+ * acquired the semaphore and 1 if the semaphore was contended.  This
+ * function may be called from any context, including interrupt and softirq.
+ */
+extern int __must_check down_trylock(struct semaphore *sem);
+
+/*
+ * Release the semaphore.  Unlike mutexes, up() may be called from any
+ * context and even by tasks which have never called down().
+ */
+extern void up(struct semaphore *sem);
+
+#endif /* __LINUX_SEMAPHORE_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c584c5..f45c69e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o nsproxy.o srcu.o \
+	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
new file mode 100644
index 0000000..32934f2
--- /dev/null
+++ b/kernel/semaphore.c
@@ -0,0 +1,204 @@
+/*
+ * Copyright (c) 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * Distributed under the terms of the GNU GPL, version 2
+ */
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/spinlock.h>
+
+/*
+ * Some notes on the implementation:
+ *
+ * down_trylock() and up() can be called from interrupt context.
+ * So we have to disable interrupts when taking the lock.
+ *
+ * The ->count variable, if positive, defines how many more tasks can
+ * acquire the semaphore.  If negative, it represents how many tasks are
+ * waiting on the semaphore (*).  If zero, no tasks are waiting, and no more
+ * tasks can acquire the semaphore.
+ *
+ * (*) Except for the window between one task calling up() and the task
+ * sleeping in a __down_common() waking up.  In order to avoid a third task
+ * coming in and stealing the second task's wakeup, we leave the ->count
+ * negative.  If we have a more complex situation, the ->count may become
+ * zero or negative (eg a semaphore with count = 2, three tasks attempt to
+ * acquire it, one sleeps, two finish and call up(), the second task to call
+ * up() notices that the list is empty and just increments count).
+ */
+
+static void noinline __down(struct semaphore *sem);
+static int noinline __down_interruptible(struct semaphore *sem);
+static int noinline __down_killable(struct semaphore *sem);
+static void noinline __up(struct semaphore *sem);
+
+void down(struct semaphore *sem)
+{
+	might_sleep();
+	spin_lock_irq(&sem->lock);
+	if (unlikely(sem->count-- <= 0))
+		__down(sem);
+	spin_unlock_irq(&sem->lock);
+}
+EXPORT_SYMBOL(down);
+
+int down_interruptible(struct semaphore *sem)
+{
+	int result = 0;
+	might_sleep();
+	spin_lock_irq(&sem->lock);
+	if (unlikely(sem->count-- <= 0))
+		result = __down_interruptible(sem);
+	spin_unlock_irq(&sem->lock);
+	return result;
+}
+EXPORT_SYMBOL(down_interruptible);
+
+int down_killable(struct semaphore *sem)
+{
+	int result = 0;
+	might_sleep();
+	spin_lock_irq(&sem->lock);
+	if (unlikely(sem->count-- <= 0))
+		result = __down_killable(sem);
+	spin_unlock_irq(&sem->lock);
+	return result;
+}
+EXPORT_SYMBOL(down_killable);
+
+/**
+ * down_trylock - try to acquire the semaphore, without waiting
+ * @sem: the semaphore to be acquired
+ *
+ * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
+ * been acquired successfully and 1 if it is contended.
+ *
+ * NOTE: This return value is inverted from both spin_trylock and
+ * mutex_trylock!  Be careful about this when converting code.
+ *
+ * Unlike mutex_trylock, this function can be used from interrupt context,
+ * and the semaphore can be released by any task or interrupt.
+ */
+int down_trylock(struct semaphore *sem)
+{
+	unsigned long flags;
+	int count;
+
+	spin_lock_irqsave(&sem->lock, flags);
+	count = sem->count - 1;
+	if (likely(count >= 0))
+		sem->count = count;
+	spin_unlock_irqrestore(&sem->lock, flags);
+	return (count < 0);
+}
+EXPORT_SYMBOL(down_trylock);
+
+void up(struct semaphore *sem)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sem->lock, flags);
+	if (likely(sem->count >= 0))
+		sem->count++;
+	else
+		__up(sem);
+	spin_unlock_irqrestore(&sem->lock, flags);
+}
+EXPORT_SYMBOL(up);
+
+/* Functions for the contended case */
+
+struct semaphore_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	int up;
+};
+
+/*
+ * Wake up a process waiting on a semaphore.  We need to call this from both
+ * __up and __down_common as it's possible to race a task into the semaphore
+ * if it comes in at just the right time between two tasks calling up() and
+ * a third task waking up.  This function assumes the wait_list is already
+ * checked for being non-empty.
+ */
+static void noinline __sched __up_down_common(struct semaphore *sem)
+{
+	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
+						struct semaphore_waiter, list);
+	list_del(&waiter->list);
+	waiter->up = 1;
+	wake_up_process(waiter->task);
+}
+
+/*
+ * Because this function is inlined, the 'state' parameter will be constant,
+ * and thus optimised away by the compiler.
+ */
+static inline int __sched __down_common(struct semaphore *sem, long state)
+{
+	int result = 0;
+	struct task_struct *task = current;
+	struct semaphore_waiter waiter;
+
+	list_add_tail(&waiter.list, &sem->wait_list);
+	waiter.task = task;
+	waiter.up = 0;
+
+	for (;;) {
+		if (unlikely((state == TASK_INTERRUPTIBLE &&
+					signal_pending(task)) ||
+			     (state == TASK_KILLABLE &&
+					fatal_signal_pending(task))))
+			goto interrupted;
+		__set_task_state(task, state);
+		spin_unlock_irq(&sem->lock);
+		schedule();
+		spin_lock_irq(&sem->lock);
+		if (waiter.up)
+			goto woken;
+	}
+
+ interrupted:
+	list_del(&waiter.list);
+	result = -EINTR;
+ woken:
+	/*
+	 * Account for the process which woke us up.  For the case where
+	 * we're interrupted, we need to increment the count on our own
+	 * behalf.  I don't believe we can hit the case where the
+	 * sem->count hits zero, *and* there's a second task sleeping,
+	 * but it doesn't hurt, that's not a commonly exercised path and
+	 * it's not a performance path either.
+	 */
+	if (unlikely((++sem->count >= 0) && !list_empty(&sem->wait_list)))
+		__up_down_common(sem);
+	return result;
+}
+
+static void noinline __sched __down(struct semaphore *sem)
+{
+	__down_common(sem, TASK_UNINTERRUPTIBLE);
+}
+
+static int noinline __sched __down_interruptible(struct semaphore *sem)
+{
+	return __down_common(sem, TASK_INTERRUPTIBLE);
+}
+
+static int noinline __sched __down_killable(struct semaphore *sem)
+{
+	return __down_common(sem, TASK_KILLABLE);
+}
+
+static void noinline __sched __up(struct semaphore *sem)
+{
+	if (unlikely(list_empty(&sem->wait_list)))
+		sem->count++;
+	else
+		__up_down_common(sem);
+}
diff --git a/lib/Makefile b/lib/Makefile
index 23de261..28dba90 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -29,7 +29,6 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
-lib-$(CONFIG_SEMAPHORE_SLEEPERS) += semaphore-sleepers.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
diff --git a/lib/semaphore-sleepers.c b/lib/semaphore-sleepers.c
deleted file mode 100644
index 0198782..0000000
--- a/lib/semaphore-sleepers.c
+++ /dev/null
@@ -1,176 +0,0 @@
-/*
- * i386 and x86-64 semaphore implementation.
- *
- * (C) Copyright 1999 Linus Torvalds
- *
- * Portions Copyright 1999 Red Hat, Inc.
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- * rw semaphores implemented November 1999 by Benjamin LaHaise <bcrl@kvack.org>
- */
-#include <linux/sched.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <asm/semaphore.h>
-
-/*
- * Semaphores are implemented using a two-way counter:
- * The "count" variable is decremented for each process
- * that tries to acquire the semaphore, while the "sleeping"
- * variable is a count of such acquires.
- *
- * Notably, the inline "up()" and "down()" functions can
- * efficiently test if they need to do any extra work (up
- * needs to do something only if count was negative before
- * the increment operation.
- *
- * "sleeping" and the contention routine ordering is protected
- * by the spinlock in the semaphore's waitqueue head.
- *
- * Note that these functions are only called when there is
- * contention on the lock, and as such all this is the
- * "non-critical" part of the whole semaphore business. The
- * critical part is the inline stuff in <asm/semaphore.h>
- * where we want to avoid any extra jumps and calls.
- */
-
-/*
- * Logic:
- *  - only on a boundary condition do we need to care. When we go
- *    from a negative count to a non-negative, we wake people up.
- *  - when we go from a non-negative count to a negative do we
- *    (a) synchronize with the "sleeper" count and (b) make sure
- *    that we're on the wakeup list before we synchronize so that
- *    we cannot lose wakeup events.
- */
-
-void __up(struct semaphore *sem)
-{
-	wake_up(&sem->wait);
-}
-
-void __sched __down(struct semaphore *sem)
-{
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	unsigned long flags;
-
-	tsk->state = TASK_UNINTERRUPTIBLE;
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	add_wait_queue_exclusive_locked(&sem->wait, &wait);
-
-	sem->sleepers++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock in
-		 * the wait_queue_head.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-		schedule();
-
-		spin_lock_irqsave(&sem->wait.lock, flags);
-		tsk->state = TASK_UNINTERRUPTIBLE;
-	}
-	remove_wait_queue_locked(&sem->wait, &wait);
-	wake_up_locked(&sem->wait);
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-	tsk->state = TASK_RUNNING;
-}
-
-int __sched __down_interruptible(struct semaphore *sem)
-{
-	int retval = 0;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	unsigned long flags;
-
-	tsk->state = TASK_INTERRUPTIBLE;
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	add_wait_queue_exclusive_locked(&sem->wait, &wait);
-
-	sem->sleepers++;
-	for (;;) {
-		int sleepers = sem->sleepers;
-
-		/*
-		 * With signals pending, this turns into
-		 * the trylock failure case - we won't be
-		 * sleeping, and we* can't get the lock as
-		 * it has contention. Just correct the count
-		 * and exit.
-		 */
-		if (signal_pending(current)) {
-			retval = -EINTR;
-			sem->sleepers = 0;
-			atomic_add(sleepers, &sem->count);
-			break;
-		}
-
-		/*
-		 * Add "everybody else" into it. They aren't
-		 * playing, because we own the spinlock in
-		 * wait_queue_head. The "-1" is because we're
-		 * still hoping to get the semaphore.
-		 */
-		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
-			sem->sleepers = 0;
-			break;
-		}
-		sem->sleepers = 1;	/* us - see -1 above */
-		spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-		schedule();
-
-		spin_lock_irqsave(&sem->wait.lock, flags);
-		tsk->state = TASK_INTERRUPTIBLE;
-	}
-	remove_wait_queue_locked(&sem->wait, &wait);
-	wake_up_locked(&sem->wait);
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-
-	tsk->state = TASK_RUNNING;
-	return retval;
-}
-
-/*
- * Trylock failed - make sure we correct for
- * having decremented the count.
- *
- * We could have done the trylock with a
- * single "cmpxchg" without failure cases,
- * but then it wouldn't work on a 386.
- */
-int __down_trylock(struct semaphore *sem)
-{
-	int sleepers;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sem->wait.lock, flags);
-	sleepers = sem->sleepers + 1;
-	sem->sleepers = 0;
-
-	/*
-	 * Add "everybody else" and us into it. They aren't
-	 * playing, because we own the spinlock in the
-	 * wait_queue_head.
-	 */
-	if (!atomic_add_negative(sleepers, &sem->count)) {
-		wake_up_locked(&sem->wait);
-	}
-
-	spin_unlock_irqrestore(&sem->wait.lock, flags);
-	return 1;
-}
-- 
1.5.4.1

