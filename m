Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZCJFQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZCJFQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZCJFLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:50 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28246 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbZCJFLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MPEcDeyrWdiwXiVfHzBRl8GEVfcK1vVunAq2+FmlGF98fj7n1DmG/VoqIENTSzuqxp
         voRJ+mCz0Ve7tiSPSlwz69Er7oOt1GITsv5IvoWnhoNMvpd56vS2rrW+zl3QkbxGbVGp
         E4dTyCCySxgTKbbLw2aqZ6YBwC7vroHQciL1I=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, cooloney@kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 13/25] [blackfin] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:38 -0500
Message-Id: <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/blackfin/include/asm/pci.h |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/blackfin/include/asm/pci.h b/arch/blackfin/include/asm/pci.h
index 6127735..4934ba1 100644
--- a/arch/blackfin/include/asm/pci.h
+++ b/arch/blackfin/include/asm/pci.h
@@ -51,8 +51,7 @@ static inline void pcibios_penalize_isa_irq(int irq)
 static inline dma_addr_t pci_map_single(struct pci_dev *hwdev, void *ptr,
 					size_t size, int direction)
 {
-	if (direction == PCI_DMA_NONE)
-		BUG();
+	BUG_ON(direction == PCI_DMA_NONE);
 
 	 /* return virt_to_bus(ptr); */
 	return (dma_addr_t) ptr;
@@ -68,9 +67,7 @@ static inline dma_addr_t pci_map_single(struct pci_dev *hwdev, void *ptr,
 static inline void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr,
 				    size_t size, int direction)
 {
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
+	BUG_ON(direction == PCI_DMA_NONE);
 	/* Nothing to do */
 }
 
@@ -92,8 +89,7 @@ static inline void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr,
 static inline int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
 			     int nents, int direction)
 {
-	if (direction == PCI_DMA_NONE)
-		BUG();
+	BUG_ON(direction == PCI_DMA_NONE);
 	return nents;
 }
 
@@ -104,9 +100,7 @@ static inline int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
 static inline void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg,
 				int nents, int direction)
 {
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
+	BUG_ON(direction == PCI_DMA_NONE);
 	/* Nothing to do */
 }
 
@@ -123,9 +117,7 @@ static inline void pci_dma_sync_single(struct pci_dev *hwdev,
 				       dma_addr_t dma_handle, size_t size,
 				       int direction)
 {
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
+	BUG_ON(direction == PCI_DMA_NONE);
 	/* Nothing to do */
 }
 
@@ -139,9 +131,7 @@ static inline void pci_dma_sync_sg(struct pci_dev *hwdev,
 				   struct scatterlist *sg, int nelems,
 				   int direction)
 {
-	if (direction == PCI_DMA_NONE)
-		BUG();
-
+	BUG_ON(direction == PCI_DMA_NONE);
 	/* Nothing to do */
 }
 
-- 
1.6.1.3

