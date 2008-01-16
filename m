Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYAPWSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYAPWSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbYAPWPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:13 -0500
Received: from ns1.suse.de ([195.135.220.2]:55185 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbYAPWPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:09 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [9/36] Add pte accessors for the global bit
Message-Id: <20080116221507.EA97E150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Needed for some test code.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 include/asm-x86/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -144,6 +144,7 @@ static inline int pte_young(pte_t pte)		
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
+static inline int pte_global(pte_t pte) 	{ return pte_val(pte) & _PAGE_GLOBAL; }
 
 static inline int pmd_large(pmd_t pte) {
 	return (pmd_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
@@ -159,6 +160,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline pte_t pte_mkwrite(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_RW); }
 static inline pte_t pte_mkhuge(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_PSE); }
 static inline pte_t pte_clrhuge(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_PSE); }
+static inline pte_t pte_mkglobal(pte_t pte)	{ return __pte(pte_val(pte) | _PAGE_GLOBAL); }
+static inline pte_t pte_clrglobal(pte_t pte)	{ return __pte(pte_val(pte) & ~_PAGE_GLOBAL); }
 
 extern pteval_t __supported_pte_mask;
 
