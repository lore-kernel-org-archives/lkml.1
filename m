Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXBLHpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXBLHpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbXBLHnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:43:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:49644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111AbXBLHiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:23 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [33/39] x86_64: Fix off by one error in IOMMU boundary checking
Message-Id: <20070212073821.7F84E13D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Should be harmless because there is normally no memory there, but
technically it was incorrect.

Pointed out by Leo Duran

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/pci-gart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/pci-gart.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-gart.c
+++ linux/arch/x86_64/kernel/pci-gart.c
@@ -185,7 +185,7 @@ static void iommu_full(struct device *de
 static inline int need_iommu(struct device *dev, unsigned long addr, size_t size)
 { 
 	u64 mask = *dev->dma_mask;
-	int high = addr + size >= mask;
+	int high = addr + size > mask;
 	int mmu = high;
 	if (force_iommu) 
 		mmu = 1; 
@@ -195,7 +195,7 @@ static inline int need_iommu(struct devi
 static inline int nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 { 
 	u64 mask = *dev->dma_mask;
-	int high = addr + size >= mask;
+	int high = addr + size > mask;
 	int mmu = high;
 	return mmu; 
 }
