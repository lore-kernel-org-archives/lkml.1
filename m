Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbYGGWCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbYGGWCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758775AbYGGWBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:01:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:9234 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbYGGWAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=TI7OcAdyRGaqrc52VmGsWvIMiLPqNxpxkL9/IwWN7rYCG1tggXf0knoj3VSYZTm+kF
         ANkOSZofyPiI+TBXxEAXNWGnxcEaeZnOBEUW8IBXI2tjKtsACjIvfld5SAIXmqYSu/Qi
         Z6oXL2S+CbL6tYMZVjjGTXbOv0Adlw989B9vo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 6/10] ide: define MAX_HWIFS in <linux/ide.h>
Date: Mon, 7 Jul 2008 23:54:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072354.24598.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Now that ide_hwif_t instances are allocated dynamically
  the difference between MAX_HWIFS == 2 and MAX_HWIFS == 10
  is ~100 bytes (x86-32) so use MAX_HWIFS == 10 on all archs
  except these ones that use MAX_HWIFS == 1.

* Define MAX_HWIFS in <linux/ide.h> instead of <asm/ide.h>.

[ Please note that avr32/cris/v850 have no <asm/ide.h>
  and alpha/ia64/sh always define CONFIG_IDE_MAX_HWIFS. ]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
this patch depends on arch/ppc/ removal (already in linux-next)

 include/asm-arm/ide.h               |    4 ----
 include/asm-blackfin/ide.h          |    2 --
 include/asm-frv/ide.h               |    4 ----
 include/asm-h8300/ide.h             |    2 --
 include/asm-m32r/ide.h              |    8 --------
 include/asm-m68k/ide.h              |    4 ----
 include/asm-mips/mach-generic/ide.h |    8 --------
 include/asm-mn10300/ide.h           |    4 ----
 include/asm-parisc/ide.h            |    4 ----
 include/asm-powerpc/ide.h           |    8 --------
 include/asm-sparc/ide.h             |    3 ---
 include/asm-sparc64/ide.h           |    8 --------
 include/asm-x86/ide.h               |    9 ---------
 include/asm-xtensa/ide.h            |    5 -----
 include/linux/ide.h                 |    8 ++++++++
 15 files changed, 8 insertions(+), 73 deletions(-)

Index: b/include/asm-arm/ide.h
===================================================================
--- a/include/asm-arm/ide.h
+++ b/include/asm-arm/ide.h
@@ -13,10 +13,6 @@
 
 #ifdef __KERNEL__
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS	4
-#endif
-
 #define __ide_mm_insw(port,addr,len)	readsw(port,addr,len)
 #define __ide_mm_insl(port,addr,len)	readsl(port,addr,len)
 #define __ide_mm_outsw(port,addr,len)	writesw(port,addr,len)
Index: b/include/asm-blackfin/ide.h
===================================================================
--- a/include/asm-blackfin/ide.h
+++ b/include/asm-blackfin/ide.h
@@ -17,8 +17,6 @@
 #ifdef __KERNEL__
 /****************************************************************************/
 
-#define MAX_HWIFS	1
-
 #include <asm-generic/ide_iops.h>
 
 /****************************************************************************/
Index: b/include/asm-frv/ide.h
===================================================================
--- a/include/asm-frv/ide.h
+++ b/include/asm-frv/ide.h
@@ -18,10 +18,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS 8
-#endif
-
 /****************************************************************************/
 /*
  * some bits needed for parts of the IDE subsystem to compile
Index: b/include/asm-h8300/ide.h
===================================================================
--- a/include/asm-h8300/ide.h
+++ b/include/asm-h8300/ide.h
@@ -16,8 +16,6 @@
 #ifdef __KERNEL__
 /****************************************************************************/
 
-#define MAX_HWIFS	1
-
 #include <asm-generic/ide_iops.h>
 
 /****************************************************************************/
Index: b/include/asm-m32r/ide.h
===================================================================
--- a/include/asm-m32r/ide.h
+++ b/include/asm-m32r/ide.h
@@ -15,14 +15,6 @@
 
 #include <asm/m32r.h>
 
