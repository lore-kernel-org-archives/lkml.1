Return-Path: <linux-kernel-owner+w=401wt.eu-S1764576AbYETJIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764576AbYETJIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762763AbYETJG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:06:56 -0400
Received: from gw.goop.org ([64.81.55.164]:44066 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762191AbYETJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:06:55 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 8] x86: use PTE_MASK in pgtable_32.h
X-Mercurial-Node: def260e5d02e2fc6604a0855a535c5a6ed36cbb8
Message-Id: <def260e5d02e2fc6604a.1211268381@localhost>
In-Reply-To: <patchbomb.1211268376@localhost>
Date: Tue, 20 May 2008 08:26:21 +0100
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

---
 include/asm-x86/pgtable_32.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -88,7 +88,7 @@
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
-#define pmd_bad(x) ((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define pmd_bad(x) ((pmd_val(x) & (~PTE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
 
@@ -159,7 +159,7 @@
 #define pmd_page(pmd) (pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
 
 #define pmd_page_vaddr(pmd)					\
-	((unsigned long)__va(pmd_val((pmd)) & PAGE_MASK))
+	((unsigned long)__va(pmd_val((pmd)) & PTE_MASK))
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address)					\


