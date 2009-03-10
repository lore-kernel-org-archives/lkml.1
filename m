Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZCJFRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZCJFRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZCJFLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:55 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:28373 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbZCJFLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F0JFzGt8/SaS8YYFRDga0Il5EKlfzkNj5q0qx+TpmpxRBEERbnReHG0b3uZyFrVxVA
         IMX/xSb5rY+3nkPRcwUADqDWRHQxlj9Yv8F/H+4YWhGmrZou+Yl/Hw7oVMu5uEwzrLI8
         lzpAyi4slakuAfBEWVl2o0E0VhUVXX/q/7kLE=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org
Subject: [PATCH 17/25] [parisc] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:42 -0500
Message-Id: <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
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
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/parisc/kernel/pci-dma.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index df47895..2587563 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -480,8 +480,7 @@ static int pa11_dma_map_sg(struct device *dev, struct scatterlist *sglist, int n
 {
 	int i;
 
-	if (direction == DMA_NONE)
-	    BUG();
+	BUG_ON(direction == DMA_NONE);
 
 	for (i = 0; i < nents; i++, sglist++ ) {
 		unsigned long vaddr = sg_virt_addr(sglist);
@@ -496,8 +495,7 @@ static void pa11_dma_unmap_sg(struct device *dev, struct scatterlist *sglist, in
 {
 	int i;
 
-	if (direction == DMA_NONE)
-	    BUG();
+	BUG_ON(direction == DMA_NONE);
 
 	if (direction == DMA_TO_DEVICE)
 	    return;
@@ -511,16 +509,14 @@ static void pa11_dma_unmap_sg(struct device *dev, struct scatterlist *sglist, in
 
 static void pa11_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, unsigned long offset, size_t size, enum dma_data_direction direction)
 {
-	if (direction == DMA_NONE)
-	    BUG();
+	BUG_ON(direction == DMA_NONE);
 
 	flush_kernel_dcache_range((unsigned long) phys_to_virt(dma_handle) + offset, size);
 }
 
 static void pa11_dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, unsigned long offset, size_t size, enum dma_data_direction direction)
 {
-	if (direction == DMA_NONE)
-	    BUG();
+	BUG_ON(direction == DMA_NONE);
 
 	flush_kernel_dcache_range((unsigned long) phys_to_virt(dma_handle) + offset, size);
 }
-- 
1.6.1.3

