Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbZBYEuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbZBYEuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbZBYEt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:49:57 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:20808 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760024AbZBYEt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:49:56 -0500
Date: Tue, 24 Feb 2009 20:51:59 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250451.UAA12881@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 12/15] bitops: Change the bitmap index from int to unsigned long [sh]
Cc: bjorn.helgaas@hp.com, justin.chen@hp.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [sh]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/sh/include/asm/bitops-grb.h  |   12 ++++++------
 arch/sh/include/asm/bitops-llsc.h |   12 ++++++------
 arch/sh/include/asm/bitops-op32.h |   19 +++++++++++--------
 3 files changed, 23 insertions(+), 20 deletions(-)
diff -Nru a/arch/sh/include/asm/bitops-grb.h b/arch/sh/include/asm/bitops-grb.h
--- a/arch/sh/include/asm/bitops-grb.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/sh/include/asm/bitops-grb.h	2009-02-15 18:19:39.785228522 -0800
@@ -1,7 +1,7 @@
 #ifndef __ASM_SH_BITOPS_GRB_H
 #define __ASM_SH_BITOPS_GRB_H
 
-static inline void set_bit(int nr, volatile void * addr)
+static inline void set_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask;
 	volatile unsigned int *a = addr;
@@ -25,7 +25,7 @@
                 : "memory" , "r0", "r1");
 }
 
-static inline void clear_bit(int nr, volatile void * addr)
+static inline void clear_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask;
 	volatile unsigned int *a = addr;
@@ -48,7 +48,7 @@
                 : "memory" , "r0", "r1");
 }
 
-static inline void change_bit(int nr, volatile void * addr)
+static inline void change_bit(unsigned long nr, volatile void *addr)
 {
         int     mask;
         volatile unsigned int *a = addr;
@@ -71,7 +71,7 @@
                 : "memory" , "r0", "r1");
 }
 
-static inline int test_and_set_bit(int nr, volatile void * addr)
+static inline int test_and_set_bit(unsigned long nr, volatile void *addr)
 {
         int     mask, retval;
 	volatile unsigned int *a = addr;
@@ -102,7 +102,7 @@
         return retval;
 }
 
-static inline int test_and_clear_bit(int nr, volatile void * addr)
+static inline int test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
         int     mask, retval,not_mask;
         volatile unsigned int *a = addr;
@@ -136,7 +136,7 @@
         return retval;
 }
 
-static inline int test_and_change_bit(int nr, volatile void * addr)
+static inline int test_and_change_bit(unsigned long nr, volatile void *addr)
 {
         int     mask, retval;
         volatile unsigned int *a = addr;
diff -Nru a/arch/sh/include/asm/bitops-llsc.h b/arch/sh/include/asm/bitops-llsc.h
--- a/arch/sh/include/asm/bitops-llsc.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/sh/include/asm/bitops-llsc.h	2009-02-15 18:19:39.785228522 -0800
@@ -1,7 +1,7 @@
 #ifndef __ASM_SH_BITOPS_LLSC_H
 #define __ASM_SH_BITOPS_LLSC_H
 
-static inline void set_bit(int nr, volatile void * addr)
+static inline void set_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask;
 	volatile unsigned int *a = addr;
@@ -22,7 +22,7 @@
 	);
 }
 
-static inline void clear_bit(int nr, volatile void * addr)
+static inline void clear_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask;
 	volatile unsigned int *a = addr;
@@ -43,7 +43,7 @@
 	);
 }
 
-static inline void change_bit(int nr, volatile void * addr)
+static inline void change_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask;
 	volatile unsigned int *a = addr;
@@ -64,7 +64,7 @@
 	);
 }
 
-static inline int test_and_set_bit(int nr, volatile void * addr)
+static inline int test_and_set_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask, retval;
 	volatile unsigned int *a = addr;
@@ -89,7 +89,7 @@
 	return retval != 0;
 }
 
-static inline int test_and_clear_bit(int nr, volatile void * addr)
+static inline int test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask, retval;
 	volatile unsigned int *a = addr;
@@ -115,7 +115,7 @@
 	return retval != 0;
 }
 
-static inline int test_and_change_bit(int nr, volatile void * addr)
+static inline int test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask, retval;
 	volatile unsigned int *a = addr;
diff -Nru a/arch/sh/include/asm/bitops-op32.h b/arch/sh/include/asm/bitops-op32.h
--- a/arch/sh/include/asm/bitops-op32.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/sh/include/asm/bitops-op32.h	2009-02-15 18:19:39.786205084 -0800
@@ -17,7 +17,7 @@
 
 #define IS_IMMEDIATE(nr)	(__builtin_constant_p(nr))
 
-static inline void __set_bit(int nr, volatile unsigned long *addr)
+static inline void __set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		__asm__ __volatile__ (
@@ -34,7 +34,7 @@
 	}
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
+static inline void __clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		__asm__ __volatile__ (
@@ -61,7 +61,7 @@
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long *addr)
+static inline void __change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		__asm__ __volatile__ (
@@ -88,7 +88,8 @@
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int
+__test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -107,7 +108,8 @@
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int
+__test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -118,8 +120,8 @@
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr,
-					    volatile unsigned long *addr)
+static inline int
+__test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -134,7 +136,8 @@
  * @nr: bit number to test
  * @addr: Address to start counting from
  */
-static inline int test_bit(int nr, const volatile unsigned long *addr)
+static inline int
+test_bit(unsigned long nr, const volatile unsigned long *addr)
 {
 	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
