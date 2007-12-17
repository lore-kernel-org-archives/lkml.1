Return-Path: <linux-kernel-owner+w=401wt.eu-S937406AbXLRBpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937406AbXLRBpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762497AbXLRBi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:38:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763073AbXLRBiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:38:22 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 13/21] [PATCH] change bitwise operations to get a void parameter.
Date: Mon, 17 Dec 2007 20:52:36 -0200
Message-Id: <11979320302030-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979320252102-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com> <11979320163651-git-send-email-gcosta@redhat.com> <11979320211287-git-send-email-gcosta@redhat.com> <11979320252102-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the bitwise operations in bitops.h to get
a void pointers as a parameter. Before this patch, a lot of warnings
can be seen. They're gone after it.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/bitops.h |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

Index: linux-2.6-x86/include/asm-x86/bitops.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/bitops.h
+++ linux-2.6-x86/include/asm-x86/bitops.h
@@ -43,7 +43,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(int nr, volatile unsigned long *addr)
+static inline void set_bit(int nr, volatile void *addr)
 {
 	asm volatile(LOCK_PREFIX "bts %1,%0"
 		     : ADDR
@@ -59,7 +59,7 @@ static inline void set_bit(int nr, volat
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile unsigned long *addr)
+static inline void __set_bit(int nr, volatile void *addr)
 {
 	asm volatile("bts %1,%0"
 		     : ADDR
@@ -77,7 +77,7 @@ static inline void __set_bit(int nr, vol
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static inline void clear_bit(int nr, volatile void *addr)
 {
 	asm volatile(LOCK_PREFIX "btr %1,%0"
 		     : ADDR
@@ -92,13 +92,13 @@ static inline void clear_bit(int nr, vol
  * clear_bit() is atomic and implies release semantics before the memory
  * operation. It can be used for an unlock.
  */
-static inline void clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
+static inline void clear_bit_unlock(unsigned nr, volatile void *addr)
 {
 	barrier();
 	clear_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
+static inline void __clear_bit(int nr, volatile void *addr)
 {
 	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
@@ -115,7 +115,7 @@ static inline void __clear_bit(int nr, v
  * No memory barrier is required here, because x86 cannot reorder stores past
  * older loads. Same principle as spin_unlock.
  */
-static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
+static inline void __clear_bit_unlock(unsigned nr, volatile void *addr)
 {
 	barrier();
 	__clear_bit(nr, addr);
@@ -133,7 +133,7 @@ static inline void __clear_bit_unlock(un
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long *addr)
+static inline void __change_bit(int nr, volatile void *addr)
 {
 	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
@@ -147,7 +147,7 @@ static inline void __change_bit(int nr, 
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile unsigned long *addr)
+static inline void change_bit(int nr, volatile void *addr)
 {
 	asm volatile(LOCK_PREFIX "btc %1,%0"
 		     : ADDR : "Ir" (nr));
@@ -161,7 +161,7 @@ static inline void change_bit(int nr, vo
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_set_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -180,7 +180,7 @@ static inline int test_and_set_bit(int n
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+static inline int test_and_set_bit_lock(int nr, volatile void *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -194,7 +194,7 @@ static inline int test_and_set_bit_lock(
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_set_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -213,7 +213,7 @@ static inline int __test_and_set_bit(int
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_clear_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -234,7 +234,7 @@ static inline int test_and_clear_bit(int
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_clear_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -246,7 +246,7 @@ static inline int __test_and_clear_bit(i
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_change_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -266,7 +266,7 @@ static inline int __test_and_change_bit(
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_change_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -278,19 +278,20 @@ static inline int test_and_change_bit(in
 	return oldbit;
 }
 
-static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
+static inline int constant_test_bit(int nr, const volatile void *addr)
 {
-	return ((1UL << (nr % BITS_PER_LONG)) & (addr[nr / BITS_PER_LONG])) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
 }
 
-static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
+static inline int variable_test_bit(int nr, volatile const void *addr)
 {
 	int oldbit;
 
 	asm volatile("bt %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit)
-		     : "m" (*addr), "Ir" (nr));
+		     : "m" (*(unsigned long *)addr), "Ir" (nr));
 
 	return oldbit;
 }
