Return-Path: <linux-kernel-owner+w=401wt.eu-S1762982AbYA2FI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762982AbYA2FI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbYA2FGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:37 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34415 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYA2FGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:35 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/9] GBPAGES: Support gbpages in pagetable dump
Message-Id: <20080129050633.ADC831B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:33 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:17.0346 (UTC) FILETIME=[D7349220:01C86233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/fault.c
===================================================================
--- linux.orig/arch/x86/mm/fault.c
+++ linux/arch/x86/mm/fault.c
@@ -240,7 +240,8 @@ void dump_pagetable(unsigned long addres
 	pud = pud_offset(pgd, address);
 	if (bad_address(pud)) goto bad;
 	printk("PUD %lx ", pud_val(*pud));
-	if (!pud_present(*pud))	goto ret;
+	if (!pud_present(*pud) || pud_large(*pud))
+		goto ret;
 
 	pmd = pmd_offset(pud, address);
 	if (bad_address(pmd)) goto bad;
