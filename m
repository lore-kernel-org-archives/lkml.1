Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYKHDs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYKHDs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYKHDrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYKHDru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:50 -0500
Message-Id: <20081108034749.340030047@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 04/10] ftrace: irqsoff tracer incorrect reset
Content-Disposition: inline; filename=0004-ftrace-irqsoff-tracer-incorrect-reset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix to irqsoff tracer output

In converting to the new start / stop ftrace handling, the irqsoff
tracer start called the irqsoff reset function. irqsoff tracer is
not the same as the other traces, and it resets the buffers while
searching for the longest latency.

The reset that the irqsoff stop method calls disables the function
tracing. That means that, by starting the tracer, the function
tracer is disabled incorrectly.

This patch simply removes the call to reset which keeps the function
tracing enabled. Reset is not needed for the irqsoff stop method.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_irqsoff.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index a87a20f..3509086 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -404,7 +404,6 @@ static void irqsoff_tracer_ctrl_update(struct trace_array *tr)
 
 static void irqsoff_tracer_start(struct trace_array *tr)
 {
-	irqsoff_tracer_reset(tr);
 	tracer_enabled = 1;
 	save_tracer_enabled = 1;
 }
-- 
1.5.6.5

-- 
