Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbZBYElB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbZBYElB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZBYEkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:40:51 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:48226 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZBYEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:40:50 -0500
Date: Tue, 24 Feb 2009 20:42:52 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250442.UAA12563@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 02/15] bitops: Change the bitmap index from int to unsigned long [arm]
Cc: ben-linux@fluff.org, bjorn.helgaas@hp.com, dan.j.williams@intel.com,
       justin.chen@hp.com, kernel@pengutronix.de, kernel@wantstofly.org,
       linux-kernel@vger.kernel.org, linux@maxim.org.za, mcuos.com@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [arm]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/arm/include/asm/bitops.h |   36 ++++++++++++++++++------------------
 arch/arm/lib/changebit.S      |    2 +-
 arch/arm/lib/clearbit.S       |    2 +-
 arch/arm/lib/setbit.S         |    2 +-
 4 files changed, 24 insertions(+), 21 deletions(-)
diff -Nru a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h	2009-02-22 20:19:40.000000000 -0800
+++ b/arch/arm/include/asm/bitops.h	2009-02-24 13:33:52.000000000 -0800
@@ -34,7 +34,7 @@
  *
  * First, the atomic bitops. These use native endian.
  */
-static inline void ____atomic_set_bit(unsigned int bit, volatile unsigned long *p)
+static inline void ____atomic_set_bit(unsigned long bit, volatile unsigned long *p)
 {
 	unsigned long flags;
 	unsigned long mask = 1UL << (bit & 31);
@@ -46,7 +46,7 @@
 	raw_local_irq_restore(flags);
 }
 
-static inline void ____atomic_clear_bit(unsigned int bit, volatile unsigned long *p)
+static inline void ____atomic_clear_bit(unsigned long bit, volatile unsigned long *p)
 {
 	unsigned long flags;
 	unsigned long mask = 1UL << (bit & 31);
@@ -58,7 +58,7 @@
 	raw_local_irq_restore(flags);
 }
 
-static inline void ____atomic_change_bit(unsigned int bit, volatile unsigned long *p)
+static inline void ____atomic_change_bit(unsigned long bit, volatile unsigned long *p)
 {
 	unsigned long flags;
 	unsigned long mask = 1UL << (bit & 31);
@@ -71,7 +71,7 @@
 }
 
 static inline int
-____atomic_test_and_set_bit(unsigned int bit, volatile unsigned long *p)
+____atomic_test_and_set_bit(unsigned long bit, volatile unsigned long *p)
 {
 	unsigned long flags;
 	unsigned int res;
@@ -88,7 +88,7 @@
 }
 
 static inline int
-____atomic_test_and_clear_bit(unsigned int bit, volatile unsigned long *p)
+____atomic_test_and_clear_bit(unsigned long bit, volatile unsigned long *p)
 {
 	unsigned long flags;
 	unsigned int res;
@@ -105,7 +105,7 @@
 }
 
 static inline int
