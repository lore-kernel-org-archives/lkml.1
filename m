Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYLIOVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYLIOVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYLIOQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:44 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52587 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbYLIOQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:29 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBM4Z5-04-AEJ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/21] AMD IOMMU: fix loop counter in free_pagetable function
Date: Tue, 9 Dec 2008 15:16:00 +0100
Message-ID: <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:18.0786 (UTC) FILETIME=[B44B9420:01C95A08]
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
index 153db6e..e96a2f3 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -600,7 +600,7 @@ static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
 			continue;
 
 		p2 = IOMMU_PTE_PAGE(p1[i]);
-		for (j = 0; j < 512; ++i) {
+		for (j = 0; j < 512; ++j) {
 			if (!IOMMU_PTE_PRESENT(p2[j]))
 				continue;
 			p3 = IOMMU_PTE_PAGE(p2[j]);
-- 
1.5.6.4


