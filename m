Return-Path: <linux-kernel-owner+w=401wt.eu-S965196AbXIJP43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196AbXIJP43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXIJP4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:56:22 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44506 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbXIJP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:56:21 -0400
Date: Mon, 10 Sep 2007 11:55:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] UML - Fix ELF_CORE_COPY_REGS build botch
Message-ID: <20070910155546.GA14107@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This needs to go into 2.6.23 ]

The earlier crash dump fix on x86_64 depended on patches in -mm which
are intended for post-2.6.23.  Without those, it broke the build when
it went into 2.6.23-rc5.

This patch changes the field references in ELF_CORE_COPY_REGS back to
those still used in mainline.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/elf-x86_64.h |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

Index: linux-2.6.17/include/asm-um/elf-x86_64.h
===================================================================
--- linux-2.6.17.orig/include/asm-um/elf-x86_64.h	2007-09-04 18:22:48.000000000 -0400
+++ linux-2.6.17/include/asm-um/elf-x86_64.h	2007-09-10 11:48:25.000000000 -0400
@@ -67,27 +67,27 @@ typedef struct { } elf_fpregset_t;
 } while (0)
 
 #define ELF_CORE_COPY_REGS(pr_reg, regs)		\
-	(pr_reg)[0] = (regs)->regs.gp[0];			\
-	(pr_reg)[1] = (regs)->regs.gp[1];			\
-	(pr_reg)[2] = (regs)->regs.gp[2];			\
-	(pr_reg)[3] = (regs)->regs.gp[3];			\
-	(pr_reg)[4] = (regs)->regs.gp[4];			\
-	(pr_reg)[5] = (regs)->regs.gp[5];			\
-	(pr_reg)[6] = (regs)->regs.gp[6];			\
-	(pr_reg)[7] = (regs)->regs.gp[7];			\
-	(pr_reg)[8] = (regs)->regs.gp[8];			\
-	(pr_reg)[9] = (regs)->regs.gp[9];			\
-	(pr_reg)[10] = (regs)->regs.gp[10];			\
-	(pr_reg)[11] = (regs)->regs.gp[11];			\
-	(pr_reg)[12] = (regs)->regs.gp[12];			\
-	(pr_reg)[13] = (regs)->regs.gp[13];			\
-	(pr_reg)[14] = (regs)->regs.gp[14];			\
-	(pr_reg)[15] = (regs)->regs.gp[15];			\
-	(pr_reg)[16] = (regs)->regs.gp[16];			\
-	(pr_reg)[17] = (regs)->regs.gp[17];			\
-	(pr_reg)[18] = (regs)->regs.gp[18];			\
-	(pr_reg)[19] = (regs)->regs.gp[19];			\
-	(pr_reg)[20] = (regs)->regs.gp[20];			\
+	(pr_reg)[0] = (regs)->regs.skas.regs[0];			\
+	(pr_reg)[1] = (regs)->regs.skas.regs[1];			\
+	(pr_reg)[2] = (regs)->regs.skas.regs[2];			\
+	(pr_reg)[3] = (regs)->regs.skas.regs[3];			\
+	(pr_reg)[4] = (regs)->regs.skas.regs[4];			\
+	(pr_reg)[5] = (regs)->regs.skas.regs[5];			\
+	(pr_reg)[6] = (regs)->regs.skas.regs[6];			\
+	(pr_reg)[7] = (regs)->regs.skas.regs[7];			\
+	(pr_reg)[8] = (regs)->regs.skas.regs[8];			\
+	(pr_reg)[9] = (regs)->regs.skas.regs[9];			\
+	(pr_reg)[10] = (regs)->regs.skas.regs[10];			\
+	(pr_reg)[11] = (regs)->regs.skas.regs[11];			\
+	(pr_reg)[12] = (regs)->regs.skas.regs[12];			\
+	(pr_reg)[13] = (regs)->regs.skas.regs[13];			\
+	(pr_reg)[14] = (regs)->regs.skas.regs[14];			\
+	(pr_reg)[15] = (regs)->regs.skas.regs[15];			\
+	(pr_reg)[16] = (regs)->regs.skas.regs[16];			\
+	(pr_reg)[17] = (regs)->regs.skas.regs[17];			\
+	(pr_reg)[18] = (regs)->regs.skas.regs[18];			\
+	(pr_reg)[19] = (regs)->regs.skas.regs[19];			\
+	(pr_reg)[20] = (regs)->regs.skas.regs[20];			\
 	(pr_reg)[21] = current->thread.arch.fs;			\
 	(pr_reg)[22] = 0;					\
 	(pr_reg)[23] = 0;					\
