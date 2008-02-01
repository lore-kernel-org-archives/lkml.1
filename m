Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbYBAJzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbYBAJzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYBAJxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:23 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:29292 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbYBAJxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:22 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/12] GBPAGES: Add gbpages support to lookup_address
Message-Id: <20080201095319.46AE71B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:19 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:47:01.0811 (UTC) FILETIME=[651AD830:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -155,6 +155,11 @@ pte_t *lookup_address(unsigned long addr
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud))
 		return NULL;
+
+	*level = PG_LEVEL_1G;
+	if (pud_large(*pud))
+		return (pte_t *)pud;
+
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		return NULL;
