Return-Path: <linux-kernel-owner+w=401wt.eu-S2992597AbXDDECm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992597AbXDDECm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992599AbXDDECl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:02:41 -0400
Received: from ozlabs.org ([203.10.76.45]:49668 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992597AbXDDECd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:02:33 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:02:22 +1000
Subject: [PATCH 14/14] get_unmapped_area doesn't need hugetlbfs hacks anymore 
In-Reply-To: <1175659331.690672.592289266160.qpush@grosgo>
Message-Id: <20070404040233.35EC6DDE3F@ozlabs.org>
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
 
