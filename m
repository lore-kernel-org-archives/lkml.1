Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZKOK3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZKOK3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZKOK3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:29:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:46973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZKOK3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:29:16 -0500
Date: Sun, 15 Nov 2009 10:28:37 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091114212603U.fujita.tomonori@lab.ntt.co.jp>
References: <20091114212603U.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: Make calgary_iommu_init() static
Message-ID: <tip-f4131c6259b46bd84dcfcd3bb9ed08e99e2875a4@git.kernel.org>
Git-Commit-ID: f4131c6259b46bd84dcfcd3bb9ed08e99e2875a4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4131c6259b46bd84dcfcd3bb9ed08e99e2875a4
Gitweb:     http://git.kernel.org/tip/f4131c6259b46bd84dcfcd3bb9ed08e99e2875a4
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Sat, 14 Nov 2009 21:26:50 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Nov 2009 09:04:14 +0100

x86: Make calgary_iommu_init() static

This makes calgary_iommu_init() static and moves it to remove
the forward declaration.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: muli@il.ibm.com
LKML-Reference: <20091114212603U.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
