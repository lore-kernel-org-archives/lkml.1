Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYIEJDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYIEJDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYIEJDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:03:07 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:57538 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYIEJDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:03:06 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH] x86: use __GFP_NORETRY in the case of GFP_DMA with pci-nommu
Date: Fri,  5 Sep 2008 17:58:48 +0900
Message-Id: <1220605129-18359-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-nommu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 526b2db..3495f88 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -102,6 +102,9 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	if (dma_mask == DMA_24BIT_MASK)
 		gfp |= GFP_DMA;
 again:
+	if (gfp & GFP_DMA)
+		gfp |= __GFP_NORETRY;
+
 	page = alloc_pages_node(node, gfp, get_order(size));
 	if (!page)
 		return NULL;
-- 
1.5.4.2

