Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbYBWGQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbYBWGQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYBWGPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:15:52 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55465 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYBWGPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:15:49 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/4] alpha: convert IOMMU to use ALIGN()
Date: Sat, 23 Feb 2008 15:13:12 +0900
Message-Id: <1203747195-7952-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1203747195-7952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1203747195-7952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation for modifications to fix the IOMMU segment
boundary problem.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/alpha/kernel/pci_iommu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 26d3789..bbf9990 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -136,11 +136,11 @@ iommu_arena_find_pages(struct pci_iommu_arena *arena, long n, long mask)
 	/* Search forward for the first mask-aligned sequence of N free ptes */
 	ptes = arena->ptes;
 	nent = arena->size >> PAGE_SHIFT;
-	p = (arena->next_entry + mask) & ~mask;
+	p = ALIGN(arena->next_entry, mask + 1);
 	i = 0;
 	while (i < n && p+i < nent) {
 		if (ptes[p+i])
-			p = (p + i + 1 + mask) & ~mask, i = 0;
+			p = ALIGN(p + i + 1, mask + 1), i = 0;
 		else
 			i = i + 1;
 	}
@@ -153,7 +153,7 @@ iommu_arena_find_pages(struct pci_iommu_arena *arena, long n, long mask)
 		p = 0, i = 0;
 		while (i < n && p+i < nent) {
 			if (ptes[p+i])
-				p = (p + i + 1 + mask) & ~mask, i = 0;
+				p = ALIGN(p + i + 1, mask + 1), i = 0;
 			else
 				i = i + 1;
 		}
-- 
1.5.3.4

