Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbYHSOfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbYHSOfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYHSOdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:33:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:19320 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYHSOdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:33:15 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5UR2L-04-SOV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/8] x86: add free_coherent dma_ops callback to NOMMU driver
Date: Tue, 19 Aug 2008 16:32:43 +0200
Message-ID: <1219156366-32498-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0629 (UTC) FILETIME=[72D47550:01C90208]
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
index b8ce83c..73853d3 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -126,8 +126,15 @@ again:
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


