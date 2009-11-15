Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZKOK3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZKOK3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZKOK3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:29:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:46958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZKOK3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:29:02 -0500
Date: Sun, 15 Nov 2009 10:27:49 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258199198-16657-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258199198-16657-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: Set dma_ops to nommu_dma_ops by default
Message-ID: <tip-a3b28ee1090072092e2be043c24df94230e725b2@git.kernel.org>
Git-Commit-ID: a3b28ee1090072092e2be043c24df94230e725b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3b28ee1090072092e2be043c24df94230e725b2
Gitweb:     http://git.kernel.org/tip/a3b28ee1090072092e2be043c24df94230e725b2
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Sat, 14 Nov 2009 20:46:36 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Nov 2009 09:03:09 +0100

x86: Set dma_ops to nommu_dma_ops by default

We set dma_ops to nommu_dma_ops at two different places for
x86_32 and x86_64. This unifies them by setting dma_ops to
nommu_dma_ops by default.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <1258199198-16657-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-dma.c     |    4 +---
 arch/x86/kernel/pci-swiotlb.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 0b11bf1..f170b53 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -15,7 +15,7 @@
 
 static int forbid_dac __read_mostly;
 
-struct dma_map_ops *dma_ops;
+struct dma_map_ops *dma_ops = &nommu_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -128,8 +128,6 @@ void __init pci_iommu_alloc(void)
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
-#else
-	dma_ops = &nommu_dma_ops;
 #endif
 	if (pci_swiotlb_init())
 		return;
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index a6e5d0f..e36e71d 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -61,8 +61,7 @@ int __init pci_swiotlb_init(void)
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
-	} else
-		dma_ops = &nommu_dma_ops;
+	}
 
 	return swiotlb_force;
 }
