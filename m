Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbZBYUCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbZBYUCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbZBYUCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:02:13 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:21940 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbZBYUCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:02:12 -0500
Date: Wed, 25 Feb 2009 12:03:45 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902252003.MAA12219@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 14/15 v2] bitops: Change the bitmap index from int to unsigned long [frv]
Cc: bjorn.helgaas@hp.com, dhowells@redhat.com, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to be unsigned long in all bitops for [frv]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 include/asm-frv/bitops.h |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)
diff -Nru a/include/asm-frv/bitops.h b/include/asm-frv/bitops.h
--- a/include/asm-frv/bitops.h	2009-02-22 20:19:40.000000000 -0800
+++ b/include/asm-frv/bitops.h	2009-02-25 11:29:20.000000000 -0800
@@ -112,7 +112,7 @@
 #define atomic_clear_mask(mask, v)	atomic_test_and_ANDNOT_mask((mask), (v))
 #define atomic_set_mask(mask, v)	atomic_test_and_OR_mask((mask), (v))
 
-static inline int test_and_clear_bit(int nr, volatile void *addr)
+static inline int test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *ptr = addr;
 	unsigned long mask = 1UL << (nr & 31);
@@ -120,7 +120,7 @@
 	return (atomic_test_and_ANDNOT_mask(mask, ptr) & mask) != 0;
 }
 
-static inline int test_and_set_bit(int nr, volatile void *addr)
+static inline int test_and_set_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *ptr = addr;
 	unsigned long mask = 1UL << (nr & 31);
@@ -128,7 +128,7 @@
 	return (atomic_test_and_OR_mask(mask, ptr) & mask) != 0;
 }
 
-static inline int test_and_change_bit(int nr, volatile void *addr)
+static inline int test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *ptr = addr;
 	unsigned long mask = 1UL << (nr & 31);
@@ -136,22 +136,22 @@
 	return (atomic_test_and_XOR_mask(mask, ptr) & mask) != 0;
 }
 
-static inline void clear_bit(int nr, volatile void *addr)
+static inline void clear_bit(unsigned long nr, volatile void *addr)
 {
 	test_and_clear_bit(nr, addr);
 }
 
-static inline void set_bit(int nr, volatile void *addr)
+static inline void set_bit(unsigned long nr, volatile void *addr)
 {
 	test_and_set_bit(nr, addr);
 }
 
-static inline void change_bit(int nr, volatile void * addr)
+static inline void change_bit(unsigned long nr, volatile void *addr)
 {
 	test_and_change_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile void * addr)
+static inline void __clear_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask;
@@ -161,7 +161,7 @@
 	*a &= ~mask;
 }
 
-static inline void __set_bit(int nr, volatile void * addr)
+static inline void __set_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask;
@@ -171,7 +171,7 @@
 	*a |= mask;
 }
 
-static inline void __change_bit(int nr, volatile void *addr)
+static inline void __change_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask;
@@ -181,7 +181,7 @@
 	*a ^= mask;
 }
 
-static inline int __test_and_clear_bit(int nr, volatile void * addr)
+static inline int __test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask, retval;
@@ -193,7 +193,7 @@
 	return retval;
 }
 
-static inline int __test_and_set_bit(int nr, volatile void * addr)
+static inline int __test_and_set_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask, retval;
@@ -205,7 +205,7 @@
 	return retval;
 }
 
-static inline int __test_and_change_bit(int nr, volatile void * addr)
+static inline int __test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask, retval;
@@ -220,12 +220,13 @@
 /*
  * This routine doesn't need to be atomic.
  */
-static inline int __constant_test_bit(int nr, const volatile void * addr)
+static inline
+int __constant_test_bit(unsigned long nr, const volatile void *addr)
 {
 	return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr >> 5])) != 0;
 }
 
-static inline int __test_bit(int nr, const volatile void * addr)
+static inline int __test_bit(unsigned long nr, const volatile void *addr)
 {
 	int 	* a = (int *) addr;
 	int	mask;
