Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbYFZTcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbYFZTcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760645AbYFZT2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:41 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:25029 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760597AbYFZT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:39 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K334R4-03-2YF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 32/34] AMD_IOMMU: call detect and initialization functions from dma code
Date: Thu, 26 Jun 2008 21:28:08 +0200
Message-ID: <1214508490-29683-33-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0268 (UTC) FILETIME=[C5D3D2C0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the function calls to initialize the AMD IOMMU hardware and
dma_ops to the generic DMA code for the x86 architecture.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-dma.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index dc00a13..dea0167 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -7,6 +7,7 @@
 #include <asm/dma.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
+#include <asm/amd_iommu.h>
 
 int forbid_dac __read_mostly;
 EXPORT_SYMBOL(forbid_dac);
@@ -122,6 +123,8 @@ void __init pci_iommu_alloc(void)
 
 	detect_intel_iommu();
 
+	amd_iommu_detect();
+
 #ifdef CONFIG_SWIOTLB
 	pci_swiotlb_init();
 #endif
@@ -502,6 +505,8 @@ static int __init pci_iommu_init(void)
 
 	intel_iommu_init();
 
+	amd_iommu_init();
+
 #ifdef CONFIG_GART_IOMMU
 	gart_iommu_init();
 #endif
-- 
1.5.3.7


