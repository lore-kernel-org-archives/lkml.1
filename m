Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYASGth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYASGth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYASGsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:48:52 -0500
Received: from ns.suse.de ([195.135.220.2]:33230 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYASGsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:48:33 -0500
From: Andi Kleen <ak@suse.de>
References: <20080119748.170864000@suse.de>
In-Reply-To: <20080119748.170864000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/8] Add pgtable accessor functions for GB pages
Message-Id: <20080119064832.786F614EAD@wotan.suse.de>
Date: Sat, 19 Jan 2008 07:48:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/pgtable_64.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -208,6 +208,12 @@ static inline unsigned long pmd_bad(pmd_
 #define pud_offset(pgd, address) ((pud_t *) pgd_page_vaddr(*(pgd)) + pud_index(address))
 #define pud_present(pud) (pud_val(pud) & _PAGE_PRESENT)
 
+static inline int pud_large(pud_t pte)
+{
+	return (pud_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
+		(_PAGE_PSE|_PAGE_PRESENT);
+}
+
 /* PMD  - Level 2 access */
 #define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PTE_MASK))
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
