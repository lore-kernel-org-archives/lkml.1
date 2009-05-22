Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbZEVMOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbZEVMOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbZEVMNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:13:22 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:17666
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757393AbZEVMNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:13:18 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KK1OLN-03-92U-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/7] amd-iommu: move protection domain printk to dump code
Date: Fri, 22 May 2009 14:12:47 +0200
Message-ID: <1242994369-28697-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
References: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:12:50.0168 (UTC) FILETIME=[A0292F80:01C9DAD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: only printk protection-domain relations if requested ]

This information is only helpful for debugging. Don't print it anymore
unless explicitly requested.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a97db99..3356599 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1009,8 +1009,9 @@ static int device_change_notifier(struct notifier_block *nb,
 		if (!dma_domain)
 			dma_domain = iommu->default_dom;
 		attach_device(iommu, &dma_domain->domain, devid);
-		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
-		       "device %s\n", dma_domain->domain.id, dev_name(dev));
+		DUMP_printk(KERN_INFO "AMD IOMMU: Using protection domain "
+			    "%d for device %s\n",
+			    dma_domain->domain.id, dev_name(dev));
 		break;
 	case BUS_NOTIFY_UNBIND_DRIVER:
 		if (!domain)
@@ -1133,8 +1134,9 @@ static int get_device_resources(struct device *dev,
 			dma_dom = (*iommu)->default_dom;
 		*domain = &dma_dom->domain;
 		attach_device(*iommu, *domain, *bdf);
-		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
-				"device %s\n", (*domain)->id, dev_name(dev));
+		DUMP_printk(KERN_INFO "AMD IOMMU: Using protection domain "
+				"%d for device %s\n",
+				(*domain)->id, dev_name(dev));
 	}
 
 	if (domain_for_device(_bdf) == NULL)
-- 
1.6.3.1


