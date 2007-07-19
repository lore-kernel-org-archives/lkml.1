Return-Path: <linux-kernel-owner+w=401wt.eu-S938424AbXGSK1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938424AbXGSK1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762127AbXGSJ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760996AbXGSJzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:52 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: stern@rowland.harvard.edu, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [54/58] x86: Make Alt-SysRq-p display the debug register contents
Message-Id: <20070719095541.5AD9414E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alan Stern <stern@rowland.harvard.edu>

This patch (as921) adds code to the show_regs() routine in i386 and x86_64
to print the contents of the debug registers along with all the others.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/process.c   |   12 ++++++++++++
 arch/x86_64/kernel/process.c |   10 ++++++++++
 2 files changed, 22 insertions(+)

Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
@@ -300,6 +300,7 @@ early_param("idle", idle_setup);
 void show_regs(struct pt_regs * regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
+	unsigned long d0, d1, d2, d3, d6, d7;
 
 	printk("\n");
 	printk("Pid: %d, comm: %20s\n", current->pid, current->comm);
@@ -324,6 +325,17 @@ void show_regs(struct pt_regs * regs)
 	cr3 = read_cr3();
 	cr4 = read_cr4_safe();
 	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n", cr0, cr2, cr3, cr4);
+
+	get_debugreg(d0, 0);
+	get_debugreg(d1, 1);
+	get_debugreg(d2, 2);
+	get_debugreg(d3, 3);
+	printk("DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
+			d0, d1, d2, d3);
+	get_debugreg(d6, 6);
+	get_debugreg(d7, 7);
+	printk("DR6: %08lx DR7: %08lx\n", d6, d7);
+
 	show_trace(NULL, regs, &regs->esp);
 }
 
Index: linux/arch/x86_64/kernel/process.c
===================================================================
--- linux.orig/arch/x86_64/kernel/process.c
+++ linux/arch/x86_64/kernel/process.c
@@ -306,6 +306,7 @@ early_param("idle", idle_setup);
 void __show_regs(struct pt_regs * regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
+	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned int fsindex,gsindex;
 	unsigned int ds,cs,es; 
 
@@ -350,6 +351,15 @@ void __show_regs(struct pt_regs * regs)
 	       fs,fsindex,gs,gsindex,shadowgs); 
 	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0); 
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
+
+	get_debugreg(d0, 0);
+	get_debugreg(d1, 1);
+	get_debugreg(d2, 2);
+	printk("DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
+	get_debugreg(d3, 3);
+	get_debugreg(d6, 6);
+	get_debugreg(d7, 7);
+	printk("DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
 }
 
 void show_regs(struct pt_regs *regs)
