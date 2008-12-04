Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYLDRju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYLDRju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbYLDRcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:46 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47897 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbYLDRcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:18 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBD4P4-04-YDG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/19] AMD IOMMU: fix iommu_map_page function
Date: Thu, 4 Dec 2008 18:31:39 +0100
Message-ID: <1228411916-22668-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:56.0949 (UTC) FILETIME=[34B85C50:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bugfix in iommu_map_page function

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9e1c0fb..b174471 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -343,7 +343,7 @@ static int iommu_map_page(struct protection_domain *dom,
 	u64 __pte, *pte, *page;
 
 	bus_addr  = PAGE_ALIGN(bus_addr);
-	phys_addr = PAGE_ALIGN(bus_addr);
+	phys_addr = PAGE_ALIGN(phys_addr);
 
 	/* only support 512GB address spaces for now */
 	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))
-- 
1.5.6.4


