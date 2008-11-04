Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYKDDXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYKDDXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 22:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYKDDXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 22:23:05 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64380 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYKDDXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 22:23:04 -0500
Message-ID: <490FC015.7080707@ct.jp.nec.com>
Date: Mon, 03 Nov 2008 19:23:01 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: signal_64: remove unused code in __setup_rt_frame()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

sizeof(*set) is always 8 on x86_64.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_64.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 83990db..cfbb60a 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -251,11 +251,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
 	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
-	if (sizeof(*set) == 16) {
-		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
-		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]);
-	} else
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-- 
1.5.6

