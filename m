Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXISDh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXISDh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXISDgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:36:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54921 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751807AbXISDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:42 -0400
Message-Id: <20070919033640.781922365@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:07 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [02/17] Vmalloc: add const
Content-Disposition: inline; filename=vcompound_vmalloc_const
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make vmalloc functions work the same way as kfree() and friends that
take a const void * argument.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/vmalloc.h |   10 +++++-----
 mm/vmalloc.c            |   16 ++++++++--------
 2 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-18 18:34:06.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-18 18:34:33.000000000 -0700
@@ -169,7 +169,7 @@ EXPORT_SYMBOL_GPL(map_vm_area);
 /*
  * Map a vmalloc()-space virtual address to the physical page.
  */
-struct page *vmalloc_to_page(void *vmalloc_addr)
+struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
 	struct page *page = NULL;
@@ -198,7 +198,7 @@ EXPORT_SYMBOL(vmalloc_to_page);
 /*
  * Map a vmalloc()-space virtual address to the physical page frame number.
  */
-unsigned long vmalloc_to_pfn(void *vmalloc_addr)
+unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 {
 	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
 }
@@ -305,7 +305,7 @@ struct vm_struct *get_vm_area_node(unsig
 }
 
 /* Caller must hold vmlist_lock */
-static struct vm_struct *__find_vm_area(void *addr)
+static struct vm_struct *__find_vm_area(const void *addr)
 {
 	struct vm_struct *tmp;
 
@@ -318,7 +318,7 @@ static struct vm_struct *__find_vm_area(
 }
 
 /* Caller must hold vmlist_lock */
-static struct vm_struct *__remove_vm_area(void *addr)
+static struct vm_struct *__remove_vm_area(const void *addr)
 {
 	struct vm_struct **p, *tmp;
 
@@ -347,7 +347,7 @@ found:
  *	This function returns the found VM area, but using it is NOT safe
  *	on SMP machines, except for its size or flags.
  */
-struct vm_struct *remove_vm_area(void *addr)
+struct vm_struct *remove_vm_area(const void *addr)
 {
 	struct vm_struct *v;
 	write_lock(&vmlist_lock);
@@ -356,7 +356,7 @@ struct vm_struct *remove_vm_area(void *a
 	return v;
 }
 
-static void __vunmap(void *addr, int deallocate_pages)
+static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
 
@@ -407,7 +407,7 @@ static void __vunmap(void *addr, int dea
  *
  *	Must not be called in interrupt context.
  */
-void vfree(void *addr)
+void vfree(const void *addr)
 {
 	BUG_ON(in_interrupt());
 	__vunmap(addr, 1);
@@ -423,7 +423,7 @@ EXPORT_SYMBOL(vfree);
  *
  *	Must not be called in interrupt context.
  */
-void vunmap(void *addr)
+void vunmap(const void *addr)
 {
 	BUG_ON(in_interrupt());
 	__vunmap(addr, 0);
Index: linux-2.6/include/linux/vmalloc.h
===================================================================
--- linux-2.6.orig/include/linux/vmalloc.h	2007-09-18 18:34:24.000000000 -0700
+++ linux-2.6/include/linux/vmalloc.h	2007-09-18 18:35:03.000000000 -0700
@@ -45,11 +45,11 @@ extern void *vmalloc_32_user(unsigned lo
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
 extern void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask,
 				pgprot_t prot);
-extern void vfree(void *addr);
+extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
-extern void vunmap(void *addr);
+extern void vunmap(const void *addr);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
@@ -71,7 +71,7 @@ extern struct vm_struct *__get_vm_area(u
 extern struct vm_struct *get_vm_area_node(unsigned long size,
 					  unsigned long flags, int node,
 					  gfp_t gfp_mask);
-extern struct vm_struct *remove_vm_area(void *addr);
+extern struct vm_struct *remove_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
 			struct page ***pages);
@@ -82,8 +82,8 @@ extern struct vm_struct *alloc_vm_area(s
 extern void free_vm_area(struct vm_struct *area);
 
 /* Determine page struct from address */
-struct page *vmalloc_to_page(void *addr);
-unsigned long vmalloc_to_pfn(void *addr);
+struct page *vmalloc_to_page(const void *addr);
+unsigned long vmalloc_to_pfn(const void *addr);
 
 /*
  *	Internals.  Dont't use..

-- 
