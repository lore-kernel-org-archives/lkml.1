Return-Path: <linux-kernel-owner+w=401wt.eu-S2992656AbXDDEN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992656AbXDDEN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992634AbXDDEN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:13:28 -0400
Received: from ozlabs.org ([203.10.76.45]:49618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992563AbXDDEBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:40 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:28 +1000
Subject: [PATCH 5/14] get_unmapped_area handles MAP_FIXED on i386
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040139.B08C6DDE41@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/i386/mm/hugetlbpage.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-cell/arch/i386/mm/hugetlbpage.c
===================================================================
--- linux-cell.orig/arch/i386/mm/hugetlbpage.c	2007-03-22 16:08:12.000000000 +1100
+++ linux-cell/arch/i386/mm/hugetlbpage.c	2007-03-22 16:14:19.000000000 +1100
@@ -367,6 +367,12 @@ hugetlb_get_unmapped_area(struct file *f
 	if (len > TASK_SIZE)
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
