Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbYCWIYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbYCWIYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbYCWIJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:12 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2272 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758048AbYCWIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:10 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 079/148] include/asm-x86/mutex_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:54 -0700
Message-Id: <1206259443-13210-80-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mutex_64.h |   73 ++++++++++++++++++++-----------------------
 1 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/include/asm-x86/mutex_64.h b/include/asm-x86/mutex_64.h
index 6c2949a..f3fae9b 100644
--- a/include/asm-x86/mutex_64.h
+++ b/include/asm-x86/mutex_64.h
@@ -16,23 +16,21 @@
  *
  * Atomically decrements @v and calls <fail_fn> if the result is negative.
  */
-#define __mutex_fastpath_lock(v, fail_fn)				\
-do {									\
-	unsigned long dummy;						\
-									\
-	typecheck(atomic_t *, v);					\
-	typecheck_fn(void (*)(atomic_t *), fail_fn);			\
-									\
-	__asm__ __volatile__(						\
-		LOCK_PREFIX "   decl (%%rdi)	\n"			\
-			"   jns 1f		\n"			\
-			"   call "#fail_fn"	\n"			\
-			"1:"						\
-									\
-		:"=D" (dummy)						\
-		: "D" (v)						\
-		: "rax", "rsi", "rdx", "rcx",				\
-		  "r8", "r9", "r10", "r11", "memory");			\
+#define __mutex_fastpath_lock(v, fail_fn)			\
+do {								\
+	unsigned long dummy;					\
+								\
+	typecheck(atomic_t *, v);				\
+	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
+								\
+	asm volatile(LOCK_PREFIX "   decl (%%rdi)\n"		\
+		     "   jns 1f		\n"			\
+		     "   call " #fail_fn "\n"			\
+		     "1:"					\
+		     : "=D" (dummy)				\
+		     : "D" (v)					\
+		     : "rax", "rsi", "rdx", "rcx",		\
+		       "r8", "r9", "r10", "r11", "memory");	\
 } while (0)
 
 /**
@@ -45,9 +43,8 @@ do {									\
  * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
  * or anything the slow path function returns
  */
-static inline int
-__mutex_fastpath_lock_retval(atomic_t *count,
-			     int (*fail_fn)(atomic_t *))
+static inline int __mutex_fastpath_lock_retval(atomic_t *count,
+					       int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
@@ -62,23 +59,21 @@ __mutex_fastpath_lock_retval(atomic_t *count,
  *
  * Atomically increments @v and calls <fail_fn> if the result is nonpositive.
  */
-#define __mutex_fastpath_unlock(v, fail_fn)				\
-do {									\
-	unsigned long dummy;						\
-									\
-	typecheck(atomic_t *, v);					\
-	typecheck_fn(void (*)(atomic_t *), fail_fn);			\
-									\
-	__asm__ __volatile__(						\
-		LOCK_PREFIX "   incl (%%rdi)	\n"			\
-			"   jg 1f		\n"			\
-			"   call "#fail_fn"	\n"			\
-			"1:			  "			\
-									\
-		:"=D" (dummy)						\
-		: "D" (v)						\
-		: "rax", "rsi", "rdx", "rcx",				\
-		  "r8", "r9", "r10", "r11", "memory");			\
+#define __mutex_fastpath_unlock(v, fail_fn)			\
+do {								\
+	unsigned long dummy;					\
+								\
+	typecheck(atomic_t *, v);				\
+	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
+								\
+	asm volatile(LOCK_PREFIX "   incl (%%rdi)\n"		\
+		     "   jg 1f\n"				\
+		     "   call " #fail_fn "\n"			\
+		     "1:"					\
+		     : "=D" (dummy)				\
+		     : "D" (v)					\
+		     : "rax", "rsi", "rdx", "rcx",		\
+		       "r8", "r9", "r10", "r11", "memory");	\
 } while (0)
 
 #define __mutex_slowpath_needs_to_unlock()	1
@@ -93,8 +88,8 @@ do {									\
  * if it wasn't 1 originally. [the fallback function is never used on
  * x86_64, because all x86_64 CPUs have a CMPXCHG instruction.]
  */
-static inline int
-__mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
+static inline int __mutex_fastpath_trylock(atomic_t *count,
+					   int (*fail_fn)(atomic_t *))
 {
 	if (likely(atomic_cmpxchg(count, 1, 0) == 1))
 		return 1;
-- 
1.5.4.rc2

