Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbYLDRja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbYLDRja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbYLDRck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:40 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47736 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbYLDRcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:14 -0500
X-BigFish: VPS4(ze80izzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBD4PD-03-CXH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/19] AMD IOMMU: register functions for the IOMMU API
Date: Thu, 4 Dec 2008 18:31:56 +0100
Message-ID: <1228411916-22668-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0511 (UTC) FILETIME=[350E1D70:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 57e636e..d859323 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -38,6 +38,8 @@ static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 static LIST_HEAD(iommu_pd_list);
 static DEFINE_SPINLOCK(iommu_pd_list_lock);
 
+static struct iommu_ops amd_iommu_ops;
+
 /*
  * general struct to manage commands send to an IOMMU
  */
@@ -1485,6 +1487,8 @@ int __init amd_iommu_init_dma_ops(void)
 	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
 
+	register_iommu(&amd_iommu_ops);
+
 	return 0;
 
 free_domains:
@@ -1713,3 +1717,13 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 
 	return paddr;
 }
+
+static struct iommu_ops amd_iommu_ops = {
+	.domain_init = amd_iommu_domain_init,
+	.domain_destroy = amd_iommu_domain_destroy,
+	.attach_dev = amd_iommu_attach_device,
+	.detach_dev = amd_iommu_detach_device,
+	.map = amd_iommu_map_range,
+	.unmap = amd_iommu_unmap_range,
+	.iova_to_phys = amd_iommu_iova_to_phys,
+};
-- 
1.5.6.4


