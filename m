Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbYIVSXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbYIVSXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYIVSVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:40 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36797 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYIVSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:35 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K7M0BH-04-6F3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/9] x86/iommu: change AMD IOMMU to use dma_ops register interface
Date: Mon, 22 Sep 2008 20:21:19 +0200
Message-ID: <1222107681-8185-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0363 (UTC) FILETIME=[037E4A30:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6f7b974..7aa9824 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1258,7 +1258,7 @@ free_mem:
  * This function is called by the DMA layer to find out if we can handle a
  * particular device. It is part of the dma_ops.
  */
-static int amd_iommu_dma_supported(struct device *dev, u64 mask)
+static int amd_iommu_device_supported(struct device *dev)
 {
 	u16 bdf;
 	struct pci_dev *pcidev;
@@ -1320,7 +1320,7 @@ static struct dma_mapping_ops amd_iommu_dma_ops = {
 	.unmap_single = unmap_single,
 	.map_sg = map_sg,
 	.unmap_sg = unmap_sg,
-	.dma_supported = amd_iommu_dma_supported,
+	.device_supported = amd_iommu_device_supported,
 };
 
 /*
@@ -1362,6 +1362,7 @@ int __init amd_iommu_init_dma_ops(void)
 #endif
 
 	/* Make the driver finally visible to the drivers */
+	x86_register_dma_ops(&amd_iommu_dma_ops, DMA_OPS_TYPE_HW);
 	dma_ops = &amd_iommu_dma_ops;
 
 	return 0;
-- 
1.5.6.4


