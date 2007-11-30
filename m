Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXLFMrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXLFMrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXLFMmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:51 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53719 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbXLFMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:33 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <cb81ed923681890aabe3b913760b57700470dbef.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 14:14:54 +0100
Subject: [PATCH 17/47] Add handling of PTRACE_DETATCH for CRISv32.
 Whitespace and formatting changes to avoid checkpatch errors.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/ptrace.c |   13 +++++++++----
 arch/cris/arch-v32/mm/Makefile     |    3 ++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index 2df6052..87014db 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000-2003, Axis Communications AB.
+ * Copyright (C) 2000-2007, Axis Communications AB.
  */
 
 #include <linux/kernel.h>
@@ -149,7 +149,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			ret = generic_ptrace_pokedata(child, addr, data);
 			break;
 
- 		/* Write the word at location address in the USER area. */
+		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
 			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
@@ -201,7 +201,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 			break;
 
- 		/* Make the child exit by sending it a sigkill. */
+		/* Make the child exit by sending it a sigkill. */
 		case PTRACE_KILL:
 			ret = 0;
 
@@ -245,9 +245,13 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 
 		}
+		case PTRACE_DETACH:
+			ret = ptrace_detach(child, data);
+			break;
+
 		/* Get all GP registers from the child. */
 		case PTRACE_GETREGS: {
-		  	int i;
+			int i;
 			unsigned long tmp;
 
 			for (i = 0; i <= PT_MAX; i++) {
@@ -294,6 +298,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 	}
 
+out_tsk:
 	return ret;
 }
 
diff --git a/arch/cris/arch-v32/mm/Makefile b/arch/cris/arch-v32/mm/Makefile
index 9146f88..0b801f2 100644
--- a/arch/cris/arch-v32/mm/Makefile
+++ b/arch/cris/arch-v32/mm/Makefile
@@ -1,3 +1,4 @@
 # Makefile for the Linux/cris parts of the memory manager.
 
-obj-y	 := mmu.o init.o tlb.o intmem.o
+obj-y	 += mmu.o init.o tlb.o intmem.o
+obj-$(CONFIG_ETRAX_L2CACHE)    += l2cache.o
-- 
1.5.3.6.970.gd25430

