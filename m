Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYGCSw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYGCSw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYGCSwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:52:51 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:2375 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYGCSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:52:50 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K3FY6Q-03-NVE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/6] AMD IOMMU: remove unnecessary code from the iommu_enable function
Date: Thu, 3 Jul 2008 19:35:11 +0200
Message-ID: <1215106511-12915-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2008 17:35:12.0241 (UTC) FILETIME=[25820E10:01C8DD33]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code removes a leftover from the iommu_enable function. The ctrl variable
is assigned but never used.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c970fac..2a13e43 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -169,14 +169,11 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 
 void __init iommu_enable(struct amd_iommu *iommu)
 {
-	u32 ctrl;
-
 	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at ");
 	print_devid(iommu->devid, 0);
 	printk(" cap 0x%hx\n", iommu->cap_ptr);
 
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
-	ctrl = readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
 }
 
 static u8 * __init iommu_map_mmio_space(u64 address)
-- 
1.5.3.7


