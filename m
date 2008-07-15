Return-Path: <linux-kernel-owner+w=401wt.eu-S1761997AbYGOQ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbYGOQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbYGOQ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:57:36 -0400
Received: from smtp.movial.fi ([62.236.91.34]:53426 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758610AbYGOQ5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:57:34 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [MIPS] fix missing prototypes in asm/fpu.h
Date: Tue, 15 Jul 2008 19:57:31 +0300
Message-Id: <1216141052-28005-3-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1216141052-28005-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1216141052-28005-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While building the Malta defconfig, sparse spat the following
warnings:

>>>>>>>>>>>>>>>>>>
arch/mips/math-emu/kernel_linkage.c:31:6: warning: symbol
'fpu_emulator_init_fpu' was not declared. Should it be static?

arch/mips/math-emu/kernel_linkage.c:54:5: warning: symbol
'fpu_emulator_save_context' was not declared. Should it be
static?

arch/mips/math-emu/kernel_linkage.c:68:5: warning: symbol
'fpu_emulator_restore_context' was not declared. Should it be
static?
>>>>>>>>>>>>>>>>>>

This patch fixes these errors by adding the proper prototypes
to the include/asm-mips/fpu.h header, and actually using this
header in the sparse-spotted source file.

Build-tested with Malta defconfig.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 arch/mips/math-emu/kernel_linkage.c |    1 +
 include/asm-mips/fpu.h              |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/mips/math-emu/kernel_linkage.c b/arch/mips/math-emu/kernel_linkage.c
index ed49ef0..52e6c58 100644
--- a/arch/mips/math-emu/kernel_linkage.c
+++ b/arch/mips/math-emu/kernel_linkage.c
@@ -24,6 +24,7 @@
 #include <asm/signal.h>
 #include <asm/uaccess.h>
 
+#include <asm/fpu.h>
 #include <asm/fpu_emulator.h>
 
 #define SIGNALLING_NAN 0x7ff800007ff80000LL
diff --git a/include/asm-mips/fpu.h b/include/asm-mips/fpu.h
index e59d4c0..8a3ef24 100644
--- a/include/asm-mips/fpu.h
+++ b/include/asm-mips/fpu.h
@@ -35,6 +35,8 @@ extern asmlinkage int (*save_fp_context32)(struct sigcontext32 __user *sc);
 extern asmlinkage int (*restore_fp_context32)(struct sigcontext32 __user *sc);
 
 extern void fpu_emulator_init_fpu(void);
+extern int fpu_emulator_save_context(struct sigcontext __user *sc);
+extern int fpu_emulator_restore_context(struct sigcontext __user *sc);
 extern void _init_fpu(void);
 extern void _save_fp(struct task_struct *);
 extern void _restore_fp(struct task_struct *);
-- 
1.5.6

