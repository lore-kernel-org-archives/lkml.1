Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbZFULPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbZFULPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZFULP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:15:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:60521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZFULPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:15:25 -0400
Subject: [PATCH -tip] x86: mm/hugetlbpage.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Rohit Seth <rohitseth@google.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 16:44:41 +0530
Message-Id: <1245582881.3052.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact : cleanup

Fix :

WARNING: Use #include <linux/mman.h> instead of <asm/mman.h>
WARNING: line over 80 characters
ERROR: code indent should use tabs where possible X 10
ERROR: do not use assignment in if condition
ERROR: return is not a function, parentheses are not required

total: 12 errors, 2 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/mm/hugetlbpage.c |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index f46c340..978fc5f 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/sysctl.h>
-#include <asm/mman.h>
+#include <linux/mman.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
@@ -93,7 +93,8 @@ static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 
 	spin_lock(&mm->page_table_lock);
 	if (pud_none(*pud))
-		pud_populate(mm, pud, (pmd_t *)((unsigned long)spte & PAGE_MASK));
+		pud_populate(mm, pud,
+			     (pmd_t *)((unsigned long)spte & PAGE_MASK));
 	else
 		put_page(virt_to_page(spte));
 	spin_unlock(&mm->page_table_lock);
@@ -269,11 +270,11 @@ static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
 
-	if (len > mm->cached_hole_size) {
-	        start_addr = mm->free_area_cache;
-	} else {
-	        start_addr = TASK_UNMAPPED_BASE;
-	        mm->cached_hole_size = 0;
+	if (len > mm->cached_hole_size)
+		start_addr = mm->free_area_cache;
+	else {
+		start_addr = TASK_UNMAPPED_BASE;
+		mm->cached_hole_size = 0;
 	}
 
 full_search:
@@ -298,7 +299,7 @@ full_search:
 			return addr;
 		}
 		if (addr + mm->cached_hole_size < vma->vm_start)
-		        mm->cached_hole_size = vma->vm_start - addr;
+			mm->cached_hole_size = vma->vm_start - addr;
 		addr = ALIGN(vma->vm_end, huge_page_size(h));
 	}
 }
@@ -319,7 +320,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 		mm->free_area_cache = base;
 
 	if (len <= largest_hole) {
-	        largest_hole = 0;
+		largest_hole = 0;
 		mm->free_area_cache  = base;
 	}
 try_again:
@@ -334,7 +335,8 @@ try_again:
 		 * Lookup failure means no vma is above this address,
 		 * i.e. return with success:
 		 */
-		if (!(vma = find_vma_prev(mm, addr, &prev_vma)))
+		vma = find_vma_prev(mm, addr, &prev_vma);
+		if (!vma)
 			return addr;
 
 		/*
@@ -342,13 +344,14 @@ try_again:
 		 * vma->vm_start, use it:
 		 */
 		if (addr + len <= vma->vm_start &&
-		            (!prev_vma || (addr >= prev_vma->vm_end))) {
+		    (!prev_vma || (addr >= prev_vma->vm_end))) {
 			/* remember the address as a hint for next time */
-		        mm->cached_hole_size = largest_hole;
-		        return (mm->free_area_cache = addr);
+			mm->cached_hole_size = largest_hole;
+			mm->free_area_cache = addr;
+			return addr;
 		} else {
 			/* pull free_area_cache down to the first hole */
-		        if (mm->free_area_cache == vma->vm_end) {
+			if (mm->free_area_cache == vma->vm_end) {
 				mm->free_area_cache = vma->vm_start;
 				mm->cached_hole_size = largest_hole;
 			}
@@ -356,7 +359,7 @@ try_again:
 
 		/* remember the largest hole we saw so far */
 		if (addr + largest_hole < vma->vm_start)
-		        largest_hole = vma->vm_start - addr;
+			largest_hole = vma->vm_start - addr;
 
 		/* try just below the current vma->vm_start */
 		addr = (vma->vm_start - len) & huge_page_mask(h);
-- 
1.6.0.6



