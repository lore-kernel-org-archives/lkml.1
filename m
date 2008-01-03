Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbYACR2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbYACR2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYACR1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:27:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:54717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbYACR1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:27:02 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103626.635376000@suse.de>
In-Reply-To: <20080103626.635376000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [5/8] GBPAGES: Support gbpages in pagetable dump
Message-Id: <20080103172701.F1E4F14DDD@wotan.suse.de>
Date: Thu,  3 Jan 2008 18:27:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/fault_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/mm/fault_64.c
===================================================================
--- linux.orig/arch/x86/mm/fault_64.c
+++ linux/arch/x86/mm/fault_64.c
@@ -288,7 +288,7 @@ void dump_pagetable(unsigned long addres
 	pud = pud_offset(pgd, address);
 	if (bad_address(pud)) goto bad;
 	printk("PUD %lx ", pud_val(*pud));
-	if (!pud_present(*pud))	goto ret;
+	if (!pud_present(*pud) || pud_large(*pud)) goto ret;
 
 	pmd = pmd_offset(pud, address);
 	if (bad_address(pmd)) goto bad;
