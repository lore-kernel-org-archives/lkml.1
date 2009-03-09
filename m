Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZCINAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZCINAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZCINAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:00:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:32771 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZCINAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:00:30 -0400
From: Aaro Koskinen <Aaro.Koskinen@nokia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] ARM: tlb: Use range in tlb_start_vma() and tlb_end_vma()
Date: Mon,  9 Mar 2009 14:59:57 +0200
Message-Id: <1236603597-1646-2-git-send-email-Aaro.Koskinen@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1236603597-1646-1-git-send-email-Aaro.Koskinen@nokia.com>
References: <49B511E9.8030405@nokia.com>
 <1236603597-1646-1-git-send-email-Aaro.Koskinen@nokia.com>
X-OriginalArrivalTime: 09 Mar 2009 12:59:59.0775 (UTC) FILETIME=[F42B72F0:01C9A0B6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush only the pages that were unmapped.

Signed-off-by: Aaro Koskinen <Aaro.Koskinen@nokia.com>
---
 arch/arm/include/asm/tlb.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index d10c9c3..a034b6d 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -68,14 +68,14 @@ tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 /*
  * In the case of tlb vma handling, we can optimise these away in the
  * case where we're doing a full MM flush.  When we're doing a munmap,
- * the vmas are adjusted to only cover the region to be torn down.
+ * the range is adjusted to only cover the region to be torn down.
  */
 static inline void
 tlb_start_vma(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	      unsigned long range_start, unsigned long range_end)
 {
 	if (!tlb->fullmm)
-		flush_cache_range(vma, vma->vm_start, vma->vm_end);
+		flush_cache_range(vma, range_start, range_end);
 }
 
 static inline void
@@ -83,7 +83,7 @@ tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	    unsigned long range_start, unsigned long range_end)
 {
 	if (!tlb->fullmm)
-		flush_tlb_range(vma, vma->vm_start, vma->vm_end);
+		flush_tlb_range(vma, range_start, range_end);
 }
 
 #define tlb_remove_page(tlb,page)	free_page_and_swap_cache(page)
-- 
1.5.4.3

