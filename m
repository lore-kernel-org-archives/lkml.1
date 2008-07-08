Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYGHMHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYGHMHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYGHMHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:07:21 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24546 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754842AbYGHMHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:07:17 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 55/58] microblaze_v5: entry.S
Date: Tue,  8 Jul 2008 13:59:55 +0200
Message-Id: <64353f136ffa9f5dba8854168b6ef9d3a71f5a47.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <5fbc8a35844b0f81291f7cf3ff5030baca819b67.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
 <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
 <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
 <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
 <9664f18e7e86af4332018549b29bf0797d6afcd5.1215517976.git.monstr@monstr.eu>
 <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
 <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
 <7a16429cfc461420883dbaa80c16047e5a1a91c1.1215517976.git.monstr@monstr.eu>
 <b6a0f3bceb0867c55613463fc43be5328fcedecd.1215517976.git.monstr@monstr.eu>
 <fc26823d77c7180b62022e2d4bcca3c4fe6de574.1215517976.git.monstr@monstr.eu>
 <64089967061955b7a29eb6d4e6269ff75b5442f2.1215517976.git.monstr@monstr.eu>
 <92e3ab88c2174acf4e25c474c1f68ffd4db72ca6.1215517976.git.monstr@monstr.eu>
 <5174afd0eaa5c6cb9344ea3217199e48899be313.1215517976.git.monstr@monstr.eu>
 <bcb94400dca62fb349d0ab1e0a6209291fdcdfc5.1215517976.git.monstr@monstr.eu>
 <5b2ed516b2e51d5117386c1b6eb814acc6e5a157.1215517976.git.monstr@monstr.eu>
 <421f4b613d4dbd983df1545a9a163347e5bd1c56.1215517976.git.monstr@monstr.eu>
 <0d39e8f03c487c004efa226c5ee81a81a8856768.1215517976.git.monstr@monstr.eu>
 <c4f477d71dd4cd2ae884b9c47756c9334f8dac18.1215517976.git.monstr@monstr.eu>
 <a98df8525bf9287d7a8b6077ff20dd61a055a98e.1215517976.git.monstr@monstr.eu>
 <c6651b096ee8a0691f94f8c19574302dbfb61ee4.1215517976.git.monstr@monstr.eu>
 <2ac3915482a9a50f7a4531908305b326baa2008e.1215517976.git.monstr@monstr.eu>
 <3c5eac3dbdbf538c727a4a8fe336cdd55650bb37.1215517976.git.monstr@monstr.eu>
 <6c03dcf8dbfd910ebf6c2f95db61d0456aa943e1.1215517976.git.monstr@monstr.eu>
 <1054e7643bd01351ba67273043203df322b49bea.1215517976.git.monstr@monstr.eu>
 <2bc35758e609ee5b79afe0f58be17d11a01498dc.1215517976.git.monstr@monstr.eu>
 <542a23f9748621b66e6f0ef8e0eb6248d542aa99.1215517976.git.monstr@monstr.eu>
 <5fbc8a35844b0f81291f7cf3ff5030baca819b67.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/entry.S |  597 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 597 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/entry.S

diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
new file mode 100644
index 0000000..cfabea7
--- /dev/null
+++ b/arch/microblaze/kernel/entry.S
@@ -0,0 +1,597 @@
+/*
+ * arch/microblaze/kernel/entry.S
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+#include <asm/errno.h>
+#include <asm/asm-offsets.h>
+#include <asm/registers.h>
+#include <asm/unistd.h>
+#include <asm/percpu.h>
+#include <asm/signal.h>
+
+#define PER_CPU(var) per_cpu__##var
+
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+	.macro	disable_irq
+	msrclr r0, MSR_IE
+	.endm
+
+	.macro	enable_irq
+	msrset r0, MSR_IE
+	.endm
+
+	.macro	clear_bip
+	msrclr r0, MSR_BIP
+	.endm
+#else
+	.macro	disable_irq
+	mfs r11, rmsr
+	andi r11, r11, ~MSR_IE
+	mts rmsr, r11
+	.endm
+
+	.macro	enable_irq
+	mfs r11, rmsr
+	ori r11, r11, MSR_IE
+	mts rmsr, r11
+	.endm
+
+	.macro	clear_bip
+	mfs r11, rmsr
+	andi r11, r11, ~MSR_BIP
+	mts rmsr, r11
+	.endm
+#endif
+
+ENTRY(_interrupt)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+	beqid	r11, 1f
+	nop
+	brid	2f				/* jump over */
+	addik	r1, r1, (-PT_SIZE)	/* room for pt_regs (delay slot) */
+1:						/* switch to kernel stack */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	/* calculate kernel stack pointer */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE
+2:
+	swi	r11, r1, PT_MODE		/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3
+	swi	r4, r1, PT_R4
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	swi	r14, r1, PT_R14
+	swi	r14, r1, PT_PC
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* prepare the link register, the argument and jump */
+	la	r15, r0, ret_from_intr - 8
+	addk	r6, r0, r15
+	braid	do_IRQ
+	add	r5, r0, r1
+
+ret_from_intr:
+	lwi	r11, r1, PT_MODE
+	bneid	r11, 3f
+
+	lwi	r6, r31, TS_THREAD_INFO	/* get thread info */
+	lwi	r19, r6, TI_FLAGS	/* get flags in thread info */
+				/* do an extra work if any bits are set */
+
+	andi	r11, r19, _TIF_NEED_RESCHED
+	beqi	r11, 1f
+	bralid	r15, schedule
+	nop
+1:	andi	r11, r19, _TIF_SIGPENDING
+	beqid	r11, no_intr_reshed
+	addk	r5, r1, r0
+	addk	r7, r0, r0
+	bralid	r15, do_signal
+	addk	r6, r0, r0
+
+no_intr_reshed:
+	/* save mode indicator */
+	lwi	r11, r1, PT_MODE
+3:
+	swi	r11, r0, PER_CPU(KM)
+
+	/* save r31 */
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+restore_context:
+	/* special purpose registers */
+	lwi	r11, r1, PT_FSR
+	mts	rfsr, r11
+	lwi	r11, r1, PT_ESR
+	mts	resr, r11
+	lwi	r11, r1, PT_EAR
+	mts	rear, r11
+	lwi	r11, r1, PT_MSR
+	mts	rmsr, r11
+
+	lwi	r31, r1, PT_R31
+	lwi	r30, r1, PT_R30
+	lwi	r29, r1, PT_R29
+	lwi	r28, r1, PT_R28
+	lwi	r27, r1, PT_R27
+	lwi	r26, r1, PT_R26
+	lwi	r25, r1, PT_R25
+	lwi	r24, r1, PT_R24
+	lwi	r23, r1, PT_R23
+	lwi	r22, r1, PT_R22
+	lwi	r21, r1, PT_R21
+	lwi	r20, r1, PT_R20
+	lwi	r19, r1, PT_R19
+	lwi	r18, r1, PT_R18
+	lwi	r17, r1, PT_R17
+	lwi	r16, r1, PT_R16
+	lwi	r15, r1, PT_R15
+	lwi	r14, r1, PT_PC
+	lwi	r13, r1, PT_R13
+	lwi	r12, r1, PT_R12
+	lwi	r11, r1, PT_R11
+	lwi	r10, r1, PT_R10
+	lwi	r9, r1, PT_R9
+	lwi	r8, r1, PT_R8
+	lwi	r7, r1, PT_R7
+	lwi	r6, r1, PT_R6
+	lwi	r5, r1, PT_R5
+	lwi	r4, r1, PT_R4
+	lwi	r3, r1, PT_R3
+	lwi	r2, r1, PT_R2
+	lwi	r1, r1, PT_R1
+	rtid	r14, 0
+	nop
+
+ENTRY(_reset)
+	brai	0;
+
+ENTRY(_user_exception)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+	beqid	r11, 1f				/* Already in kernel mode? */
+	nop
+	brid	2f				/* jump over */
+	addik	r1, r1, (-PT_SIZE)	/* Room for pt_regs (delay slot) */
+1:						/* Switch to kernel stack */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	/* calculate kernel stack pointer */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+2:
+	swi	r11, r1, PT_MODE		/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	/* save them on stack */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3 /* r3: _always_ in clobber list; see unistd.h */
+	swi	r4, r1, PT_R4 /* r4: _always_ in clobber list; see unistd.h */
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	/* r12: _always_ in clobber list; see unistd.h */
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	/* r14: _always_ in clobber list; see unistd.h */
+	swi	r14, r1, PT_R14
+	/* but we want to return to the next inst. */
+	addik	r14, r14, 0x4
+	swi	r14, r1, PT_PC		/* increment by 4 and store in pc */
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+
+	disable_irq
+	nop		/* make sure IE bit is in effect */
+	clear_bip	/* once IE is in effect it is safe to clear BIP */
+	nop
+
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* re-enable interrupts now we are in kernel mode */
+	enable_irq
+
+	/* See if the system call number is valid. */
+	addi	r11, r12, -NR_syscalls
+	bgei	r11, 1f			/* return to user if not valid */
+	/* Figure out which function to use for this system call. */
+	/* Note Microblaze barrel shift is optional, so don't rely on it */
+	add	r12, r12, r12			/* convert num -> ptr */
+	add	r12, r12, r12
+	lwi	r12, r12, sys_call_table	/* Get function pointer */
+	la	r15, r0, ret_to_user-8		/* set return address */
+	bra	r12				/* Make the system call. */
+	bri	0				/* won't reach here */
+1:
+	brid	ret_to_user			/* jump to syscall epilogue */
+	addi	r3, r0, -ENOSYS			/* set errno in delay slot */
+
+/*
+ * Debug traps are like a system call, but entered via brki r14, 0x60
+ * All we need to do is send the SIGTRAP signal to current, ptrace and do_signal
+ * will handle the rest
+ */
+ENTRY(_debug_exception)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE	/* get the kernel stack */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+//save_context:
+	swi	r11, r1, PT_MODE	/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	/* save them on stack */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3 /* r3: _always_ in clobber list; see unistd.h */
+	swi	r4, r1, PT_R4 /* r4: _always_ in clobber list; see unistd.h */
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	/* r12: _always_ in clobber list; see unistd.h */
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	/* r14: _always_ in clobber list; see unistd.h */
+	swi	r14, r1, PT_R14
+	swi	r14, r1, PT_PC /* Will return to interrupted instruction */
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+
+	disable_irq
+	nop		/* make sure IE bit is in effect */
+	clear_bip	/* once IE is in effect it is safe to clear BIP */
+	nop
+
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* re-enable interrupts now we are in kernel mode */
+	enable_irq
+
+	addi	r5, r0, SIGTRAP			/* sending the trap signal */
+	add	r6, r0, r31			/* to current */
+	bralid	r15, send_sig
+	add	r7, r0, r0			/* 3rd param zero */
+
+	/* Restore r3/r4 to work around how ret_to_user works */
+	lwi	r3, r1, PT_R3
+	lwi	r4, r1, PT_R4
+	bri	ret_to_user
+
+ENTRY(_break)
+	bri	0
+
+/* struct task_struct *_switch_to(struct thread_info *prev,
+					struct thread_info *next); */
+ENTRY(_switch_to)
+	/* prepare return value */
+	addk	r3, r0, r31
+
+	/* save registers in cpu_context */
+	/* use r11 and r12, volatile registers, as temp register */
+	addik	r11, r5, TI_CPU_CONTEXT
+	swi	r1, r11, CC_SP
+	swi	r2, r11, CC_R2
+	/* skip volatile registers.
+	 * they are saved on stack when we jumped to _switch_to() */
+	/* dedicated registers */
+	swi	r13, r11, CC_R13
+	swi	r14, r11, CC_R14
+	swi	r15, r11, CC_R15
+	swi	r16, r11, CC_R16
+	swi	r17, r11, CC_R17
+	swi	r18, r11, CC_R18
+	/* save non-volatile registers */
+	swi	r19, r11, CC_R19
+	swi	r20, r11, CC_R20
+	swi	r21, r11, CC_R21
+	swi	r22, r11, CC_R22
+	swi	r23, r11, CC_R23
+	swi	r24, r11, CC_R24
+	swi	r25, r11, CC_R25
+	swi	r26, r11, CC_R26
+	swi	r27, r11, CC_R27
+	swi	r28, r11, CC_R28
+	swi	r29, r11, CC_R29
+	swi	r30, r11, CC_R30
+	/* special purpose registers */
+	mfs	r12, rmsr
+	swi	r12, r11, CC_MSR
+	mfs	r12, rear
+	swi	r12, r11, CC_EAR
+	mfs	r12, resr
+	swi	r12, r11, CC_ESR
+	mfs	r12, rfsr
+	swi	r12, r11, CC_FSR
+
+	/* update r31, the current */
+	lwi	r31, r6, TI_TASK
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+
+	/* get new process' cpu context and restore */
+	addik	r11, r6, TI_CPU_CONTEXT
+
+	/* special purpose registers */
+	lwi	r12, r11, CC_FSR
+	mts	rfsr, r12
+	lwi	r12, r11, CC_ESR
+	mts	resr, r12
+	lwi	r12, r11, CC_EAR
+	mts	rear, r12
+	lwi	r12, r11, CC_MSR
+	mts	rmsr, r12
+	/* non-volatile registers */
+	lwi	r30, r11, CC_R30
+	lwi	r29, r11, CC_R29
+	lwi	r28, r11, CC_R28
+	lwi	r27, r11, CC_R27
+	lwi	r26, r11, CC_R26
+	lwi	r25, r11, CC_R25
+	lwi	r24, r11, CC_R24
+	lwi	r23, r11, CC_R23
+	lwi	r22, r11, CC_R22
+	lwi	r21, r11, CC_R21
+	lwi	r20, r11, CC_R20
+	lwi	r19, r11, CC_R19
+	/* dedicated registers */
+	lwi	r18, r11, CC_R18
+	lwi	r17, r11, CC_R17
+	lwi	r16, r11, CC_R16
+	lwi	r15, r11, CC_R15
+	lwi	r14, r11, CC_R14
+	lwi	r13, r11, CC_R13
+	/* skip volatile registers */
+	lwi	r2, r11, CC_R2
+	lwi	r1, r11, CC_SP
+
+	rtsd	r15, 8
+	nop
+
+ENTRY(ret_from_fork)
+	addk	r5, r0, r3
+	addk	r6, r0, r1
+	brlid	r15, schedule_tail
+	nop
+	swi	r31, r1, PT_R31		/* save r31 in user context. */
+			/* will soon be restored to r31 in ret_to_user */
+	addk	r3, r0, r0
+	brid	ret_to_user
+	nop
+
+work_pending:
+	andi	r11, r19, _TIF_NEED_RESCHED
+	beqi	r11, 1f
+	bralid	r15, schedule
+	nop
+1:	andi	r11, r19, _TIF_SIGPENDING
+	beqi	r11, no_work_pending
+	addk	r5, r1, r0
+	addik	r7, r0, 1
+	bralid	r15, do_signal
+	addk	r6, r0, r0
+	bri	no_work_pending
+
+ENTRY(ret_to_user)
+	disable_irq
+
+	swi	r4, r1, PT_R4		/* return val */
+	swi	r3, r1, PT_R3		/* return val */
+
+	lwi	r6, r31, TS_THREAD_INFO /* get thread info */
+	lwi	r19, r6, TI_FLAGS /* get flags in thread info */
+	bnei	r19, work_pending /* do an extra work if any bits are set */
+no_work_pending:
+	disable_irq
+
+	/* save r31 */
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* save mode indicator */
+	lwi	r18, r1, PT_MODE
+	swi	r18, r0, PER_CPU(KM)
+//restore_context:
+	/* special purpose registers */
+	lwi	r18, r1, PT_FSR
+	mts	rfsr, r18
+	lwi	r18, r1, PT_ESR
+	mts	resr, r18
+	lwi	r18, r1, PT_EAR
+	mts	rear, r18
+	lwi	r18, r1, PT_MSR
+	mts	rmsr, r18
+
+	lwi	r31, r1, PT_R31
+	lwi	r30, r1, PT_R30
+	lwi	r29, r1, PT_R29
+	lwi	r28, r1, PT_R28
+	lwi	r27, r1, PT_R27
+	lwi	r26, r1, PT_R26
+	lwi	r25, r1, PT_R25
+	lwi	r24, r1, PT_R24
+	lwi	r23, r1, PT_R23
+	lwi	r22, r1, PT_R22
+	lwi	r21, r1, PT_R21
+	lwi	r20, r1, PT_R20
+	lwi	r19, r1, PT_R19
+	lwi	r18, r1, PT_R18
+	lwi	r17, r1, PT_R17
+	lwi	r16, r1, PT_R16
+	lwi	r15, r1, PT_R15
+	lwi	r14, r1, PT_PC
+	lwi	r13, r1, PT_R13
+	lwi	r12, r1, PT_R12
+	lwi	r11, r1, PT_R11
+	lwi	r10, r1, PT_R10
+	lwi	r9, r1, PT_R9
+	lwi	r8, r1, PT_R8
+	lwi	r7, r1, PT_R7
+	lwi	r6, r1, PT_R6
+	lwi	r5, r1, PT_R5
+	lwi	r4, r1, PT_R4		/* return val */
+	lwi	r3, r1, PT_R3		/* return val */
+	lwi	r2, r1, PT_R2
+	lwi	r1, r1, PT_R1
+
+	rtid	r14, 0
+	nop
+
+sys_vfork_wrapper:
+	brid	sys_vfork
+	addk	r5, r1, r0
+
+sys_clone_wrapper:
+	brid	sys_clone
+	addk	r7, r1, r0
+
+sys_execve_wrapper:
+	brid	sys_execve
+	addk	r8, r1, r0
+
+sys_sigreturn_wrapper:
+	brid	sys_sigreturn
+	addk	r5, r1, r0
+
+sys_rt_sigreturn_wrapper:
+	brid	sys_rt_sigreturn
+	addk	r5, r1, r0
+
+sys_sigsuspend_wrapper:
+	brid	sys_rt_sigsuspend
+	addk	r6, r1, r0
+
+sys_rt_sigsuspend_wrapper:
+	brid	sys_rt_sigsuspend
+	addk	r7, r1, r0
+
+	/* Interrupt vector table */
+	.section	.init.ivt, "ax"
+	.org 0x0
+	brai	_reset
+	brai	_user_exception
+	brai	_interrupt
+	brai	_break
+	brai	_hw_exception_handler
+	.org 0x60
+	brai	_debug_exception
+
+.section .rodata,"a"
+#include "syscall_table.S"
+
+syscall_table_size=(.-sys_call_table)
-- 
1.5.4.GIT

