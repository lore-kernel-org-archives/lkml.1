Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYIXATw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYIXATw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 20:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYIXATp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 20:19:45 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5694 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYIXATo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 20:19:44 -0400
Message-ID: <48D987A0.50508@ct.jp.nec.com>
Date: Tue, 23 Sep 2008 17:19:44 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: signal: cosmetic unification of do_signal()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make do_signal() same.
Thia patch modifies only comments in signal_64.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_64.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index bf77d47..5a5fbc3 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -410,7 +410,8 @@ static void do_signal(struct pt_regs *regs)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/* Re-enable any watchpoints before delivering the
+		/*
+		 * Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
 		 * inside the kernel.
@@ -418,7 +419,7 @@ static void do_signal(struct pt_regs *regs)
 		if (current->thread.debugreg7)
 			set_debugreg(current->thread.debugreg7, 7);
 
-		/* Whee!  Actually deliver the signal.  */
+		/* Whee! Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
 			/*
 			 * A signal was successfully delivered; the saved
@@ -441,6 +442,7 @@ static void do_signal(struct pt_regs *regs)
 			regs->ax = regs->orig_ax;
 			regs->ip -= 2;
 			break;
+
 		case -ERESTART_RESTARTBLOCK:
 			regs->ax = NR_restart_syscall;
 			regs->ip -= 2;
-- 
1.5.6

