Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYLIO3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYLIO3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYLIORn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:43 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52458 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbYLIOQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:28 -0500
X-BigFish: VPS4(ze80izzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KBM4Z2-03-KKI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/11] VT-d: register functions for the IOMMU API
Date: Tue, 9 Dec 2008 15:16:09 +0100
Message-ID: <1228832170-13405-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832170-13405-10-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832170-13405-1-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-2-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-3-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-4-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-5-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-6-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-7-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-8-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-9-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-10-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:10.0997 (UTC) FILETIME=[AFA71250:01C95A08]
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
index 7128105..81e04ec 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -277,6 +277,8 @@ static int intel_iommu_strict;
 static DEFINE_SPINLOCK(device_domain_lock);
 static LIST_HEAD(device_domain_list);
 
+static struct iommu_ops intel_iommu_ops;
+
 static int __init intel_iommu_setup(char *str)
 {
 	if (!str)
@@ -2729,6 +2731,9 @@ int __init intel_iommu_init(void)
 	init_timer(&unmap_timer);
 	force_iommu = 1;
 	dma_ops = &intel_dma_ops;
+
+	register_iommu(&intel_iommu_ops);
+
 	return 0;
 }
 
@@ -3119,3 +3124,13 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 
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


