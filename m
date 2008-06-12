Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbYFLWNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbYFLWNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbYFLWMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:12:40 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:43415 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387AbYFLWMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:12:39 -0400
Date: Fri, 13 Jun 2008 01:11:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] mn10300: move sg_dma_{address,len}() to
	asm/scatterlist.h
Message-ID: <20080612221131.GO17231@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mn10300 was the only archotecture where sg_dma_{address,len}() were not 
in asm/scatterlist.h, and it's not a big surprise that this caused a 
compile error somewhere:

<--  snip  -->

..
  CC      drivers/media/video/videobuf-dma-sg.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/videobuf-dma-sg.c: In function `videobuf_dma_map':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/videobuf-dma-sg.c:238: error: implicit declaration of function 'sg_dma_address'
...
make[4]: *** [drivers/media/video/videobuf-dma-sg.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-mn10300/pci.h         |    9 ---------
 include/asm-mn10300/scatterlist.h |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

b300203c4ab4c6ef3650159edc67a6806171f2f6 diff --git a/include/asm-mn10300/pci.h b/include/asm-mn10300/pci.h
index 205192c..cd9cc5c 100644
--- a/include/asm-mn10300/pci.h
+++ b/include/asm-mn10300/pci.h
@@ -74,15 +74,6 @@ struct pci_dev;
 /* This is always fine. */
 #define pci_dac_dma_supported(pci_dev, mask)	(0)
 
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
-
 /* Return the index of the PCI controller for device. */
 static inline int pci_controller_num(struct pci_dev *dev)
 {
diff --git a/include/asm-mn10300/scatterlist.h b/include/asm-mn10300/scatterlist.h
index e29d91d..6753590 100644
--- a/include/asm-mn10300/scatterlist.h
+++ b/include/asm-mn10300/scatterlist.h
@@ -43,4 +43,13 @@ struct scatterlist {
 
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
+/*
+ * These macros should be used after a pci_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns.
+ */
+#define sg_dma_address(sg)	((sg)->dma_address)
+#define sg_dma_len(sg)		((sg)->length)
+
 #endif /* _ASM_SCATTERLIST_H */

