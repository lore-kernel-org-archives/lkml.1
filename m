Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYLSFOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYLSFOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYLSFLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:34 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42905 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYLSFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:28 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 03/11] swiotlb: Rename SG_ENT_PHYS_ADDRESS to SG_ENT_BUS_ADDRESS
Date: Thu, 18 Dec 2008 23:11:14 -0600
Message-Id: <1229663480-10757-4-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add hwdev argument - some platforms will need this to
calculate an actual bus address.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 9b89a9d..add1f92 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -36,7 +36,7 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(sg_virt(sg))
+#define SG_ENT_BUS_ADDRESS(hwdev, sg)	virt_to_bus(sg_virt(sg))
 
 /*
  * Maximum allowable number of contiguous slabs to map,
@@ -765,7 +765,7 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
+		if (sg->dma_address != SG_ENT_BUS_ADDRESS(hwdev, sg))
 			unmap_single(hwdev, bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
@@ -798,7 +798,7 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
+		if (sg->dma_address != SG_ENT_BUS_ADDRESS(hwdev, sg))
 			sync_single(hwdev, bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-- 
1.5.6.5

