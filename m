Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbYLDRd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbYLDRd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbYLDR3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:33 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:3106 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbYLDR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:22 -0500
X-BigFish: VPS4(ze80izzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBD4K7-04-Y6Z-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/11] VT-d: register functions for the IOMMU API
Date: Thu, 4 Dec 2008 18:28:55 +0100
Message-ID: <1228411736-22644-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0865 (UTC) FILETIME=[C961B910:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c5f1405..20d2305 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -90,6 +90,8 @@ static int intel_iommu_strict;
 static DEFINE_SPINLOCK(device_domain_lock);
 static LIST_HEAD(device_domain_list);
 
+static struct iommu_ops intel_iommu_ops;
+
 static int __init intel_iommu_setup(char *str)
 {
 	if (!str)
@@ -2419,6 +2421,9 @@ int __init intel_iommu_init(void)
 	init_timer(&unmap_timer);
 	force_iommu = 1;
 	dma_ops = &intel_dma_ops;
+
+	register_iommu(&intel_iommu_ops);
+
 	return 0;
 }
 
@@ -2822,3 +2827,13 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 
 	return phys;
 }
+
+static struct iommu_ops intel_iommu_ops = {
+	.domain_init	= intel_iommu_domain_init,
+	.domain_destroy = intel_iommu_domain_destroy,
+	.attach_dev	= intel_iommu_attach_device,
+	.detach_dev	= intel_iommu_detach_device,
+	.map		= intel_iommu_map_range,
+	.unmap		= intel_iommu_unmap_range,
+	.iova_to_phys	= intel_iommu_iova_to_phys,
+};
-- 
1.5.6.4


