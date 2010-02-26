Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796Ab0BZAqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:46:23 -0500
Received: from sh.osrg.net ([192.16.179.4]:49907 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934749Ab0BZAqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:46:22 -0500
Date: Fri, 26 Feb 2010 09:43:51 +0900
To: tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [PATCH] IA64: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100226094203Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 26 Feb 2010 09:43:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IA64's scatterlist structure is identical to the generic one.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/include/asm/scatterlist.h |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/arch/ia64/include/asm/scatterlist.h b/arch/ia64/include/asm/scatterlist.h
index d6f5787..d8e9896 100644
--- a/arch/ia64/include/asm/scatterlist.h
+++ b/arch/ia64/include/asm/scatterlist.h
@@ -2,25 +2,6 @@
 #define _ASM_IA64_SCATTERLIST_H
 
 /*
- * Modified 1998-1999, 2001-2002, 2004
- *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
- */
-
-#include <asm/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-	unsigned int length;	/* buffer length */
-
-	dma_addr_t dma_address;
-	unsigned int dma_length;
-};
-
-/*
  * It used to be that ISA_DMA_THRESHOLD had something to do with the
  * DMA-limits of ISA-devices.  Nowadays, its only remaining use (apart
  * from the aha1542.c driver, which isn't 64-bit clean anyhow) is to
@@ -30,9 +11,6 @@ struct scatterlist {
  */
 #define ISA_DMA_THRESHOLD	0xffffffff
 
-#define sg_dma_len(sg)		((sg)->dma_length)
-#define sg_dma_address(sg)	((sg)->dma_address)
-
-#define	ARCH_HAS_SG_CHAIN
+#include <asm-generic/scatterlist.h>
 
 #endif /* _ASM_IA64_SCATTERLIST_H */
-- 
1.6.5

