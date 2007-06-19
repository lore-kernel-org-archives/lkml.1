Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXFSUYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXFSUYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760179AbXFSUYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:24:25 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63918 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbXFSUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:24:24 -0400
Subject: [PATCH RT] Remove double warning print with faulty preempt disable
	nesting
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 16:23:47 -0400
Message-Id: <1182284627.15228.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a faulty preempt disable bug we print out a warning but then we go
and call preempt_enable_no_resched, which also can print out a warning.
This is redundant.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rt9/lib/smp_processor_id.c
===================================================================
--- linux-2.6.21-rt9.orig/lib/smp_processor_id.c
+++ linux-2.6.21-rt9/lib/smp_processor_id.c
@@ -47,7 +47,11 @@ unsigned int notrace debug_smp_processor
 	dump_stack();
 
 out_enable:
-	preempt_enable_no_resched();
+	/*
+	 * Don't print message if we enable to zero.
+	 * We arleady printed a warning up above.
+	 */
+	__preempt_enable_no_resched();
 out:
 	return this_cpu;
 }


