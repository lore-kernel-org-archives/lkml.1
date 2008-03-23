Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbYCWIgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbYCWIgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759759AbYCWIKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:18 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2299 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbYCWIKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:13 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 006/148] include/asm-x86/atomic_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:41 -0700
Message-Id: <1206259443-13210-7-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/atomic_32.h |  143 ++++++++++++++++++++----------------------
 1 files changed, 68 insertions(+), 75 deletions(-)

diff --git a/include/asm-x86/atomic_32.h b/include/asm-x86/atomic_32.h
index 437aac8..21a4825 100644
--- a/include/asm-x86/atomic_32.h
+++ b/include/asm-x86/atomic_32.h
@@ -15,138 +15,133 @@
  * on us. We need to use _exactly_ the address the user gave us,
  * not some alias that contains the same information.
  */
-typedef struct { int counter; } atomic_t;
+typedef struct {
+	int counter;
+} atomic_t;
 
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
  * atomic_read - read atomic variable
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically reads the value of @v.
- */ 
+ */
 #define atomic_read(v)		((v)->counter)
 
 /**
  * atomic_set - set atomic variable
  * @v: pointer of type atomic_t
  * @i: required value
- * 
+ *
  * Atomically sets the value of @v to @i.
- */ 
-#define atomic_set(v,i)		(((v)->counter) = (i))
+ */
+#define atomic_set(v, i)	(((v)->counter) = (i))
 
 /**
  * atomic_add - add integer to atomic variable
  * @i: integer value to add
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically adds @i to @v.
  */
-static __inline__ void atomic_add(int i, atomic_t *v)
+static inline void atomic_add(int i, atomic_t *v)
 {
-	__asm__ __volatile__(
-		LOCK_PREFIX "addl %1,%0"
-		:"+m" (v->counter)
-		:"ir" (i));
+	asm volatile(LOCK_PREFIX "addl %1,%0"
+		     : "+m" (v->counter)
+		     : "ir" (i));
 }
 
 /**
  * atomic_sub - subtract integer from atomic variable
  * @i: integer value to subtract
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically subtracts @i from @v.
  */
-static __inline__ void atomic_sub(int i, atomic_t *v)
+static inline void atomic_sub(int i, atomic_t *v)
 {
-	__asm__ __volatile__(
-		LOCK_PREFIX "subl %1,%0"
-		:"+m" (v->counter)
-		:"ir" (i));
+	asm volatile(LOCK_PREFIX "subl %1,%0"
+		     : "+m" (v->counter)
+		     : "ir" (i));
 }
 
 /**
  * atomic_sub_and_test - subtract value from variable and test result
  * @i: integer value to subtract
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically subtracts @i from @v and returns
  * true if the result is zero, or false for all
  * other cases.
  */
-static __inline__ int atomic_sub_and_test(int i, atomic_t *v)
+static inline int atomic_sub_and_test(int i, atomic_t *v)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		LOCK_PREFIX "subl %2,%0; sete %1"
-		:"+m" (v->counter), "=qm" (c)
-		:"ir" (i) : "memory");
+	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
 	return c;
 }
 
 /**
  * atomic_inc - increment atomic variable
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically increments @v by 1.
- */ 
-static __inline__ void atomic_inc(atomic_t *v)
+ */
+static inline void atomic_inc(atomic_t *v)
 {
-	__asm__ __volatile__(
-		LOCK_PREFIX "incl %0"
-		:"+m" (v->counter));
+	asm volatile(LOCK_PREFIX "incl %0"
+		     : "+m" (v->counter));
 }
 
 /**
  * atomic_dec - decrement atomic variable
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically decrements @v by 1.
- */ 
-static __inline__ void atomic_dec(atomic_t *v)
+ */
+static inline void atomic_dec(atomic_t *v)
 {
-	__asm__ __volatile__(
-		LOCK_PREFIX "decl %0"
-		:"+m" (v->counter));
+	asm volatile(LOCK_PREFIX "decl %0"
+		     : "+m" (v->counter));
 }
 
 /**
  * atomic_dec_and_test - decrement and test
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically decrements @v by 1 and
  * returns true if the result is 0, or false for all other
  * cases.
- */ 
-static __inline__ int atomic_dec_and_test(atomic_t *v)
+ */
+static inline int atomic_dec_and_test(atomic_t *v)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		LOCK_PREFIX "decl %0; sete %1"
-		:"+m" (v->counter), "=qm" (c)
-		: : "memory");
+	asm volatile(LOCK_PREFIX "decl %0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
 	return c != 0;
 }
 
 /**
- * atomic_inc_and_test - increment and test 
+ * atomic_inc_and_test - increment and test
  * @v: pointer of type atomic_t
- * 
+ *
  * Atomically increments @v by 1
  * and returns true if the result is zero, or false for all
  * other cases.
- */ 
-static __inline__ int atomic_inc_and_test(atomic_t *v)
+ */
+static inline int atomic_inc_and_test(atomic_t *v)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		LOCK_PREFIX "incl %0; sete %1"
-		:"+m" (v->counter), "=qm" (c)
-		: : "memory");
+	asm volatile(LOCK_PREFIX "incl %0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
 	return c != 0;
 }
 
