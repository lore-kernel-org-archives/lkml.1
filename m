Return-Path: <linux-kernel-owner+w=401wt.eu-S934159AbXC0Sbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbXC0Sbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934160AbXC0Sbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:31:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:45442 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934162AbXC0SbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:31:09 -0400
Date: Tue, 27 Mar 2007 14:27:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/6] UML - Fix pte bit collision
Message-ID: <20070327182749.GA8411@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

_PAGE_PROTNONE conflicts with the lowest bit of pgoff.  This causes
all sorts of weirdness when nonlinear mappings are used.

Took me a good half day to track this down.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/pgtable-2level.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.21-mm/include/asm-um/pgtable-2level.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-um/pgtable-2level.h	2007-03-27 12:34:31.000000000 -0400
+++ linux-2.6.21-mm/include/asm-um/pgtable-2level.h	2007-03-27 12:52:12.000000000 -0400
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
