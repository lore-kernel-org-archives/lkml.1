Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbXHRAnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbXHRAnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbXHRAmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:42:52 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:57731 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbXHRAmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:42:18 -0400
Date: Fri, 17 Aug 2007 15:43:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 1/6] UML - Fix inlines
Message-ID: <20070817194340.GA8734@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/pgalloc.h          |    2 +-
 include/asm-um/pgtable-3level.h   |    2 +-
 include/asm-um/processor-x86_64.h |    2 +-
 include/asm-um/smp.h              |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.22/include/asm-um/pgalloc.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/pgalloc.h	2007-08-13 22:38:59.000000000 -0400
+++ linux-2.6.22/include/asm-um/pgalloc.h	2007-08-16 12:04:12.000000000 -0400
@@ -42,7 +42,7 @@ static inline void pte_free(struct page 
 
 #ifdef CONFIG_3_LEVEL_PGTABLES
 
-extern __inline__ void pmd_free(pmd_t *pmd)
+static inline void pmd_free(pmd_t *pmd)
 {
 	free_page((unsigned long)pmd);
 }
Index: linux-2.6.22/include/asm-um/pgtable-3level.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/pgtable-3level.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-um/pgtable-3level.h	2007-08-15 10:39:59.000000000 -0400
@@ -69,7 +69,7 @@ static inline pmd_t *pmd_alloc_one(struc
         return pmd;
 }
 
-extern inline void pud_clear (pud_t *pud)
+static inline void pud_clear (pud_t *pud)
 {
         set_pud(pud, __pud(0));
 }
Index: linux-2.6.22/include/asm-um/processor-x86_64.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/processor-x86_64.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-um/processor-x86_64.h	2007-08-15 10:39:59.000000000 -0400
@@ -18,7 +18,7 @@ struct arch_thread {
 };
 
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
-extern inline void rep_nop(void)
+static inline void rep_nop(void)
 {
 	__asm__ __volatile__("rep;nop": : :"memory");
 }
Index: linux-2.6.22/include/asm-um/smp.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/smp.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-um/smp.h	2007-08-15 10:39:59.000000000 -0400
@@ -18,7 +18,7 @@ extern int hard_smp_processor_id(void);
 extern int ncpus;
 
 
-extern inline void smp_cpus_done(unsigned int maxcpus)
+static inline void smp_cpus_done(unsigned int maxcpus)
 {
 }
 
