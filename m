Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYKMTe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYKMTe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYKMTeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:05 -0500
Received: from gw.goop.org ([64.81.55.164]:34372 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYKMTeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 38] x86: remove unused iommu_nr_pages
X-Mercurial-Node: c76bd960c45757fe0b99aff31f9664fbc81adfab
Message-Id: <c76bd960c45757fe0b99.1226603400@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last usage was removed by the patch set culminating in

commit e3c449f526cebb8d287241c7e82faafd9709668b
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Oct 15 22:02:11 2008 -0700

    x86, AMD IOMMU: convert driver to generic iommu_num_pages function

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.orgdiff -r 9b89e3b4ca90 arch/x86/include/asm/iommu.h
---
 arch/x86/include/asm/iommu.h |    2 --
 arch/x86/kernel/pci-dma.c    |    7 -------
 2 files changed, 9 deletions(-)

diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -8,8 +8,6 @@
 extern int iommu_detected;
 extern int dmar_disabled;
 
-extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
-
 /* 10 seconds */
 #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -125,13 +125,6 @@
 	pci_swiotlb_init();
 }
 
-unsigned long iommu_nr_pages(unsigned long addr, unsigned long len)
-{
-	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
-
-	return size >> PAGE_SHIFT;
-}
-EXPORT_SYMBOL(iommu_nr_pages);
 #endif
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,


