Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYIJGce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYIJGce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYIJGcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:32:16 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:9242 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYIJGcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:32:15 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 18/24] i386: convert hardware exception 19 to an interrupt gate
Date: Tue,  9 Sep 2008 21:56:12 +0200
Message-Id: <1220990178-29773-19-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-18-git-send-email-heukelum@fastmail.fm>
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
 <1220990178-29773-16-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-17-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-18-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 08:31:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

Handle SIMD coprocessor exception with interrupt initially off.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index f696914..1ad7697 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1142,6 +1142,8 @@ static void simd_math_error(void __user *ip)
 
 void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
+
 	if (cpu_has_xmm) {
 		/* Handle SIMD FPU exceptions on PIII+ processors. */
 		ignore_fpu_irq = 1;
@@ -1292,7 +1294,7 @@ void __init trap_init(void)
 #ifdef CONFIG_X86_MCE
 	set_intr_gate(18, &machine_check);
 #endif
-	set_trap_gate(19, &simd_coprocessor_error);
+	set_intr_gate(19, &simd_coprocessor_error);
 
 	if (cpu_has_fxsr) {
 		printk(KERN_INFO "Enabling fast FPU save and restore... ");
-- 
1.5.4.3

