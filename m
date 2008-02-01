Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYBAJys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYBAJys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbYBAJxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:22 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:29292 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbYBAJxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:20 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/12] GBPAGES: Support gbpages in pagetable dump
Message-Id: <20080201095318.41BD41B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:18 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:47:00.0796 (UTC) FILETIME=[647FF7C0:01C864B7]
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
