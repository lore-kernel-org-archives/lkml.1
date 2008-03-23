Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbYCWINS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbYCWINS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758896AbYCWIIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:07 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2234 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbYCWIIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:05 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 017/148] include/asm-x86/cmpxchg_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:52 -0700
Message-Id: <1206259443-13210-18-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/cmpxchg_64.h |  134 +++++++++++++++++++++--------------------
 1 files changed, 69 insertions(+), 65 deletions(-)

diff --git a/include/asm-x86/cmpxchg_64.h b/include/asm-x86/cmpxchg_64.h
index 56f5b41..d9b26b9 100644
--- a/include/asm-x86/cmpxchg_64.h
+++ b/include/asm-x86/cmpxchg_64.h
@@ -3,7 +3,8 @@
 
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
-#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
+#define xchg(ptr, v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v), \
+						 (ptr), sizeof(*(ptr))))
 
 #define __xg(x) ((volatile long *)(x))
 
@@ -19,33 +20,34 @@ static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
  * Note 2: xchg has side effect, so that attribute volatile is necessary,
  *	  but generally the primitive is invalid, *ptr is output argument. --ANK
  */
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+				   int size)
 {
 	switch (size) {
-		case 1:
-			__asm__ __volatile__("xchgb %b0,%1"
-				:"=q" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 2:
-			__asm__ __volatile__("xchgw %w0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 4:
-			__asm__ __volatile__("xchgl %k0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 8:
-			__asm__ __volatile__("xchgq %0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
+	case 1:
+		asm volatile("xchgb %b0,%1"
+			     : "=q" (x)
+			     : "m" (*__xg(ptr)), "0" (x)
+			     : "memory");
+		break;
+	case 2:
+		asm volatile("xchgw %w0,%1"
+			     : "=r" (x)
+			     : "m" (*__xg(ptr)), "0" (x)
+			     : "memory");
+		break;
+	case 4:
+		asm volatile("xchgl %k0,%1"
+			     : "=r" (x)
+			     : "m" (*__xg(ptr)), "0" (x)
+			     : "memory");
+		break;
+	case 8:
+		asm volatile("xchgq %0,%1"
+			     : "=r" (x)
+			     : "m" (*__xg(ptr)), "0" (x)
+			     : "memory");
+		break;
 	}
 	return x;
 }
@@ -64,61 +66,62 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
+			     : "=a"(prev)
+			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 2:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 4:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %k1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 8:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgq %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	}
 	return old;
 }
 
 static inline unsigned long __cmpxchg_local(volatile void *ptr,
-			unsigned long old, unsigned long new, int size)
+					    unsigned long old,
+					    unsigned long new, int size)
 {
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		__asm__ __volatile__("cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("cmpxchgb %b1,%2"
+			     : "=a"(prev)
+			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 2:
-		__asm__ __volatile__("cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("cmpxchgw %w1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 4:
-		__asm__ __volatile__("cmpxchgl %k1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("cmpxchgl %k1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	case 8:
-		__asm__ __volatile__("cmpxchgq %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
+		asm volatile("cmpxchgq %1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
 		return prev;
 	}
 	return old;
@@ -126,19 +129,20 @@ static inline unsigned long __cmpxchg_local(volatile void *ptr,
 
 #define cmpxchg(ptr, o, n)						\
 	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
-					(unsigned long)(n), sizeof(*(ptr))))
+				       (unsigned long)(n), sizeof(*(ptr))))
 #define cmpxchg64(ptr, o, n)						\
-  ({									\
+({									\
 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
 	cmpxchg((ptr), (o), (n));					\
-  })
+})
 #define cmpxchg_local(ptr, o, n)					\
 	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-					(unsigned long)(n), sizeof(*(ptr))))
+					     (unsigned long)(n),	\
+					     sizeof(*(ptr))))
 #define cmpxchg64_local(ptr, o, n)					\
-  ({									\
+({									\
 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
 	cmpxchg_local((ptr), (o), (n));					\
-  })
+})
 
 #endif
-- 
1.5.4.rc2

