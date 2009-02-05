Return-Path: <linux-kernel-owner+w=401wt.eu-S1762985AbZBETm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762985AbZBETm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbZBETcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:39 -0500
Received: from gw.goop.org ([64.81.55.164]:40068 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759550AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 28 of 36] x86: unify pgd_bad
X-Mercurial-Node: b42a531abdfdbf1337febd22109ca9d5b0c08d0f
Message-Id: <b42a531abdfdbf1337fe.1233862270@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pgd_bad.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable-3level.h |    5 -----
 arch/x86/include/asm/pgtable.h        |    5 +++++
 arch/x86/include/asm/pgtable_64.h     |    5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -23,11 +23,6 @@
 	return pud_val(pud) == 0;
 }
 
-static inline int pud_bad(pud_t pud)
-{
-	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
-}
-
 /* Rules for using set_pte: the pte being assigned *must* be
  * either not present or in a state where the hardware will
  * not attempt to update the pte.  In places where this is
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -584,6 +584,11 @@
 	return (pud_val(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
 		(_PAGE_PSE | _PAGE_PRESENT);
 }
+
+static inline int pud_bad(pud_t pud)
+{
+	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
+}
 #endif	/* PAGETABLE_LEVELS > 2 */
 
 #if PAGETABLE_LEVELS > 3
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -153,11 +153,6 @@
 
 #ifndef __ASSEMBLY__
 
-static inline int pud_bad(pud_t pud)
-{
-	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
-}
-
 static inline int pmd_bad(pmd_t pmd)
 {
 	return (pmd_val(pmd) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;


