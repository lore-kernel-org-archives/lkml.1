Return-Path: <linux-kernel-owner+w=401wt.eu-S1765078AbZFQHM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765078AbZFQHM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764752AbZFQHL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:11:26 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:60177 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbZFQHLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:11:23 -0400
Date: Wed, 17 Jun 2009 17:11:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200906170711.n5H7BKVi009035@localhost.localdomain>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: merge mmu and non-mmu versions of dma.h
Cc: gerg@uclinux.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] m68k: merge mmu and non-mmu versions of dma.h

The non-mmu version of dma.h contains a lot of ColdFire specific DMA
support, but also all of the base m68k support. So use the non-mmu
version of dma.h for all.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/{dma_no.h => dma.h} |   19 ++++++++-----------
 arch/m68k/include/asm/dma_mm.h            |   16 ----------------
 2 files changed, 8 insertions(+), 27 deletions(-)
 rename arch/m68k/include/asm/{dma_no.h => dma.h} (97%)
 delete mode 100644 arch/m68k/include/asm/dma_mm.h

diff --git a/arch/m68k/include/asm/dma_no.h b/arch/m68k/include/asm/dma.h
similarity index 97%
rename from arch/m68k/include/asm/dma_no.h
rename to arch/m68k/include/asm/dma.h
index 939a020..7cf7066 100644
--- a/arch/m68k/include/asm/dma_no.h
+++ b/arch/m68k/include/asm/dma.h
@@ -1,9 +1,6 @@
 #ifndef _M68K_DMA_H
 #define _M68K_DMA_H 1
  
-//#define	DMA_DEBUG	1
-
-
 #ifdef CONFIG_COLDFIRE
 /*
  * ColdFire DMA Model:
@@ -479,16 +476,16 @@ static __inline__ int get_dma_residue(unsigned int dmanr)
 
 #endif /* !defined(CONFIG_M5272) */
 #endif /* CONFIG_COLDFIRE */
- 
-#define MAX_DMA_CHANNELS 8
 
-/* Don't define MAX_DMA_ADDRESS; it's useless on the m68k/coldfire and any
-   occurrence should be flagged as an error.  */
-/* under 2.4 it is actually needed by the new bootmem allocator */
+/* it's useless on the m68k, but unfortunately needed by the new
+   bootmem allocator (but this should do it for this) */
 #define MAX_DMA_ADDRESS PAGE_OFFSET
 
-/* These are in kernel/dma.c: */
-extern int request_dma(unsigned int dmanr, const char *device_id);	/* reserve a DMA channel */
+#define MAX_DMA_CHANNELS 8
+
+extern int request_dma(unsigned int dmanr, const char * device_id);	/* reserve a DMA channel */
 extern void free_dma(unsigned int dmanr);	/* release it again */
- 
+
+#define isa_dma_bridge_buggy    (0)
+
 #endif /* _M68K_DMA_H */
diff --git a/arch/m68k/include/asm/dma_mm.h b/arch/m68k/include/asm/dma_mm.h
deleted file mode 100644
index 4240fbc..0000000
--- a/arch/m68k/include/asm/dma_mm.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _M68K_DMA_H
-#define _M68K_DMA_H 1
-
-
-/* it's useless on the m68k, but unfortunately needed by the new
-   bootmem allocator (but this should do it for this) */
-#define MAX_DMA_ADDRESS PAGE_OFFSET
-
-#define MAX_DMA_CHANNELS 8
-
-extern int request_dma(unsigned int dmanr, const char * device_id);	/* reserve a DMA channel */
-extern void free_dma(unsigned int dmanr);	/* release it again */
-
-#define isa_dma_bridge_buggy    (0)
-
-#endif /* _M68K_DMA_H */
