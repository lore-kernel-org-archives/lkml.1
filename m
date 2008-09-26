Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYIZMWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYIZMWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYIZMWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:22:10 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:19855 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYIZMWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:22:09 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 4/7] traps: x86_64: remove trace_hardirqs_fixup from int3 handler
Date: Fri, 26 Sep 2008 14:03:05 +0200
Message-Id: <1222430588-29072-5-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222430588-29072-4-git-send-email-heukelum@fastmail.fm>
References: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-2-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-3-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-4-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 26 Sep 2008 14:21:53 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.215; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All exceptions are taken via interrupt gates. TRACE_IRQS_OFF
is called just before entering the C code, so the irq state
is known to the irq tracer at this point. No need to call
trace_hardirqs_fixup.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_64.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 04b163e..2ff759e 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -857,8 +857,6 @@ void restart_nmi(void)
 /* runs on IST stack. */
 asmlinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
-	trace_hardirqs_fixup();
-
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-- 
1.5.4.3