-#ifndef MAX_HWIFS
-# ifdef CONFIG_BLK_DEV_IDEPCI
-#define MAX_HWIFS	10
-# else
-#define MAX_HWIFS	2
-# endif
-#endif
-
 static __inline__ int ide_default_irq(unsigned long base)
 {
 	switch (base) {
Index: b/include/asm-m68k/ide.h
===================================================================
--- a/include/asm-m68k/ide.h
+++ b/include/asm-m68k/ide.h
@@ -45,10 +45,6 @@
 #include <asm/macints.h>
 #endif
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS	4	/* same as the other archs */
-#endif
-
 /*
  * Get rid of defs from io.h - ide has its private and conflicting versions
  * Since so far no single m68k platform uses ISA/PCI I/O space for IDE, we
Index: b/include/asm-mips/mach-generic/ide.h
===================================================================
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -19,14 +19,6 @@
 #include <linux/stddef.h>
 #include <asm/processor.h>
 
-#ifndef MAX_HWIFS
-# ifdef CONFIG_BLK_DEV_IDEPCI
-#define MAX_HWIFS	10
-# else
-#define MAX_HWIFS	6
-# endif
-#endif
-
 static __inline__ int ide_probe_legacy(void)
 {
 #ifdef CONFIG_PCI
Index: b/include/asm-mn10300/ide.h
===================================================================
--- a/include/asm-mn10300/ide.h
+++ b/include/asm-mn10300/ide.h
@@ -23,10 +23,6 @@
 #undef SUPPORT_VLB_SYNC
 #define SUPPORT_VLB_SYNC 0
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS 8
-#endif
-
 /*
  * some bits needed for parts of the IDE subsystem to compile
  */
Index: b/include/asm-parisc/ide.h
===================================================================
--- a/include/asm-parisc/ide.h
+++ b/include/asm-parisc/ide.h
@@ -13,10 +13,6 @@
 
 #ifdef __KERNEL__
 
-#ifndef MAX_HWIFS
-#define MAX_HWIFS	2
-#endif
-
 #define ide_request_irq(irq,hand,flg,dev,id)	request_irq((irq),(hand),(flg),(dev),(id))
 #define ide_free_irq(irq,dev_id)		free_irq((irq), (dev_id))
 #define ide_request_region(from,extent,name)	request_region((from), (extent), (name))
Index: b/include/asm-powerpc/ide.h
===================================================================
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -14,14 +14,6 @@
 #endif
 #include <asm/io.h>
 
-#ifndef MAX_HWIFS
-#ifdef __powerpc64__
-#define MAX_HWIFS	10
-#else
-#define MAX_HWIFS	8
-#endif
-#endif
-
 #define __ide_mm_insw(p, a, c)	readsw((void __iomem *)(p), (a), (c))
 #define __ide_mm_insl(p, a, c)	readsl((void __iomem *)(p), (a), (c))
 #define __ide_mm_outsw(p, a, c)	writesw((void __iomem *)(p), (a), (c))
Index: b/include/asm-sparc/ide.h
===================================================================
--- a/include/asm-sparc/ide.h
+++ b/include/asm-sparc/ide.h
@@ -14,9 +14,6 @@
 #include <asm/io.h>
 #include <asm/psr.h>
 
-#undef  MAX_HWIFS
-#define MAX_HWIFS	2
-
 #define __ide_insl(data_reg, buffer, wcount) \
 	__ide_insw(data_reg, buffer, (wcount)<<1)
 #define __ide_outsl(data_reg, buffer, wcount) \
Index: b/include/asm-sparc64/ide.h
===================================================================
--- a/include/asm-sparc64/ide.h
+++ b/include/asm-sparc64/ide.h
@@ -16,14 +16,6 @@
 #include <asm/cacheflush.h>
 #include <asm/page.h>
 
-#ifndef MAX_HWIFS
-# ifdef CONFIG_BLK_DEV_IDEPCI
-#define MAX_HWIFS	10
-# else
-#define MAX_HWIFS	2
-# endif
-#endif
-
 #define __ide_insl(data_reg, buffer, wcount) \
 	__ide_insw(data_reg, buffer, (wcount)<<1)
 #define __ide_outsl(data_reg, buffer, wcount) \
Index: b/include/asm-x86/ide.h
===================================================================
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -11,15 +11,6 @@
 
 #ifdef __KERNEL__
 
-
-#ifndef MAX_HWIFS
-# ifdef CONFIG_BLK_DEV_IDEPCI
-#define MAX_HWIFS	10
-# else
-#define MAX_HWIFS	6
-# endif
-#endif
-
 static __inline__ int ide_default_irq(unsigned long base)
 {
 	switch (base) {
Index: b/include/asm-xtensa/ide.h
===================================================================
--- a/include/asm-xtensa/ide.h
+++ b/include/asm-xtensa/ide.h
@@ -14,11 +14,6 @@
 
 #ifdef __KERNEL__
 
-
-#ifndef MAX_HWIFS
-# define MAX_HWIFS	1
-#endif
-
 #include <asm-generic/ide_iops.h>
 
 #endif	/* __KERNEL__ */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -213,6 +213,14 @@ static inline int __ide_default_irq(unsi
 
 #include <asm/ide.h>
 
+#ifndef MAX_HWIFS
+#if defined(CONFIG_BLACKFIN) || defined(CONFIG_H8300) || defined(CONFIG_XTENSA)
+# define MAX_HWIFS	1
+#else
+# define MAX_HWIFS	10
+#endif
+#endif
+
 #if !defined(MAX_HWIFS) || defined(CONFIG_EMBEDDED)
 #undef MAX_HWIFS
 #define MAX_HWIFS	CONFIG_IDE_MAX_HWIFS
