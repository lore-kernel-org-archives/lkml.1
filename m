Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbYAYWwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbYAYWwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbYAYWwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:52:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44306 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658AbYAYWwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:52:34 -0500
Date: Fri, 25 Jan 2008 14:52:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [patch 3/3] x86: deprecate change_page_attr() for drivers
Message-ID: <20080125145212.5ad8fbec@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: deprecate change_page_attr()
From: Arjan van de Ven <arjan@linux.intel.com>

With the introduction of the new API, no driver or non-archcore code needs
to use c-p-a anymore, so this patch also deprecates the EXPORT_SYMBOL of CPA
(it's a horrible API after all).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/mm/pageattr.c       |    2 +-
 include/asm-x86/cacheflush.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux.trees.git/arch/x86/mm/pageattr.c
===================================================================
--- linux.trees.git.orig/arch/x86/mm/pageattr.c
+++ linux.trees.git/arch/x86/mm/pageattr.c
@@ -288,7 +288,7 @@ int change_page_attr(struct page *page, 
 
 	return change_page_attr_addr(addr, numpages, prot);
 }
-EXPORT_SYMBOL(change_page_attr);
+EXPORT_UNUSED_SYMBOL(change_page_attr); /* to be removed in 2.6.27 */
 
 /**
  * change_page_attr_set - Change page table attributes in the linear mapping.
Index: linux.trees.git/include/asm-x86/cacheflush.h
===================================================================
--- linux.trees.git.orig/include/asm-x86/cacheflush.h
+++ linux.trees.git/include/asm-x86/cacheflush.h
@@ -25,7 +25,8 @@
 	memcpy(dst, src, len)
 
 void global_flush_tlb(void);
-int change_page_attr(struct page *page, int numpages, pgprot_t prot);
+int __deprecated_for_modules change_page_attr(struct page *page, int numpages,
+								pgprot_t prot);
 int change_page_attr_addr(unsigned long addr, int numpages, pgprot_t prot);
 
 int set_pages_uc(struct page *page, int numpages);


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
