Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbZFKMFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbZFKMFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZFKMFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:05:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46184 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZFKMFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:05:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] bitops: Change the bitmap index from int to unsigned long
	[frv]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Justin Chen <justin.chen@hp.com>,
       David Howells <dhowells@redhat.com>
Date: Thu, 11 Jun 2009 13:04:59 +0100
Message-ID: <20090611120458.12082.4348.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Chen <jchen@hpdst41.cup.hp.com>

Change the index to unsigned long in all bitops for [frv]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/bitops.h |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)


diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
index 287f6f6..50ae91b 100644
--- a/arch/frv/include/asm/bitops.h
+++ b/arch/frv/include/asm/bitops.h
@@ -112,7 +112,7 @@ extern unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsig
 #define atomic_clear_mask(mask, v)	atomic_test_and_ANDNOT_mask((mask), (v))
 #define atomic_set_mask(mask, v)	atomic_test_and_OR_mask((mask), (v))
 
-static inline int test_and_clear_bit(int nr, volatile void *addr)
+static inline int test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *ptr = addr;
 	unsigned long mask = 1UL << (nr & 31);
@@ -120,7 +120,7 @@ static inline int test_and_clear_bit(int nr, volatile void *addr)
 	return (atomic_test_and_ANDNOT_mask(mask, ptr) & mask) != 0;
 }
 
-static inline int test_and_set_bit(int nr, volatile void *addr)
+static inline int test_and_set_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *ptr = addr;
 	unsigned long mask = 1UL << (nr & 31);
@@ -128,7 +128,7 @@ static inline int test_and_set_bit(int nr, volatile void *addr)
 	return (atomic_test_and_OR_mask(mask, ptr) & mask) != 0;
 }
 
-static inline int test_and_change_bit(int nr, volatile void *addr)
+static inline int test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *ptr = addr;
 	unsigned long mask = 1UL << (nr & 31);
@@ -136,22 +136,22 @@ static inline int test_and_change_bit(int nr, volatile void *addr)
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
@@ -161,7 +161,7 @@ static inline void __clear_bit(int nr, volatile void * addr)
 	*a &= ~mask;
 }
 
-static inline void __set_bit(int nr, volatile void * addr)
+static inline void __set_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask;
@@ -171,7 +171,7 @@ static inline void __set_bit(int nr, volatile void * addr)
 	*a |= mask;
 }
 
-static inline void __change_bit(int nr, volatile void *addr)
+static inline void __change_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask;
@@ -181,7 +181,7 @@ static inline void __change_bit(int nr, volatile void *addr)
 	*a ^= mask;
 }
 
-static inline int __test_and_clear_bit(int nr, volatile void * addr)
+static inline int __test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask, retval;
@@ -193,7 +193,7 @@ static inline int __test_and_clear_bit(int nr, volatile void * addr)
 	return retval;
 }
 
-static inline int __test_and_set_bit(int nr, volatile void * addr)
+static inline int __test_and_set_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask, retval;
@@ -205,7 +205,7 @@ static inline int __test_and_set_bit(int nr, volatile void * addr)
 	return retval;
 }
 
-static inline int __test_and_change_bit(int nr, volatile void * addr)
+static inline int __test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	volatile unsigned long *a = addr;
 	int mask, retval;
@@ -220,12 +220,13 @@ static inline int __test_and_change_bit(int nr, volatile void * addr)
 /*
  * This routine doesn't need to be atomic.
  */
-static inline int __constant_test_bit(int nr, const volatile void * addr)
+static inline int
+__constant_test_bit(unsigned long nr, const volatile void *addr)
 {
 	return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr >> 5])) != 0;
 }
 
-static inline int __test_bit(int nr, const volatile void * addr)
+static inline int __test_bit(unsigned long nr, const volatile void *addr)
 {
 	int 	* a = (int *) addr;
 	int	mask;

