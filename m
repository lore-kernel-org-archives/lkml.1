Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYEILLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYEILLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYEILJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:35 -0400
Received: from gw.goop.org ([64.81.55.164]:47574 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbYEILJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 8] x86: use PTE_MASK in 32-bit PAE
X-Mercurial-Node: cd00888da96472528352c809436b4d83b28f5516
Message-Id: <cd00888da96472528352.1210330962@localhost>
In-Reply-To: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:42 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PTE_MASK in 3-level pagetables (ie, 32-bit PAE).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable-3level.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -120,9 +120,9 @@
 		write_cr3(pgd);
 }
 
-#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_MASK))
 
-#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_MASK))
 
 
 /* Find an entry in the second-level page table.. */
@@ -160,7 +160,7 @@
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return (pte_val(pte) & ~_PAGE_NX) >> PAGE_SHIFT;
+	return (pte_val(pte) & PTE_MASK) >> PAGE_SHIFT;
 }
 
 /*


