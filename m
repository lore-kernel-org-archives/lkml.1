Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYIEJDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYIEJDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYIEJD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:03:28 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:57602 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbYIEJDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:03:25 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH] x86: gart alloc_coherent doesn't need to check NULL device argument
Date: Fri,  5 Sep 2008 17:58:49 +0900
Message-Id: <1220605129-18359-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220605129-18359-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220605129-18359-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/dma-mapping.h guarantees that gart alloc_coherent doesn't get NULL
device argument.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 4d08649..0b99d4a 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -506,9 +506,6 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 
 	align_mask = (1UL << get_order(size)) - 1;
 
-	if (!dev)
-		dev = &x86_dma_fallback_dev;
-
 	*dma_addr = dma_map_area(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL,
 				 align_mask);
 	flush_gart();
-- 
1.5.4.2

