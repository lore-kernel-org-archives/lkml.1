Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYLBNFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYLBNFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYLBNCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:02:11 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:26056 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYLBNBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:37 -0500
X-BigFish: VPS4(ze80izzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KB92UD-03-HHL-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/12] VT-d: register functions for the IOMMU API
Date: Tue, 2 Dec 2008 14:01:23 +0100
Message-ID: <1228222883-17207-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:24.0019 (UTC) FILETIME=[14505030:01C9547E]
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
index 2e8b102..bb6f771 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -55,6 +55,7 @@
 
 
 static void flush_unmaps_timeout(unsigned long data);
+static struct iommu_ops intel_iommu_ops;
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
 
@@ -2429,6 +2430,9 @@ int __init intel_iommu_init(void)
 	init_timer(&unmap_timer);
 	force_iommu = 1;
 	dma_ops = &intel_dma_ops;
+
+	register_iommu(&intel_iommu_ops);
+
 	return 0;
 }
 
@@ -2929,3 +2933,12 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	return paddr;
 }
 
+static struct iommu_ops intel_iommu_ops = {
+	.domain_init	= intel_iommu_domain_init,
+	.domain_destroy	= intel_iommu_domain_destroy,
+	.attach_dev	= intel_iommu_attach_device,
+	.detach_dev	= intel_iommu_detach_device,
+	.map		= intel_iommu_map,
+	.unmap		= intel_iommu_unmap,
+	.iova_to_phys	= intel_iommu_iova_to_phys,
+};
-- 
1.5.6.4


