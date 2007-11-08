Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbXKHCfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbXKHCfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760236AbXKHCdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:33:42 -0500
Received: from gw.goop.org ([64.81.55.164]:57077 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760211AbXKHCdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:33:40 -0500
Message-Id: <20071108015310.059598778@goop.org>
References: <20071108015008.660012621@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Nov 2007 17:50:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Zach Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH RFC 2/7] x86: clean up mm/init_32.c
Content-Disposition: inline; filename=x86-cleanup-mm-init_32.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some code reformatting in init_32.c.  No functional change.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 arch/x86/mm/init_32.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -165,16 +165,25 @@ static void __init kernel_physical_mappi
 		pmd = one_md_table_init(pgd);
 		if (pfn >= max_low_pfn)
 			continue;
-		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn; pmd++, pmd_idx++) {
+		for (pmd_idx = 0;
+		     pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn;
+		     pmd++, pmd_idx++) {
 			unsigned int address = pfn * PAGE_SIZE + PAGE_OFFSET;
 
-			/* Map with big pages if possible, otherwise create normal page tables. */
+			/* Map with big pages if possible, otherwise
+			   create normal page tables. */
 			if (cpu_has_pse) {
-				unsigned int address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE + PAGE_OFFSET + PAGE_SIZE-1;
-				if (is_kernel_text(address) || is_kernel_text(address2))
-					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
-				else
-					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE));
+				unsigned int address2;
+				pgprot_t prot = PAGE_KERNEL_LARGE;
+
+				address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE +
+					PAGE_OFFSET + PAGE_SIZE-1;
+
+				if (is_kernel_text(address) ||
+				    is_kernel_text(address2))
+					prot = PAGE_KERNEL_LARGE_EXEC;
+
+				set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
 			} else {
@@ -183,10 +192,12 @@ static void __init kernel_physical_mappi
 				for (pte_ofs = 0;
 				     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
 				     pte++, pfn++, pte_ofs++, address += PAGE_SIZE) {
+					pgprot_t prot = PAGE_KERNEL;
+
 					if (is_kernel_text(address))
-						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
-					else
-						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
+						prot = PAGE_KERNEL_EXEC;
+
+					set_pte(pte, pfn_pte(pfn, prot));
 				}
 			}
 		}

-- 

