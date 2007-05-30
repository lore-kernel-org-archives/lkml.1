Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbXE3VA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbXE3VA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXE3VAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:00:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57157 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754931AbXE3VAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:00:19 -0400
Date: Wed, 30 May 2007 17:00:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Roland McGrath <roland@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make Alt-SysRq-p display the debug register contents
In-Reply-To: <20070530203849.9C1FD1F8512@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0705301655230.2614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as921) adds code to the show_regs() routine in i386 and
x86_64 to print the contents of the debug registers along with all the
others.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roland McGrath <roland@redhat.com>

---

Index: usb-2.6/arch/i386/kernel/process.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/process.c
+++ usb-2.6/arch/i386/kernel/process.c
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
 
Index: usb-2.6/arch/x86_64/kernel/process.c
===================================================================
--- usb-2.6.orig/arch/x86_64/kernel/process.c
+++ usb-2.6/arch/x86_64/kernel/process.c
@@ -305,6 +305,7 @@ early_param("idle", idle_setup);
 void __show_regs(struct pt_regs * regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
+	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned int fsindex,gsindex;
 	unsigned int ds,cs,es; 
 
@@ -349,6 +350,15 @@ void __show_regs(struct pt_regs * regs)
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

