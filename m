Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbXLLU5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbXLLU5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXLLU5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:57:07 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:25225 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbXLLU5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:57:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Dzc+P19GMpHKDE0Uf6cEAFdtNdqnlndX31+ph2wKAhzMRXQTBWmvrqSdT3BBp2ZrQiGhpDkHZJIDHDipRNPhXi6dSMC5rAmaY23bEluco0bEH5lGRV0X9h6ql56gRHSqiev0oS5ds+0Cd/l31PnUipccM+4EjAtnHvCykaXZOdE=
Subject: [PATCH] mm: remove fastcall from mm/
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 12:57:03 -0800
Message-Id: <1197493023.21291.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastcall is always defined to be empty, remove it

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 mm/filemap.c        |   10 +++++-----
 mm/highmem.c        |    4 ++--
 mm/internal.h       |    2 +-
 mm/memory.c         |    2 +-
 mm/page-writeback.c |    2 +-
 mm/page_alloc.c     |   16 ++++++++--------
 mm/swap.c           |   10 +++++-----
 7 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 188cf5f..4483574 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -510,7 +510,7 @@ static inline void wake_up_page(struct page *page, int bit)
 	__wake_up_bit(page_waitqueue(page), &page->flags, bit);
 }
 
-void fastcall wait_on_page_bit(struct page *page, int bit_nr)
+void wait_on_page_bit(struct page *page, int bit_nr)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
 
@@ -534,7 +534,7 @@ EXPORT_SYMBOL(wait_on_page_bit);
  * the clear_bit and the read of the waitqueue (to avoid SMP races with a
  * parallel wait_on_page_locked()).
  */
