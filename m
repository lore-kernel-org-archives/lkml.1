Return-Path: <linux-kernel-owner+w=401wt.eu-S1161645AbXDXFe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161645AbXDXFe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161635AbXDXFej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:34:39 -0400
Received: from ozlabs.org ([203.10.76.45]:35025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161636AbXDXFdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:42 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:40 +1000
Subject: [PATCH 12/12] get_unmapped_area doesn't need hugetlbfs hacks anymore 
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053342.63371DDF07@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the hugetlbfs specific hacks in toplevel get_unmapped_area() now
that all archs and hugetlbfs itself do the right thing for both cases.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: William Irwin <bill.irwin@oracle.com>

 mm/mmap.c |   16 ----------------
 1 file changed, 16 deletions(-)

Index: linux-cell/mm/mmap.c
===================================================================
--- linux-cell.orig/mm/mmap.c	2007-04-12 12:14:46.000000000 +1000
+++ linux-cell/mm/mmap.c	2007-04-12 12:14:47.000000000 +1000
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
 
