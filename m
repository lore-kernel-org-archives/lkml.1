Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZFULZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZFULZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZFULZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:25:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:37793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZFULZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:25:24 -0400
Subject: [PATCH -tip] x86: mm/init_32.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 16:54:52 +0530
Message-Id: <1245583492.3052.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Fix :

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
ERROR: do not initialise externals to 0 or NULL
ERROR: code indent should use tabs where possible
ERROR: space required after that ',' (ctx:VxV)
ERROR: spaces required around that ':' (ctx:ExV) X 3

total: 6 errors, 1 warning

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/mm/init_32.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3cd7711..64f0ee3 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -30,12 +30,12 @@
 #include <linux/memory_hotplug.h>
 #include <linux/initrd.h>
 #include <linux/cpumask.h>
+#include <linux/uaccess.h>
 
 #include <asm/asm.h>
 #include <asm/bios_ebda.h>
 #include <asm/processor.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/dma.h>
 #include <asm/fixmap.h>
@@ -56,7 +56,7 @@ unsigned long highstart_pfn, highend_pfn;
 
 static noinline int do_test_wp_bit(void);
 
-bool __read_mostly __vmalloc_start_set = false;
+bool __read_mostly __vmalloc_start_set;
 
 static __init void *alloc_low_page(void)
 {
@@ -215,7 +215,7 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
 							pmd++, pmd_idx++) {
 			pte = page_table_kmap_check(one_page_table_init(pmd),
-			                            pmd, vaddr, pte);
+						    pmd, vaddr, pte);
 
 			vaddr += PMD_SIZE;
 		}
@@ -989,12 +989,12 @@ static noinline int do_test_wp_bit(void)
 		"1:	movb %1, %0	\n"
 		"	xorl %2, %2	\n"
 		"2:			\n"
-		_ASM_EXTABLE(1b,2b)
-		:"=m" (*(char *)fix_to_virt(FIX_WP_TEST)),
+		_ASM_EXTABLE(1b, 2b)
+		: "=m" (*(char *)fix_to_virt(FIX_WP_TEST)),
 		 "=q" (tmp_reg),
 		 "=r" (flag)
-		:"2" (1)
-		:"memory");
+		: "2" (1)
+		: "memory");
 
 	return flag;
 }
-- 
1.6.0.6



