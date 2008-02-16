Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYBPPv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYBPPv3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYBPPvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:51:20 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:45805 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYBPPvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:51:19 -0500
Message-ID: <47B7065B.8090209@tiscali.nl>
Date: Sat, 16 Feb 2008 16:50:51 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] [x86] arch/x86/kernel/signal_32.c: replace !likely(x)
 by likely(!x)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace !likely(x) by likely(!x)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index caee1f0..335872f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -303,7 +303,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
 	 * If we are on the alternate signal stack and would overflow it, don't.
 	 * Return an always-bogus address instead so we will die with SIGSEGV.
 	 */
-	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
+	if (on_sig_stack(sp) && likely(!on_sig_stack(sp - frame_size)))
 		return (void __user *) -1L;
 
 	/* This is the X/Open sanctioned signal stack switching.  */
