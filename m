Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXBJLoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXBJLoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbXBJLoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:44:23 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:14640 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbXBJLoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:44:22 -0500
Date: Sat, 10 Feb 2007 12:43:14 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: [patch] More defines for dma-mapping-broken.h
Message-ID: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

9ac7849e35f705830f7b016ff272b0ff1f7ff759 causes this on s390.
Since we don't support DMA extend dma-mapping-broken.h a bit.

drivers/base/dma-mapping.c: In function `dmam_noncoherent_release':
drivers/base/dma-mapping.c:32:
	warning: implicit declaration of function `dma_free_noncoherent'
drivers/base/dma-mapping.c: In function `dmam_alloc_noncoherent':
drivers/base/dma-mapping.c:129:
	warning: implicit declaration of function `dma_alloc_noncoherent'
drivers/base/dma-mapping.c:129:
	warning: assignment makes pointer from integer without a cast

Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/asm-generic/dma-mapping-broken.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/include/asm-generic/dma-mapping-broken.h
===================================================================
--- linux-2.6.orig/include/asm-generic/dma-mapping-broken.h
+++ linux-2.6/include/asm-generic/dma-mapping-broken.h
@@ -3,7 +3,6 @@
 
 /* This is used for archs that do not support DMA */
 
-
 static inline void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		   gfp_t flag)
@@ -19,4 +18,7 @@ dma_free_coherent(struct device *dev, si
 	BUG();
 }
 
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
 #endif /* _ASM_GENERIC_DMA_MAPPING_H */
