Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYJCUHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYJCUHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYJCUHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:07:11 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:4498 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbYJCUHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:07:07 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 3/9] traps: i386: use preempt_conditional_sti/cli in do_int3
Date: Fri,  3 Oct 2008 22:00:34 +0200
Message-Id: <1223064040-23170-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223064040-23170-3-git-send-email-heukelum@fastmail.fm>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-2-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-3-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 03 Oct 2008 22:06:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use preempt_conditional_sti/cli in do_int3, like on x86_64.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index c17fcc8..535c41a 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -478,14 +478,15 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-	conditional_sti(regs);
 #else
 	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
 #endif
 
+	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
+	preempt_conditional_cli(regs);
 }
 
 /*
-- 
1.5.4.3

