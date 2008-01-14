Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbYANWRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbYANWRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYANWQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbYANWQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:35 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [3/31] Add pte accessors for the global bit
Message-Id: <20080114221634.C899214F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Needed for some test code.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -134,6 +134,7 @@ static inline int pte_young(pte_t pte)		
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
+static inline int pte_global(pte_t pte) 	{ return pte_val(pte) & _PAGE_GLOBAL; }
 
 static inline int pmd_large(pmd_t pte) {
 	return (pmd_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
@@ -149,6 +150,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline pte_t pte_mkwrite(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_RW); }
 static inline pte_t pte_mkhuge(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_PSE); }
 static inline pte_t pte_clrhuge(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_PSE); }
+static inline pte_t pte_mkglobal(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_GLOBAL); }
+static inline pte_t pte_clrglobal(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_GLOBAL); }
 
 extern pteval_t __supported_pte_mask;
 
