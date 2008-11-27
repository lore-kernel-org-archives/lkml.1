Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbYK0Pmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbYK0Pmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYK0PlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:25 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:61779 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYK0PlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:10 -0500
X-BigFish: VPS4(ze80izzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KB00W7-03-L7A-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/9] VT-d: register functions for the IOMMU API
Date: Thu, 27 Nov 2008 16:40:53 +0100
Message-ID: <1227800454-9555-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0937 (UTC) FILETIME=[88F5C090:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 8fa0269..71b4d2f 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -57,6 +57,7 @@
 
 
 static void flush_unmaps_timeout(unsigned long data);
+static struct iommu_ops intel_iommu_ops;
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
 
@@ -2326,6 +2327,9 @@ int __init intel_iommu_init(void)
 	init_timer(&unmap_timer);
 	force_iommu = 1;
 	dma_ops = &intel_dma_ops;
+
+	register_iommu(&intel_iommu_ops);
+
 	return 0;
 }
 
@@ -2514,3 +2518,12 @@ static phys_addr_t intel_iova_to_phys(struct iommu_domain *domain,
 
 	return (pfn << PAGE_SHIFT) & offset;
 }
+
+static struct iommu_ops intel_iommu_ops = {
+	.domain_init	= intel_iommu_domain_init,
+	.domain_destroy	= intel_iommu_domain_destroy,
+	.attach_dev	= intel_iommu_attach_device,
+	.detach_dev	= intel_iommu_detach_device,
+	.map		= intel_iommu_map,
+	.iova_to_phys	= intel_iova_to_phys,
+};
-- 
1.5.6.4


