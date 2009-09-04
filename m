Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbZIDJmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbZIDJmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbZIDJmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:15 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20762 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445AbZIDJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:04 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPFXLW-03-O1N-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/14] x86/amd-iommu: Remove last usages of IOMMU_PTE_L0_INDEX
Date: Fri, 4 Sep 2009 11:40:47 +0200
Message-ID: <1252057252-32074-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0533 (UTC) FILETIME=[CCCA01D0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change allows to remove these old macros later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 3be2b61..ebc1c84 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1402,7 +1402,7 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 		pte = alloc_pte(&dom->domain, address, &pte_page, GFP_ATOMIC);
 		aperture->pte_pages[APERTURE_PAGE_INDEX(address)] = pte_page;
 	} else
-		pte += IOMMU_PTE_L0_INDEX(address);
+		pte += PM_LEVEL_INDEX(0, address);
 
 	update_domain(&dom->domain);
 
@@ -1466,7 +1466,7 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 	if (!pte)
 		return;
 
-	pte += IOMMU_PTE_L0_INDEX(address);
+	pte += PM_LEVEL_INDEX(0, address);
 
 	WARN_ON(!*pte);
 
-- 
1.6.3.3


