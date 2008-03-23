Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbYCWIWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbYCWIWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbYCWIJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:08 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2269 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758835AbYCWIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:06 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 064/148] include/asm-x86/local.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:39 -0700
Message-Id: <1206259443-13210-65-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/local.h |  105 ++++++++++++++++++++++------------------------
 1 files changed, 50 insertions(+), 55 deletions(-)

diff --git a/include/asm-x86/local.h b/include/asm-x86/local.h
index f852c62..330a724 100644
--- a/include/asm-x86/local.h
+++ b/include/asm-x86/local.h
@@ -18,32 +18,28 @@ typedef struct {
 
 static inline void local_inc(local_t *l)
 {
-	__asm__ __volatile__(
-		_ASM_INC "%0"
-		:"+m" (l->a.counter));
+	asm volatile(_ASM_INC "%0"
+		     : "+m" (l->a.counter));
 }
 
 static inline void local_dec(local_t *l)
 {
-	__asm__ __volatile__(
-		_ASM_DEC "%0"
-		:"+m" (l->a.counter));
+	asm volatile(_ASM_DEC "%0"
+		     : "+m" (l->a.counter));
 }
 
 static inline void local_add(long i, local_t *l)
 {
-	__asm__ __volatile__(
-		_ASM_ADD "%1,%0"
-		:"+m" (l->a.counter)
-		:"ir" (i));
+	asm volatile(_ASM_ADD "%1,%0"
+		     : "+m" (l->a.counter)
+		     : "ir" (i));
 }
 
 static inline void local_sub(long i, local_t *l)
 {
-	__asm__ __volatile__(
-		_ASM_SUB "%1,%0"
-		:"+m" (l->a.counter)
-		:"ir" (i));
+	asm volatile(_ASM_SUB "%1,%0"
+		     : "+m" (l->a.counter)
+		     : "ir" (i));
 }
 
 /**
@@ -59,10 +55,9 @@ static inline int local_sub_and_test(long i, local_t *l)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		_ASM_SUB "%2,%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		:"ir" (i) : "memory");
+	asm volatile(_ASM_SUB "%2,%0; sete %1"
+		     : "+m" (l->a.counter), "=qm" (c)
+		     : "ir" (i) : "memory");
 	return c;
 }
 
@@ -78,10 +73,9 @@ static inline int local_dec_and_test(local_t *l)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		_ASM_DEC "%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		: : "memory");
+	asm volatile(_ASM_DEC "%0; sete %1"
+		     : "+m" (l->a.counter), "=qm" (c)
+		     : : "memory");
 	return c != 0;
 }
 
@@ -97,10 +91,9 @@ static inline int local_inc_and_test(local_t *l)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		_ASM_INC "%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		: : "memory");
+	asm volatile(_ASM_INC "%0; sete %1"
+		     : "+m" (l->a.counter), "=qm" (c)
+		     : : "memory");
 	return c != 0;
 }
 
@@ -117,10 +110,9 @@ static inline int local_add_negative(long i, local_t *l)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		_ASM_ADD "%2,%0; sets %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		:"ir" (i) : "memory");
+	asm volatile(_ASM_ADD "%2,%0; sets %1"
+		     : "+m" (l->a.counter), "=qm" (c)
+		     : "ir" (i) : "memory");
 	return c;
 }
 
@@ -141,10 +133,9 @@ static inline long local_add_return(long i, local_t *l)
 #endif
 	/* Modern 486+ processor */
 	__i = i;
-	__asm__ __volatile__(
-		_ASM_XADD "%0, %1;"
-		:"+r" (i), "+m" (l->a.counter)
-		: : "memory");
+	asm volatile(_ASM_XADD "%0, %1;"
+		     : "+r" (i), "+m" (l->a.counter)
+		     : : "memory");
 	return i + __i;
 
 #ifdef CONFIG_M386
@@ -182,11 +173,11 @@ static inline long local_sub_return(long i, local_t *l)
 #define local_add_unless(l, a, u)				\
 ({								\
 	long c, old;						\
-	c = local_read(l);					\
+	c = local_read((l));					\
 	for (;;) {						\
 		if (unlikely(c == (u)))				\
 			break;					\
-		old = local_cmpxchg((l), c, c + (a));	\
+		old = local_cmpxchg((l), c, c + (a));		\
 		if (likely(old == c))				\
 			break;					\
 		c = old;					\
@@ -214,26 +205,30 @@ static inline long local_sub_return(long i, local_t *l)
 
 /* Need to disable preemption for the cpu local counters otherwise we could
    still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
+#define cpu_local_wrap_v(l)		\
+({					\
+	local_t res__;			\
+	preempt_disable(); 		\
+	res__ = (l);			\
+	preempt_enable();		\
+	res__;				\
+})
 #define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
+({					\
+	preempt_disable();		\
+	(l);				\
+	preempt_enable();		\
+})					\
+
+#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var((l))))
+#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var((l)), (i)))
+#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var((l))))
+#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var((l))))
+#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var((l))))
+#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var((l))))
+
+#define __cpu_local_inc(l)	cpu_local_inc((l))
+#define __cpu_local_dec(l)	cpu_local_dec((l))
 #define __cpu_local_add(i, l)	cpu_local_add((i), (l))
 #define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
 
-- 
1.5.4.rc2

