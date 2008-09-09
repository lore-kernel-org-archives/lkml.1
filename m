Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYIJAme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYIJAme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYIJAmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:42:19 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:15828 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYIJAmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:42:18 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 6/24] i386: convert hardware exception 5 to an interrupt gate
Date: Tue,  9 Sep 2008 21:56:00 +0200
Message-Id: <1220990178-29773-7-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-6-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-5-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-6-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 02:41:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

Handle bounds exception with interrupt initially off.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 5d762a8..becfc84 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -634,7 +634,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 
 DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
 DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_VM86_TRAP(5, SIGSEGV, "bounds", bounds)
+DO_VM86_ERROR(5, SIGSEGV, "bounds", bounds)
 DO_TRAP_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
 DO_TRAP(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_TRAP(10, SIGSEGV, "invalid TSS", invalid_TSS)
@@ -1251,7 +1251,7 @@ void __init trap_init(void)
 	set_intr_gate(2, &nmi);
 	set_system_intr_gate(3, &int3); /* int3 can be called from all */
 	set_system_intr_gate(4, &overflow); /* int4 can be called from all */
-	set_trap_gate(5, &bounds);
+	set_intr_gate(5, &bounds);
 	set_trap_gate(6, &invalid_op);
 	set_trap_gate(7, &device_not_available);
 	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
-- 
1.5.4.3

