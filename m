Return-Path: <linux-kernel-owner+w=401wt.eu-S933906AbXFSUSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbXFSUSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbXFSUSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:18:34 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:46351 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbXFSUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:18:33 -0400
Subject: [PATCH RT] disable preemption on running show all regs.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 16:17:56 -0400
Message-Id: <1182284276.15228.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The show all regs sysrq uses the nmi function to do it. But this
function expects preemption to be off, or funny things happen.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rt9/drivers/char/sysrq.c
===================================================================
--- linux-2.6.21-rt9.orig/drivers/char/sysrq.c
+++ linux-2.6.21-rt9/drivers/char/sysrq.c
@@ -213,7 +213,9 @@ static struct sysrq_key_op sysrq_showreg
 
 static void sysrq_handle_showallregs(int key, struct tty_struct *tty)
 {
+        preempt_disable();
 	nmi_show_all_regs();
+        preempt_enable();
 }
 
 static struct sysrq_key_op sysrq_showallregs_op = {


