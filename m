Return-Path: <linux-kernel-owner+w=401wt.eu-S1764726AbYCWIhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764726AbYCWIhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759137AbYCWIKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:20 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2300 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759727AbYCWIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:15 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 123/148] include/asm-x86/sync_bitops.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:38 -0700
Message-Id: <1206259443-13210-124-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/sync_bitops.h |   56 ++++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/asm-x86/sync_bitops.h b/include/asm-x86/sync_bitops.h
index bc249f4..f1078a5 100644
--- a/include/asm-x86/sync_bitops.h
+++ b/include/asm-x86/sync_bitops.h
@@ -13,7 +13,7 @@
  * bit 0 is the LSB of addr; bit 32 is the LSB of (addr+1).
  */
 
-#define ADDR (*(volatile long *) addr)
+#define ADDR (*(volatile long *)addr)
 
 /**
  * sync_set_bit - Atomically set a bit in memory
@@ -26,12 +26,12 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void sync_set_bit(int nr, volatile unsigned long * addr)
+static inline void sync_set_bit(int nr, volatile unsigned long *addr)
 {
-	__asm__ __volatile__("lock; btsl %1,%0"
-			     :"+m" (ADDR)
-			     :"Ir" (nr)
-			     : "memory");
+	asm volatile("lock; btsl %1,%0"
+		     : "+m" (ADDR)
+		     : "Ir" (nr)
+		     : "memory");
 }
 
 /**
@@ -44,12 +44,12 @@ static inline void sync_set_bit(int nr, volatile unsigned long * addr)
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void sync_clear_bit(int nr, volatile unsigned long * addr)
+static inline void sync_clear_bit(int nr, volatile unsigned long *addr)
 {
-	__asm__ __volatile__("lock; btrl %1,%0"
-			     :"+m" (ADDR)
-			     :"Ir" (nr)
-			     : "memory");
+	asm volatile("lock; btrl %1,%0"
+		     : "+m" (ADDR)
+		     : "Ir" (nr)
+		     : "memory");
 }
 
 /**
@@ -61,12 +61,12 @@ static inline void sync_clear_bit(int nr, volatile unsigned long * addr)
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void sync_change_bit(int nr, volatile unsigned long * addr)
+static inline void sync_change_bit(int nr, volatile unsigned long *addr)
 {
-	__asm__ __volatile__("lock; btcl %1,%0"
-			     :"+m" (ADDR)
-			     :"Ir" (nr)
-			     : "memory");
+	asm volatile("lock; btcl %1,%0"
+		     : "+m" (ADDR)
+		     : "Ir" (nr)
+		     : "memory");
 }
 
 /**
@@ -77,13 +77,13 @@ static inline void sync_change_bit(int nr, volatile unsigned long * addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_set_bit(int nr, volatile unsigned long * addr)
+static inline int sync_test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	__asm__ __volatile__("lock; btsl %2,%1\n\tsbbl %0,%0"
-			     :"=r" (oldbit),"+m" (ADDR)
-			     :"Ir" (nr) : "memory");
+	asm volatile("lock; btsl %2,%1\n\tsbbl %0,%0"
+		     : "=r" (oldbit), "+m" (ADDR)
+		     : "Ir" (nr) : "memory");
 	return oldbit;
 }
 
@@ -95,13 +95,13 @@ static inline int sync_test_and_set_bit(int nr, volatile unsigned long * addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_clear_bit(int nr, volatile unsigned long * addr)
+static inline int sync_test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	__asm__ __volatile__("lock; btrl %2,%1\n\tsbbl %0,%0"
-			     :"=r" (oldbit),"+m" (ADDR)
-			     :"Ir" (nr) : "memory");
+	asm volatile("lock; btrl %2,%1\n\tsbbl %0,%0"
+		     : "=r" (oldbit), "+m" (ADDR)
+		     : "Ir" (nr) : "memory");
 	return oldbit;
 }
 
@@ -113,13 +113,13 @@ static inline int sync_test_and_clear_bit(int nr, volatile unsigned long * addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int sync_test_and_change_bit(int nr, volatile unsigned long* addr)
+static inline int sync_test_and_change_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	__asm__ __volatile__("lock; btcl %2,%1\n\tsbbl %0,%0"
-			     :"=r" (oldbit),"+m" (ADDR)
-			     :"Ir" (nr) : "memory");
+	asm volatile("lock; btcl %2,%1\n\tsbbl %0,%0"
+		     : "=r" (oldbit), "+m" (ADDR)
+		     : "Ir" (nr) : "memory");
 	return oldbit;
 }
 
-- 
1.5.4.rc2

