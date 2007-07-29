Return-Path: <linux-kernel-owner+w=401wt.eu-S1765580AbXG2PPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765580AbXG2PPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765287AbXG2PCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:02:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47900 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765166AbXG2PCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:02:18 -0400
Date: Sun, 29 Jul 2007 17:01:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: matthew@wil.cx, grundler@parisc-linux.org, kyle@parisc-linux.org
Cc: parisc-linux@parisc-linux.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] parisc: "extern inline" -> "static inline"
Message-ID: <20070729150154.GQ16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"extern inline" will have different semantics with gcc 4.3,
and "static inline" is correct here.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/parisc/lib/memcpy.c       |    4 ++--
 include/asm-parisc/io.h        |    2 +-
 include/asm-parisc/pci.h       |    2 +-
 include/asm-parisc/pgtable.h   |   32 ++++++++++++++++----------------
 include/asm-parisc/prefetch.h  |    4 ++--
 include/asm-parisc/semaphore.h |   10 +++++-----
 include/asm-parisc/tlbflush.h  |    3 +--
 7 files changed, 28 insertions(+), 29 deletions(-)

--- linux-2.6.14-rc5-mm1-full/arch/parisc/lib/memcpy.c.old	2005-10-30 01:58:43.000000000 +0200
+++ linux-2.6.14-rc5-mm1-full/arch/parisc/lib/memcpy.c	2005-10-30 01:59:11.000000000 +0200
@@ -158,12 +158,12 @@
 #define stw(_s,_t,_o,_a,_e) 	def_store_insn(stw,"r",_s,_t,_o,_a,_e)
 
 #ifdef  CONFIG_PREFETCH
-extern inline void prefetch_src(const void *addr)
+static inline void prefetch_src(const void *addr)
 {
 	__asm__("ldw 0(" s_space ",%0), %%r0" : : "r" (addr));
 }
 
-extern inline void prefetch_dst(const void *addr)
+static inline void prefetch_dst(const void *addr)
 {
 	__asm__("ldd 0(" d_space ",%0), %%r0" : : "r" (addr));
 }
--- linux-2.6.14-rc5-mm1-full/include/asm-parisc/pci.h.old	2005-10-30 01:59:57.000000000 +0200
+++ linux-2.6.14-rc5-mm1-full/include/asm-parisc/pci.h	2005-10-30 02:00:01.000000000 +0200
@@ -193,7 +193,7 @@
 extern void pcibios_register_hba(struct pci_hba_data *);
 extern void pcibios_set_master(struct pci_dev *);
 #else
-extern inline void pcibios_register_hba(struct pci_hba_data *x)
+static inline void pcibios_register_hba(struct pci_hba_data *x)
 {
 }
 #endif
--- linux-2.6.14-rc5-mm1-full/include/asm-parisc/semaphore.h.old	2005-10-30 02:00:45.000000000 +0200
+++ linux-2.6.14-rc5-mm1-full/include/asm-parisc/semaphore.h	2005-10-30 02:00:51.000000000 +0200
@@ -58,7 +58,7 @@
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
 #define DECLARE_MUTEX_LOCKED(name) __DECLARE_SEMAPHORE_GENERIC(name,0)
 
-extern inline void sema_init (struct semaphore *sem, int val)
+static inline void sema_init (struct semaphore *sem, int val)
 {
 	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
 }
@@ -86,7 +86,7 @@
  * interrupts while we're messing with the semaphore.  Sorry.
  */
 
-extern __inline__ void down(struct semaphore * sem)
+static inline void down(struct semaphore * sem)
 {
 	might_sleep();
 	spin_lock_irq(&sem->sentry);
@@ -98,7 +98,7 @@
 	spin_unlock_irq(&sem->sentry);
 }
 
