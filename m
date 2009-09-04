Return-Path: <linux-kernel-owner+w=401wt.eu-S933623AbZIDJtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbZIDJtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbZIDJtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:49:18 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:55707 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563AbZIDJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:49:10 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KPFXXQ-01-4V8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] x86/amd-iommu: replace "AMD IOMMU" by "AMD-Vi"
Date: Fri, 4 Sep 2009 11:47:25 +0200
Message-ID: <1252057647-32322-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
References: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:47:29.0437 (UTC) FILETIME=[B792FCD0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the "AMD IOMMU" printk strings with the
official name for the hardware: "AMD-Vi".

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu.c            |    2 +-
 arch/x86/kernel/amd_iommu_init.c       |   12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 0c878ca..106e130 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -198,7 +198,7 @@ extern bool amd_iommu_dump;
 #define DUMP_printk(format, arg...)					\
 	do {								\
 		if (amd_iommu_dump)						\
-			printk(KERN_INFO "AMD IOMMU: " format, ## arg);	\
+			printk(KERN_INFO "AMD-Vi: " format, ## arg);	\
 	} while(0);
 
 /*
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 70fdef5..3e62d78 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -141,7 +141,7 @@ static void iommu_print_event(void *__evt)
 	int flags = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
 	u64 address = (u64)(((u64)event[3]) << 32) | event[2];
 
-	printk(KERN_ERR "AMD IOMMU: Event logged [");
+	printk(KERN_ERR "AMD-Vi: Event logged [");
 
 	switch (type) {
 	case EVENT_TYPE_ILL_DEV:
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c1b17e9..169958a 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -252,7 +252,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 /* Function to enable the hardware */
 static void iommu_enable(struct amd_iommu *iommu)
 {
-	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at %s cap 0x%hx\n",
+	printk(KERN_INFO "AMD-Vi: Enabling IOMMU at %s cap 0x%hx\n",
 	       dev_name(&iommu->dev->dev), iommu->cap_ptr);
 
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
@@ -902,7 +902,7 @@ static int __init iommu_setup_msi(struct amd_iommu *iommu)
 
 	r = request_irq(iommu->dev->irq, amd_iommu_int_handler,
 			IRQF_SAMPLE_RANDOM,
-			"AMD IOMMU",
+			"AMD-Vi",
 			NULL);
 
 	if (r) {
@@ -1150,7 +1150,7 @@ int __init amd_iommu_init(void)
 
 
 	if (no_iommu) {
-		printk(KERN_INFO "AMD IOMMU disabled by kernel command line\n");
+		printk(KERN_INFO "AMD-Vi disabled by kernel command line\n");
 		return 0;
 	}
 
@@ -1248,16 +1248,16 @@ int __init amd_iommu_init(void)
 
 	enable_iommus();
 
-	printk(KERN_INFO "AMD IOMMU: device isolation ");
+	printk(KERN_INFO "AMD-Vi: device isolation ");
 	if (amd_iommu_isolate)
 		printk("enabled\n");
 	else
 		printk("disabled\n");
 
 	if (amd_iommu_unmap_flush)
-		printk(KERN_INFO "AMD IOMMU: IO/TLB flush on unmap enabled\n");
+		printk(KERN_INFO "AMD-Vi: IO/TLB flush on unmap enabled\n");
 	else
-		printk(KERN_INFO "AMD IOMMU: Lazy IO/TLB flushing enabled\n");
+		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
 out:
 	return ret;
-- 
1.6.3.3


