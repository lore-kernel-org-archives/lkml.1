Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbXHNVnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbXHNVnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbXHNVZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:25:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38472 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758159AbXHNVZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:25:46 -0400
Date: Tue, 14 Aug 2007 23:25:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jdike@karaya.com
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] UML: "extern inline" -> "static inline"
Message-ID: <20070814212533.GT18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-um/pgalloc.h          |    2 +-
 include/asm-um/pgtable-3level.h   |    2 +-
 include/asm-um/processor-x86_64.h |    2 +-
 include/asm-um/smp.h              |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

536a148260f539edfbd81819a087dab0ea773350 
diff --git a/include/asm-um/pgalloc.h b/include/asm-um/pgalloc.h
index 34ab268..1490487 100644
--- a/include/asm-um/pgalloc.h
+++ b/include/asm-um/pgalloc.h
@@ -42,7 +42,7 @@ static inline void pte_free(struct page *pte)
 
 #ifdef CONFIG_3_LEVEL_PGTABLES
 
-extern __inline__ void pmd_free(pmd_t *pmd)
+static inline void pmd_free(pmd_t *pmd)
 {
 	free_page((unsigned long)pmd);
 }
diff --git a/include/asm-um/pgtable-3level.h b/include/asm-um/pgtable-3level.h
index ca0c2a9..aa82b88 100644
--- a/include/asm-um/pgtable-3level.h
+++ b/include/asm-um/pgtable-3level.h
@@ -69,7 +69,7 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
         return pmd;
 }
 
-extern inline void pud_clear (pud_t *pud)
+static inline void pud_clear (pud_t *pud)
 {
         set_pud(pud, __pud(0));
 }
diff --git a/include/asm-um/processor-x86_64.h b/include/asm-um/processor-x86_64.h
index 31c2d4d..d946bf2 100644
--- a/include/asm-um/processor-x86_64.h
+++ b/include/asm-um/processor-x86_64.h
@@ -18,7 +18,7 @@ struct arch_thread {
 };
 
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
-extern inline void rep_nop(void)
+static inline void rep_nop(void)
 {
 	__asm__ __volatile__("rep;nop": : :"memory");
 }
diff --git a/include/asm-um/smp.h b/include/asm-um/smp.h
index 84f8cf2..f27a963 100644
--- a/include/asm-um/smp.h
+++ b/include/asm-um/smp.h
@@ -18,7 +18,7 @@ extern int hard_smp_processor_id(void);
 extern int ncpus;
 
 
-extern inline void smp_cpus_done(unsigned int maxcpus)
+static inline void smp_cpus_done(unsigned int maxcpus)
 {
 }
 

