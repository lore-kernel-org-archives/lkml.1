Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbZIDJjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbZIDJjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933366AbZIDJi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:38:28 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:1826 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933352AbZIDJiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:25 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXFU-01-4M2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/8] x86/dma: Mark iommu_pass_through as __read_mostly
Date: Fri, 4 Sep 2009 11:36:27 +0200
Message-ID: <1252056994-31980-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0279 (UTC) FILETIME=[366F19F0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is read most of the time. This patch marks it
as such. It also documents the meaning the this variable
while at it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-dma.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1a041bc..873aa07 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -32,7 +32,14 @@ int no_iommu __read_mostly;
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly = 0;
 
-int iommu_pass_through;
+/*
+ * This variable becomes 1 if iommu=pt is passed on the kernel command line.
+ * If this variable is 1, IOMMU implementations do no DMA ranslation for
+ * devices and allow every device to access to whole physical memory. This is
+ * useful if a user want to use an IOMMU only for KVM device assignment to
+ * guests and not for driver dma translation.
+ */
+int iommu_pass_through __read_mostly;
 
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
-- 
1.6.3.3


