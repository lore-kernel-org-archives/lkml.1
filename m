Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbZEVMYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbZEVMYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758477AbZEVMWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:30 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21892 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbZEVMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:23 -0400
X-BigFish: VPS1(zzzz1202hzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KK1P0Z-01-JR5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/12] amd-iommu: disable round-robin allocator for CONFIG_IOMMU_STRESS
Date: Fri, 22 May 2009 14:21:31 +0200
Message-ID: <1242994893-28902-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:33.0064 (UTC) FILETIME=[D7D4C880:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: put high load on iommu tlb to find stale entry bugs ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 31d56c3..543822b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -783,6 +783,11 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 {
 	unsigned long address;
 
+#ifdef CONFIG_IOMMU_STRESS
+	dom->next_address = 0;
+	dom->need_flush = true;
+#endif
+
 	address = dma_ops_area_alloc(dev, dom, pages, align_mask,
 				     dma_mask, dom->next_address);
 
-- 
1.6.3.1


