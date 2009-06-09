Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbZFIN6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbZFIN6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZFIN5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:57:48 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:12964
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757204AbZFIN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:57:47 -0400
X-SpamScore: 13
X-BigFish: VPS13(z1857rzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KKZ5G2-03-LB3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] amd-iommu: remove BUS_NOTIFY_BOUND_DRIVER handling
Date: Tue, 9 Jun 2009 15:57:18 +0200
Message-ID: <1244555840-3855-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
References: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jun 2009 13:57:30.0923 (UTC) FILETIME=[3B37D7B0:01C9E90A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling this event causes device assignment in KVM to fail because the
device gets re-attached as soon as the pci-stub registers as the driver
for the device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8510e90..8187260 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1145,17 +1145,6 @@ static int device_change_notifier(struct notifier_block *nb,
 			  "to a non-dma-ops domain\n", dev_name(dev));
 
 	switch (action) {
-	case BUS_NOTIFY_BOUND_DRIVER:
-		if (domain)
-			goto out;
-		dma_domain = find_protection_domain(devid);
-		if (!dma_domain)
-			dma_domain = iommu->default_dom;
-		attach_device(iommu, &dma_domain->domain, devid);
-		DUMP_printk(KERN_INFO "AMD IOMMU: Using protection domain "
-			    "%d for device %s\n",
-			    dma_domain->domain.id, dev_name(dev));
-		break;
 	case BUS_NOTIFY_UNBOUND_DRIVER:
 		if (!domain)
 			goto out;
-- 
1.6.3.1


