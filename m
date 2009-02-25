Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbZBYEmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbZBYEmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZBYEm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:42:29 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42004 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZBYEm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:42:28 -0500
Date: Tue, 24 Feb 2009 20:44:31 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250444.UAA12610@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 04/15] bitops: Change the bitmap index from int to unsigned long [blackfin]
Cc: bjorn.helgaas@hp.com, cooloney@kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [blackfin]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/blackfin/include/asm/bitops.h |   74 ++++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 29 deletions(-)
diff -Nru a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
--- a/arch/blackfin/include/asm/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/blackfin/include/asm/bitops.h	2009-02-15 18:19:39.770580084 -0800
@@ -23,57 +23,68 @@
 
 #include <linux/linkage.h>
 
-asmlinkage int __raw_bit_set_asm(volatile unsigned long *addr, int nr);
+asmlinkage int
+__raw_bit_set_asm(volatile unsigned long *addr, unsigned long nr);
 
-asmlinkage int __raw_bit_clear_asm(volatile unsigned long *addr, int nr);
+asmlinkage int
+__raw_bit_clear_asm(volatile unsigned long *addr, unsigned long nr);
 
-asmlinkage int __raw_bit_toggle_asm(volatile unsigned long *addr, int nr);
+asmlinkage int
+__raw_bit_toggle_asm(volatile unsigned long *addr, unsigned long nr);
 
-asmlinkage int __raw_bit_test_set_asm(volatile unsigned long *addr, int nr);
+asmlinkage int
+__raw_bit_test_set_asm(volatile unsigned long *addr, unsigned long nr);
 
-asmlinkage int __raw_bit_test_clear_asm(volatile unsigned long *addr, int nr);
+asmlinkage int
+__raw_bit_test_clear_asm(volatile unsigned long *addr, unsigned long nr);
 
-asmlinkage int __raw_bit_test_toggle_asm(volatile unsigned long *addr, int nr);
+asmlinkage int
+__raw_bit_test_toggle_asm(volatile unsigned long *addr, unsigned long nr);
 
-asmlinkage int __raw_bit_test_asm(const volatile unsigned long *addr, int nr);
+asmlinkage int
+__raw_bit_test_asm(const volatile unsigned long *addr, unsigned long nr);
 
-static inline void set_bit(int nr, volatile unsigned long *addr)
+static inline void set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr + (nr >> 5);
 	__raw_bit_set_asm(a, nr & 0x1f);
 }
 
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static inline void clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr + (nr >> 5);
 	__raw_bit_clear_asm(a, nr & 0x1f);
 }
 
-static inline void change_bit(int nr, volatile unsigned long *addr)
+static inline void change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr + (nr >> 5);
 	__raw_bit_toggle_asm(a, nr & 0x1f);
 }
 
-static inline int test_bit(int nr, const volatile unsigned long *addr)
+static inline int
+test_bit(unsigned long nr, const volatile unsigned long *addr)
 {
 	volatile const unsigned long *a = addr + (nr >> 5);
 	return __raw_bit_test_asm(a, nr & 0x1f) != 0;
 }
 
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr + (nr >> 5);
 	return __raw_bit_test_set_asm(a, nr & 0x1f);
 }
 
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr + (nr >> 5);
 	return __raw_bit_test_clear_asm(a, nr & 0x1f);
 }
 
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	volatile unsigned long *a = addr + (nr >> 5);
 	return __raw_bit_test_toggle_asm(a, nr & 0x1f);
@@ -83,7 +94,7 @@
 
 #include <asm/system.h>		/* save_flags */
 
-static inline void set_bit(int nr, volatile unsigned long *addr)
+static inline void set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int *a = (int *)addr;
 	int mask;
@@ -95,7 +106,7 @@
 	local_irq_restore_hw(flags);
 }
 
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static inline void clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int *a = (int *)addr;
 	int mask;
@@ -107,7 +118,7 @@
 	local_irq_restore_hw(flags);
 }
 
-static inline void change_bit(int nr, volatile unsigned long *addr)
+static inline void change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int mask, flags;
 	unsigned long *ADDR = (unsigned long *)addr;
@@ -119,7 +130,8 @@
 	local_irq_restore_hw(flags);
 }
 
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -135,7 +147,8 @@
 	return retval;
 }
 
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -151,7 +164,8 @@
 	return retval;
 }
 
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -174,7 +188,7 @@
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
-static inline void __set_bit(int nr, volatile unsigned long *addr)
+static inline void __set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int *a = (int *)addr;
 	int mask;
@@ -184,7 +198,7 @@
 	*a |= mask;
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
+static inline void __clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int *a = (int *)addr;
 	int mask;
@@ -194,7 +208,7 @@
 	*a &= ~mask;
 }
 
-static inline void __change_bit(int nr, volatile unsigned long *addr)
+static inline void __change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int mask;
 	unsigned long *ADDR = (unsigned long *)addr;
@@ -204,7 +218,8 @@
 	*ADDR ^= mask;
 }
 
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int
+__test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -216,7 +231,8 @@
 	return retval;
 }
 
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int
+__test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -228,8 +244,8 @@
 	return retval;
 }
 
-static inline int __test_and_change_bit(int nr,
-					    volatile unsigned long *addr)
+static inline int
+__test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	int mask, retval;
 	volatile unsigned int *a = (volatile unsigned int *)addr;
@@ -241,7 +257,7 @@
 	return retval;
 }
 
-static inline int __test_bit(int nr, const void *addr)
+static inline int __test_bit(unsigned long nr, const void *addr)
 {
 	int *a = (int *)addr;
 	int mask;
@@ -256,7 +272,7 @@
  * This routine doesn't need irq save and restore ops in UP
  * context.
  */
-static inline int test_bit(int nr, const void *addr)
+static inline int test_bit(unsigned long nr, const void *addr)
 {
 	return __test_bit(nr, addr);
 }
