Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYCWIbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYCWIbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbYCWIJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:50 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2288 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759514AbYCWIJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:47 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 107/148] include/asm-x86/semaphore_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:22 -0700
Message-Id: <1206259443-13210-108-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/semaphore_32.h |  104 +++++++++++++++++++---------------------
 1 files changed, 50 insertions(+), 54 deletions(-)

diff --git a/include/asm-x86/semaphore_32.h b/include/asm-x86/semaphore_32.h
index ac96d38..42a7e39 100644
--- a/include/asm-x86/semaphore_32.h
+++ b/include/asm-x86/semaphore_32.h
@@ -55,12 +55,12 @@ struct semaphore {
 	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
 }
 
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
+#define __DECLARE_SEMAPHORE_GENERIC(name, count)			\
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
 
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
+#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name, 1)
 
-static inline void sema_init (struct semaphore *sem, int val)
+static inline void sema_init(struct semaphore *sem, int val)
 {
 /*
  *	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
@@ -73,19 +73,19 @@ static inline void sema_init (struct semaphore *sem, int val)
 	init_waitqueue_head(&sem->wait);
 }
 
-static inline void init_MUTEX (struct semaphore *sem)
+static inline void init_MUTEX(struct semaphore *sem)
 {
 	sema_init(sem, 1);
 }
 
-static inline void init_MUTEX_LOCKED (struct semaphore *sem)
+static inline void init_MUTEX_LOCKED(struct semaphore *sem)
 {
 	sema_init(sem, 0);
 }
 
 extern asmregparm void __down_failed(atomic_t *count_ptr);
-extern asmregparm int  __down_failed_interruptible(atomic_t *count_ptr);
-extern asmregparm int  __down_failed_trylock(atomic_t *count_ptr);
+extern asmregparm int __down_failed_interruptible(atomic_t *count_ptr);
+extern asmregparm int __down_failed_trylock(atomic_t *count_ptr);
 extern asmregparm void __up_wakeup(atomic_t *count_ptr);
 
 /*
@@ -93,41 +93,39 @@ extern asmregparm void __up_wakeup(atomic_t *count_ptr);
  * "__down_failed" is a special asm handler that calls the C
  * routine that actually waits. See arch/i386/kernel/semaphore.c
  */
-static inline void down(struct semaphore * sem)
+static inline void down(struct semaphore *sem)
 {
 	might_sleep();
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
+	asm volatile("# atomic down operation\n\t"
+		     LOCK_PREFIX "decl %0\n\t"     /* --sem->count */
+		     "jns 2f\n"
+		     "\tlea %0,%%eax\n\t"
+		     "call __down_failed\n"
+		     "2:"
+		     : "+m" (sem->count)
+		     :
+		     : "memory", "ax");
 }
 
 /*
  * Interruptible try to acquire a semaphore.  If we obtained
  * it, return zero.  If we were interrupted, returns -EINTR
  */
-static inline int down_interruptible(struct semaphore * sem)
+static inline int down_interruptible(struct semaphore *sem)
 {
 	int result;
 
 	might_sleep();
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
+	asm volatile("# atomic interruptible down operation\n\t"
+		     "xorl %0,%0\n\t"
+		     LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
+		     "jns 2f\n\t"
+		     "lea %1,%%eax\n\t"
+		     "call __down_failed_interruptible\n"
+		     "2:"
+		     : "=&a" (result), "+m" (sem->count)
+		     :
+		     : "memory");
 	return result;
 }
 
@@ -135,21 +133,20 @@ static inline int down_interruptible(struct semaphore * sem)
  * Non-blockingly attempt to down() a semaphore.
  * Returns zero if we acquired it
  */
-static inline int down_trylock(struct semaphore * sem)
+static inline int down_trylock(struct semaphore *sem)
 {
 	int result;
 
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
+	asm volatile("# atomic interruptible down operation\n\t"
+		     "xorl %0,%0\n\t"
+		     LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
+		     "jns 2f\n\t"
+		     "lea %1,%%eax\n\t"
+		     "call __down_failed_trylock\n\t"
+		     "2:\n"
+		     : "=&a" (result), "+m" (sem->count)
+		     :
+		     : "memory");
 	return result;
 }
 
@@ -157,18 +154,17 @@ static inline int down_trylock(struct semaphore * sem)
  * Note! This is subtle. We jump to wake people up only if
  * the semaphore was negative (== somebody was waiting on it).
  */
-static inline void up(struct semaphore * sem)
+static inline void up(struct semaphore *sem)
 {
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
+	asm volatile("# atomic up operation\n\t"
+		     LOCK_PREFIX "incl %0\n\t"     /* ++sem->count */
+		     "jg 1f\n\t"
+		     "lea %0,%%eax\n\t"
+		     "call __up_wakeup\n"
+		     "1:"
+		     : "+m" (sem->count)
+		     :
+		     : "memory", "ax");
 }
 
 #endif
-- 
1.5.4.rc2

