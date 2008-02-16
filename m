Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbYBPQYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbYBPQYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYBPQY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:24:26 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:28570 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbYBPQYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:24:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=w7HLOp6yZ0fjZrDF39viiL2+uQQxGQruzlTAI3YilplOzRSZlYfG+L8SXG98+YWM6d3tVCRFznNhkwDtiQQB4/fXxjoFRBZYDT5se/VSAxD2B59FHe3Y04P/dlx+/b3bPXWIBmuCnqeBPc09ahB982rohnMDKneQ+n4Bjis51l4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 17:38:56 +0100
Message-Id: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/12] ide: remove ide_default_io_ctl() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is always == '((base) + 0x206)' if CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS=y
and it is not needed otherwise (arm, blackfin, parisc, ppc64, sh, sparc[64]).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c                   |    2 +-
 include/asm-alpha/ide.h             |    2 --
 include/asm-arm/ide.h               |    8 --------
 include/asm-blackfin/ide.h          |    4 ----
 include/asm-ia64/ide.h              |    2 --
 include/asm-m32r/ide.h              |    2 --
 include/asm-mips/mach-generic/ide.h |    2 --
 include/asm-parisc/ide.h            |    2 --
 include/asm-powerpc/ide.h           |    2 --
 include/asm-sh/ide.h                |    3 ---
 include/asm-sparc/ide.h             |    2 --
 include/asm-sparc64/ide.h           |    2 --
 include/asm-x86/ide.h               |    2 --
 13 files changed, 1 insertion(+), 34 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -205,7 +205,7 @@ static void __init init_ide_data (void)
 	for (index = 0; index < MAX_HWIFS; ++index) {
 		ide_hwif_t *hwif = &ide_hwifs[index];
 		unsigned long io_addr = ide_default_io_base(index);
-		unsigned long ctl_addr = ide_default_io_ctl(io_addr);
+		unsigned long ctl_addr = io_addr + 0x206;
 
 		ide_init_port_data(hwif, index);
 
Index: b/include/asm-alpha/ide.h
===================================================================
--- a/include/asm-alpha/ide.h
+++ b/include/asm-alpha/ide.h
@@ -37,8 +37,6 @@ static inline unsigned long ide_default_
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #ifdef CONFIG_PCI
 #define ide_init_default_irq(base)	(0)
 #else
Index: b/include/asm-arm/ide.h
===================================================================
--- a/include/asm-arm/ide.h
+++ b/include/asm-arm/ide.h
@@ -17,14 +17,6 @@
 #define MAX_HWIFS	4
 #endif
 
-#if !defined(CONFIG_ARCH_L7200)
-# ifdef CONFIG_ARCH_CLPS7500
-#  define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-# else
-#  define ide_default_io_ctl(base)	(0)
-# endif
-#endif /* !ARCH_L7200 */
-
 #define __ide_mm_insw(port,addr,len)	readsw(port,addr,len)
 #define __ide_mm_insl(port,addr,len)	readsl(port,addr,len)
 #define __ide_mm_outsw(port,addr,len)	writesw(port,addr,len)
Index: b/include/asm-blackfin/ide.h
===================================================================
--- a/include/asm-blackfin/ide.h
+++ b/include/asm-blackfin/ide.h
@@ -19,10 +19,6 @@
 
 #define MAX_HWIFS	1
 
-/* Legacy ... BLK_DEV_IDECS */
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
-
 #include <asm-generic/ide_iops.h>
 
 /****************************************************************************/
Index: b/include/asm-ia64/ide.h
===================================================================
--- a/include/asm-ia64/ide.h
+++ b/include/asm-ia64/ide.h
@@ -44,8 +44,6 @@ static inline unsigned long ide_default_
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #ifdef CONFIG_PCI
 #define ide_init_default_irq(base)	(0)
 #else
Index: b/include/asm-m32r/ide.h
===================================================================
--- a/include/asm-m32r/ide.h
+++ b/include/asm-m32r/ide.h
@@ -63,8 +63,6 @@ static __inline__ unsigned long ide_defa
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #ifdef CONFIG_BLK_DEV_IDEPCI
 #define ide_init_default_irq(base)     (0)
 #else
Index: b/include/asm-mips/mach-generic/ide.h
===================================================================
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -96,8 +96,6 @@ static __inline__ unsigned long ide_defa
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #ifdef CONFIG_BLK_DEV_IDEPCI
 #define ide_init_default_irq(base)	(0)
 #else
Index: b/include/asm-parisc/ide.h
===================================================================
--- a/include/asm-parisc/ide.h
+++ b/include/asm-parisc/ide.h
@@ -17,8 +17,6 @@
 #define MAX_HWIFS	2
 #endif
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #define ide_request_irq(irq,hand,flg,dev,id)	request_irq((irq),(hand),(flg),(dev),(id))
 #define ide_free_irq(irq,dev_id)		free_irq((irq), (dev_id))
 #define ide_request_region(from,extent,name)	request_region((from), (extent), (name))
Index: b/include/asm-powerpc/ide.h
===================================================================
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -86,8 +86,6 @@ static __inline__ unsigned long ide_defa
 
 #endif /* __powerpc64__ */
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_POWERPC_IDE_H */
Index: b/include/asm-sh/ide.h
===================================================================
--- a/include/asm-sh/ide.h
+++ b/include/asm-sh/ide.h
@@ -14,9 +14,6 @@
 
 #ifdef __KERNEL__
 
-
-#define ide_default_io_ctl(base)	(0)
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
Index: b/include/asm-sparc/ide.h
===================================================================
--- a/include/asm-sparc/ide.h
+++ b/include/asm-sparc/ide.h
@@ -17,8 +17,6 @@
 #undef  MAX_HWIFS
 #define MAX_HWIFS	2
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #define __ide_insl(data_reg, buffer, wcount) \
 	__ide_insw(data_reg, buffer, (wcount)<<1)
 #define __ide_outsl(data_reg, buffer, wcount) \
Index: b/include/asm-sparc64/ide.h
===================================================================
--- a/include/asm-sparc64/ide.h
+++ b/include/asm-sparc64/ide.h
@@ -24,8 +24,6 @@
 # endif
 #endif
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #define __ide_insl(data_reg, buffer, wcount) \
 	__ide_insw(data_reg, buffer, (wcount)<<1)
 #define __ide_outsl(data_reg, buffer, wcount) \
Index: b/include/asm-x86/ide.h
===================================================================
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -58,8 +58,6 @@ static __inline__ unsigned long ide_defa
 	}
 }
 
-#define ide_default_io_ctl(base)	((base) + 0x206) /* obsolete */
-
 #ifdef CONFIG_BLK_DEV_IDEPCI
 #define ide_init_default_irq(base)	(0)
 #else
