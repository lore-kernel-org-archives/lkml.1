Return-Path: <linux-kernel-owner+w=401wt.eu-S937443AbXLRBou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937443AbXLRBou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbXLRBi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:38:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbXLRBiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:38:20 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 15/21] [PATCH] remove legacy stuff from processor_64.h
Date: Mon, 17 Dec 2007 20:52:38 -0200
Message-Id: <11979320401316-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979320354186-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com> <11979320163651-git-send-email-gcosta@redhat.com> <11979320211287-git-send-email-gcosta@redhat.com> <11979320252102-git-send-email-gcosta@redhat.com> <11979320302030-git-send-email-gcosta@redhat.com> <11979320354186-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes definitions and macros that are not used anymore
from processor_64.h

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor_64.h |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -18,8 +18,6 @@
 #include <linux/personality.h>
 #include <asm/desc_defs.h>
 
-extern char ignore_irq13;
-
 extern void identify_cpu(struct cpuinfo_x86 *);
 
 /*
@@ -68,9 +66,6 @@ DECLARE_PER_CPU(struct orig_ist, orig_is
 	.x86_tss.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
 }
 
-#define INIT_MMAP \
-{ &init_mm, 0, 0, NULL, PAGE_SHARED, VM_READ | VM_WRITE | VM_EXEC, 1, NULL, NULL }
-
 #define start_thread(regs,new_rip,new_rsp) do { \
 	asm volatile("movl %0,%%fs; movl %0,%%es; movl %0,%%ds": :"r" (0));	 \
 	load_gs_index(0);							\
@@ -144,13 +139,4 @@ static inline void prefetchw(void *x) 
 			  "r" (x));
 } 
 
-
-#define stack_current() \
-({								\
-	struct thread_info *ti;					\
-	asm("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
-	ti->task;					\
-})
-
-
 #endif /* __ASM_X86_64_PROCESSOR_H */
