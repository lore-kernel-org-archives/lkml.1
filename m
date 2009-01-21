Return-Path: <linux-kernel-owner+w=401wt.eu-S1763902AbZAUPG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763902AbZAUPG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbZAUPGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:06:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:57426 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbZAUPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:06:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RULM+MIqhL7I3cIFt8HMq4p1r7OviSa2OTmd5zblNzyw/U4bkeewPmevIpwu5TnR/o
         WDtPpe+7VxKB122rJ9iHhPvtXL1iU49mcitCMI6TqoZZf7eqq4o2nCLvDSgug5L7nQmm
         Updq2e1BW9sflhC+l5Gxlz4hEOa8GTsDWM9Ag=
Message-ID: <497739E6.4010806@gmail.com>
Date: Wed, 21 Jan 2009 16:06:14 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, um: fix ELF_CORE_COPY_REGS macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When this macros isn't called with regs, e.g. with foo
this will incorectly expand to foo->foo.gp[*]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/um/sys-x86_64/asm/elf.h b/arch/um/sys-x86_64/asm/elf.h
index 6e8a919..04b9e87 100644
--- a/arch/um/sys-x86_64/asm/elf.h
+++ b/arch/um/sys-x86_64/asm/elf.h
@@ -66,28 +66,28 @@ typedef struct user_i387_struct elf_fpregset_t;
 	PT_REGS_R15(regs) = 0; \
 } while (0)
 
-#define ELF_CORE_COPY_REGS(pr_reg, regs)		\
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
+#define ELF_CORE_COPY_REGS(pr_reg, _regs)		\
+	(pr_reg)[0] = (_regs)->regs.gp[0];			\
+	(pr_reg)[1] = (_regs)->regs.gp[1];			\
+	(pr_reg)[2] = (_regs)->regs.gp[2];			\
+	(pr_reg)[3] = (_regs)->regs.gp[3];			\
+	(pr_reg)[4] = (_regs)->regs.gp[4];			\
+	(pr_reg)[5] = (_regs)->regs.gp[5];			\
+	(pr_reg)[6] = (_regs)->regs.gp[6];			\
+	(pr_reg)[7] = (_regs)->regs.gp[7];			\
+	(pr_reg)[8] = (_regs)->regs.gp[8];			\
+	(pr_reg)[9] = (_regs)->regs.gp[9];			\
+	(pr_reg)[10] = (_regs)->regs.gp[10];			\
+	(pr_reg)[11] = (_regs)->regs.gp[11];			\
+	(pr_reg)[12] = (_regs)->regs.gp[12];			\
+	(pr_reg)[13] = (_regs)->regs.gp[13];			\
+	(pr_reg)[14] = (_regs)->regs.gp[14];			\
+	(pr_reg)[15] = (_regs)->regs.gp[15];			\
+	(pr_reg)[16] = (_regs)->regs.gp[16];			\
+	(pr_reg)[17] = (_regs)->regs.gp[17];			\
+	(pr_reg)[18] = (_regs)->regs.gp[18];			\
+	(pr_reg)[19] = (_regs)->regs.gp[19];			\
+	(pr_reg)[20] = (_regs)->regs.gp[20];			\
 	(pr_reg)[21] = current->thread.arch.fs;			\
 	(pr_reg)[22] = 0;					\
 	(pr_reg)[23] = 0;					\
