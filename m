Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYCWIce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYCWIce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759619AbYCWIJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:57 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2290 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759580AbYCWIJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:56 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 108/148] include/asm-x86/semaphore_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:23 -0700
Message-Id: <1206259443-13210-109-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/semaphore_64.h |   98 +++++++++++++++++++---------------------
 1 files changed, 47 insertions(+), 51 deletions(-)

diff --git a/include/asm-x86/semaphore_64.h b/include/asm-x86/semaphore_64.h
index 7969430..5835d8e 100644
--- a/include/asm-x86/semaphore_64.h
+++ b/include/asm-x86/semaphore_64.h
@@ -57,11 +57,11 @@ struct semaphore {
 }
 
 #define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name,count)
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
 
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
+#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name, 1)
 
-static inline void sema_init (struct semaphore *sem, int val)
+static inline void sema_init(struct semaphore *sem, int val)
 {
 /*
  *	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
@@ -74,12 +74,12 @@ static inline void sema_init (struct semaphore *sem, int val)
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
@@ -89,51 +89,49 @@ asmlinkage int  __down_failed_interruptible(void  /* params in registers */);
 asmlinkage int  __down_failed_trylock(void  /* params in registers */);
 asmlinkage void __up_wakeup(void /* special register calling convention */);
 
-asmlinkage void __down(struct semaphore * sem);
-asmlinkage int  __down_interruptible(struct semaphore * sem);
-asmlinkage int  __down_trylock(struct semaphore * sem);
-asmlinkage void __up(struct semaphore * sem);
+asmlinkage void __down(struct semaphore *sem);
+asmlinkage int  __down_interruptible(struct semaphore *sem);
+asmlinkage int  __down_trylock(struct semaphore *sem);
+asmlinkage void __up(struct semaphore *sem);
 
 /*
  * This is ugly, but we want the default case to fall through.
  * "__down_failed" is a special asm handler that calls the C
  * routine that actually waits. See arch/x86_64/kernel/semaphore.c
  */
-static inline void down(struct semaphore * sem)
+static inline void down(struct semaphore *sem)
 {
 	might_sleep();
 
-	__asm__ __volatile__(
-		"# atomic down operation\n\t"
-		LOCK_PREFIX "decl %0\n\t"     /* --sem->count */
-		"jns 1f\n\t"
-		"call __down_failed\n"
-		"1:"
-		:"=m" (sem->count)
-		:"D" (sem)
-		:"memory");
+	asm volatile("# atomic down operation\n\t"
+		     LOCK_PREFIX "decl %0\n\t"     /* --sem->count */
+		     "jns 1f\n\t"
+		     "call __down_failed\n"
+		     "1:"
+		     : "=m" (sem->count)
+		     : "D" (sem)
+		     : "memory");
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
-		"call __down_failed_interruptible\n"
-		"2:\n"
-		:"=&a" (result), "=m" (sem->count)
-		:"D" (sem)
-		:"memory");
+	asm volatile("# atomic interruptible down operation\n\t"
+		     "xorl %0,%0\n\t"
+		     LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
+		     "jns 2f\n\t"
+		     "call __down_failed_interruptible\n"
+		     "2:\n"
+		     : "=&a" (result), "=m" (sem->count)
+		     : "D" (sem)
+		     : "memory");
 	return result;
 }
 
@@ -141,20 +139,19 @@ static inline int down_interruptible(struct semaphore * sem)
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
-		"call __down_failed_trylock\n\t"
-		"2:\n"
-		:"=&a" (result), "=m" (sem->count)
-		:"D" (sem)
-		:"memory","cc");
+	asm volatile("# atomic interruptible down operation\n\t"
+		     "xorl %0,%0\n\t"
+		     LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
+		     "jns 2f\n\t"
+		     "call __down_failed_trylock\n\t"
+		     "2:\n"
+		     : "=&a" (result), "=m" (sem->count)
+		     : "D" (sem)
+		     : "memory", "cc");
 	return result;
 }
 
@@ -164,17 +161,16 @@ static inline int down_trylock(struct semaphore * sem)
  * The default case (no contention) will result in NO
  * jumps for both down() and up().
  */
-static inline void up(struct semaphore * sem)
+static inline void up(struct semaphore *sem)
 {
-	__asm__ __volatile__(
-		"# atomic up operation\n\t"
-		LOCK_PREFIX "incl %0\n\t"     /* ++sem->count */
-		"jg 1f\n\t"
-		"call __up_wakeup\n"
-		"1:"
-		:"=m" (sem->count)
-		:"D" (sem)
-		:"memory");
+	asm volatile("# atomic up operation\n\t"
+		     LOCK_PREFIX "incl %0\n\t"     /* ++sem->count */
+		     "jg 1f\n\t"
+		     "call __up_wakeup\n"
+		     "1:"
+		     : "=m" (sem->count)
+		     : "D" (sem)
+		     : "memory");
 }
 #endif /* __KERNEL__ */
 #endif
-- 
1.5.4.rc2

