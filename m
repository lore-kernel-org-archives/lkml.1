Return-Path: <linux-kernel-owner+w=401wt.eu-S1762702AbYA2FJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762702AbYA2FJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYA2FGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:38 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34415 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbYA2FGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:37 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/9] GBPAGES: Add gbpages support to lookup_address
Message-Id: <20080129050634.B1B811B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:34 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:18.0409 (UTC) FILETIME=[D7D6C590:01C86233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c    |    5 +++++
 include/asm-x86/pgtable.h |    1 +
 2 files changed, 6 insertions(+)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -152,9 +152,14 @@ pte_t *lookup_address(unsigned long addr
 
 	if (pgd_none(*pgd))
 		return NULL;
+
+	*level = PG_LEVEL_1G;
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud))
 		return NULL;
+	if (pud_large(*pud))
+		return (pte_t *)pud;
+
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		return NULL;
Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -242,6 +242,7 @@ enum {
 	PG_LEVEL_NONE,
 	PG_LEVEL_4K,
 	PG_LEVEL_2M,
+	PG_LEVEL_1G,
 };
 
 /*
