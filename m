Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYLDRdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYLDRdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbYLDR3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:31 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:12901 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYLDR3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:21 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBD4K7-04-Y70-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/11] VT-d: remove now unused intel_iommu_found function
Date: Thu, 4 Dec 2008 18:28:56 +0100
Message-ID: <1228411736-22644-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0928 (UTC) FILETIME=[C96B5600:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |    6 ------
 include/linux/intel-iommu.h |    9 ---------
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 20d2305..90767f2 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2808,12 +2808,6 @@ static void intel_iommu_unmap_range(struct iommu_domain *domain,
 		dmar_domain->max_addr = base;
 }
 
-int intel_iommu_found(void)
-{
-	return g_num_of_iommus;
-}
-EXPORT_SYMBOL_GPL(intel_iommu_found);
-
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 					    unsigned long iova)
 {
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 57c44c2..86a9653 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -335,15 +335,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-#ifdef CONFIG_DMAR
-int intel_iommu_found(void);
-#else /* CONFIG_DMAR */
-static inline int intel_iommu_found(void)
-{
-	return 0;
-}
-#endif /* CONFIG_DMAR */
-
 extern void *intel_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
 extern void intel_free_coherent(struct device *, size_t, void *, dma_addr_t);
 extern dma_addr_t intel_map_single(struct device *, phys_addr_t, size_t, int);
-- 
1.5.6.4


