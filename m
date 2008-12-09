Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYLIO0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYLIO0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYLIORW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:22 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41382 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbYLIOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:45 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBM4Z8-03-KKR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/21] AMD IOMMU: rename iommu_map to iommu_map_page
Date: Tue, 9 Dec 2008 15:15:58 +0100
Message-ID: <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:18.0685 (UTC) FILETIME=[B43C2AD0:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: function rename

The iommu_map function maps only one page. Make this clear in the
function name.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5662e22..4db4542 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -336,10 +336,10 @@ static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
  * supporting all features of AMD IOMMU page tables like level skipping
  * and full 64 bit address spaces.
  */
-static int iommu_map(struct protection_domain *dom,
-		     unsigned long bus_addr,
-		     unsigned long phys_addr,
-		     int prot)
+static int iommu_map_page(struct protection_domain *dom,
+			  unsigned long bus_addr,
+			  unsigned long phys_addr,
+			  int prot)
 {
 	u64 __pte, *pte, *page;
 
@@ -438,7 +438,7 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 
 	for (addr = e->address_start; addr < e->address_end;
 	     addr += PAGE_SIZE) {
-		ret = iommu_map(&dma_dom->domain, addr, addr, e->prot);
+		ret = iommu_map_page(&dma_dom->domain, addr, addr, e->prot);
 		if (ret)
 			return ret;
 		/*
-- 
1.5.6.4


