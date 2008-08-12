Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYHLP1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYHLP1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYHLPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:25:25 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:49275 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYHLPZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:25:22 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K5HUTH-03-1L0-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/7] x86: add free_coherent dma_ops callback to GART driver
Date: Tue, 12 Aug 2008 17:24:12 +0200
Message-ID: <1218554657-16070-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 12 Aug 2008 15:24:18.0095 (UTC) FILETIME=[7C987BF0:01C8FC8F]
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
index 55cc388..18db09b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -519,6 +519,15 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
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
@@ -722,6 +731,7 @@ static struct dma_mapping_ops gart_dma_ops = {
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
 	.alloc_coherent			= gart_alloc_coherent,
+	.free_coherent			= gart_free_coherent,
 };
 
 void gart_iommu_shutdown(void)
-- 
1.5.3.7


