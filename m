Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbYLDRin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbYLDRin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758181AbYLDRcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:32 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14755 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbYLDRcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:13 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBD4P7-03-CX5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/19] AMD IOMMU: rename iommu_map to iommu_map_page
Date: Thu, 4 Dec 2008 18:31:38 +0100
Message-ID: <1228411916-22668-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:56.0900 (UTC) FILETIME=[34B0E240:01C95636]
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
index e4899e0..9e1c0fb 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -335,10 +335,10 @@ static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
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
 
@@ -437,7 +437,7 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 
 	for (addr = e->address_start; addr < e->address_end;
 	     addr += PAGE_SIZE) {
-		ret = iommu_map(&dma_dom->domain, addr, addr, e->prot);
+		ret = iommu_map_page(&dma_dom->domain, addr, addr, e->prot);
 		if (ret)
 			return ret;
 		/*
-- 
1.5.6.4


