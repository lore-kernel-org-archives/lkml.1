Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbXGSNtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbXGSNtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760376AbXGSNsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:54500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbXGSNsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:30 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: bunk@stusta.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [1/48] i386: pgd_{c,d}tor() static
Message-Id: <20070719134829.A2EC214E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

pgd_{c,d}tor() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/mm/pgtable.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/i386/mm/pgtable.c
===================================================================
--- linux.orig/arch/i386/mm/pgtable.c
+++ linux/arch/i386/mm/pgtable.c
@@ -235,7 +235,7 @@ static inline void pgd_list_del(pgd_t *p
 
 #if (PTRS_PER_PMD == 1)
 /* Non-PAE pgd constructor */
-void pgd_ctor(void *pgd)
+static void pgd_ctor(void *pgd)
 {
 	unsigned long flags;
 
@@ -257,7 +257,7 @@ void pgd_ctor(void *pgd)
 }
 #else  /* PTRS_PER_PMD > 1 */
 /* PAE pgd constructor */
-void pgd_ctor(void *pgd)
+static void pgd_ctor(void *pgd)
 {
 	/* PAE, kernel PMD may be shared */
 
@@ -276,7 +276,7 @@ void pgd_ctor(void *pgd)
 }
 #endif	/* PTRS_PER_PMD */
 
-void pgd_dtor(void *pgd)
+static void pgd_dtor(void *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
