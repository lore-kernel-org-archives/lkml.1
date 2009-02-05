Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbZBETkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbZBETkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759538AbZBETce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:34 -0500
Received: from gw.goop.org ([64.81.55.164]:40054 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759558AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 35 of 36] x86: make pgd/pud/pmd/pte_none consistent
X-Mercurial-Node: ab45a6865df539a36a75ba13f07e2eda71f40647
Message-Id: <ab45a6865df539a36a75.1233862277@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _none test is done differently for every level of the pagetable.
Standardize them by:

 1: Use the native_X_val to extract the raw entry, with no need to go
    via paravirt_ops, diff -r 1d0646d0d319 arch/x86/include/asm/pgtable.h, and
 2: Compare with 0 rather than using a boolean !, since they are actually values
    and not booleans.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/include/asm/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -503,7 +503,7 @@
 {
 	/* Only check low word on 32-bit platforms, since it might be
 	   out of sync with upper half. */
-	return !(unsigned long)native_pmd_val(pmd);
+	return (unsigned long)native_pmd_val(pmd) == 0;
 }
 
 static inline unsigned long pmd_page_vaddr(pmd_t pmd)
@@ -568,7 +568,7 @@
 #if PAGETABLE_LEVELS > 2
 static inline int pud_none(pud_t pud)
 {
-	return pud_val(pud) == 0;
+	return native_pud_val(pud) == 0;
 }
 
 static inline int pud_present(pud_t pud)
@@ -643,7 +643,7 @@
 
 static inline int pgd_none(pgd_t pgd)
 {
-	return !pgd_val(pgd);
+	return !native_pgd_val(pgd);
 }
 #endif	/* PAGETABLE_LEVELS > 3 */
 


