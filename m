Return-Path: <linux-kernel-owner+w=401wt.eu-S934057AbXDDEM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057AbXDDEM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992634AbXDDEJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:09:59 -0400
Received: from ozlabs.org ([203.10.76.45]:49618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934057AbXDDEBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:41 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:30 +1000
Subject: [PATCH 8/14] get_unmapped_area handles MAP_FIXED on sparc64
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040141.55458DDE9E@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/sparc64/mm/hugetlbpage.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-cell/arch/sparc64/mm/hugetlbpage.c
===================================================================
--- linux-cell.orig/arch/sparc64/mm/hugetlbpage.c	2007-03-22 16:12:57.000000000 +1100
+++ linux-cell/arch/sparc64/mm/hugetlbpage.c	2007-03-22 16:15:33.000000000 +1100
@@ -175,6 +175,12 @@ hugetlb_get_unmapped_area(struct file *f
 	if (len > task_size)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(addr, len, pgoff))
+			return -EINVAL;
+		return addr;
+	}
+
 	if (addr) {
 		addr = ALIGN(addr, HPAGE_SIZE);
 		vma = find_vma(mm, addr);
