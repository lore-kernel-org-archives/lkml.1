Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZCPRGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZCPRGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759977AbZCPRFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:05:48 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:13358
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759674AbZCPRFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:05:46 -0400
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KGLZH5-01-IY5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] dma-debug/x86: register pci bus for dma-debug leak detection
Date: Mon, 16 Mar 2009 18:05:30 +0100
Message-ID: <1237223130-26519-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Mar 2009 17:05:30.0556 (UTC) FILETIME=[694A7FC0:01C9A659]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: detect dma memory leaks for pci devices

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-dma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index ebf7d45..c7c4776 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -271,6 +271,10 @@ static int __init pci_iommu_init(void)
 {
 	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
 
+#ifdef CONFIG_PCI
+	dma_debug_add_bus(&pci_bus_type);
+#endif
+
 	calgary_iommu_init();
 
 	intel_iommu_init();
-- 
1.5.6.4


