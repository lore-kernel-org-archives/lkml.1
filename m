Return-Path: <linux-kernel-owner+w=401wt.eu-S1764782AbXGLMIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764782AbXGLMIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbXGLMIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:08:30 -0400
Received: from rex.snapgear.com ([203.143.235.140]:38176 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764480AbXGLMI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:08:28 -0400
Date: Thu, 12 Jul 2007 22:07:50 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707121207.l6CC7owp026556@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: start dump from exception stack
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
 
