Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJCURd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJCURd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYJCURJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:17:09 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:14367 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYJCURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:17:07 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 4/9] traps: x86_64: make io_check_error equal to the one on i386
Date: Fri,  3 Oct 2008 22:00:35 +0200
Message-Id: <1223064040-23170-5-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223064040-23170-4-git-send-email-heukelum@fastmail.fm>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-2-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-3-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-4-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 03 Oct 2008 22:16:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make io_check_error equal to the one on i386.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_64.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index a7aef2d..6bce291 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -253,13 +253,19 @@ mem_parity_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void
 io_check_error(unsigned char reason, struct pt_regs *regs)
 {
-	printk("NMI: IOCK error (debug interrupt?)\n");
+	unsigned long i;
+
+	printk(KERN_EMERG "NMI: IOCK error (debug interrupt?)\n");
 	show_registers(regs);
 
 	/* Re-enable the IOCK line, wait for a few seconds */
 	reason = (reason & 0xf) | 8;
 	outb(reason, 0x61);
-	mdelay(2000);
+
+	i = 2000;
+	while (--i)
+		udelay(1000);
+
 	reason &= ~8;
 	outb(reason, 0x61);
 }
-- 
1.5.4.3