-extern __inline__ int down_interruptible(struct semaphore * sem)
+static inline int down_interruptible(struct semaphore * sem)
 {
 	int ret = 0;
 	might_sleep();
@@ -116,3 +116,3 @@
  */
-extern __inline__ int down_trylock(struct semaphore * sem)
+static inline int down_trylock(struct semaphore * sem)
 {
@@ -132,3 +132,3 @@
  */
-extern __inline__ void up(struct semaphore * sem)
+static inline void up(struct semaphore * sem)
 {
--- linux-2.6.14-rc5-mm1-full/include/asm-parisc/tlbflush.h.old	2005-10-30 02:01:00.000000000 +0200
+++ linux-2.6.14-rc5-mm1-full/include/asm-parisc/tlbflush.h	2005-10-30 02:01:06.000000000 +0200
@@ -42,7 +42,7 @@
 #endif
 }
 
-extern __inline__ void flush_tlb_pgtables(struct mm_struct *mm, unsigned long start, unsigned long end)
+static inline void flush_tlb_pgtables(struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 }
  

--- linux-2.6.18-rc4-mm1/include/asm-parisc/io.h.old	2006-08-13 23:08:01.000000000 +0200
+++ linux-2.6.18-rc4-mm1/include/asm-parisc/io.h	2006-08-13 23:08:15.000000000 +0200
@@ -128,7 +128,7 @@
 /* Most machines react poorly to I/O-space being cacheable... Instead let's
  * define ioremap() in terms of ioremap_nocache().
  */
-extern inline void __iomem * ioremap(unsigned long offset, unsigned long size)
+static inline void __iomem * ioremap(unsigned long offset, unsigned long size)
 {
 	return __ioremap(offset, size, _PAGE_NO_CACHE);
 }
--- linux-2.6.18-rc4-mm1/include/asm-parisc/prefetch.h.old	2006-08-13 23:08:25.000000000 +0200
+++ linux-2.6.18-rc4-mm1/include/asm-parisc/prefetch.h	2006-08-13 23:08:34.000000000 +0200
@@ -19,7 +19,7 @@
 #ifdef CONFIG_PREFETCH
 
 #define ARCH_HAS_PREFETCH
-extern inline void prefetch(const void *addr)
+static inline void prefetch(const void *addr)
 {
 	__asm__("ldw 0(%0), %%r0" : : "r" (addr));
 }
@@ -27,7 +27,7 @@
 /* LDD is a PA2.0 addition. */
 #ifdef CONFIG_PA20
 #define ARCH_HAS_PREFETCHW
-extern inline void prefetchw(const void *addr)
+static inline void prefetchw(const void *addr)
 {
 	__asm__("ldd 0(%0), %%r0" : : "r" (addr));
 }
--- linux-2.6.23-rc1-mm1/include/asm-parisc/pgtable.h.old	2007-07-28 17:18:19.000000000 +0200
+++ linux-2.6.23-rc1-mm1/include/asm-parisc/pgtable.h	2007-07-28 17:18:40.000000000 +0200
@@ -325,27 +325,27 @@ static inline void pgd_clear(pgd_t *pgd)
  * setup: the pgd is never bad, and a pmd always exists (as it's folded
  * into the pgd entry)
  */
-extern inline int pgd_none(pgd_t pgd)		{ return 0; }
-extern inline int pgd_bad(pgd_t pgd)		{ return 0; }
-extern inline int pgd_present(pgd_t pgd)	{ return 1; }
-extern inline void pgd_clear(pgd_t * pgdp)	{ }
+static inline int pgd_none(pgd_t pgd)		{ return 0; }
+static inline int pgd_bad(pgd_t pgd)		{ return 0; }
+static inline int pgd_present(pgd_t pgd)	{ return 1; }
+static inline void pgd_clear(pgd_t * pgdp)	{ }
 #endif
 
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-extern inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
-extern inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-extern inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
-extern inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
-
-extern inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
-extern inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
-extern inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~_PAGE_WRITE; return pte; }
-extern inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
-extern inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
-extern inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= _PAGE_WRITE; return pte; }
+static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
+static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
+static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+
+static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
+static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~_PAGE_WRITE; return pte; }
+static inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= _PAGE_WRITE; return pte; }
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
@@ -369,7 +369,7 @@ static inline pte_t pfn_pte(unsigned lon
 	return pte;
 }
 
-extern inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 { pte_val(pte) = (pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot); return pte; }
 
 /* Permanent address of a page.  On parisc we don't have highmem. */

