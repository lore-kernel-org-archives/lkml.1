Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYLOOTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYLOOTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYLOOS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:28 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21048 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbYLOOS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:26 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KBX925-03-GLJ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/22] AMD IOMMU: use dev_name instead of self-build print_devid
Date: Mon, 15 Dec 2008 15:17:46 +0100
Message-ID: <1229350685-3816-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:05.0928 (UTC) FILETIME=[F2A2A680:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use generic dev_name instead of own function

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   12 ------------
 arch/x86/kernel/amd_iommu.c            |    3 +--
 2 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 6adc702..ee8cfa0 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -389,18 +389,6 @@ extern int amd_iommu_isolate;
  */
 extern bool amd_iommu_unmap_flush;
 
-/* takes a PCI device id and prints it out in a readable form */
-static inline void print_devid(u16 devid, int nl)
-{
-	int bus = devid >> 8;
-	int dev = devid >> 3 & 0x1f;
-	int fn  = devid & 0x07;
-
-	printk("%02x:%02x.%x", bus, dev, fn);
-	if (nl)
-		printk("\n");
-}
-
 /* takes bus and device/function and returns the device id
  * FIXME: should that be in generic PCI code? */
 static inline u16 calc_devid(u8 bus, u8 devfn)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index cebbf58..dc7cef3 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1073,8 +1073,7 @@ static int get_device_resources(struct device *dev,
 		*domain = &dma_dom->domain;
 		attach_device(*iommu, *domain, *bdf);
 		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
-				"device ", (*domain)->id);
-		print_devid(_bdf, 1);
+				"device %s\n", (*domain)->id, dev_name(dev));
 	}
 
 	if (domain_for_device(_bdf) == NULL)
-- 
1.5.6.4


