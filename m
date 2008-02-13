Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYBMVgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYBMVgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbYBMVaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:19 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55663 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763292AbYBMVaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:09 -0500
Date: Wed, 13 Feb 2008 23:29:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: don't make irq_return global
Message-ID: <20080213212953.GO3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not required for irq_return to be global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/entry_32.S |    2 +-
 arch/x86/kernel/entry_64.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

29fc832bc0de2ea3ebfcc105c9bfd56535cf5a42 diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 824e21b..4b87c32 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -409,7 +409,7 @@ restore_nocheck_notrace:
 	RESTORE_REGS
 	addl $4, %esp			# skip orig_eax/error_code
 	CFI_ADJUST_CFA_OFFSET -4
-ENTRY(irq_return)
+irq_return:
 	INTERRUPT_RETURN
 .section .fixup,"ax"
 iret_exc:
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6be39a3..2ad9a1b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -583,7 +583,7 @@ retint_restore_args:	/* return to kernel space */
 restore_args:
 	RESTORE_ARGS 0,8,0
 
-ENTRY(irq_return)
+irq_return:
 	INTERRUPT_RETURN
 
 	.section __ex_table, "a"

