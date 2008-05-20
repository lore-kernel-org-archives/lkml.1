Return-Path: <linux-kernel-owner+w=401wt.eu-S1764352AbYETJIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764352AbYETJIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761728AbYETJGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:06:54 -0400
Received: from gw.goop.org ([64.81.55.164]:44045 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761314AbYETJGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:06:53 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 8] x86: use PTE_MASK in 32-bit PAE
X-Mercurial-Node: d2cfb4dc7c7d28ddde78d79a08adb442e6a47734
Message-Id: <d2cfb4dc7c7d28ddde78.1211268380@localhost>
In-Reply-To: <patchbomb.1211268376@localhost>
Date: Tue, 20 May 2008 08:26:20 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PTE_MASK in 3-level pagetables (ie, 32-bit PAE).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/pgtable-3level.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -120,9 +120,9 @@
 		write_cr3(pgd);
 }
 
-#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_MASK))
 
-#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_MASK))
 
 
 /* Find an entry in the second-level page table.. */
@@ -160,7 +160,7 @@
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return (pte_val(pte) & ~_PAGE_NX) >> PAGE_SHIFT;
+	return (pte_val(pte) & PTE_MASK) >> PAGE_SHIFT;
 }
 
 /*


