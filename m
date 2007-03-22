Return-Path: <linux-kernel-owner+w=401wt.eu-S965819AbXCVGEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965819AbXCVGEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965827AbXCVGEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:04:08 -0400
Received: from ozlabs.org ([203.10.76.45]:57802 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965819AbXCVGDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:03:54 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:01:17 +1100
Subject: [RFC/PATCH 8/15] get_unmapped_area handles MAP_FIXED on sparc64
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060258.4583DDE39D@ozlabs.org>
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
