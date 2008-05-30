Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYE3Q7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYE3Q7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYE3Q7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:59:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4995 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYE3Q7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:59:10 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, agl@us.ibm.com,
       wli@holomorphy.com, kenchen@google.com, dwg@au1.ibm.com,
       andi@firstfloor.org, Mel Gorman <mel@csn.ul.ie>, dean@arctic.org,
       abh@cray.com, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 2/2] huge page MAP_NORESERVE review cleanups
References: <exportbomb.1212166524@pinky>
InReply-To: <exportbomb.1212166524@pinky>
Date: Fri, 30 May 2008 17:58:39 +0100
Message-Id: <1212166719.0@pinky>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the new encapsulated huge page offset helper.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 mm/hugetlb.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1dce03a..901e580 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -733,8 +733,7 @@ static int vma_needs_reservation(struct vm_area_struct *vma, unsigned long addr)
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		unsigned long idx = ((addr - vma->vm_start) >> HPAGE_SHIFT) +
-				(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+		pgoff_t idx = vma_pagecache_offset(vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
 
@@ -752,8 +751,7 @@ static void vma_commit_reservation(struct vm_area_struct *vma,
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		unsigned long idx = ((addr - vma->vm_start) >> HPAGE_SHIFT) +
-				(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+		pgoff_t idx = vma_pagecache_offset(vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 	}
 }
