Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYIJEM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYIJEM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 00:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYIJEMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 00:12:13 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:23535 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYIJEMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 00:12:12 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 3/24] i386: convert hardware exception 0 to an interrupt gate
Date: Tue,  9 Sep 2008 21:55:57 +0200
Message-Id: <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 06:11:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

Handle divide error exception with interrupt initially off.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 9ac59e0..97d193c 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -632,7 +632,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	do_trap(trapnr, signr, str, 1, regs, error_code, &info);	\
 }
 
-DO_VM86_TRAP_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
+DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
 #ifndef CONFIG_KPROBES
 DO_VM86_TRAP(3, SIGTRAP, "int3", int3)
 #endif
@@ -1245,7 +1245,7 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_trap_gate(0, &divide_error);
+	set_intr_gate(0, &divide_error);
 	set_intr_gate(1, &debug);
 	set_intr_gate(2, &nmi);
 	set_system_intr_gate(3, &int3); /* int3 can be called from all */
-- 
1.5.4.3

