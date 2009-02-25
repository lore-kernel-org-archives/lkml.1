Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbZBYEva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbZBYEva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760607AbZBYEuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:50:50 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:41605 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759826AbZBYEut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:50:49 -0500
Date: Tue, 24 Feb 2009 20:52:53 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250452.UAA12910@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 15/15] bitops: Change the bitmap index from int to unsigned long [m32r]
Cc: bjorn.helgaas@hp.com, justin.chen@hp.com, linux-kernel@vger.kernel.org,
       takata@linux-m32r.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [m32r]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 include/asm-m32r/bitops.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)
diff -Nru a/include/asm-m32r/bitops.h b/include/asm-m32r/bitops.h
--- a/include/asm-m32r/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/include/asm-m32r/bitops.h	2009-02-15 18:19:39.793041022 -0800
@@ -39,7 +39,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static __inline__ void set_bit(int nr, volatile void * addr)
+static __inline__ void set_bit(unsigned long nr, volatile void *addr)
 {
 	__u32 mask;
 	volatile __u32 *a = addr;
@@ -75,7 +75,7 @@
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static __inline__ void clear_bit(int nr, volatile void * addr)
+static __inline__ void clear_bit(unsigned long nr, volatile void *addr)
 {
 	__u32 mask;
 	volatile __u32 *a = addr;
@@ -114,7 +114,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static __inline__ void change_bit(int nr, volatile void * addr)
+static __inline__ void change_bit(unsigned long nr, volatile void *addr)
 {
 	__u32  mask;
 	volatile __u32  *a = addr;
@@ -148,7 +148,7 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static __inline__ int test_and_set_bit(int nr, volatile void * addr)
+static __inline__ int test_and_set_bit(unsigned long nr, volatile void *addr)
 {
 	__u32 mask, oldbit;
 	volatile __u32 *a = addr;
@@ -183,7 +183,8 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static __inline__ int test_and_clear_bit(int nr, volatile void * addr)
+static __inline__ int
+test_and_clear_bit(unsigned long nr, volatile void *addr)
 {
 	__u32 mask, oldbit;
 	volatile __u32 *a = addr;
@@ -220,7 +221,8 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static __inline__ int test_and_change_bit(int nr, volatile void * addr)
+static __inline__ int
+test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	__u32 mask, oldbit;
 	volatile __u32 *a = addr;
