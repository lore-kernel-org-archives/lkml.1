Return-Path: <linux-kernel-owner+w=401wt.eu-S1760558AbYGKBBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbYGKBBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYGKA75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005951.001704691@goodmis.org>
References: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/8] ftrace: use current CPU for function startup
Content-Disposition: inline; filename=ftrace-function-use-this-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more of a clean up. Currently the function tracer initializes the
tracer with which ever CPU was last used for tracing. This value isn't
realy useful for function tracing, but at least it should be something other
than a random number.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-tip.git/kernel/trace/trace_functions.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_functions.c	2008-07-10 12:19:54.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_functions.c	2008-07-10 12:56:09.000000000 -0400
@@ -28,7 +28,10 @@ static void function_reset(struct trace_
 
 static void start_function_trace(struct trace_array *tr)
 {
+	tr->cpu = get_cpu();
 	function_reset(tr);
+	put_cpu();
+
 	tracing_start_cmdline_record();
 	tracing_start_function_trace();
 }

-- 
