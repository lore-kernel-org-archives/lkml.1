Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZCEEkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZCEEkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 23:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZCEEki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 23:40:38 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52223 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbZCEEkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 23:40:37 -0500
Date: Thu, 5 Mar 2009 10:10:28 +0530
From: prasad@linux.vnet.ibm.com
To: mingo@elte.hu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [patch 07/11] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20090305044028.GH17747@in.ibm.com>
References: <20090305043440.189041194@linux.vnet.ibm.com>
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
@@ -795,15 +795,6 @@ static void do_signal(struct pt_regs *re
 
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

