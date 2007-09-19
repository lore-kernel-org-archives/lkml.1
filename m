Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXISBca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXISBca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXISBcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:32:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49034 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXISBcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:32:17 -0400
Date: Tue, 18 Sep 2007 21:31:24 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - refix ELF_CORE_COPY_REGS
Message-ID: <20070919013124.GA10827@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The former uml-fix-x86_64-core-dump-crash.patch expressed
ELF_CORE_COPY_REGS in terms of the pt_regs struct currently in -mm.  I
fast-tracked this to mainline, where it was wrong because the pt_regs
struct there hadn't been changed.  Fixing that then made the patch
wrong for -mm when it was rebased on -rc6.

This patch changes things back again to be right for -mm.  This should
go to mainline after uml-rename-pt_regs-general-purpose-register-file.patch

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 include/asm-um/elf-x86_64.h |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

Index: linux-2.6.20/include/asm-um/elf-x86_64.h
===================================================================
--- linux-2.6.20.orig/include/asm-um/elf-x86_64.h	2007-09-18 13:28:30.000000000 -0400
+++ linux-2.6.20/include/asm-um/elf-x86_64.h	2007-09-18 20:50:47.000000000 -0400
@@ -68,27 +68,27 @@ typedef struct user_i387_struct elf_fpre
 } while (0)
 
 #define ELF_CORE_COPY_REGS(pr_reg, regs)		\
-	(pr_reg)[0] = (regs)->regs.skas.regs[0];			\
-	(pr_reg)[1] = (regs)->regs.skas.regs[1];			\
-	(pr_reg)[2] = (regs)->regs.skas.regs[2];			\
-	(pr_reg)[3] = (regs)->regs.skas.regs[3];			\
-	(pr_reg)[4] = (regs)->regs.skas.regs[4];			\
-	(pr_reg)[5] = (regs)->regs.skas.regs[5];			\
-	(pr_reg)[6] = (regs)->regs.skas.regs[6];			\
-	(pr_reg)[7] = (regs)->regs.skas.regs[7];			\
-	(pr_reg)[8] = (regs)->regs.skas.regs[8];			\
-	(pr_reg)[9] = (regs)->regs.skas.regs[9];			\
-	(pr_reg)[10] = (regs)->regs.skas.regs[10];			\
-	(pr_reg)[11] = (regs)->regs.skas.regs[11];			\
-	(pr_reg)[12] = (regs)->regs.skas.regs[12];			\
-	(pr_reg)[13] = (regs)->regs.skas.regs[13];			\
-	(pr_reg)[14] = (regs)->regs.skas.regs[14];			\
-	(pr_reg)[15] = (regs)->regs.skas.regs[15];			\
-	(pr_reg)[16] = (regs)->regs.skas.regs[16];			\
-	(pr_reg)[17] = (regs)->regs.skas.regs[17];			\
-	(pr_reg)[18] = (regs)->regs.skas.regs[18];			\
-	(pr_reg)[19] = (regs)->regs.skas.regs[19];			\
-	(pr_reg)[20] = (regs)->regs.skas.regs[20];			\
+	(pr_reg)[0] = (regs)->regs.gp[0];			\
+	(pr_reg)[1] = (regs)->regs.gp[1];			\
+	(pr_reg)[2] = (regs)->regs.gp[2];			\
+	(pr_reg)[3] = (regs)->regs.gp[3];			\
+	(pr_reg)[4] = (regs)->regs.gp[4];			\
+	(pr_reg)[5] = (regs)->regs.gp[5];			\
+	(pr_reg)[6] = (regs)->regs.gp[6];			\
+	(pr_reg)[7] = (regs)->regs.gp[7];			\
+	(pr_reg)[8] = (regs)->regs.gp[8];			\
+	(pr_reg)[9] = (regs)->regs.gp[9];			\
+	(pr_reg)[10] = (regs)->regs.gp[10];			\
+	(pr_reg)[11] = (regs)->regs.gp[11];			\
+	(pr_reg)[12] = (regs)->regs.gp[12];			\
+	(pr_reg)[13] = (regs)->regs.gp[13];			\
+	(pr_reg)[14] = (regs)->regs.gp[14];			\
+	(pr_reg)[15] = (regs)->regs.gp[15];			\
+	(pr_reg)[16] = (regs)->regs.gp[16];			\
+	(pr_reg)[17] = (regs)->regs.gp[17];			\
+	(pr_reg)[18] = (regs)->regs.gp[18];			\
+	(pr_reg)[19] = (regs)->regs.gp[19];			\
+	(pr_reg)[20] = (regs)->regs.gp[20];			\
 	(pr_reg)[21] = current->thread.arch.fs;			\
 	(pr_reg)[22] = 0;					\
 	(pr_reg)[23] = 0;					\
