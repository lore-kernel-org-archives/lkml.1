Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYI3DHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYI3DHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYI3DG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:06:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53570 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYI3DGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:06:54 -0400
Message-Id: <20080930030651.917721714@goodmis.org>
References: <20080930030236.230994826@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 23:02:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/6] ftrace: give time for wakeup test to run
Content-Disposition: inline; filename=ftrace-add-wait-in-wakeup-selftest.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that the testing thread in the ftrace wakeup test does not
run before we stop the trace. This will cause the trace to fail since nothing
will be in the buffers.

This patch adds a small wait in the wakeup test to allow for the woken task
to run and be traced.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_selftest.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-tip.git/kernel/trace/trace_selftest.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_selftest.c	2008-09-29 20:13:37.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_selftest.c	2008-09-29 20:14:30.000000000 -0400
@@ -498,6 +498,9 @@ trace_selftest_startup_wakeup(struct tra
 
 	wake_up_process(p);
 
+	/* give a little time to let the thread wake up */
+	msleep(100);
+
 	/* stop the tracing. */
 	tr->ctrl = 0;
 	trace->ctrl_update(tr);

-- 
