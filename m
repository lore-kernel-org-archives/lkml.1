Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbZBYEl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbZBYEl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbZBYElO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:41:14 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20171 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbZBYElM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:41:12 -0500
Date: Tue, 24 Feb 2009 20:43:16 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250443.UAA12576@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 03/15] bitops: Change the bitmap index from int to unsigned long [avr32]
Cc: bjorn.helgaas@hp.com, hskinnemoen@atmel.com, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [arv32]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/avr32/include/asm/bitops.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)
diff -Nru a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
--- a/arch/avr32/include/asm/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/avr32/include/asm/bitops.h	2009-02-15 18:19:39.769603522 -0800
@@ -32,7 +32,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(int nr, volatile void * addr)
+static inline void set_bit(unsigned long nr, volatile void * addr)
 {
 	unsigned long *p = ((unsigned long *)addr) + nr / BITS_PER_LONG;
 	unsigned long tmp;
@@ -71,7 +71,7 @@
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile void * addr)
+static inline void clear_bit(unsigned long nr, volatile void * addr)
 {
 	unsigned long *p = ((unsigned long *)addr) + nr / BITS_PER_LONG;
 	unsigned long tmp;
@@ -109,7 +109,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile void * addr)
+static inline void change_bit(unsigned long nr, volatile void * addr)
 {
 	unsigned long *p = ((unsigned long *)addr) + nr / BITS_PER_LONG;
 	unsigned long mask = 1UL << (nr % BITS_PER_LONG);
@@ -134,7 +134,7 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile void * addr)
+static inline int test_and_set_bit(unsigned long nr, volatile void * addr)
 {
 	unsigned long *p = ((unsigned long *)addr) + nr / BITS_PER_LONG;
 	unsigned long mask = 1UL << (nr % BITS_PER_LONG);
@@ -174,7 +174,7 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile void * addr)
+static inline int test_and_clear_bit(unsigned long nr, volatile void * addr)
 {
 	unsigned long *p = ((unsigned long *)addr) + nr / BITS_PER_LONG;
 	unsigned long mask = 1UL << (nr % BITS_PER_LONG);
@@ -215,7 +215,7 @@
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile void * addr)
+static inline int test_and_change_bit(unsigned long nr, volatile void * addr)
 {
 	unsigned long *p = ((unsigned long *)addr) + nr / BITS_PER_LONG;
 	unsigned long mask = 1UL << (nr % BITS_PER_LONG);
