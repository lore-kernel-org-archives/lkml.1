Return-Path: <linux-kernel-owner+w=401wt.eu-S1751396AbZKNM1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbZKNM1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 07:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZKNM1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 07:27:00 -0500
Received: from sh.osrg.net ([192.16.179.4]:39868 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbZKNM07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 07:26:59 -0500
Date: Sat, 14 Nov 2009 21:26:50 +0900
To: muli@il.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] Calgary: make calgary_iommu_init static
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091114212603U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Nov 2009 21:26:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes calgary_iommu_init() static and moves it to remove the
forward declaration.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-calgary_64.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 833f491..c84ad03 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1345,7 +1345,24 @@ static void __init get_tce_space_from_tar(void)
 	return;
 }
 
-int __init calgary_iommu_init(void);
+static int __init calgary_iommu_init(void)
+{
+	int ret;
+
+	/* ok, we're trying to use Calgary - let's roll */
+	printk(KERN_INFO "PCI-DMA: Using Calgary IOMMU\n");
+
+	ret = calgary_init();
+	if (ret) {
+		printk(KERN_ERR "PCI-DMA: Calgary init failed %d, "
+		       "falling back to no_iommu\n", ret);
+		return ret;
+	}
+
+	bad_dma_address = 0x0;
+
+	return 0;
+}
 
 void __init detect_calgary(void)
 {
@@ -1458,25 +1475,6 @@ cleanup:
 	}
 }
 
-int __init calgary_iommu_init(void)
-{
-	int ret;
-
-	/* ok, we're trying to use Calgary - let's roll */
-	printk(KERN_INFO "PCI-DMA: Using Calgary IOMMU\n");
-
-	ret = calgary_init();
-	if (ret) {
-		printk(KERN_ERR "PCI-DMA: Calgary init failed %d, "
-		       "falling back to no_iommu\n", ret);
-		return ret;
-	}
-
-	bad_dma_address = 0x0;
-
-	return 0;
-}
-
 static int __init calgary_parse_options(char *p)
 {
 	unsigned int bridge;
-- 
1.5.6.5