@@ -154,19 +149,18 @@ static __inline__ int atomic_inc_and_test(atomic_t *v)
  * atomic_add_negative - add and test if negative
  * @v: pointer of type atomic_t
  * @i: integer value to add
- * 
+ *
  * Atomically adds @i to @v and returns true
  * if the result is negative, or false when
  * result is greater than or equal to zero.
- */ 
-static __inline__ int atomic_add_negative(int i, atomic_t *v)
+ */
+static inline int atomic_add_negative(int i, atomic_t *v)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		LOCK_PREFIX "addl %2,%0; sets %1"
-		:"+m" (v->counter), "=qm" (c)
-		:"ir" (i) : "memory");
+	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
 	return c;
 }
 
@@ -177,20 +171,19 @@ static __inline__ int atomic_add_negative(int i, atomic_t *v)
  *
  * Atomically adds @i to @v and returns @i + @v
  */
-static __inline__ int atomic_add_return(int i, atomic_t *v)
+static inline int atomic_add_return(int i, atomic_t *v)
 {
 	int __i;
 #ifdef CONFIG_M386
 	unsigned long flags;
-	if(unlikely(boot_cpu_data.x86 <= 3))
+	if (unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */
 	__i = i;
-	__asm__ __volatile__(
-		LOCK_PREFIX "xaddl %0, %1"
-		:"+r" (i), "+m" (v->counter)
-		: : "memory");
+	asm volatile(LOCK_PREFIX "xaddl %0, %1"
+		     : "+r" (i), "+m" (v->counter)
+		     : : "memory");
 	return i + __i;
 
 #ifdef CONFIG_M386
@@ -210,9 +203,9 @@ no_xadd: /* Legacy 386 processor */
  *
  * Atomically subtracts @i from @v and returns @v - @i
  */
-static __inline__ int atomic_sub_return(int i, atomic_t *v)
+static inline int atomic_sub_return(int i, atomic_t *v)
 {
-	return atomic_add_return(-i,v);
+	return atomic_add_return(-i, v);
 }
 
 #define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
@@ -227,7 +220,7 @@ static __inline__ int atomic_sub_return(int i, atomic_t *v)
  * Atomically adds @a to @v, so long as @v was not already @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -244,17 +237,17 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-#define atomic_inc_return(v)  (atomic_add_return(1,v))
-#define atomic_dec_return(v)  (atomic_sub_return(1,v))
+#define atomic_inc_return(v)  (atomic_add_return(1, v))
+#define atomic_dec_return(v)  (atomic_sub_return(1, v))
 
 /* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr) \
-__asm__ __volatile__(LOCK_PREFIX "andl %0,%1" \
-: : "r" (~(mask)),"m" (*addr) : "memory")
+#define atomic_clear_mask(mask, addr)				\
+	asm volatile(LOCK_PREFIX "andl %0,%1"			\
+		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
 
-#define atomic_set_mask(mask, addr) \
-__asm__ __volatile__(LOCK_PREFIX "orl %0,%1" \
-: : "r" (mask),"m" (*(addr)) : "memory")
+#define atomic_set_mask(mask, addr)				\
+	asm volatile(LOCK_PREFIX "orl %0,%1"				\
+		     : : "r" (mask), "m" (*(addr)) : "memory")
 
 /* Atomic operations are already serializing on x86 */
 #define smp_mb__before_atomic_dec()	barrier()
-- 
1.5.4.rc2

