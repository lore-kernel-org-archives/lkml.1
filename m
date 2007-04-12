Return-Path: <linux-kernel-owner+w=401wt.eu-S1161502AbXDLCYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161502AbXDLCYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161493AbXDLCVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:21:02 -0400
Received: from ozlabs.org ([203.10.76.45]:55495 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161483AbXDLCUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:20:32 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 12 Apr 2007 12:20:29 +1000
Subject: [PATCH 5/12] get_unmapped_area handles MAP_FIXED on i386
In-Reply-To: <1176344427.242579.337989891532.qpush@grosgo>
Message-Id: <20070412022031.A810EDDF2A@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle MAP_FIXED in i386 hugetlb_get_unmapped_area(), just call
prepare_hugepage_range.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
