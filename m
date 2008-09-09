Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbYIIUM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbYIIUM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYIIUMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:12:18 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:8450 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYIIUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:12:17 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 15/24] i386: convert hardware exception 16 to an interrupt gate
Date: Tue,  9 Sep 2008 21:56:09 +0200
Message-Id: <1220990178-29773-16-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-15-git-send-email-heukelum@fastmail.fm>
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
 <1220990178-29773-13-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-14-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-15-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 09 Sep 2008 22:11:59 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

Handle coprocessor error exception with interrupt initially off.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index ef934a2..733c0e3 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1086,6 +1086,7 @@ void math_error(void __user *ip)
 
 void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
 	ignore_fpu_irq = 1;
 	math_error((void __user *)regs->ip);
 }
@@ -1277,7 +1278,7 @@ void __init trap_init(void)
 	set_intr_gate(13, &general_protection);
 	set_intr_gate(14, &page_fault);
 	set_intr_gate(15, &spurious_interrupt_bug);
-	set_trap_gate(16, &coprocessor_error);
+	set_intr_gate(16, &coprocessor_error);
 	set_trap_gate(17, &alignment_check);
 #ifdef CONFIG_X86_MCE
 	set_trap_gate(18, &machine_check);
-- 
1.5.4.3

