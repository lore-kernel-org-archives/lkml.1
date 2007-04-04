Return-Path: <linux-kernel-owner+w=401wt.eu-S2992590AbXDDEF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992590AbXDDEF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030403AbXDDEEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:04:25 -0400
Received: from ozlabs.org ([203.10.76.45]:49668 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992590AbXDDECa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:02:30 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:02:19 +1000
Subject: [PATCH 8/14] get_unmapped_area handles MAP_FIXED on sparc64
In-Reply-To: <1175659331.690672.592289266160.qpush@grosgo>
Message-Id: <20070404040230.14970DDEA0@ozlabs.org>
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
