Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbYJ0Ib2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbYJ0Ib2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYJ0IbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:31:21 -0400
Received: from aun.it.uu.se ([130.238.12.36]:35950 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYJ0IbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:31:20 -0400
Date: Mon, 27 Oct 2008 09:30:57 +0100 (MET)
Message-Id: <200810270830.m9R8UvcV029513@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: mingo@redhat.com
Subject: [PATCH 2.6.28-rc2] x86_64: remove duplicated register setup code in ia32 signal delivery
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia32_setup_rt_frame() has a duplicated code block labelled
"Make -mregparm=3 work" for setting up the register parameters
to the user-mode signal handler.

This is harmless but ugly. Remove the redundant assignments.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 arch/x86/ia32/ia32_signal.c |    5 -----
 1 file changed, 5 deletions(-)

diff -rupN linux-2.6.28-rc2/arch/x86/ia32/ia32_signal.c linux-2.6.28-rc2.x86-signals-fixes/arch/x86/ia32/ia32_signal.c
--- linux-2.6.28-rc2/arch/x86/ia32/ia32_signal.c	2008-10-26 21:35:33.000000000 +0100
+++ linux-2.6.28-rc2.x86-signals-fixes/arch/x86/ia32/ia32_signal.c	2008-10-27 08:14:43.000000000 +0100
@@ -572,11 +572,6 @@ int ia32_setup_rt_frame(int sig, struct 
 	regs->dx = (unsigned long) &frame->info;
 	regs->cx = (unsigned long) &frame->uc;
 
-	/* Make -mregparm=3 work */
-	regs->ax = sig;
-	regs->dx = (unsigned long) &frame->info;
-	regs->cx = (unsigned long) &frame->uc;
-
 	loadsegment(ds, __USER32_DS);
 	loadsegment(es, __USER32_DS);
 
