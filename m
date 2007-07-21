Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbXGUXMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbXGUXMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 19:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXGUXMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 19:12:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39419 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbXGUXMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 19:12:42 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] make sparc32 PAGE_SHARED a read-mostly variable
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1ICO7t-0001yp-RO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jul 2007 00:12:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


same scheme as for sparc64, same rationale

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/mm/init.c        |    3 +++
 arch/sparc/mm/srmmu.c       |    2 +-
 arch/sparc/mm/sun4c.c       |    2 +-
 include/asm-sparc/pgtable.h |    3 +--
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/mm/init.c b/arch/sparc/mm/init.c
index a532922..a1bef07 100644
--- a/arch/sparc/mm/init.c
+++ b/arch/sparc/mm/init.c
@@ -308,6 +308,9 @@ extern void sun4c_paging_init(void);
 extern void srmmu_paging_init(void);
 extern void device_scan(void);
 
+pgprot_t PAGE_SHARED __read_mostly;
+EXPORT_SYMBOL(PAGE_SHARED);
+
 void __init paging_init(void)
 {
 	switch(sparc_cpu_model) {
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index ca26232..17b485f 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -2154,7 +2154,7 @@ void __init ld_mmu_srmmu(void)
 	BTFIXUPSET_SIMM13(ptrs_per_pgd, SRMMU_PTRS_PER_PGD);
 
 	BTFIXUPSET_INT(page_none, pgprot_val(SRMMU_PAGE_NONE));
-	BTFIXUPSET_INT(page_shared, pgprot_val(SRMMU_PAGE_SHARED));
+	PAGE_SHARED = pgprot_val(SRMMU_PAGE_SHARED);
 	BTFIXUPSET_INT(page_copy, pgprot_val(SRMMU_PAGE_COPY));
 	BTFIXUPSET_INT(page_readonly, pgprot_val(SRMMU_PAGE_RDONLY));
 	BTFIXUPSET_INT(page_kernel, pgprot_val(SRMMU_PAGE_KERNEL));
diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
index bdd835f..a57a366 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -2155,7 +2155,7 @@ void __init ld_mmu_sun4c(void)
 	BTFIXUPSET_SIMM13(user_ptrs_per_pgd, KERNBASE / SUN4C_PGDIR_SIZE);
 
 	BTFIXUPSET_INT(page_none, pgprot_val(SUN4C_PAGE_NONE));
-	BTFIXUPSET_INT(page_shared, pgprot_val(SUN4C_PAGE_SHARED));
+	PAGE_SHARED = pgprot_val(SUN4C_PAGE_SHARED);
 	BTFIXUPSET_INT(page_copy, pgprot_val(SUN4C_PAGE_COPY));
 	BTFIXUPSET_INT(page_readonly, pgprot_val(SUN4C_PAGE_READONLY));
 	BTFIXUPSET_INT(page_kernel, pgprot_val(SUN4C_PAGE_KERNEL));
diff --git a/include/asm-sparc/pgtable.h b/include/asm-sparc/pgtable.h
index a55f4c3..2cc235b 100644
--- a/include/asm-sparc/pgtable.h
+++ b/include/asm-sparc/pgtable.h
@@ -46,7 +46,6 @@ BTFIXUPDEF_SIMM13(user_ptrs_per_pgd)
 #define pgd_ERROR(e)   __builtin_trap()
 
 BTFIXUPDEF_INT(page_none)
-BTFIXUPDEF_INT(page_shared)
 BTFIXUPDEF_INT(page_copy)
 BTFIXUPDEF_INT(page_readonly)
 BTFIXUPDEF_INT(page_kernel)
@@ -66,7 +65,7 @@ BTFIXUPDEF_INT(page_kernel)
 #define PTE_SIZE		(PTRS_PER_PTE*4)
 
 #define PAGE_NONE      __pgprot(BTFIXUP_INT(page_none))
-#define PAGE_SHARED    __pgprot(BTFIXUP_INT(page_shared))
+extern pgprot_t PAGE_SHARED;
 #define PAGE_COPY      __pgprot(BTFIXUP_INT(page_copy))
 #define PAGE_READONLY  __pgprot(BTFIXUP_INT(page_readonly))
 
-- 
1.5.3.GIT

