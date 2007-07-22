Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXGVMte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXGVMte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758962AbXGVMtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:49:25 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:38796 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbXGVMtZ (ORCPT <rfc822;Linux-Kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:49:25 -0400
Date: Sun, 22 Jul 2007 16:49:52 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Linux-Kernel@vger.kernel.org
Cc: hpa@zytor.com
Subject: [PATCH 1/2] x86: duplicated code cleanup
Message-ID: <20070722124952.GA20538@dnb.sw.ru>
Mail-Followup-To: Linux-Kernel@vger.kernel.org, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- no changes at all, just move duplicated code to macro expression.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 arch/i386/kernel/entry.S |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
index a714d6b..0993810 100644
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -183,6 +183,12 @@ VM_MASK		= 0x00020000
 	.long 3b,6b;	\
 .popsection
 
+#define IRET_EXC		\
+.section __ex_table,"a";	\
+	.align 4;		\
+	.long 1b,iret_exc;	\
+.previous
+
 #define RING0_INT_FRAME \
 	CFI_STARTPROC simple;\
 	CFI_SIGNAL_FRAME;\
@@ -413,10 +419,7 @@ iret_exc:
 	pushl $do_iret_error
 	jmp error_code
 .previous
-.section __ex_table,"a"
-	.align 4
-	.long 1b,iret_exc
-.previous
+IRET_EXC
 
 	CFI_RESTORE_STATE
 ldt_ss:
@@ -863,19 +866,13 @@ nmi_espfix_stack:
 	CFI_ADJUST_CFA_OFFSET -24
 1:	INTERRUPT_RETURN
 	CFI_ENDPROC
-.section __ex_table,"a"
-	.align 4
-	.long 1b,iret_exc
-.previous
+IRET_EXC
 KPROBE_END(nmi)
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 1:	iret
-.section __ex_table,"a"
-	.align 4
-	.long 1b,iret_exc
-.previous
+IRET_EXC
 END(native_iret)
 
 ENTRY(native_irq_enable_sysexit)
-- 
1.5.2.2


