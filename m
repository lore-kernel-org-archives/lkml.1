Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYBAQkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYBAQkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbYBAQkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:40:06 -0500
Received: from gw.goop.org ([64.81.55.164]:59589 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbYBAQkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:40:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 4] x86: update reference for PAE tlb flushing
X-Mercurial-Node: 486ab2346850b276fa9f795188f0790c308d845f
Message-Id: <486ab2346850b276fa9f.1201883964@localhost>
In-Reply-To: <patchbomb.1201883960@localhost>
Date: Fri, 01 Feb 2008 08:39:24 -0800
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
@@ -80,8 +80,10 @@
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
@@ -98,8 +98,10 @@
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


