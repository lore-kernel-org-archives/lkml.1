Return-Path: <linux-kernel-owner+w=401wt.eu-S1764787AbYCWIiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764787AbYCWIiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbYCWIKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:21 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2301 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759265AbYCWIKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:16 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 116/148] include/asm-x86/spinlock.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:31 -0700
Message-Id: <1206259443-13210-117-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/spinlock.h |  105 +++++++++++++++++++++-----------------------
 1 files changed, 50 insertions(+), 55 deletions(-)

diff --git a/include/asm-x86/spinlock.h b/include/asm-x86/spinlock.h
index 23804c1..47dfe26 100644
--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -82,7 +82,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
 	short inc = 0x0100;
 
-	__asm__ __volatile__ (
+	asm volatile (
 		LOCK_PREFIX "xaddw %w0, %1\n"
 		"1:\t"
 		"cmpb %h0, %b0\n\t"
@@ -92,9 +92,9 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 		/* don't need lfence here, because loads are in-order */
 		"jmp 1b\n"
 		"2:"
-		:"+Q" (inc), "+m" (lock->slock)
+		: "+Q" (inc), "+m" (lock->slock)
 		:
-		:"memory", "cc");
+		: "memory", "cc");
 }
 
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
@@ -104,30 +104,28 @@ static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 	int tmp;
 	short new;
 
-	asm volatile(
-		"movw %2,%w0\n\t"
-		"cmpb %h0,%b0\n\t"
-		"jne 1f\n\t"
-		"movw %w0,%w1\n\t"
-		"incb %h1\n\t"
-		"lock ; cmpxchgw %w1,%2\n\t"
-		"1:"
-		"sete %b1\n\t"
-		"movzbl %b1,%0\n\t"
-		:"=&a" (tmp), "=Q" (new), "+m" (lock->slock)
-		:
-		: "memory", "cc");
+	asm volatile("movw %2,%w0\n\t"
+		     "cmpb %h0,%b0\n\t"
+		     "jne 1f\n\t"
+		     "movw %w0,%w1\n\t"
+		     "incb %h1\n\t"
+		     "lock ; cmpxchgw %w1,%2\n\t"
+		     "1:"
+		     "sete %b1\n\t"
+		     "movzbl %b1,%0\n\t"
+		     : "=&a" (tmp), "=Q" (new), "+m" (lock->slock)
+		     :
+		     : "memory", "cc");
 
 	return tmp;
 }
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	__asm__ __volatile__(
-		UNLOCK_LOCK_PREFIX "incb %0"
-		:"+m" (lock->slock)
-		:
-		:"memory", "cc");
+	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
+		     : "+m" (lock->slock)
+		     :
+		     : "memory", "cc");
 }
 #else
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
@@ -149,21 +147,20 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 	int inc = 0x00010000;
 	int tmp;
 
-	__asm__ __volatile__ (
-		"lock ; xaddl %0, %1\n"
-		"movzwl %w0, %2\n\t"
-		"shrl $16, %0\n\t"
-		"1:\t"
-		"cmpl %0, %2\n\t"
-		"je 2f\n\t"
-		"rep ; nop\n\t"
-		"movzwl %1, %2\n\t"
-		/* don't need lfence here, because loads are in-order */
-		"jmp 1b\n"
-		"2:"
-		:"+Q" (inc), "+m" (lock->slock), "=r" (tmp)
-		:
-		:"memory", "cc");
+	asm volatile("lock ; xaddl %0, %1\n"
+		     "movzwl %w0, %2\n\t"
+		     "shrl $16, %0\n\t"
+		     "1:\t"
+		     "cmpl %0, %2\n\t"
+		     "je 2f\n\t"
+		     "rep ; nop\n\t"
+		     "movzwl %1, %2\n\t"
+		     /* don't need lfence here, because loads are in-order */
+		     "jmp 1b\n"
+		     "2:"
+		     : "+Q" (inc), "+m" (lock->slock), "=r" (tmp)
+		     :
+		     : "memory", "cc");
 }
 
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
@@ -173,31 +170,29 @@ static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 	int tmp;
 	int new;
 
-	asm volatile(
-		"movl %2,%0\n\t"
-		"movl %0,%1\n\t"
-		"roll $16, %0\n\t"
-		"cmpl %0,%1\n\t"
-		"jne 1f\n\t"
-		"addl $0x00010000, %1\n\t"
-		"lock ; cmpxchgl %1,%2\n\t"
-		"1:"
-		"sete %b1\n\t"
-		"movzbl %b1,%0\n\t"
-		:"=&a" (tmp), "=r" (new), "+m" (lock->slock)
-		:
-		: "memory", "cc");
+	asm volatile("movl %2,%0\n\t"
+		     "movl %0,%1\n\t"
+		     "roll $16, %0\n\t"
+		     "cmpl %0,%1\n\t"
+		     "jne 1f\n\t"
+		     "addl $0x00010000, %1\n\t"
+		     "lock ; cmpxchgl %1,%2\n\t"
+		     "1:"
+		     "sete %b1\n\t"
+		     "movzbl %b1,%0\n\t"
+		     : "=&a" (tmp), "=r" (new), "+m" (lock->slock)
+		     :
+		     : "memory", "cc");
 
 	return tmp;
 }
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	__asm__ __volatile__(
-		UNLOCK_LOCK_PREFIX "incw %0"
-		:"+m" (lock->slock)
-		:
-		:"memory", "cc");
+	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
+		     : "+m" (lock->slock)
+		     :
+		     : "memory", "cc");
 }
 #endif
 
-- 
1.5.4.rc2

