Return-Path: <linux-kernel-owner+w=401wt.eu-S937489AbXGRXjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937489AbXGRXjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936871AbXGRXbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:31:34 -0400
Received: from rex.snapgear.com ([203.143.235.140]:35241 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936859AbXGRXbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:31:33 -0400
Date: Thu, 19 Jul 2007 09:30:14 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707182330.l6INUEeW014893@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH][RESEND] m68knommu: start dump from exception stack
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In die_if_kernel() start the stack dump at the exception-time SP, not
at the SP with all the saved registers; the stack below exception-time
sp contains only exception-saved values and is already printed in
details just before.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/kernel/traps.c linux-2.6.22-uc0/arch/m68knommu/kernel/traps.c
--- linux-2.6.22/arch/m68knommu/kernel/traps.c	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/kernel/traps.c	2007-07-12 15:27:00.000000000 +1000
@@ -82,7 +80,7 @@
 
 	printk(KERN_EMERG "Process %s (pid: %d, stackpage=%08lx)\n",
 		current->comm, current->pid, PAGE_SIZE+(unsigned long)current);
-	show_stack(NULL, (unsigned long *)fp);
+	show_stack(NULL, (unsigned long *)(fp+1));
 	do_exit(SIGSEGV);
 }
 
