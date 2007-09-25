Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbXIYXoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbXIYXoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXIYXmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:42:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57657 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751768AbXIYXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:50 -0400
Message-Id: <20070925234249.628858015@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:06 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [02/17] vmalloc: add const
Content-Disposition: inline; filename=vcompound_vmalloc_const
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make vmalloc functions work the same way as kfree() and friends that
take a const void * argument.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h      |    4 ++--
 include/linux/vmalloc.h |    6 +++---
 mm/vmalloc.c            |   16 ++++++++--------
 3 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-24 16:58:37.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-24 16:58:45.000000000 -0700
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
--- linux-2.6.orig/include/linux/vmalloc.h	2007-09-24 16:58:37.000000000 -0700
+++ linux-2.6/include/linux/vmalloc.h	2007-09-24 16:58:45.000000000 -0700
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
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-09-24 16:58:44.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-09-24 16:58:48.000000000 -0700
@@ -294,8 +294,8 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
-struct page *vmalloc_to_page(void *addr);
-unsigned long vmalloc_to_pfn(void *addr);
+struct page *vmalloc_to_page(const void *addr);
+unsigned long vmalloc_to_pfn(const void *addr);
 
 static inline struct page *compound_head(struct page *page)
 {

-- 
