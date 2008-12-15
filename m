Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYLOOU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYLOOU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYLOOSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:31 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:23540 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbYLOOSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:30 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBX926-03-GLL-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/22] AMD IOMMU: use dev_name in iommu_enable function
Date: Mon, 15 Dec 2008 15:17:50 +0100
Message-ID: <1229350685-3816-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0085 (UTC) FILETIME=[F2BA9B50:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index b53152b..0f36753 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -245,12 +245,8 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 /* Function to enable the hardware */
 void __init iommu_enable(struct amd_iommu *iommu)
 {
-	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU "
-	       "at %02x:%02x.%x cap 0x%hx\n",
-	       iommu->dev->bus->number,
-	       PCI_SLOT(iommu->dev->devfn),
-	       PCI_FUNC(iommu->dev->devfn),
-	       iommu->cap_ptr);
+	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at %s cap 0x%hx\n",
+	       dev_name(&iommu->dev->dev), iommu->cap_ptr);
 
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
-- 
1.5.6.4


