Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbYA2Ada@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbYA2Ada (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYA2AdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:33:21 -0500
Received: from zrnetservice.com ([209.133.52.163]:50313 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757348AbYA2AdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:33:20 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 4] x86: update reference for PAE tlb flushing
X-Mercurial-Node: b114ed40c337347cde5ec410e231dabec106eeb0
Message-Id: <b114ed40c337347cde5e.1201564124@localhost>
In-Reply-To: <patchbomb.1201564120@localhost>
Date: Mon, 28 Jan 2008 15:48:44 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove bogus reference to "Pentium-II erratum A13" and point to the
actual canonical source of information about what requirements x86
processors have for PAE pagetable updates.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/pgalloc_32.h     |    6 ++++--
 include/asm-x86/pgtable-3level.h |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -87,8 +87,10 @@ static inline void pud_populate(struct m
 	set_pud(pudp, __pud(__pa(pmd) | _PAGE_PRESENT));
 
 	/*
-	 * Pentium-II erratum A13: in PAE mode we explicitly have to flush
-	 * the TLB via cr3 if the top-level pgd is changed...
+	 * According to Intel App note "TLBs, Paging-Structure Caches,
+	 * and Their Invalidation", April 2007, document 317080-001,
+	 * section 8.1: in PAE mode we explicitly have to flush the
+	 * TLB via cr3 if the top-level pgd is changed...
 	 */
 	if (mm == current->active_mm)
 		write_cr3(read_cr3());
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -98,8 +98,10 @@ static inline void pud_clear(pud_t *pudp
 	set_pud(pudp, __pud(0));
 
 	/*
-	 * Pentium-II erratum A13: in PAE mode we explicitly have to flush
-	 * the TLB via cr3 if the top-level pgd is changed...
+	 * According to Intel App note "TLBs, Paging-Structure Caches,
+	 * and Their Invalidation", April 2007, document 317080-001,
+	 * section 8.1: in PAE mode we explicitly have to flush the
+	 * TLB via cr3 if the top-level pgd is changed...
 	 *
 	 * Make sure the pud entry we're updating is within the
 	 * current pgd to avoid unnecessary TLB flushes.


