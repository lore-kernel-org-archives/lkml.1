Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZEUOCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZEUOCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbZEUOCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:02:24 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:52975 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZEUOCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:02:23 -0400
Date: Thu, 21 May 2009 19:32:21 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 07/12] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20090521140221.GH13849@in.ibm.com>
References: <20090521095613.834622717@prasadkr_t60p.in.ibm.com>
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

