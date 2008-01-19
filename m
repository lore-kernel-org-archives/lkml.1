Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbYASGuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbYASGuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYASGsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:48:54 -0500
Received: from mx1.suse.de ([195.135.220.2]:33233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbYASGse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:48:34 -0500
From: Andi Kleen <ak@suse.de>
References: <20080119748.170864000@suse.de>
In-Reply-To: <20080119748.170864000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/8] GBPAGES: Support gbpages in pagetable dump
Message-Id: <20080119064833.878E714EAD@wotan.suse.de>
Date: Sat, 19 Jan 2008 07:48:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/fault_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/fault_64.c
===================================================================
--- linux.orig/arch/x86/mm/fault_64.c
+++ linux/arch/x86/mm/fault_64.c
@@ -200,7 +200,8 @@ void dump_pagetable(unsigned long addres
 	pud = pud_offset(pgd, address);
 	if (bad_address(pud)) goto bad;
 	printk("PUD %lx ", pud_val(*pud));
-	if (!pud_present(*pud))	goto ret;
+	if (!pud_present(*pud) || pud_large(*pud))
+		goto ret;
 
 	pmd = pmd_offset(pud, address);
 	if (bad_address(pmd)) goto bad;
