Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYGKBZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYGKBZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbYGKBYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:24:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:48437 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbYGKBYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:24:41 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/4] x86: remove ifdef CONFIG_SWIOTLB in pci-dma.c
Date: Fri, 11 Jul 2008 10:23:45 +0900
Message-Id: <1215739425-28399-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1215739425-28399-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1215739425-28399-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1215739425-28399-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1215739425-28399-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As other IOMMUs do, this puts dummy pci_swiotlb_init() in swiotlb.h
and remove ifdef CONFIG_SWIOTLB in pci-dma.c.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-dma.c |    2 --
 include/asm-x86/swiotlb.h |    6 ++++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 2377de7..e01b616 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -122,9 +122,7 @@ void __init pci_iommu_alloc(void)
 
 	amd_iommu_detect();
 
-#ifdef CONFIG_SWIOTLB
 	pci_swiotlb_init();
-#endif
 }
 #endif
 
diff --git a/include/asm-x86/swiotlb.h b/include/asm-x86/swiotlb.h
index f5d9e74..c706a74 100644
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -45,12 +45,14 @@ extern int swiotlb_force;
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
+extern void pci_swiotlb_init(void);
 #else
 #define swiotlb 0
+static inline void pci_swiotlb_init(void)
+{
+}
 #endif
 
-extern void pci_swiotlb_init(void);
-
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
 #endif /* _ASM_SWIOTLB_H */
-- 
1.5.5.GIT