-____atomic_test_and_change_bit(unsigned int bit, volatile unsigned long *p)
+____atomic_test_and_change_bit(unsigned long bit, volatile unsigned long *p)
 {
 	unsigned long flags;
 	unsigned int res;
@@ -151,12 +151,12 @@
 /*
  * Little endian assembly bitops.  nr = 0 -> byte 0 bit 0.
  */
-extern void _set_bit_le(int nr, volatile unsigned long * p);
-extern void _clear_bit_le(int nr, volatile unsigned long * p);
-extern void _change_bit_le(int nr, volatile unsigned long * p);
-extern int _test_and_set_bit_le(int nr, volatile unsigned long * p);
-extern int _test_and_clear_bit_le(int nr, volatile unsigned long * p);
-extern int _test_and_change_bit_le(int nr, volatile unsigned long * p);
+extern void _set_bit_le(unsigned long nr, volatile unsigned long * p);
+extern void _clear_bit_le(unsigned long nr, volatile unsigned long * p);
+extern void _change_bit_le(unsigned long nr, volatile unsigned long * p);
+extern int _test_and_set_bit_le(unsigned long nr, volatile unsigned long * p);
+extern int _test_and_clear_bit_le(unsigned long nr, volatile unsigned long * p);
+extern int _test_and_change_bit_le(unsigned long nr, volatile unsigned long * p);
 extern int _find_first_zero_bit_le(const void * p, unsigned size);
 extern int _find_next_zero_bit_le(const void * p, int size, int offset);
 extern int _find_first_bit_le(const unsigned long *p, unsigned size);
@@ -165,12 +165,12 @@
 /*
  * Big endian assembly bitops.  nr = 0 -> byte 3 bit 0.
  */
-extern void _set_bit_be(int nr, volatile unsigned long * p);
-extern void _clear_bit_be(int nr, volatile unsigned long * p);
-extern void _change_bit_be(int nr, volatile unsigned long * p);
-extern int _test_and_set_bit_be(int nr, volatile unsigned long * p);
-extern int _test_and_clear_bit_be(int nr, volatile unsigned long * p);
-extern int _test_and_change_bit_be(int nr, volatile unsigned long * p);
+extern void _set_bit_be(unsigned long nr, volatile unsigned long * p);
+extern void _clear_bit_be(unsigned long nr, volatile unsigned long * p);
+extern void _change_bit_be(unsigned long nr, volatile unsigned long * p);
+extern int _test_and_set_bit_be(unsigned long nr, volatile unsigned long * p);
+extern int _test_and_clear_bit_be(unsigned long nr, volatile unsigned long * p);
+extern int _test_and_change_bit_be(unsigned long nr, volatile unsigned long * p);
 extern int _find_first_zero_bit_be(const void * p, unsigned size);
 extern int _find_next_zero_bit_be(const void * p, int size, int offset);
 extern int _find_first_bit_be(const unsigned long *p, unsigned size);
diff -Nru a/arch/arm/lib/changebit.S b/arch/arm/lib/changebit.S
--- orig/arch/arm/lib/changebit.S	2009-02-22 20:19:40.000000000 -0800
+++ new/arch/arm/lib/changebit.S	2009-02-24 13:29:19.000000000 -0800
@@ -13,7 +13,7 @@
                 .text
 
 /* Purpose  : Function to change a bit
- * Prototype: int change_bit(int bit, void *addr)
+ * Prototype: int change_bit(unsigned long bit, void *addr)
  */
 ENTRY(_change_bit_be)
 		eor	r0, r0, #0x18		@ big endian byte ordering
diff -Nru a/arch/arm/lib/clearbit.S b/arch/arm/lib/clearbit.S
--- orig/arch/arm/lib/clearbit.S	2009-02-22 20:19:40.000000000 -0800
+++ new/arch/arm/lib/clearbit.S	2009-02-24 13:29:19.000000000 -0800
@@ -14,7 +14,7 @@
 
 /*
  * Purpose  : Function to clear a bit
- * Prototype: int clear_bit(int bit, void *addr)
+ * Prototype: int clear_bit(unsigned long bit, void *addr)
  */
 ENTRY(_clear_bit_be)
 		eor	r0, r0, #0x18		@ big endian byte ordering
diff -Nru a/arch/arm/lib/setbit.S b/arch/arm/lib/setbit.S
--- orig/arch/arm/lib/setbit.S	2009-02-22 20:19:40.000000000 -0800
+++ new/arch/arm/lib/setbit.S	2009-02-24 13:29:19.000000000 -0800
@@ -14,7 +14,7 @@
 
 /*
  * Purpose  : Function to set a bit
- * Prototype: int set_bit(int bit, void *addr)
+ * Prototype: int set_bit(unsigned long bit, void *addr)
  */
 ENTRY(_set_bit_be)
 		eor	r0, r0, #0x18		@ big endian byte ordering
