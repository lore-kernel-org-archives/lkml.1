Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYHSNre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYHSNre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbYHSNrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:47:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60756 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbYHSNrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:47:11 -0400
Date: Tue, 19 Aug 2008 16:47:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mel Gorman <mel@csn.ul.ie>, Adam Litke <agl@us.ibm.com>,
       wli@holomorphy.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mm/hugetlb.c:unmap_ref_private() static
Message-ID: <20080819134701.GE8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global unmap_ref_private() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4e1c826ff4f7503f5e33c2ad1307cf6b4d2b5758 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c3bb4d6..0c2d6f6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1742,10 +1742,8 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
-int unmap_ref_private(struct mm_struct *mm,
-					struct vm_area_struct *vma,
-					struct page *page,
-					unsigned long address)
+static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
+			     struct page *page, unsigned long address)
 {
 	struct vm_area_struct *iter_vma;
 	struct address_space *mapping;

