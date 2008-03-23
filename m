Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbYCWIS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbYCWIS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759267AbYCWIIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:46 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2258 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759240AbYCWIIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:40 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 007/148] include/asm-x86/atomic_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:42 -0700
Message-Id: <1206259443-13210-8-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/atomic_64.h |  251 ++++++++++++++++++++-----------------------
 1 files changed, 119 insertions(+), 132 deletions(-)

diff --git a/include/asm-x86/atomic_64.h b/include/asm-x86/atomic_64.h
index 2d20a7a..3e0cd7d 100644
--- a/include/asm-x86/atomic_64.h
+++ b/include/asm-x86/atomic_64.h
@@ -22,140 +22,135 @@
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
+#define atomic_set(v, i)		(((v)->counter) = (i))
 
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
-		:"=m" (v->counter)
-		:"ir" (i), "m" (v->counter));
+	asm volatile(LOCK_PREFIX "addl %1,%0"
+		     : "=m" (v->counter)
+		     : "ir" (i), "m" (v->counter));
 }
 
 /**
  * atomic_sub - subtract the atomic variable
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
-		:"=m" (v->counter)
-		:"ir" (i), "m" (v->counter));
+	asm volatile(LOCK_PREFIX "subl %1,%0"
+		     : "=m" (v->counter)
+		     : "ir" (i), "m" (v->counter));
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
-		:"=m" (v->counter), "=qm" (c)
-		:"ir" (i), "m" (v->counter) : "memory");
+	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "ir" (i), "m" (v->counter) : "memory");
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
-		:"=m" (v->counter)
-		:"m" (v->counter));
+	asm volatile(LOCK_PREFIX "incl %0"
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
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
-		:"=m" (v->counter)
-		:"m" (v->counter));
+	asm volatile(LOCK_PREFIX "decl %0"
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
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
-		:"=m" (v->counter), "=qm" (c)
-		:"m" (v->counter) : "memory");
+	asm volatile(LOCK_PREFIX "decl %0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "m" (v->counter) : "memory");
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
-		:"=m" (v->counter), "=qm" (c)
-		:"m" (v->counter) : "memory");
+	asm volatile(LOCK_PREFIX "incl %0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "m" (v->counter) : "memory");
 	return c != 0;
 }
 
@@ -163,19 +158,18 @@ static __inline__ int atomic_inc_and_test(atomic_t *v)
  * atomic_add_negative - add and test if negative
  * @i: integer value to add
  * @v: pointer of type atomic_t
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
-		:"=m" (v->counter), "=qm" (c)
-		:"ir" (i), "m" (v->counter) : "memory");
+	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "ir" (i), "m" (v->counter) : "memory");
 	return c;
 }
 
@@ -186,27 +180,28 @@ static __inline__ int atomic_add_negative(int i, atomic_t *v)
  *
  * Atomically adds @i to @v and returns @i + @v
  */
-static __inline__ int atomic_add_return(int i, atomic_t *v)
+static inline int atomic_add_return(int i, atomic_t *v)
 {
 	int __i = i;
-	__asm__ __volatile__(
-		LOCK_PREFIX "xaddl %0, %1"
-		:"+r" (i), "+m" (v->counter)
-		: : "memory");
+	asm volatile(LOCK_PREFIX "xaddl %0, %1"
+		     : "+r" (i), "+m" (v->counter)
+		     : : "memory");
 	return i + __i;
 }
 
-static __inline__ int atomic_sub_return(int i, atomic_t *v)
+static inline int atomic_sub_return(int i, atomic_t *v)
 {
-	return atomic_add_return(-i,v);
+	return atomic_add_return(-i, v);
 }
 
-#define atomic_inc_return(v)  (atomic_add_return(1,v))
-#define atomic_dec_return(v)  (atomic_sub_return(1,v))
+#define atomic_inc_return(v)  (atomic_add_return(1, v))
+#define atomic_dec_return(v)  (atomic_sub_return(1, v))
 
 /* An 64bit atomic type */
 
-typedef struct { long counter; } atomic64_t;
+typedef struct {
+	long counter;
+} atomic64_t;
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
@@ -226,7 +221,7 @@ typedef struct { long counter; } atomic64_t;
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic64_set(v,i)		(((v)->counter) = (i))
+#define atomic64_set(v, i)		(((v)->counter) = (i))
 
 /**
  * atomic64_add - add integer to atomic64 variable
@@ -235,12 +230,11 @@ typedef struct { long counter; } atomic64_t;
  *
  * Atomically adds @i to @v.
  */
-static __inline__ void atomic64_add(long i, atomic64_t *v)
+static inline void atomic64_add(long i, atomic64_t *v)
 {
-	__asm__ __volatile__(
-		LOCK_PREFIX "addq %1,%0"
-		:"=m" (v->counter)
-		:"ir" (i), "m" (v->counter));
+	asm volatile(LOCK_PREFIX "addq %1,%0"
+		     : "=m" (v->counter)
+		     : "ir" (i), "m" (v->counter));
 }
 
 /**
@@ -250,12 +244,11 @@ static __inline__ void atomic64_add(long i, atomic64_t *v)
  *
  * Atomically subtracts @i from @v.
  */
-static __inline__ void atomic64_sub(long i, atomic64_t *v)
+static inline void atomic64_sub(long i, atomic64_t *v)
 {
-	__asm__ __volatile__(
-		LOCK_PREFIX "subq %1,%0"
-		:"=m" (v->counter)
-		:"ir" (i), "m" (v->counter));
+	asm volatile(LOCK_PREFIX "subq %1,%0"
+		     : "=m" (v->counter)
+		     : "ir" (i), "m" (v->counter));
 }
 
 /**
@@ -267,14 +260,13 @@ static __inline__ void atomic64_sub(long i, atomic64_t *v)
  * true if the result is zero, or false for all
  * other cases.
  */
