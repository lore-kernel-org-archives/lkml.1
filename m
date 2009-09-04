Return-Path: <linux-kernel-owner+w=401wt.eu-S933427AbZIDJjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbZIDJjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933414AbZIDJjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:39:12 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:21158 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbZIDJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:28 -0400
X-SpamScore: 7
X-BigFish: VPS7(zba6lzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KPFXFY-01-4M4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/8] x86/amd-iommu: Initialize passthrough mode when requested
Date: Fri, 4 Sep 2009 11:36:34 +0200
Message-ID: <1252056994-31980-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0513 (UTC) FILETIME=[3692CE90:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the passthrough mode for AMD IOMMU by
running the initialization function when iommu=pt is passed
on the kernel command line.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c1b17e9..f00f489 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1242,12 +1242,18 @@ int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
-	ret = amd_iommu_init_dma_ops();
+	if (iommu_pass_through)
+		ret = amd_iommu_init_passthrough();
+	else
+		ret = amd_iommu_init_dma_ops();
 	if (ret)
 		goto free;
 
 	enable_iommus();
 
+	if (iommu_pass_through)
+		goto out;
+
 	printk(KERN_INFO "AMD IOMMU: device isolation ");
 	if (amd_iommu_isolate)
 		printk("enabled\n");
-- 
1.6.3.3


