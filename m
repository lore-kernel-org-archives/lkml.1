Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZFIGuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZFIGuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZFIGum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:50:42 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:46584 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbZFIGul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:50:41 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 03/27] score: create head files asmmacro.h atomic.h auxvec.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF84086610.39FD58B5-ON482575D0.00231C8C-482575D0.00238F4B@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:24:07 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:24:07,
	Serialize complete at 2009/06/09 ?? 02:24:07
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 026fac90a1eabb39797acb5727b68da78c076c2b Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:05 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/asmmacro.h |  161 
+++++++++++++++++++++++++++++++++++++
 arch/score/include/asm/atomic.h   |    6 ++
 arch/score/include/asm/auxvec.h   |    4 +
 3 files changed, 171 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/asmmacro.h
 create mode 100644 arch/score/include/asm/atomic.h
 create mode 100644 arch/score/include/asm/auxvec.h

diff --git a/arch/score/include/asm/asmmacro.h 
b/arch/score/include/asm/asmmacro.h
new file mode 100644
index 0000000..a04a54c
--- /dev/null
+++ b/arch/score/include/asm/asmmacro.h
@@ -0,0 +1,161 @@
+#ifndef _ASM_SCORE_ASMMACRO_H
+#define _ASM_SCORE_ASMMACRO_H
+
+#include <asm/asm-offsets.h>
+
+#ifdef __ASSEMBLY__
+
+.macro SAVE_ALL
+       mfcr    r30, cr0
+       mv      r31, r0
+       nop
+       /* if UMs == 1, change stack. */
+       slli.c  r30, r30, 28
+       bpl     1f
+       la      r31, kernelsp
+       lw      r31, [r31]
+1:
+       mv      r30, r0
+       addri   r0, r31, -PT_SIZE
+
+       sw      r30, [r0, PT_R0]
+       .set    r1
+       sw      r1, [r0, PT_R1]
+       .set    nor1
+       sw      r2, [r0, PT_R2]
+       sw      r3, [r0, PT_R3]
+       sw      r4, [r0, PT_R4]
+       sw      r5, [r0, PT_R5]
+       sw      r6, [r0, PT_R6]
+       sw      r7, [r0, PT_R7]
+
+       sw      r8, [r0, PT_R8]
+       sw      r9, [r0, PT_R9]
+       sw      r10, [r0, PT_R10]
+       sw      r11, [r0, PT_R11]
+       sw      r12, [r0, PT_R12]
+       sw      r13, [r0, PT_R13]
+       sw      r14, [r0, PT_R14]
+       sw      r15, [r0, PT_R15]
+
+       sw      r16, [r0, PT_R16]
+       sw      r17, [r0, PT_R17]
+       sw      r18, [r0, PT_R18]
+       sw      r19, [r0, PT_R19]
+       sw      r20, [r0, PT_R20]
+       sw      r21, [r0, PT_R21]
+       sw      r22, [r0, PT_R22]
+       sw      r23, [r0, PT_R23]
+
+       sw      r24, [r0, PT_R24]
+       sw      r25, [r0, PT_R25]
+       sw      r25, [r0, PT_R25]
+       sw      r26, [r0, PT_R26]
+       sw      r27, [r0, PT_R27]
+
+       sw      r28, [r0, PT_R28]
+       sw      r29, [r0, PT_R29]
+       orri    r28, r0, 0x1fff
+       li      r31, 0x00001fff
+       xor     r28, r28, r31
+
+       mfcehl  r30, r31
+       sw      r30, [r0, PT_CEH]
+       sw      r31, [r0, PT_CEL]
+
+       mfcr    r31, cr0
+       sw      r31, [r0, PT_PSR]
+
+       mfcr    r31, cr1
+       sw      r31, [r0, PT_CONDITION]
+
+       mfcr    r31, cr2
+       sw      r31, [r0, PT_ECR]
+ 
+       mfcr    r31, cr5
+       srli    r31, r31, 1
+       slli    r31, r31, 1
+       sw      r31, [r0, PT_EPC]
+.endm
+
+.macro RESTORE_ALL_AND_RET
+       mfcr    r30, cr0
+       srli    r30, r30, 1
+       slli    r30, r30, 1
+       mtcr    r30, cr0
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       .set    r1
+       ldis    r1, 0x00ff
+       and     r30, r30, r1
+       not     r1, r1
+       lw      r31, [r0, PT_PSR]
+       and     r31, r31, r1
+       .set    nor1
+       or      r31, r31, r30
+       mtcr    r31, cr0
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       lw      r30, [r0, PT_CONDITION]
+       mtcr    r30, cr1
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       lw      r30, [r0, PT_CEH]
+       lw      r31, [r0, PT_CEL]
+       mtcehl  r30, r31
+
+       .set    r1
+       lw      r1, [r0, PT_R1]
+       .set    nor1
+       lw      r2, [r0, PT_R2]
+       lw      r3, [r0, PT_R3]
+       lw      r4, [r0, PT_R4]
+       lw      r5, [r0, PT_R5]
+       lw      r6, [r0, PT_R6]
+       lw      r7, [r0, PT_R7]
+
+       lw      r8, [r0, PT_R8]
+       lw      r9, [r0, PT_R9]
+       lw      r10, [r0, PT_R10]
+       lw      r11, [r0, PT_R11]
+       lw      r12, [r0, PT_R12]
+       lw      r13, [r0, PT_R13]
+       lw      r14, [r0, PT_R14]
+       lw      r15, [r0, PT_R15]
+
+       lw      r16, [r0, PT_R16]
+       lw      r17, [r0, PT_R17]
+       lw      r18, [r0, PT_R18]
+       lw      r19, [r0, PT_R19]
+       lw      r20, [r0, PT_R20]
+       lw      r21, [r0, PT_R21]
+       lw      r22, [r0, PT_R22]
+       lw      r23, [r0, PT_R23]
+
+       lw      r24, [r0, PT_R24]
+       lw      r25, [r0, PT_R25]
+       lw      r26, [r0, PT_R26]
+       lw      r27, [r0, PT_R27]
+       lw      r28, [r0, PT_R28]
+       lw      r29, [r0, PT_R29]
+
+       lw      r30, [r0, PT_EPC]
+       lw      r0, [r0, PT_R0]
+       mtcr    r30, cr5
+       rte
+.endm
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_SCORE_ASMMACRO_H */
diff --git a/arch/score/include/asm/atomic.h 
b/arch/score/include/asm/atomic.h
new file mode 100644
index 0000000..84eb8dd
--- /dev/null
+++ b/arch/score/include/asm/atomic.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_ATOMIC_H
+#define _ASM_SCORE_ATOMIC_H
+
+#include <asm-generic/atomic.h>
+
+#endif /* _ASM_SCORE_ATOMIC_H */
diff --git a/arch/score/include/asm/auxvec.h 
b/arch/score/include/asm/auxvec.h
new file mode 100644
index 0000000..f691515
--- /dev/null
+++ b/arch/score/include/asm/auxvec.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_AUXVEC_H
+#define _ASM_SCORE_AUXVEC_H
+
+#endif /* _ASM_SCORE_AUXVEC_H */
-- 
1.6.2

