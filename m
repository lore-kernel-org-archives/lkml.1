Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYJ3KhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYJ3KhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYJ3KhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:37:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26441 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbYJ3KhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:37:05 -0400
Message-Id: <49099C71.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 30 Oct 2008 10:37:21 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386/PAE: fix pud_page()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To the unsuspecting user it is quite annoying that this broken and
inconsistent with x86-64 definition still exists.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/pgtable-3level.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.28-rc2/arch/x86/include/asm/pgtable-3level.h	2008-10-30 11:03:18.000000000 +0100
+++ 2.6.28-rc2-i386-pae-pud_page/arch/x86/include/asm/pgtable-3level.h	2008-10-29 11:35:24.000000000 +0100
@@ -120,13 +120,13 @@ static inline void pud_clear(pud_t *pudp
 		write_cr3(pgd);
 }
 
-#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_PFN_MASK))
+#define pud_page(pud) pfn_to_page(pud_val(pud) >> PAGE_SHIFT)
 
 #define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_PFN_MASK))
 
 
 /* Find an entry in the second-level page table.. */
-#define pmd_offset(pud, address) ((pmd_t *)pud_page(*(pud)) +	\
+#define pmd_offset(pud, address) ((pmd_t *)pud_page_vaddr(*(pud)) +	\
 				  pmd_index(address))
 
 #ifdef CONFIG_SMP



