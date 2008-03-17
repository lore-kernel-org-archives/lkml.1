Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYCRF1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYCRF1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYCRFYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:17 -0400
Received: from gw.goop.org ([64.81.55.164]:37850 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYCRFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 31] x86: put paravirt stubs into common asm/pgalloc.h
X-Mercurial-Node: ec229a03cb8bafefd0ac5d779da45e3bba01b87f
Message-Id: <ec229a03cb8bafefd0ac.1205797016@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:36:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pageattr.c       |    2 --
 include/asm-x86/pgalloc.h    |   10 ++++++++++
 include/asm-x86/pgalloc_32.h |   10 ----------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -479,9 +479,7 @@
 		goto out_unlock;
 
 	pbase = (pte_t *)page_address(base);
-#ifdef CONFIG_X86_32
 	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
-#endif
 	ref_prot = pte_pgprot(pte_clrhuge(*kpte));
 
 #ifdef CONFIG_X86_64
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -4,6 +4,16 @@
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define paravirt_alloc_pt(mm, pfn) do { } while (0)
+#define paravirt_alloc_pd(mm, pfn) do { } while (0)
+#define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) do { } while (0)
+#define paravirt_release_pt(pfn) do { } while (0)
+#define paravirt_release_pd(pfn) do { } while (0)
+#endif
 
 /*
  * Allocate and free page tables.
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -1,15 +1,5 @@
 #ifndef _I386_PGALLOC_H
 #define _I386_PGALLOC_H
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define paravirt_alloc_pt(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) do { } while (0)
-#define paravirt_release_pt(pfn) do { } while (0)
-#define paravirt_release_pd(pfn) do { } while (0)
-#endif
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 				       pmd_t *pmd, pte_t *pte)


