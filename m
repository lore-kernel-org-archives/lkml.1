Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYJBPLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYJBPLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYJBPLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:11:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbYJBPLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:11:06 -0400
Message-Id: <20081002151104.635936668@goodmis.org>
References: <20081002150529.087488257@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 11:05:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] xen: nuke dead code in enlighten.c
Content-Disposition: inline; filename=xen-nuke-enlighten-dead-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel is no place to hold dead code.

No reason for #if 0 in the kernel proper.

Note, the walk function being deleted is only referenced in the
 #if 0 code.

CC: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/xen/enlighten.c |   42 ------------------------------------------
 1 file changed, 42 deletions(-)

Index: linux-compile.git/arch/x86/xen/enlighten.c
===================================================================
--- linux-compile.git.orig/arch/x86/xen/enlighten.c	2008-10-02 10:34:41.000000000 -0400
+++ linux-compile.git/arch/x86/xen/enlighten.c	2008-10-02 10:34:59.000000000 -0400
@@ -1451,39 +1451,6 @@ static void *m2v(phys_addr_t maddr)
 	return __ka(m2p(maddr));
 }
 
-#ifdef CONFIG_X86_64
-static void walk(pgd_t *pgd, unsigned long addr)
-{
-	unsigned l4idx = pgd_index(addr);
-	unsigned l3idx = pud_index(addr);
-	unsigned l2idx = pmd_index(addr);
-	unsigned l1idx = pte_index(addr);
-	pgd_t l4;
-	pud_t l3;
-	pmd_t l2;
-	pte_t l1;
-
-	xen_raw_printk("walk %p, %lx -> %d %d %d %d\n",
-		       pgd, addr, l4idx, l3idx, l2idx, l1idx);
-
-	l4 = pgd[l4idx];
-	xen_raw_printk("  l4: %016lx\n", l4.pgd);
-	xen_raw_printk("      %016lx\n", pgd_val(l4));
-
-	l3 = ((pud_t *)(m2v(l4.pgd)))[l3idx];
-	xen_raw_printk("  l3: %016lx\n", l3.pud);
-	xen_raw_printk("      %016lx\n", pud_val(l3));
-
-	l2 = ((pmd_t *)(m2v(l3.pud)))[l2idx];
-	xen_raw_printk("  l2: %016lx\n", l2.pmd);
-	xen_raw_printk("      %016lx\n", pmd_val(l2));
-
-	l1 = ((pte_t *)(m2v(l2.pmd)))[l1idx];
-	xen_raw_printk("  l1: %016lx\n", l1.pte);
-	xen_raw_printk("      %016lx\n", pte_val(l1));
-}
-#endif
-
 static void set_page_prot(void *addr, pgprot_t prot)
 {
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
@@ -1747,15 +1714,6 @@ asmlinkage void __init xen_start_kernel(
 
 	xen_raw_console_write("about to get started...\n");
 
-#if 0
-	xen_raw_printk("&boot_params=%p __pa(&boot_params)=%lx __va(__pa(&boot_params))=%lx\n",
-		       &boot_params, __pa_symbol(&boot_params),
-		       __va(__pa_symbol(&boot_params)));
-
-	walk(pgd, &boot_params);
-	walk(pgd, __va(__pa(&boot_params)));
-#endif
-
 	/* Start the world */
 #ifdef CONFIG_X86_32
 	i386_start_kernel();

-- 
