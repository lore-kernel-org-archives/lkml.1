Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbYCWIqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbYCWIqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbYCWILH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:07 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2321 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759459AbYCWILF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:05 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 078/148] include/asm-x86/mutex_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:53 -0700
Message-Id: <1206259443-13210-79-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mutex_32.h |   64 ++++++++++++++++++++-----------------------
 1 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/include/asm-x86/mutex_32.h b/include/asm-x86/mutex_32.h
index 9a6b3da..73e928e 100644
--- a/include/asm-x86/mutex_32.h
+++ b/include/asm-x86/mutex_32.h
@@ -21,22 +21,20 @@
  * wasn't 1 originally. This function MUST leave the value lower than 1
  * even when the "1" assertion wasn't true.
  */
-#define __mutex_fastpath_lock(count, fail_fn)				\
-do {									\
-	unsigned int dummy;						\
-									\
-	typecheck(atomic_t *, count);					\
+#define __mutex_fastpath_lock(count, fail_fn)			\
+do {								\
+	unsigned int dummy;					\
+								\
+	typecheck(atomic_t *, count);				\
 	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
-									\
-	__asm__ __volatile__(						\
-		LOCK_PREFIX "   decl (%%eax)	\n"			\
-			"   jns 1f		\n"			\
-			"   call "#fail_fn"	\n"			\
-			"1:			\n"			\
-									\
-		:"=a" (dummy)						\
-		: "a" (count)						\
-		: "memory", "ecx", "edx");				\
+								\
+	asm volatile(LOCK_PREFIX "   decl (%%eax)\n"		\
+		     "   jns 1f	\n"				\
+		     "   call " #fail_fn "\n"			\
+		     "1:\n"					\
+		     : "=a" (dummy)				\
+		     : "a" (count)				\
+		     : "memory", "ecx", "edx");			\
 } while (0)
 
 
@@ -50,8 +48,8 @@ do {									\
  * wasn't 1 originally. This function returns 0 if the fastpath succeeds,
  * or anything the slow path function returns
  */
-static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
+static inline int __mutex_fastpath_lock_retval(atomic_t *count,
+					       int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
@@ -72,22 +70,20 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
  * __mutex_slowpath_needs_to_unlock() macro needs to return 1, it needs
  * to return 0 otherwise.
  */
-#define __mutex_fastpath_unlock(count, fail_fn)				\
-do {									\
-	unsigned int dummy;						\
-									\
-	typecheck(atomic_t *, count);					\
+#define __mutex_fastpath_unlock(count, fail_fn)			\
+do {								\
+	unsigned int dummy;					\
+								\
+	typecheck(atomic_t *, count);				\
 	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
-									\
-	__asm__ __volatile__(						\
-		LOCK_PREFIX "   incl (%%eax)	\n"			\
-			"   jg	1f		\n"			\
-			"   call "#fail_fn"	\n"			\
-			"1:			\n"			\
-									\
-		:"=a" (dummy)						\
-		: "a" (count)						\
-		: "memory", "ecx", "edx");				\
+								\
+	asm volatile(LOCK_PREFIX "   incl (%%eax)\n"		\
+		     "   jg	1f\n"				\
+		     "   call " #fail_fn "\n"			\
+		     "1:\n"					\
+		     : "=a" (dummy)				\
+		     : "a" (count)				\
+		     : "memory", "ecx", "edx");			\
 } while (0)
 
 #define __mutex_slowpath_needs_to_unlock()	1
@@ -104,8 +100,8 @@ do {									\
  * Additionally, if the value was < 0 originally, this function must not leave
  * it to 0 on failure.
  */
-static inline int
-__mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
+static inline int __mutex_fastpath_trylock(atomic_t *count,
+					   int (*fail_fn)(atomic_t *))
 {
 	/*
 	 * We have two variants here. The cmpxchg based one is the best one
-- 
1.5.4.rc2

