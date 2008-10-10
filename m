Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYJJMVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYJJMVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYJJMVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:21:01 -0400
Received: from perso1.free.fr ([212.27.63.203]:46194 "EHLO perso1.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYJJMVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:21:01 -0400
XPARM: thesermon.free.fr
XPARAM2: 193.50.29.42
Subject: [PATCH 4/6] tracing/ftrace: Remove unused code in sched_switch tracer
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 10 Oct 2008 14:21:08
To: Ingo Molnar <mingo@elte.hu>
Message-Id: <20081010122108.35784D1C02B@perso1.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When init_sched_switch_trace() is called, it has no reason to start
the sched tracer if the sched_ref is not zero.

_ If this is non-zero, the tracer is already used, but we can register it
to the tracing engine. There is already a security which avoid the tracer
probes not to be resgistered twice. 

_ If this is zero, this block will not be used.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_switch.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 59de514..96620c7 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -203,14 +203,6 @@ static struct tracer sched_switch_trace __read_mostly =
 
 __init static int init_sched_switch_trace(void)
 {
-	int ret = 0;
-
-	if (atomic_read(&sched_ref))
-		ret = tracing_sched_register();
-	if (ret) {
-		pr_info("error registering scheduler trace\n");
-		return ret;
-	}
 	return register_tracer(&sched_switch_trace);
 }
 device_initcall(init_sched_switch_trace);