-static __inline__ int atomic64_sub_and_test(long i, atomic64_t *v)
+static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		LOCK_PREFIX "subq %2,%0; sete %1"
-		:"=m" (v->counter), "=qm" (c)
-		:"ir" (i), "m" (v->counter) : "memory");
+	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "ir" (i), "m" (v->counter) : "memory");
 	return c;
 }
 
@@ -284,12 +276,11 @@ static __inline__ int atomic64_sub_and_test(long i, atomic64_t *v)
  *
  * Atomically increments @v by 1.
  */
-static __inline__ void atomic64_inc(atomic64_t *v)
+static inline void atomic64_inc(atomic64_t *v)
 {
-	__asm__ __volatile__(
-		LOCK_PREFIX "incq %0"
-		:"=m" (v->counter)
-		:"m" (v->counter));
+	asm volatile(LOCK_PREFIX "incq %0"
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
 }
 
 /**
@@ -298,12 +289,11 @@ static __inline__ void atomic64_inc(atomic64_t *v)
  *
  * Atomically decrements @v by 1.
  */
-static __inline__ void atomic64_dec(atomic64_t *v)
+static inline void atomic64_dec(atomic64_t *v)
 {
-	__asm__ __volatile__(
-		LOCK_PREFIX "decq %0"
-		:"=m" (v->counter)
-		:"m" (v->counter));
+	asm volatile(LOCK_PREFIX "decq %0"
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
 }
 
 /**
@@ -314,14 +304,13 @@ static __inline__ void atomic64_dec(atomic64_t *v)
  * returns true if the result is 0, or false for all other
  * cases.
  */
-static __inline__ int atomic64_dec_and_test(atomic64_t *v)
+static inline int atomic64_dec_and_test(atomic64_t *v)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		LOCK_PREFIX "decq %0; sete %1"
-		:"=m" (v->counter), "=qm" (c)
-		:"m" (v->counter) : "memory");
+	asm volatile(LOCK_PREFIX "decq %0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "m" (v->counter) : "memory");
 	return c != 0;
 }
 
@@ -333,14 +322,13 @@ static __inline__ int atomic64_dec_and_test(atomic64_t *v)
  * and returns true if the result is zero, or false for all
  * other cases.
  */
-static __inline__ int atomic64_inc_and_test(atomic64_t *v)
+static inline int atomic64_inc_and_test(atomic64_t *v)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		LOCK_PREFIX "incq %0; sete %1"
-		:"=m" (v->counter), "=qm" (c)
-		:"m" (v->counter) : "memory");
+	asm volatile(LOCK_PREFIX "incq %0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "m" (v->counter) : "memory");
 	return c != 0;
 }
 
@@ -353,14 +341,13 @@ static __inline__ int atomic64_inc_and_test(atomic64_t *v)
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
-static __inline__ int atomic64_add_negative(long i, atomic64_t *v)
+static inline int atomic64_add_negative(long i, atomic64_t *v)
 {
 	unsigned char c;
 
-	__asm__ __volatile__(
-		LOCK_PREFIX "addq %2,%0; sets %1"
-		:"=m" (v->counter), "=qm" (c)
-		:"ir" (i), "m" (v->counter) : "memory");
+	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "ir" (i), "m" (v->counter) : "memory");
 	return c;
 }
 
@@ -371,29 +358,28 @@ static __inline__ int atomic64_add_negative(long i, atomic64_t *v)
  *
  * Atomically adds @i to @v and returns @i + @v
  */
-static __inline__ long atomic64_add_return(long i, atomic64_t *v)
+static inline long atomic64_add_return(long i, atomic64_t *v)
 {
 	long __i = i;
-	__asm__ __volatile__(
-		LOCK_PREFIX "xaddq %0, %1;"
-		:"+r" (i), "+m" (v->counter)
-		: : "memory");
+	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
+		     : "+r" (i), "+m" (v->counter)
+		     : : "memory");
 	return i + __i;
 }
 
-static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
+static inline long atomic64_sub_return(long i, atomic64_t *v)
 {
-	return atomic64_add_return(-i,v);
+	return atomic64_add_return(-i, v);
 }
 
-#define atomic64_inc_return(v)  (atomic64_add_return(1,v))
-#define atomic64_dec_return(v)  (atomic64_sub_return(1,v))
+#define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
+#define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
 
-#define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
+#define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
+#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
 
 /**
  * atomic_add_unless - add unless the number is a given value
@@ -404,7 +390,7 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
 	c = atomic_read(v);
@@ -430,7 +416,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
 	long c, old;
 	c = atomic64_read(v);
@@ -448,13 +434,14 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 /* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr) \
-__asm__ __volatile__(LOCK_PREFIX "andl %0,%1" \
-: : "r" (~(mask)),"m" (*addr) : "memory")
-
-#define atomic_set_mask(mask, addr) \
-__asm__ __volatile__(LOCK_PREFIX "orl %0,%1" \
-: : "r" ((unsigned)mask),"m" (*(addr)) : "memory")
+#define atomic_clear_mask(mask, addr)					\
+	asm volatile(LOCK_PREFIX "andl %0,%1"				\
+		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
+
+#define atomic_set_mask(mask, addr)					\
+	asm volatile(LOCK_PREFIX "orl %0,%1"				\
+		     : : "r" ((unsigned)(mask)), "m" (*(addr))		\
+		     : "memory")
 
 /* Atomic operations are already serializing on x86 */
 #define smp_mb__before_atomic_dec()	barrier()
-- 
1.5.4.rc2

