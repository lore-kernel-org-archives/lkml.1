Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbZBYEs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbZBYEs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZBYEsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:48:18 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:41198 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbZBYEsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:48:16 -0500
Date: Tue, 24 Feb 2009 20:50:20 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250450.UAA12827@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 07/15] bitops: Change the bitmap index from int to unsigned long [ia64]
Cc: bjorn.helgaas@hp.com, jes@sgi.com, justin.chen@hp.com,
       linux-kernel@vger.kernel.org, tony.luck@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [ia64]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/ia64/include/asm/bitops.h      |   30 +++++++++++++++---------------
 arch/ia64/include/asm/sync_bitops.h |   21 ++++++++++++++-------
 2 files changed, 29 insertions(+), 22 deletions(-)
diff -Nru a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
--- a/arch/ia64/include/asm/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/ia64/include/asm/bitops.h	2009-02-15 18:27:51.850652181 -0800
@@ -35,7 +35,7 @@
  * bit 0 is the LSB of addr; bit 32 is the LSB of (addr+1).
  */
 static __inline__ void
-set_bit (int nr, volatile void *addr)
+set_bit (unsigned long nr, volatile void *addr)
 {
 	__u32 bit, old, new;
 	volatile __u32 *m;
@@ -60,7 +60,7 @@
  * may be that only one operation succeeds.
  */
 static __inline__ void
-__set_bit (int nr, volatile void *addr)
+__set_bit (unsigned long nr, volatile void *addr)
 {
 	*((__u32 *) addr + (nr >> 5)) |= (1 << (nr & 31));
 }
@@ -82,7 +82,7 @@
  * in order to ensure changes are visible on other processors.
  */
 static __inline__ void
-clear_bit (int nr, volatile void *addr)
+clear_bit (unsigned long nr, volatile void *addr)
 {
 	__u32 mask, old, new;
 	volatile __u32 *m;
@@ -106,7 +106,7 @@
  * contain a memory barrier suitable for unlock type operations.
  */
 static __inline__ void
-clear_bit_unlock (int nr, volatile void *addr)
+clear_bit_unlock (unsigned long nr, volatile void *addr)
 {
 	__u32 mask, old, new;
 	volatile __u32 *m;
@@ -130,7 +130,7 @@
  * with release semantics. See also __raw_spin_unlock().
  */
 static __inline__ void
-__clear_bit_unlock(int nr, void *addr)
+__clear_bit_unlock(unsigned long nr, void *addr)
 {
 	__u32 * const m = (__u32 *) addr + (nr >> 5);
 	__u32 const new = *m & ~(1 << (nr & 31));
@@ -148,7 +148,7 @@
  * may be that only one operation succeeds.
  */
 static __inline__ void
-__clear_bit (int nr, volatile void *addr)
+__clear_bit (unsigned long nr, volatile void *addr)
 {
 	*((__u32 *) addr + (nr >> 5)) &= ~(1 << (nr & 31));
 }
@@ -163,7 +163,7 @@
  * restricted to acting on a single-word quantity.
  */
 static __inline__ void
-change_bit (int nr, volatile void *addr)
+change_bit (unsigned long nr, volatile void *addr)
 {
 	__u32 bit, old, new;
 	volatile __u32 *m;
@@ -188,7 +188,7 @@
  * may be that only one operation succeeds.
  */
 static __inline__ void
-__change_bit (int nr, volatile void *addr)
+__change_bit (unsigned long nr, volatile void *addr)
 {
 	*((__u32 *) addr + (nr >> 5)) ^= (1 << (nr & 31));
 }
@@ -202,7 +202,7 @@
  * It also implies the acquisition side of the memory barrier.
  */
 static __inline__ int
-test_and_set_bit (int nr, volatile void *addr)
+test_and_set_bit (unsigned long nr, volatile void *addr)
 {
 	__u32 bit, old, new;
 	volatile __u32 *m;
@@ -237,7 +237,7 @@
  * but actually fail.  You must protect multiple accesses with a lock.
  */
 static __inline__ int
-__test_and_set_bit (int nr, volatile void *addr)
+__test_and_set_bit (unsigned long nr, volatile void *addr)
 {
 	__u32 *p = (__u32 *) addr + (nr >> 5);
 	__u32 m = 1 << (nr & 31);
@@ -256,7 +256,7 @@
  * It also implies the acquisition side of the memory barrier.
  */
 static __inline__ int
-test_and_clear_bit (int nr, volatile void *addr)
+test_and_clear_bit (unsigned long nr, volatile void *addr)
 {
 	__u32 mask, old, new;
 	volatile __u32 *m;
@@ -282,7 +282,7 @@
  * but actually fail.  You must protect multiple accesses with a lock.
  */
 static __inline__ int
-__test_and_clear_bit(int nr, volatile void * addr)
+__test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
 	__u32 *p = (__u32 *) addr + (nr >> 5);
 	__u32 m = 1 << (nr & 31);
@@ -301,7 +301,7 @@
  * It also implies the acquisition side of the memory barrier.
  */
 static __inline__ int
-test_and_change_bit (int nr, volatile void *addr)
+test_and_change_bit (unsigned long nr, volatile void *addr)
 {
 	__u32 bit, old, new;
 	volatile __u32 *m;
@@ -325,7 +325,7 @@
  * This operation is non-atomic and can be reordered.
  */
 static __inline__ int
-__test_and_change_bit (int nr, void *addr)
+__test_and_change_bit (unsigned long nr, void *addr)
 {
 	__u32 old, bit = (1 << (nr & 31));
 	__u32 *m = (__u32 *) addr + (nr >> 5);
@@ -336,7 +336,7 @@
 }
 
 static __inline__ int
-test_bit (int nr, const volatile void *addr)
+test_bit (unsigned long nr, const volatile void *addr)
 {
 	return 1 & (((const volatile __u32 *) addr)[nr >> 5] >> (nr & 31));
 }
diff -Nru a/arch/ia64/include/asm/sync_bitops.h b/arch/ia64/include/asm/sync_bitops.h
--- a/arch/ia64/include/asm/sync_bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/ia64/include/asm/sync_bitops.h	2009-02-15 18:28:28.760807979 -0800
@@ -10,37 +10,44 @@
  * when communicating with Xen or other guest OSes running on other CPUs.
  */
 
-static inline void sync_set_bit(int nr, volatile void *addr)
+static inline void
+sync_set_bit(unsigned long nr, volatile void *addr)
 {
 	set_bit(nr, addr);
 }
 
-static inline void sync_clear_bit(int nr, volatile void *addr)
+static inline void
+sync_clear_bit(unsigned long nr, volatile void *addr)
 {
 	clear_bit(nr, addr);
 }
 
-static inline void sync_change_bit(int nr, volatile void *addr)
+static inline void
+sync_change_bit(unsigned long nr, volatile void *addr)
 {
 	change_bit(nr, addr);
 }
 
-static inline int sync_test_and_set_bit(int nr, volatile void *addr)
+static inline int
+sync_test_and_set_bit(unsigned long nr, volatile void *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
 
-static inline int sync_test_and_clear_bit(int nr, volatile void *addr)
+static inline int
+sync_test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
 	return test_and_clear_bit(nr, addr);
 }
 
-static inline int sync_test_and_change_bit(int nr, volatile void *addr)
+static inline int
+sync_test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	return test_and_change_bit(nr, addr);
 }
 
-static inline int sync_test_bit(int nr, const volatile void *addr)
+static inline int
+sync_test_bit(unsigned long nr, const volatile void *addr)
 {
 	return test_bit(nr, addr);
 }
