Return-Path: <linux-kernel-owner+w=401wt.eu-S1762646AbXEPDqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646AbXEPDqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760873AbXEPDqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:46:04 -0400
Received: from ozlabs.org ([203.10.76.45]:52061 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200AbXEPDqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:46:01 -0400
To: Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 16 May 2007 13:45:29 +1000
Subject: [RFC/PATCH 2/2] Make map_vm_area() static
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Message-Id: <20070516034600.8A7C6DDEE7@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

map_vm_area() is only ever used inside of mm/vmalloc.c. This makes
it static and removes the prototype.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

---

 include/linux/vmalloc.h |    2 --
 mm/vmalloc.c            |    3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

Index: linux-cell/include/linux/vmalloc.h
===================================================================
--- linux-cell.orig/include/linux/vmalloc.h	2007-05-16 13:18:31.000000000 +1000
+++ linux-cell/include/linux/vmalloc.h	2007-05-16 13:18:33.000000000 +1000
@@ -66,8 +66,6 @@ extern struct vm_struct *get_vm_area_nod
 					  gfp_t gfp_mask);
 extern struct vm_struct *remove_vm_area(void *addr);
 
-extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
-			struct page ***pages);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
 
 /*
Index: linux-cell/mm/vmalloc.c
===================================================================
--- linux-cell.orig/mm/vmalloc.c	2007-05-16 13:18:18.000000000 +1000
+++ linux-cell/mm/vmalloc.c	2007-05-16 13:18:22.000000000 +1000
@@ -140,7 +140,8 @@ static inline int vmap_pud_range(pgd_t *
 	return 0;
 }
 
-int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
+static int map_vm_area(struct vm_struct *area, pgprot_t prot,
+		       struct page ***pages)
 {
 	pgd_t *pgd;
 	unsigned long next;
