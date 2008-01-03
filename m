Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbYACPYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbYACPYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYACPYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:43009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYACPYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:18 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [3/28] Add pte accessors for the global bit
Message-Id: <20080103152417.2BA7E14E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Needed for some test code.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/pgtable_32.h |    3 +++
 include/asm-x86/pgtable_64.h |    3 +++
 2 files changed, 6 insertions(+)

Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -275,6 +275,7 @@ static inline int pte_young(pte_t pte)		
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
+static inline int pte_global(pte_t pte)		{ return pte_val(pte) & _PAGE_GLOBAL; }
 
 static inline pte_t pte_mkclean(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_DIRTY)); return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_ACCESSED)); return pte; }
@@ -285,6 +286,8 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline pte_t pte_mkwrite(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_RW)); return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_PSE)); return pte; }
 static inline pte_t pte_clrhuge(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_PSE)); return pte; }
+static inline pte_t pte_mkglobal(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) | _PAGE_GLOBAL)); return pte; }
+static inline pte_t pte_clrglobal(pte_t pte)	{ set_pte(&pte, __pte(pte_val(pte) & ~_PAGE_GLOBAL)); return pte; }
 
 struct vm_area_struct;
 
Index: linux/include/asm-x86/pgtable_32.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_32.h
+++ linux/include/asm-x86/pgtable_32.h
@@ -220,6 +220,7 @@ static inline int pte_dirty(pte_t pte)		
 static inline int pte_young(pte_t pte)		{ return (pte).pte_low & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return (pte).pte_low & _PAGE_RW; }
 static inline int pte_huge(pte_t pte)		{ return (pte).pte_low & _PAGE_PSE; }
+static inline int pte_global(pte_t pte)		{ return (pte).pte_low & _PAGE_GLOBAL; }
 
 /*
  * The following only works if pte_present() is not true.
@@ -233,6 +234,8 @@ static inline pte_t pte_mkdirty(pte_t pt
 static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte_low |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte_low |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ (pte).pte_low |= _PAGE_PSE; return pte; }
+static inline pte_t pte_mkglobal(pte_t pte)	{ (pte).pte_low |= _PAGE_GLOBAL; return pte; }
+static inline pte_t pte_clrglobal(pte_t pte)	{ (pte).pte_low &= ~_PAGE_GLOBAL; return pte; }
 
 #ifdef CONFIG_X86_PAE
 # include <asm/pgtable-3level.h>
