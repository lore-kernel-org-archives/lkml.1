Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbYH2Lua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbYH2Lua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYH2LuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:50:19 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13879 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYH2LuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:50:18 -0400
Message-Id: <48B7FEE4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:51:32 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: pgd_{c,d}tor() cleanup
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giving pgd_ctor() a properly typed parameter allows eliminating a local
variable. Adjust pgd_dtor() to match.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>

---
 arch/x86/mm/pgtable.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.27-rc5/arch/x86/mm/pgtable.c	2008-08-21 14:37:29.000000000 +0200
+++ 2.6.27-rc5-x86-pgd-alloc-cleanup/arch/x86/mm/pgtable.c	2008-08-19 11:57:23.000000000 +0200
@@ -63,10 +63,8 @@ static inline void pgd_list_del(pgd_t *p
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
-static void pgd_ctor(void *p)
+static void pgd_ctor(pgd_t *pgd)
 {
-	pgd_t *pgd = p;
-
 	/* If the pgd points to a shared pagetable level (either the
 	   ptes in non-PAE, or shared PMD in PAE), then just copy the
 	   references from swapper_pg_dir. */
@@ -87,7 +85,7 @@ static void pgd_ctor(void *p)
 		pgd_list_add(pgd);
 }
 
-static void pgd_dtor(void *pgd)
+static void pgd_dtor(pgd_t *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 



