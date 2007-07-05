Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbXGEXXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbXGEXXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762790AbXGEXW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:22:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52134 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762775AbXGEXWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:22:25 -0400
Date: Fri, 6 Jul 2007 01:22:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jeremy@xensource.com,
       chrisw@sous-sol.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [-mm patch] make arch/i386/xen/mmu.c:xen_pgd_pin() static
Message-ID: <20070705232255.GX3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

xen_pgd_pin() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/xen/mmu.c |    2 +-
 arch/i386/xen/mmu.h |    3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

--- linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.h.old	2007-07-04 20:42:44.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.h	2007-07-04 20:42:54.000000000 +0200
@@ -27,9 +27,6 @@
 void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
 void xen_exit_mmap(struct mm_struct *mm);
 
-void xen_pgd_pin(pgd_t *pgd);
-//void xen_pgd_unpin(pgd_t *pgd);
-
 #ifdef CONFIG_X86_PAE
 unsigned long long xen_pte_val(pte_t);
 unsigned long long xen_pmd_val(pmd_t);
--- linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.c.old	2007-07-04 20:43:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.c	2007-07-04 20:43:06.000000000 +0200
@@ -408,7 +408,7 @@
 /* This is called just after a mm has been created, but it has not
    been used yet.  We need to make sure that its pagetable is all
    read-only, and can be pinned. */
-void xen_pgd_pin(pgd_t *pgd)
+static void xen_pgd_pin(pgd_t *pgd)
 {
 	struct multicall_space mcs;
 	struct mmuext_op *op;

