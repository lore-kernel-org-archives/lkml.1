Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYHSOeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYHSOeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYHSOdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:33:09 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:41830 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbYHSOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:33:06 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0K5UR2K-03-AJ1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/8] x86: add free_coherent dma_ops callback to GART driver
Date: Tue, 19 Aug 2008 16:32:40 +0200
Message-ID: <1219156366-32498-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0536 (UTC) FILETIME=[72C64480:01C90208]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 44a75a6..794d026 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -526,6 +526,15 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 	return NULL;
 }
 
+/* free a coherent mapping */
+static void
+gart_free_coherent(struct device *dev, size_t size, void *vaddr,
+		   dma_addr_t dma_addr)
+{
+	gart_unmap_single(dev, dma_addr, size, DMA_BIDIRECTIONAL);
+	free_pages((unsigned long)vaddr, get_order(size));
+}
+
 static int no_agp;
 
 static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
@@ -729,6 +738,7 @@ static struct dma_mapping_ops gart_dma_ops = {
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
 	.alloc_coherent			= gart_alloc_coherent,
+	.free_coherent			= gart_free_coherent,
 };
 
 void gart_iommu_shutdown(void)
-- 
1.5.3.7


