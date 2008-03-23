Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYCWIIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYCWIIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYCWIHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:33 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1887 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYCWIHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:30 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 010/148] include/asm-x86/bitops.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:45 -0700
Message-Id: <1206259443-13210-11-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/bitops.h |   95 ++++++++++++++++++++--------------------------
 1 files changed, 41 insertions(+), 54 deletions(-)

diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index d10c501..a66143a 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -23,13 +23,13 @@
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
 /* Technically wrong, but this avoids compilation errors on some gcc
    versions. */
-#define ADDR "=m" (*(volatile long *) addr)
-#define BIT_ADDR "=m" (((volatile int *) addr)[nr >> 5])
+#define ADDR "=m" (*(volatile long *)addr)
+#define BIT_ADDR "=m" (((volatile int *)addr)[nr >> 5])
 #else
 #define ADDR "+m" (*(volatile long *) addr)
-#define BIT_ADDR "+m" (((volatile int *) addr)[nr >> 5])
+#define BIT_ADDR "+m" (((volatile int *)addr)[nr >> 5])
 #endif
-#define BASE_ADDR "m" (*(volatile int *) addr)
+#define BASE_ADDR "m" (*(volatile int *)addr)
 
 /**
  * set_bit - Atomically set a bit in memory
@@ -48,9 +48,7 @@
  */
 static inline void set_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "bts %1,%0"
-		     : ADDR
-		     : "Ir" (nr) : "memory");
+	asm volatile(LOCK_PREFIX "bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
 
 /**
@@ -64,9 +62,7 @@ static inline void set_bit(int nr, volatile void *addr)
  */
 static inline void __set_bit(int nr, volatile void *addr)
 {
-	asm volatile("bts %1,%0"
-		     : ADDR
-		     : "Ir" (nr) : "memory");
+	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
 
 /**
@@ -81,8 +77,7 @@ static inline void __set_bit(int nr, volatile void *addr)
  */
 static inline void clear_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "btr %1,%2"
-		     : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile(LOCK_PREFIX "btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
 }
 
 /*
@@ -150,8 +145,7 @@ static inline void __change_bit(int nr, volatile void *addr)
  */
 static inline void change_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "btc %1,%2"
-		     : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile(LOCK_PREFIX "btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
 }
 
 /**
@@ -167,9 +161,7 @@ static inline int test_and_set_bit(int nr, volatile void *addr)
 	int oldbit;
 
 	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR
-		     : "Ir" (nr) : "memory");
+		     "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
 
 	return oldbit;
 }
@@ -201,8 +193,7 @@ static inline int __test_and_set_bit(int nr, volatile void *addr)
 
 	asm volatile("bts %2,%3\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR
-		     : "Ir" (nr), BASE_ADDR);
+		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
 	return oldbit;
 }
 
@@ -220,8 +211,7 @@ static inline int test_and_clear_bit(int nr, volatile void *addr)
 
 	asm volatile(LOCK_PREFIX "btr %2,%1\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR
-		     : "Ir" (nr) : "memory");
+		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
 
 	return oldbit;
 }
@@ -241,8 +231,7 @@ static inline int __test_and_clear_bit(int nr, volatile void *addr)
 
 	asm volatile("btr %2,%3\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR
-		     : "Ir" (nr), BASE_ADDR);
+		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
 	return oldbit;
 }
 
@@ -253,8 +242,7 @@ static inline int __test_and_change_bit(int nr, volatile void *addr)
 
 	asm volatile("btc %2,%3\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR
-		     : "Ir" (nr), BASE_ADDR);
+		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
 
 	return oldbit;
 }
@@ -273,8 +261,7 @@ static inline int test_and_change_bit(int nr, volatile void *addr)
 
 	asm volatile(LOCK_PREFIX "btc %2,%1\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR
-		     : "Ir" (nr) : "memory");
+		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
 
 	return oldbit;
 }
@@ -307,10 +294,10 @@ static inline int variable_test_bit(int nr, volatile const void *addr)
 static int test_bit(int nr, const volatile unsigned long *addr);
 #endif
 
-#define test_bit(nr,addr)			\
-	(__builtin_constant_p(nr) ?		\
-	 constant_test_bit((nr),(addr)) :	\
-	 variable_test_bit((nr),(addr)))
+#define test_bit(nr, addr)			\
+	(__builtin_constant_p((nr))		\
+	 ? constant_test_bit((nr), (addr))	\
+	 : variable_test_bit((nr), (addr)))
 
 /**
  * __ffs - find first set bit in word
@@ -320,9 +307,9 @@ static int test_bit(int nr, const volatile unsigned long *addr);
  */
 static inline unsigned long __ffs(unsigned long word)
 {
-	__asm__("bsf %1,%0"
-		:"=r" (word)
-		:"rm" (word));
+	asm("bsf %1,%0"
+		: "=r" (word)
+		: "rm" (word));
 	return word;
 }
 
@@ -334,9 +321,9 @@ static inline unsigned long __ffs(unsigned long word)
  */
 static inline unsigned long ffz(unsigned long word)
 {
-	__asm__("bsf %1,%0"
-		:"=r" (word)
-		:"r" (~word));
+	asm("bsf %1,%0"
+		: "=r" (word)
+		: "r" (~word));
 	return word;
 }
 
@@ -348,9 +335,9 @@ static inline unsigned long ffz(unsigned long word)
  */
 static inline unsigned long __fls(unsigned long word)
 {
-	__asm__("bsr %1,%0"
-		:"=r" (word)
-		:"rm" (word));
+	asm("bsr %1,%0"
+	    : "=r" (word)
+	    : "rm" (word));
 	return word;
 }
 
@@ -370,14 +357,14 @@ static inline int ffs(int x)
 {
 	int r;
 #ifdef CONFIG_X86_CMOV
-	__asm__("bsfl %1,%0\n\t"
-		"cmovzl %2,%0"
-		: "=r" (r) : "rm" (x), "r" (-1));
+	asm("bsfl %1,%0\n\t"
+	    "cmovzl %2,%0"
+	    : "=r" (r) : "rm" (x), "r" (-1));
 #else
-	__asm__("bsfl %1,%0\n\t"
-		"jnz 1f\n\t"
-		"movl $-1,%0\n"
-		"1:" : "=r" (r) : "rm" (x));
+	asm("bsfl %1,%0\n\t"
+	    "jnz 1f\n\t"
+	    "movl $-1,%0\n"
+	    "1:" : "=r" (r) : "rm" (x));
 #endif
 	return r + 1;
 }
@@ -397,14 +384,14 @@ static inline int fls(int x)
 {
 	int r;
 #ifdef CONFIG_X86_CMOV
-	__asm__("bsrl %1,%0\n\t"
-		"cmovzl %2,%0"
-		: "=&r" (r) : "rm" (x), "rm" (-1));
+	asm("bsrl %1,%0\n\t"
+	    "cmovzl %2,%0"
+	    : "=&r" (r) : "rm" (x), "rm" (-1));
 #else
-	__asm__("bsrl %1,%0\n\t"
-		"jnz 1f\n\t"
-		"movl $-1,%0\n"
-		"1:" : "=r" (r) : "rm" (x));
+	asm("bsrl %1,%0\n\t"
+	    "jnz 1f\n\t"
+	    "movl $-1,%0\n"
+	    "1:" : "=r" (r) : "rm" (x));
 #endif
 	return r + 1;
 }
-- 
1.5.4.rc2

