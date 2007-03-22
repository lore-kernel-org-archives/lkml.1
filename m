Return-Path: <linux-kernel-owner+w=401wt.eu-S965827AbXCVGEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965827AbXCVGEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965817AbXCVGEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:04:37 -0400
Received: from ozlabs.org ([203.10.76.45]:57970 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965828AbXCVGEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:04:08 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:01:30 +1100
Subject: [RFC/PATCH 15/15] get_unmapped_area doesn't need hugetlbfs hacks anymore 
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060305.82158DDF53@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 mm/mmap.c |   16 ----------------
 1 file changed, 16 deletions(-)

Index: linux-cell/mm/mmap.c
===================================================================
--- linux-cell.orig/mm/mmap.c	2007-03-22 16:30:24.000000000 +1100
+++ linux-cell/mm/mmap.c	2007-03-22 16:30:48.000000000 +1100
@@ -1381,22 +1381,6 @@ get_unmapped_area(struct file *file, uns
 	if (addr & ~PAGE_MASK)
 		return -EINVAL;
 
-	if (file && is_file_hugepages(file))  {
-		/*
-		 * Check if the given range is hugepage aligned, and
-		 * can be made suitable for hugepages.
-		 */
-		ret = prepare_hugepage_range(addr, len, pgoff);
-	} else {
-		/*
-		 * Ensure that a normal request is not falling in a
-		 * reserved hugepage range.  For some archs like IA-64,
-		 * there is a separate region for hugepages.
-		 */
-		ret = is_hugepage_only_range(current->mm, addr, len);
-	}
-	if (ret)
-		return -EINVAL;
 	return addr;
 }
 
