Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYIIVMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYIIVMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 17:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYIIVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 17:12:12 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:16639 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYIIVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 17:12:11 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 12/24] i386: convert hardware exception 12 to an interrupt gate
Date: Tue,  9 Sep 2008 21:56:06 +0200
Message-Id: <1220990178-29773-13-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-12-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-5-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-6-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-7-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-8-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-9-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-10-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-11-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-12-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 09 Sep 2008 23:11:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

Handle stack segment exception with interrupt initially off.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 572ea9f..e535324 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -640,7 +640,7 @@ DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
 DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
-DO_TRAP(12, SIGBUS, "stack segment", stack_segment)
+DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
 DO_TRAP_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
 DO_TRAP_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
@@ -1270,7 +1270,7 @@ void __init trap_init(void)
 	set_intr_gate(9, &coprocessor_segment_overrun);
 	set_intr_gate(10, &invalid_TSS);
 	set_intr_gate(11, &segment_not_present);
-	set_trap_gate(12, &stack_segment);
+	set_intr_gate(12, &stack_segment);
 	set_trap_gate(13, &general_protection);
 	set_intr_gate(14, &page_fault);
 	set_trap_gate(15, &spurious_interrupt_bug);
-- 
1.5.4.3

