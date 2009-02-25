Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbZBYEsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbZBYEsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757639AbZBYEsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:48:36 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:8708 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbZBYEse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:48:34 -0500
Date: Tue, 24 Feb 2009 20:50:38 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250450.UAA12841@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 08/15] bitops: Change the bitmap index from int to unsigned long [m68k]
Cc: bjorn.helgaas@hp.com, geert@linux-m68k.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [m68k]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/m68k/include/asm/bitops_mm.h |   41 ++++++++++++++++++++++++++---------------
 arch/m68k/include/asm/bitops_no.h |   22 +++++++++++-----------
 2 files changed, 60 insertions(+), 37 deletions(-)
diff -Nru a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h	2009-02-22 20:19:40.000000000 -0800
+++ b/arch/m68k/include/asm/bitops_mm.h	2009-02-24 13:52:37.000000000 -0800
@@ -27,7 +27,8 @@
 
 #define __test_and_set_bit(nr,vaddr) test_and_set_bit(nr,vaddr)
 
-static inline int __constant_test_and_set_bit(int nr, unsigned long *vaddr)
+static inline int __constant_test_and_set_bit(unsigned long nr,
+					      unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	char retval;
@@ -39,7 +40,8 @@
 	return retval;
 }
 
-static inline int __generic_test_and_set_bit(int nr, unsigned long *vaddr)
+static inline int __generic_test_and_set_bit(unsigned long nr,
+					     unsigned long *vaddr)
 {
 	char retval;
 
@@ -56,14 +58,16 @@
 
 #define __set_bit(nr,vaddr) set_bit(nr,vaddr)
 
-static inline void __constant_set_bit(int nr, volatile unsigned long *vaddr)
+static inline void __constant_set_bit(unsigned long nr,
+				      volatile unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	__asm__ __volatile__ ("bset %1,%0"
 			: "+m" (*p) : "di" (nr & 7));
 }
 
-static inline void __generic_set_bit(int nr, volatile unsigned long *vaddr)
+static inline void __generic_set_bit(unsigned long nr,
+				     volatile unsigned long *vaddr)
 {
 	__asm__ __volatile__ ("bfset %1{%0:#1}"
 			: : "d" (nr^31), "o" (*vaddr) : "memory");
@@ -76,7 +80,8 @@
 
 #define __test_and_clear_bit(nr,vaddr) test_and_clear_bit(nr,vaddr)
 
-static inline int __constant_test_and_clear_bit(int nr, unsigned long *vaddr)
+static inline int __constant_test_and_clear_bit(unsigned long nr,
+						unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	char retval;
@@ -88,7 +93,8 @@
 	return retval;
 }
 
-static inline int __generic_test_and_clear_bit(int nr, unsigned long *vaddr)
+static inline int __generic_test_and_clear_bit(unsigned long nr,
+					       unsigned long *vaddr)
 {
 	char retval;
 
@@ -110,14 +116,16 @@
    __generic_clear_bit(nr, vaddr))
 #define __clear_bit(nr,vaddr) clear_bit(nr,vaddr)
 
-static inline void __constant_clear_bit(int nr, volatile unsigned long *vaddr)
+static inline void __constant_clear_bit(unsigned long nr,
+					volatile unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	__asm__ __volatile__ ("bclr %1,%0"
 			: "+m" (*p) : "di" (nr & 7));
 }
 
-static inline void __generic_clear_bit(int nr, volatile unsigned long *vaddr)
+static inline void __generic_clear_bit(unsigned long nr,
+				       volatile unsigned long *vaddr)
 {
 	__asm__ __volatile__ ("bfclr %1{%0:#1}"
 			: : "d" (nr^31), "o" (*vaddr) : "memory");
@@ -131,7 +139,8 @@
 #define __test_and_change_bit(nr,vaddr) test_and_change_bit(nr,vaddr)
 #define __change_bit(nr,vaddr) change_bit(nr,vaddr)
 
-static inline int __constant_test_and_change_bit(int nr, unsigned long *vaddr)
+static inline int __constant_test_and_change_bit(unsigned long nr,
+						 unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	char retval;
@@ -143,7 +152,8 @@
 	return retval;
 }
 
-static inline int __generic_test_and_change_bit(int nr, unsigned long *vaddr)
+static inline int __generic_test_and_change_bit(unsigned long nr,
+						unsigned long *vaddr)
 {
 	char retval;
 
@@ -158,20 +168,21 @@
    __constant_change_bit(nr, vaddr) : \
    __generic_change_bit(nr, vaddr))
 
-static inline void __constant_change_bit(int nr, unsigned long *vaddr)
+static inline void __constant_change_bit(unsigned long nr,
+					 unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;
 	__asm__ __volatile__ ("bchg %1,%0"
 			: "+m" (*p) : "di" (nr & 7));
 }
 
-static inline void __generic_change_bit(int nr, unsigned long *vaddr)
+static inline void __generic_change_bit(unsigned long nr, unsigned long *vaddr)
 {
 	__asm__ __volatile__ ("bfchg %1{%0:#1}"
 			: : "d" (nr^31), "o" (*vaddr) : "memory");
 }
 
-static inline int test_bit(int nr, const unsigned long *vaddr)
+static inline int test_bit(unsigned long nr, const unsigned long *vaddr)
 {
 	return (vaddr[nr >> 5] & (1UL << (nr & 31))) != 0;
 }
@@ -353,7 +364,7 @@
 #define minix_set_bit(nr,addr)			__set_bit((nr) ^ 16, (unsigned long *)(addr))
 #define minix_test_and_clear_bit(nr, addr)	__test_and_clear_bit((nr) ^ 16, (unsigned long *)(addr))
 
-static inline int minix_test_bit(int nr, const void *vaddr)
+static inline int minix_test_bit(unsigned long nr, const void *vaddr)
 {
 	const unsigned short *p = vaddr;
 	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
@@ -366,7 +377,7 @@
 #define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
 #define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
 
-static inline int ext2_test_bit(int nr, const void *vaddr)
+static inline int ext2_test_bit(unsigned long nr, const void *vaddr)
 {
 	const unsigned char *p = vaddr;
 	return (p[nr >> 3] & (1U << (nr & 7))) != 0;
diff -Nru a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h	2009-02-22 20:19:40.000000000 -0800
+++ b/arch/m68k/include/asm/bitops_no.h	2009-02-24 13:55:21.000000000 -0800
@@ -49,7 +49,7 @@
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffz.h>
 
-static __inline__ void set_bit(int nr, volatile unsigned long * addr)
+static __inline__ void set_bit(unsigned long nr, volatile unsigned long * addr)
 {
 #ifdef CONFIG_COLDFIRE
 	__asm__ __volatile__ ("lea %0,%%a0; bset %1,(%%a0)"
@@ -72,7 +72,7 @@
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
-static __inline__ void clear_bit(int nr, volatile unsigned long * addr)
+static __inline__ void clear_bit(unsigned long nr, volatile unsigned long * addr)
 {
 #ifdef CONFIG_COLDFIRE
 	__asm__ __volatile__ ("lea %0,%%a0; bclr %1,(%%a0)"
@@ -89,7 +89,7 @@
 
 #define __clear_bit(nr, addr) clear_bit(nr, addr)
 
-static __inline__ void change_bit(int nr, volatile unsigned long * addr)
+static __inline__ void change_bit(unsigned long nr, volatile unsigned long * addr)
 {
 #ifdef CONFIG_COLDFIRE
 	__asm__ __volatile__ ("lea %0,%%a0; bchg %1,(%%a0)"
@@ -106,7 +106,7 @@
 
 #define __change_bit(nr, addr) change_bit(nr, addr)
 
-static __inline__ int test_and_set_bit(int nr, volatile unsigned long * addr)
+static __inline__ int test_and_set_bit(unsigned long nr, volatile unsigned long * addr)
 {
 	char retval;
 
@@ -127,7 +127,7 @@
 
 #define __test_and_set_bit(nr, addr) test_and_set_bit(nr, addr)
 
-static __inline__ int test_and_clear_bit(int nr, volatile unsigned long * addr)
+static __inline__ int test_and_clear_bit(unsigned long nr, volatile unsigned long * addr)
 {
 	char retval;
 
@@ -148,7 +148,7 @@
 
 #define __test_and_clear_bit(nr, addr) test_and_clear_bit(nr, addr)
 
-static __inline__ int test_and_change_bit(int nr, volatile unsigned long * addr)
+static __inline__ int test_and_change_bit(unsigned long nr, volatile unsigned long * addr)
 {
 	char retval;
 
@@ -172,12 +172,12 @@
 /*
  * This routine doesn't need to be atomic.
  */
-static __inline__ int __constant_test_bit(int nr, const volatile unsigned long * addr)
+static __inline__ int __constant_test_bit(unsigned long nr, const volatile unsigned long * addr)
 {
 	return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr >> 5])) != 0;
 }
 
-static __inline__ int __test_bit(int nr, const volatile unsigned long * addr)
+static __inline__ int __test_bit(unsigned long nr, const volatile unsigned long * addr)
 {
 	int 	* a = (int *) addr;
 	int	mask;
@@ -196,7 +196,7 @@
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-static __inline__ int ext2_set_bit(int nr, volatile void * addr)
+static __inline__ int ext2_set_bit(unsigned long nr, volatile void * addr)
 {
 	char retval;
 
@@ -215,7 +215,7 @@
 	return retval;
 }
 
-static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
+static __inline__ int ext2_clear_bit(unsigned long nr, volatile void * addr)
 {
 	char retval;
 
@@ -252,7 +252,7 @@
 		ret;					\
 	})
 
-static __inline__ int ext2_test_bit(int nr, const volatile void * addr)
+static __inline__ int ext2_test_bit(unsigned long nr, const volatile void * addr)
 {
 	char retval;
 
