Return-Path: <linux-kernel-owner+w=401wt.eu-S2992719AbXCBXHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992719AbXCBXHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992718AbXCBXHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:07:01 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:57031 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992719AbXCBXHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:07:00 -0500
To: jdike@addtoit.com
CC: linux-kernel@vger.kernel.org, user-mode-linux@lists.sourceforge.net
Subject: nonlinear vma problem in uml
Message-Id: <E1HNGpQ-0005yE-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 03 Mar 2007 00:06:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

_PAGE_PROTNONE conflicts with the lowest bit of pgoff.  This causes
all sorts of weirdness when nonlinear mappings are used.

Took me a good half day to track this down.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/asm-um/pgtable-2level.h
===================================================================
--- linux.orig/include/asm-um/pgtable-2level.h	2007-03-02 23:03:15.000000000 +0100
+++ linux/include/asm-um/pgtable-2level.h	2007-03-02 23:03:26.000000000 +0100
@@ -45,12 +45,12 @@ static inline void pgd_mkuptodate(pgd_t 
 	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 
 /*
- * Bits 0 through 3 are taken
+ * Bits 0 through 4 are taken
  */
-#define PTE_FILE_MAX_BITS	28
+#define PTE_FILE_MAX_BITS	27
 
-#define pte_to_pgoff(pte) (pte_val(pte) >> 4)
+#define pte_to_pgoff(pte) (pte_val(pte) >> 5)
 
-#define pgoff_to_pte(off) ((pte_t) { ((off) << 4) + _PAGE_FILE })
+#define pgoff_to_pte(off) ((pte_t) { ((off) << 5) + _PAGE_FILE })
 
 #endif
