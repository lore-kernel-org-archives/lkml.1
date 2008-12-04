Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYLDRlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYLDRlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbYLDRcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:35 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47637 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725AbYLDRcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:13 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBD4P6-03-CX4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/19] AMD IOMMU: fix loop counter in free_pagetable function
Date: Thu, 4 Dec 2008 18:31:40 +0100
Message-ID: <1228411916-22668-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:56.0980 (UTC) FILETIME=[34BD1740:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bugfix

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b174471..f3dd4cd 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -599,7 +599,7 @@ static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
 			continue;
 
 		p2 = IOMMU_PTE_PAGE(p1[i]);
-		for (j = 0; j < 512; ++i) {
+		for (j = 0; j < 512; ++j) {
 			if (!IOMMU_PTE_PRESENT(p2[j]))
 				continue;
 			p3 = IOMMU_PTE_PAGE(p2[j]);
-- 
1.5.6.4


