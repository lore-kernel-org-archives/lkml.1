Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbZE3Kwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbZE3Kwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762018AbZE3KwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:52:20 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:42656 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762063AbZE3KwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:52:19 -0400
Date: Sat, 30 May 2009 16:22:16 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 07/12] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20090530105216.GH9512@in.ibm.com>
References: <20090530103857.715014561@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_signal_07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables re-enabling of Hardware Breakpoint registers through
the  signal handling code. This is now done during
hw_breakpoint_handler().

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/signal.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/signal.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/signal.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/signal.c
@@ -799,15 +799,6 @@ static void do_signal(struct pt_regs *re
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/*
-		 * Re-enable any watchpoints before delivering the
-		 * signal to user space. The processor register will
-		 * have been cleared if the watchpoint triggered
-		 * inside the kernel.
-		 */
-		if (current->thread.debugreg7)
-			set_debugreg(current->thread.debugreg7, 7);
-
 		/* Whee! Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
 			/*

