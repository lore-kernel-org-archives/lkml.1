Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYHLP0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYHLP0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYHLPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:25:16 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:9237 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYHLPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:25:15 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5HUTG-04-OI5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/7] x86: add free_coherent dma_ops callback to NOMMU driver
Date: Tue, 12 Aug 2008 17:24:15 +0200
Message-ID: <1218554657-16070-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 12 Aug 2008 15:24:18.0180 (UTC) FILETIME=[7CA57440:01C8FC8F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-nommu.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 4d8cde3..f4ad3e7 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -109,8 +109,15 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	return NULL;
 }
 
+static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
+				dma_addr_t dma_addr)
+{
+	free_pages((unsigned long)vaddr, get_order(size));
+}
+
 struct dma_mapping_ops nommu_dma_ops = {
 	.alloc_coherent = nommu_alloc_coherent,
+	.free_coherent = nommu_free_coherent,
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
 	.is_phys = 1,
-- 
1.5.3.7


