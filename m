Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbXFALLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbXFALLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXFALLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:11:24 -0400
Received: from rex.snapgear.com ([203.143.235.140]:48557 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753128AbXFALLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:11:24 -0400
Date: Fri, 1 Jun 2007 21:10:15 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200706011110.l51BAFe7023558@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: use TRHEAD_SIZE instead of hard constant
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use THREAD_SIZE instead of a hard constant.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---



diff -Naur linux-2.6.21/arch/m68knommu/kernel/process.c linux-2.6.21-uc0/arch/m68knommu/kernel/process.c
--- linux-2.6.21/arch/m68knommu/kernel/process.c	2007-05-01 17:12:41.000000000 +1000
+++ linux-2.6.21-uc0/arch/m68knommu/kernel/process.c	2007-05-01 17:16:11.000000000 +1000
@@ -377,7 +377,7 @@
 	fp = ((struct switch_stack *)p->thread.ksp)->a6;
 	do {
 		if (fp < stack_page+sizeof(struct thread_info) ||
-		    fp >= 8184+stack_page)
+		    fp >= THREAD_SIZE-8+stack_page)
 			return 0;
 		pc = ((unsigned long *)fp)[1];
 		if (!in_sched_functions(pc))
