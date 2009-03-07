Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbZCGFIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbZCGFIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZCGFHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:07:11 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34863 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZCGFHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:07:09 -0500
Date: Sat, 7 Mar 2009 10:36:55 +0530
From: prasad@linux.vnet.ibm.com
To: mingo@elte.hu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 07/11] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20090307050655.GH23959@in.ibm.com>
References: <20090307045120.039324630@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=7
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch disables re-enabling of Hardware Breakpoint registers through
the  signal handling code. This is now done during
hw_breakpoint_handler().

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/signal.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/signal.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/signal.c
+++ linux-2.6-tip/arch/x86/kernel/signal.c
@@ -794,15 +794,6 @@ static void do_signal(struct pt_regs *re
 
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

