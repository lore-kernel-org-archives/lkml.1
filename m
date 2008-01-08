Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYAHWRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYAHWRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYAHWPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:39 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47852
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752075AbYAHWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 10] x86: unify zero_page definition
X-Mercurial-Node: 623ee54fd174df8ba6e9d6087de3dc4ce44c9bdc
Message-Id: <623ee54fd174df8ba6e9.1199829611@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ZERO_PAGE/empty_zero_page to common place.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-x86/pgtable.h    |    8 ++++++++
 include/asm-x86/pgtable_32.h |    6 ------
 include/asm-x86/pgtable_64.h |    7 -------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -110,6 +110,14 @@ extern unsigned long long __PAGE_KERNEL,
 #define __S111	PAGE_SHARED_EXEC
 
 #ifndef __ASSEMBLER__
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
+#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
+
 
 /*
  * The following only work if pte_present() is true.
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -25,12 +25,6 @@ struct mm_struct;
 struct mm_struct;
 struct vm_area_struct;
 
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
-extern unsigned long empty_zero_page[1024];
 extern pgd_t swapper_pg_dir[1024];
 extern struct kmem_cache *pmd_cache;
 extern spinlock_t pgd_lock;
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -22,13 +22,6 @@ extern pgd_t init_level4_pgt[];
 
 extern void paging_init(void);
 extern void clear_kernel_mapping(unsigned long addr, unsigned long size);
-
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
-#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
 #endif /* !__ASSEMBLY__ */
 


