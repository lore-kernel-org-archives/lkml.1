Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbYGKBrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbYGKBrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYGKBrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:47:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:59020 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbYGKBrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:47:14 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 3/4] x86: remove ifdef CONFIG_CALGARY_IOMMU in pci-dma.c
Date: Fri, 11 Jul 2008 10:23:44 +0900
Message-Id: <1215739425-28399-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1215739425-28399-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1215739425-28399-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1215739425-28399-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-x86/calgary.h has dummy calgary_iommu_init() and detect_calgary()
in !CONFIG_CALGARY_IOMMU case. So we don't need ifdef
CONFIG_CALGARY_IOMMU in pci-dma.c.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>
---
 arch/x86/kernel/pci-dma.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 034fe1c..2377de7 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -116,9 +116,7 @@ void __init pci_iommu_alloc(void)
 	 */
 	gart_iommu_hole_init();
 
-#ifdef CONFIG_CALGARY_IOMMU
 	detect_calgary();
-#endif
 
 	detect_intel_iommu();
 
@@ -378,9 +376,7 @@ EXPORT_SYMBOL(dma_free_coherent);
 
 static int __init pci_iommu_init(void)
 {
-#ifdef CONFIG_CALGARY_IOMMU
 	calgary_iommu_init();
-#endif
 
 	intel_iommu_init();
 
-- 
1.5.5.GIT

