Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZCJFPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZCJFPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZCJFLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:39358 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZCJFLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yIcQ2DuwN4Rwl/unkiGCb5Llgo50OShV5xtuGeZoqK/zdDJrrG/znx3tqB6WUlbE3J
         YOtj1lmBB3a51W7IU6zA7gDLQUo8JNQVyUaem+IPDXgAh4+HU9wXxjUzOxLEbvv57wt9
         rSa7PnmrsVWoalBnf/kK/TBi6OmO1DDHqpuEU=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: [PATCH 11/25] [alpha] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:36 -0500
Message-Id: <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/alpha/kernel/pci_iommu.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index b9094da..9ebaca2 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -310,8 +310,7 @@ pci_map_single(struct pci_dev *pdev, void *cpu_addr, size_t size, int dir)
 {
 	int dac_allowed; 
 
-	if (dir == PCI_DMA_NONE)
-		BUG();
+	BUG_ON(dir == PCI_DMA_NONE);
 
 	dac_allowed = pdev ? pci_dac_dma_supported(pdev, pdev->dma_mask) : 0; 
 	return pci_map_single_1(pdev, cpu_addr, size, dac_allowed);
@@ -324,8 +323,7 @@ pci_map_page(struct pci_dev *pdev, struct page *page, unsigned long offset,
 {
 	int dac_allowed;
 
-	if (dir == PCI_DMA_NONE)
-		BUG();
+	BUG_ON(dir == PCI_DMA_NONE);
 
 	dac_allowed = pdev ? pci_dac_dma_supported(pdev, pdev->dma_mask) : 0; 
 	return pci_map_single_1(pdev, (char *)page_address(page) + offset, 
@@ -348,8 +346,7 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr, size_t size,
 	struct pci_iommu_arena *arena;
 	long dma_ofs, npages;
 
-	if (direction == PCI_DMA_NONE)
-		BUG();
+	BUG_ON(direction == PCI_DMA_NONE);
 
 	if (dma_addr >= __direct_map_base
 	    && dma_addr < __direct_map_base + __direct_map_size) {
@@ -641,8 +638,7 @@ pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
 	int dac_allowed;
 	struct device *dev;
 
-	if (direction == PCI_DMA_NONE)
-		BUG();
+	BUG_ON(direction == PCI_DMA_NONE);
 
 	dac_allowed = pdev ? pci_dac_dma_supported(pdev, pdev->dma_mask) : 0;
 
@@ -723,8 +719,7 @@ pci_unmap_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
 	dma_addr_t max_dma;
 	dma_addr_t fbeg, fend;
 
-	if (direction == PCI_DMA_NONE)
-		BUG();
+	BUG_ON(direction == PCI_DMA_NONE);
 
 	if (! alpha_mv.mv_pci_tbi)
 		return;
-- 
1.6.1.3

