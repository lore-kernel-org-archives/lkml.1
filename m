Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbXGLMJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbXGLMJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbXGLMIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:08:43 -0400
Received: from rex.snapgear.com ([203.143.235.140]:38179 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761845AbXGLMIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:08:41 -0400
Date: Thu, 12 Jul 2007 22:07:50 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707121207.l6CC7oRg026554@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use TRHEAD_SIZE instead of hard constant
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use THREAD_SIZE instead of a hard constant.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/kernel/process.c linux-2.6.22-uc0/arch/m68knommu/kernel/process.c
--- linux-2.6.22/arch/m68knommu/kernel/process.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/kernel/process.c	2007-07-12 15:27:00.000000000 +1000
@@ -377,7 +377,7 @@
 	fp = ((struct switch_stack *)p->thread.ksp)->a6;
 	do {
 		if (fp < stack_page+sizeof(struct thread_info) ||
-		    fp >= 8184+stack_page)
+		    fp >= THREAD_SIZE-8+stack_page)
 			return 0;
 		pc = ((unsigned long *)fp)[1];
 		if (!in_sched_functions(pc))
