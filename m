Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbZBETmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbZBETmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbZBETck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:40 -0500
Received: from gw.goop.org ([64.81.55.164]:40049 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbZBETcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 31 of 36] x86: unify pud_none
X-Mercurial-Node: 73137e103cf55659a6025be60969f0a837fa983a
Message-Id: <73137e103cf55659a602.1233862273@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:31:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unify and demacro pud_none.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable-3level.h |    5 -----
 arch/x86/include/asm/pgtable.h        |    5 +++++
 arch/x86/include/asm/pgtable_64.h     |    1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -18,11 +18,6 @@
 	printk("%s:%d: bad pgd %p(%016Lx).\n",				\
 	       __FILE__, __LINE__, &(e), pgd_val(e))
 
-static inline int pud_none(pud_t pud)
-{
-	return pud_val(pud) == 0;
-}
-
 /* Rules for using set_pte: the pte being assigned *must* be
  * either not present or in a state where the hardware will
  * not attempt to update the pte.  In places where this is
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -563,6 +563,11 @@
 }
 
 #if PAGETABLE_LEVELS > 2
+static inline int pud_none(pud_t pud)
+{
+	return pud_val(pud) == 0;
+}
+
 static inline int pud_present(pud_t pud)
 {
 	return pud_val(pud) & _PAGE_PRESENT;
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -67,7 +67,6 @@
 	       __FILE__, __LINE__, &(e), pgd_val(e))
 
 #define pgd_none(x)	(!pgd_val(x))
-#define pud_none(x)	(!pud_val(x))
 
 struct mm_struct;
 


