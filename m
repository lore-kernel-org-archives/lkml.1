Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbZIDJnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbZIDJnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933496AbZIDJmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:17 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:12855
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933461AbZIDJmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:03 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KPFXLW-03-O1M-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/14] x86/amd-iommu: Use 2-level page tables for dma_ops domains
Date: Fri, 4 Sep 2009 11:40:49 +0200
Message-ID: <1252057252-32074-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0595 (UTC) FILETIME=[CCD377B0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver now supports a dynamic number of levels for IO
page tables. This allows to reduce the number of levels for
dma_ops domains by one because a dma_ops domain has usually
an address space size between 128MB and 4G.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6ffb3e6..addf658 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1010,7 +1010,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
 	dma_dom->domain.id = domain_id_alloc();
 	if (dma_dom->domain.id == 0)
 		goto free_dma_dom;
-	dma_dom->domain.mode = PAGE_MODE_3_LEVEL;
+	dma_dom->domain.mode = PAGE_MODE_2_LEVEL;
 	dma_dom->domain.pt_root = (void *)get_zeroed_page(GFP_KERNEL);
 	dma_dom->domain.flags = PD_DMA_OPS_MASK;
 	dma_dom->domain.priv = dma_dom;
-- 
1.6.3.3


