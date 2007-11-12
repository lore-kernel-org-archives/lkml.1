Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbXKLOko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbXKLOko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXKLOkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:40:19 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:25489 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXKLOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:40:15 -0500
Message-Id: <20071112144010.052155135@de.ibm.com>
References: <20071112143009.425807965@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Nov 2007 15:30:12 +0100
From: schwidefsky@de.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 3/3] arch_rebalance_pgtables call
Content-Disposition: inline; filename=003-mm-update-pgd.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

In order to change the layout of the page tables after an mmap has
crossed the adress space limit of the current page table layout a
architecture hook in get_unmapped_area is needed. The arguments
are the address of the new mapping and the length of it.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 mm/mmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -36,6 +36,10 @@
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
 
+#ifndef arch_rebalance_pgtables
+#define arch_rebalance_pgtables(addr, len)		(addr)
+#endif
+
 static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
@@ -1436,7 +1440,7 @@ get_unmapped_area(struct file *file, uns
 	if (addr & ~PAGE_MASK)
 		return -EINVAL;
 
-	return addr;
+	return arch_rebalance_pgtables(addr, len);
 }
 
 EXPORT_SYMBOL(get_unmapped_area);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

