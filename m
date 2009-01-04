Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZADV5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZADV5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZADV44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:56:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZADV4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:56:55 -0500
Date: Sun, 4 Jan 2009 22:56:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core/iommu fixes
Message-ID: <20090104215645.GA22924@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      intel-iommu: fix build error with INTR_REMAP=y and DMAR=n

Jesper Juhl (1):
      swiotlb: Don't include linux/swiotlb.h twice in lib/swiotlb.c

Roland Dreier (1):
      swiotlb: add missing __init annotations


 arch/x86/kernel/pci-swiotlb_64.c |    2 +-
 include/linux/dma_remapping.h    |    8 ++++++++
 lib/swiotlb.c                    |    3 +--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 242c344..8cba374 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -13,7 +13,7 @@
 
 int swiotlb __read_mostly;
 
-void *swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
 {
 	return alloc_bootmem_low_pages(size);
 }
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 136f170..af1dab4 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -17,7 +17,15 @@ struct dmar_domain;
 struct root_entry;
 
 extern void free_dmar_iommu(struct intel_iommu *iommu);
+
+#ifdef CONFIG_DMAR
 extern int iommu_calculate_agaw(struct intel_iommu *iommu);
+#else
+static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
+{
+	return 0;
+}
+#endif
 
 extern int dmar_disabled;
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index fa2dc4e..7f5e21b 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -23,7 +23,6 @@
 #include <linux/spinlock.h>
 #include <linux/swiotlb.h>
 #include <linux/string.h>
-#include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
 #include <linux/highmem.h>
@@ -116,7 +115,7 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
-void * __weak swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+void * __weak __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
 {
 	return alloc_bootmem_low_pages(size);
 }
