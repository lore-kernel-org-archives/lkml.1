Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZKTOAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZKTOAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZKTOAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:00:09 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:29269 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZKTOAI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Fri, 20 Nov 2009 09:00:08 -0500
Message-Id: <4B06AEFE02000078000211F4@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 20 Nov 2009 14:00:14 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: suppress stack overrun message for init_task
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_task doesn't get its stack end location set to STACK_END_MAGIC,
and hence the message is confusing rather than helpful in this case.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32-rc8/arch/x86/mm/fault.c
+++ 2.6.32-rc8-x86-init-task-stack/arch/x86/mm/fault.c
@@ -658,7 +658,7 @@ no_context(struct pt_regs *regs, unsigne
 	show_fault_oops(regs, error_code, address);
 
 	stackend = end_of_stack(tsk);
-	if (*stackend != STACK_END_MAGIC)
+	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;



