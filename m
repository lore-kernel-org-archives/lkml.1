Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZFBWpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZFBWpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbZFBWnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:5254 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbZFBWnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xHsbVGOzKxUVnWRKRciSa8w4EvywIB4wE8QEBK7SNyA0kL9wT0D826cliNtsMU08gj
         8ineoj4riEm6EdBPygD/zF8cTstk8GbXpMjGpNkFVEdIT2mFMXCdjDGJFZTWHFlutNul
         6yWx8obObVH9+0s7rewD06rerAr8Pv4Jt/Sy8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/12] hw-breakpoints: modify signal handling code to refrain from re-enabling HW Breakpoints
Date: Wed,  3 Jun 2009 00:43:31 +0200
Message-Id: <1243982616-18212-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

This patch disables re-enabling of Hardware Breakpoint registers through
the signal handling code. This is now done during from hw_breakpoint_handler().

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/signal.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 1442516..f33d2e0 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -800,15 +800,6 @@ static void do_signal(struct pt_regs *regs)
 
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
-- 
1.6.2.3

