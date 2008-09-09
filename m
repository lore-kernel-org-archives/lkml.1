Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbYIIQLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbYIIQLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYIIQI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:08:57 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:36001 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbYIIQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:08:53 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] x86: convert gart to use is_buffer_dma_capable helper function
Date: Wed, 10 Sep 2008 01:06:47 +0900
Message-Id: <1220976409-8417-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0b99d4a..1b0c412 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -214,24 +214,14 @@ static void iommu_full(struct device *dev, size_t size, int dir)
 static inline int
 need_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	u64 mask = *dev->dma_mask;
-	int high = addr + size > mask;
-	int mmu = high;
-
-	if (force_iommu)
-		mmu = 1;
-
-	return mmu;
+	return force_iommu ||
+		!is_buffer_dma_capable(*dev->dma_mask, addr, size);
 }
 
 static inline int
 nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	u64 mask = *dev->dma_mask;
-	int high = addr + size > mask;
-	int mmu = high;
-
-	return mmu;
+	return !is_buffer_dma_capable(*dev->dma_mask, addr, size);
 }
 
 /* Map a single continuous physical area into the IOMMU.
-- 
1.5.4.2

