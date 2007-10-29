Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbXJ2N24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbXJ2N24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXJ2N2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:28:47 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40331 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXJ2N2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:28:47 -0400
Date: Mon, 29 Oct 2007 09:25:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: dhowells@redhat.com
Subject: [PATCH] FRV:  Move DMA macros to scatterlist.h for consistency.
Message-ID: <Pine.LNX.4.64.0710290925001.11882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


To be consistent with other architectures, these two DMA macros should
be defined in scatterlist.h as opposed to dma-mapping.h

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  if david prefers to handle this because he wants to do something
differently, that's cool.

  not compile-tested as it looks fairly trivial, but i've said *that*
before.


diff --git a/include/asm-frv/dma-mapping.h b/include/asm-frv/dma-mapping.h
index bcb2df6..2e8966c 100644
--- a/include/asm-frv/dma-mapping.h
+++ b/include/asm-frv/dma-mapping.h
@@ -17,16 +17,6 @@ void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle
 void dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle);

 /*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
-
-/*
  * Map a single buffer of the indicated size for DMA in streaming mode.
  * The 32-bit bus address to use is returned.
  *
diff --git a/include/asm-frv/scatterlist.h b/include/asm-frv/scatterlist.h
index 2e7143b..c0c2da0 100644
--- a/include/asm-frv/scatterlist.h
+++ b/include/asm-frv/scatterlist.h
@@ -31,6 +31,9 @@ struct scatterlist {
 	unsigned int	length;
 };

+#define sg_dma_address(sg)	((sg)->dma_address)
+#define sg_dma_len(sg)		((sg)->length)
+
 #define ISA_DMA_THRESHOLD (0xffffffffUL)

 #endif /* !_ASM_SCATTERLIST_H */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
