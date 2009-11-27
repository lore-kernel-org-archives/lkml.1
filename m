Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZK0N4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZK0N4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZK0N4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:05 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:5876 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZK0Nzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:55 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD4-02-34T-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/34] x86/amd-iommu: Remove iommu parameter from dma_ops_domain_(un)map
Date: Fri, 27 Nov 2009 14:55:26 +0100
Message-ID: <1259330145-14865-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0248 (UTC) FILETIME=[52A82180:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter is unused in these function so remove it from
the parameter list.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c5102eb..da3f9d8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1585,8 +1585,7 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
  * This is the generic map function. It maps one 4kb page at paddr to
  * the given address in the DMA address space for the domain.
  */
-static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
-				     struct dma_ops_domain *dom,
+static dma_addr_t dma_ops_domain_map(struct dma_ops_domain *dom,
 				     unsigned long address,
 				     phys_addr_t paddr,
 				     int direction)
@@ -1620,8 +1619,7 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 /*
  * The generic unmapping function for on page in the DMA address space.
  */
-static void dma_ops_domain_unmap(struct amd_iommu *iommu,
-				 struct dma_ops_domain *dom,
+static void dma_ops_domain_unmap(struct dma_ops_domain *dom,
 				 unsigned long address)
 {
 	struct aperture_range *aperture;
@@ -1700,7 +1698,7 @@ retry:
 
 	start = address;
 	for (i = 0; i < pages; ++i) {
-		ret = dma_ops_domain_map(iommu, dma_dom, start, paddr, dir);
+		ret = dma_ops_domain_map(dma_dom, start, paddr, dir);
 		if (ret == DMA_ERROR_CODE)
 			goto out_unmap;
 
@@ -1724,7 +1722,7 @@ out_unmap:
 
 	for (--i; i >= 0; --i) {
 		start -= PAGE_SIZE;
-		dma_ops_domain_unmap(iommu, dma_dom, start);
+		dma_ops_domain_unmap(dma_dom, start);
 	}
 
 	dma_ops_free_addresses(dma_dom, address, pages);
@@ -1754,7 +1752,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	start = dma_addr;
 
 	for (i = 0; i < pages; ++i) {
-		dma_ops_domain_unmap(iommu, dma_dom, start);
+		dma_ops_domain_unmap(dma_dom, start);
 		start += PAGE_SIZE;
 	}
 
-- 
1.6.5.3