-void fastcall unlock_page(struct page *page)
+void unlock_page(struct page *page)
 {
 	smp_mb__before_clear_bit();
 	if (!TestClearPageLocked(page))
@@ -568,7 +568,7 @@ EXPORT_SYMBOL(end_page_writeback);
  * chances are that on the second loop, the block layer's plug list is empty,
  * so sync_page() will then return in state TASK_UNINTERRUPTIBLE.
  */
-void fastcall __lock_page(struct page *page)
+void __lock_page(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
@@ -581,7 +581,7 @@ EXPORT_SYMBOL(__lock_page);
  * Variant of lock_page that does not require the caller to hold a reference
  * on the page's mapping.
  */
-void fastcall __lock_page_nosync(struct page *page)
+void __lock_page_nosync(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 	__wait_on_bit_lock(page_waitqueue(page), &wait, __sleep_on_page_lock,
@@ -1248,7 +1248,7 @@ asmlinkage ssize_t sys_readahead(int fd, loff_t offset, size_t count)
  * This adds the requested page to the page cache if it isn't already there,
  * and schedules an I/O to read in its contents from disk.
  */
-static int fastcall page_cache_read(struct file * file, pgoff_t offset)
+static int page_cache_read(struct file * file, pgoff_t offset)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *page; 
diff --git a/mm/highmem.c b/mm/highmem.c
index 7a967bc..35d4773 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -163,7 +163,7 @@ start:
 	return vaddr;
 }
 
-void fastcall *kmap_high(struct page *page)
+void *kmap_high(struct page *page)
 {
 	unsigned long vaddr;
 
@@ -185,7 +185,7 @@ void fastcall *kmap_high(struct page *page)
 
 EXPORT_SYMBOL(kmap_high);
 
-void fastcall kunmap_high(struct page *page)
+void kunmap_high(struct page *page)
 {
 	unsigned long vaddr;
 	unsigned long nr;
diff --git a/mm/internal.h b/mm/internal.h
index 953f941..1e34d24 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -34,7 +34,7 @@ static inline void __put_page(struct page *page)
 	atomic_dec(&page->_count);
 }
 
-extern void fastcall __init __free_pages_bootmem(struct page *page,
+extern void __init __free_pages_bootmem(struct page *page,
 						unsigned int order);
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index 4bf0b6d..a7eca94 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1108,7 +1108,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 }
 EXPORT_SYMBOL(get_user_pages);
 
-pte_t * fastcall get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl)
+pte_t * get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl)
 {
 	pgd_t * pgd = pgd_offset(mm, addr);
 	pud_t * pud = pud_alloc(mm, pgd, addr);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index d55cfca..28799e9 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1067,7 +1067,7 @@ static int __set_page_dirty(struct page *page)
 	return 0;
 }
 
-int fastcall set_page_dirty(struct page *page)
+int set_page_dirty(struct page *page)
 {
 	int ret = __set_page_dirty(page);
 	if (ret)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b5a58d4..e8206c4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -537,7 +537,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 /*
  * permit the bootmem allocator to evade page validation on high-order frees
  */
-void fastcall __init __free_pages_bootmem(struct page *page, unsigned int order)
+void __init __free_pages_bootmem(struct page *page, unsigned int order)
 {
 	if (order == 0) {
 		__ClearPageReserved(page);
@@ -974,7 +974,7 @@ void drain_all_local_pages(void)
 /*
  * Free a 0-order page
  */
-static void fastcall free_hot_cold_page(struct page *page, int cold)
+static void free_hot_cold_page(struct page *page, int cold)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -1004,12 +1004,12 @@ static void fastcall free_hot_cold_page(struct page *page, int cold)
 	put_cpu();
 }
 
-void fastcall free_hot_page(struct page *page)
+void free_hot_page(struct page *page)
 {
 	free_hot_cold_page(page, 0);
 }
 	
-void fastcall free_cold_page(struct page *page)
+void free_cold_page(struct page *page)
 {
 	free_hot_cold_page(page, 1);
 }
@@ -1632,7 +1632,7 @@ EXPORT_SYMBOL(__alloc_pages);
 /*
  * Common helper functions.
  */
-fastcall unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
+unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
 {
 	struct page * page;
 	page = alloc_pages(gfp_mask, order);
@@ -1643,7 +1643,7 @@ fastcall unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
 
 EXPORT_SYMBOL(__get_free_pages);
 
-fastcall unsigned long get_zeroed_page(gfp_t gfp_mask)
+unsigned long get_zeroed_page(gfp_t gfp_mask)
 {
 	struct page * page;
 
@@ -1669,7 +1669,7 @@ void __pagevec_free(struct pagevec *pvec)
 		free_hot_cold_page(pvec->pages[i], pvec->cold);
 }
 
-fastcall void __free_pages(struct page *page, unsigned int order)
+void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page)) {
 		if (order == 0)
@@ -1681,7 +1681,7 @@ fastcall void __free_pages(struct page *page, unsigned int order)
 
 EXPORT_SYMBOL(__free_pages);
 
-fastcall void free_pages(unsigned long addr, unsigned int order)
+void free_pages(unsigned long addr, unsigned int order)
 {
 	if (addr != 0) {
 		VM_BUG_ON(!virt_addr_valid((void *)addr));
diff --git a/mm/swap.c b/mm/swap.c
index 9ac8832..57b7e25 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -41,7 +41,7 @@ static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs) = { 0, };
  * This path almost never happens for VM activity - pages are normally
  * freed via pagevecs.  But it gets used by networking.
  */
-static void fastcall __page_cache_release(struct page *page)
+static void __page_cache_release(struct page *page)
 {
 	if (PageLRU(page)) {
 		unsigned long flags;
@@ -165,7 +165,7 @@ int rotate_reclaimable_page(struct page *page)
 /*
  * FIXME: speed this up?
  */
-void fastcall activate_page(struct page *page)
+void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
 
@@ -186,7 +186,7 @@ void fastcall activate_page(struct page *page)
  * inactive,referenced		->	active,unreferenced
  * active,unreferenced		->	active,referenced
  */
-void fastcall mark_page_accessed(struct page *page)
+void mark_page_accessed(struct page *page)
 {
 	if (!PageActive(page) && PageReferenced(page) && PageLRU(page)) {
 		activate_page(page);
@@ -202,7 +202,7 @@ EXPORT_SYMBOL(mark_page_accessed);
  * lru_cache_add: add a page to the page lists
  * @page: the page to add
  */
-void fastcall lru_cache_add(struct page *page)
+void lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs);
 
@@ -212,7 +212,7 @@ void fastcall lru_cache_add(struct page *page)
 	put_cpu_var(lru_add_pvecs);
 }
 
-void fastcall lru_cache_add_active(struct page *page)
+void lru_cache_add_active(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_active_pvecs);
 
-- 
1.5.3.7.2212.gd092



