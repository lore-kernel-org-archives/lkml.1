Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbXKHCdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbXKHCdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbXKHCd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:33:29 -0500
Received: from gw.goop.org ([64.81.55.164]:57055 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbXKHCd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:33:28 -0500
Message-Id: <20071108015309.956010847@goop.org>
References: <20071108015008.660012621@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Nov 2007 17:50:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Zach Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH RFC 1/7] x86: kill mk_pte_huge
Content-Disposition: inline; filename=x86-kill-mk_pte_huge.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It only has a single use, which can be trivially replaced.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 arch/x86/mm/init_64.c        |    3 +--
 include/asm-x86/pgtable_64.h |    9 ---------
 2 files changed, 1 insertion(+), 11 deletions(-)

===================================================================
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -768,8 +768,7 @@ int __meminit vmemmap_populate(struct pa
 			if (!p)
 				return -ENOMEM;
 
-			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
-			mk_pte_huge(entry);
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL_LARGE);
 			set_pmd(pmd, __pmd(pte_val(entry)));
 
 			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
===================================================================
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -378,15 +378,6 @@ static inline pte_t pte_clrhuge(pte_t pt
 /* page, protection -> pte */
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
 
-static inline pte_t __mk_pte_huge(pte_t entry)
-{
-	unsigned long pte;
-	pte = pte_val(entry);
-	pte |= _PAGE_PRESENT | _PAGE_PSE;
-	return  __pte(pte);
-}
-#define mk_pte_huge(entry) ((entry) = __mk_pte_huge(entry))
-
 #include <linux/mm_types.h>
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long addr, pte_t *ptep)

-- 

