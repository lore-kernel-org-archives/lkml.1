Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYIVSYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYIVSYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYIVSVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:50 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:51362 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbYIVSVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:46 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7M0BI-04-6F7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/9] x86/iommu: change Intel IOMMU to use dma_ops register interface
Date: Mon, 22 Sep 2008 20:21:20 +0200
Message-ID: <1222107681-8185-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0379 (UTC) FILETIME=[0380BB30:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 6c4c1c3..283e65f 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2255,6 +2255,12 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 	return nelems;
 }
 
+static int intel_device_supported(struct device *dev)
+{
+	/* FIXME: is this correct? */
+	return  dev && dev->bus == &pci_bus_type;
+}
+
 static struct dma_mapping_ops intel_dma_ops = {
 	.alloc_coherent = intel_alloc_coherent,
 	.free_coherent = intel_free_coherent,
@@ -2262,6 +2268,7 @@ static struct dma_mapping_ops intel_dma_ops = {
 	.unmap_single = intel_unmap_single,
 	.map_sg = intel_map_sg,
 	.unmap_sg = intel_unmap_sg,
+	.device_supported = intel_device_supported,
 };
 
 static inline int iommu_domain_cache_init(void)
@@ -2449,6 +2456,7 @@ int __init intel_iommu_init(void)
 
 	init_timer(&unmap_timer);
 	force_iommu = 1;
+	x86_register_dma_ops(&intel_dma_ops, DMA_OPS_TYPE_HW);
 	dma_ops = &intel_dma_ops;
 	return 0;
 }
-- 
1.5.6.4


