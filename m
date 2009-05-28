Return-Path: <linux-kernel-owner+w=401wt.eu-S1764120AbZE1Um3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120AbZE1Um3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbZE1UmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:42:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZE1UmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:42:05 -0400
Message-Id: <20090528204205.741623556@goodmis.org>
References: <20090528204128.571984478@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 28 May 2009 16:41:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] tracing: combine the default tracers into one config
Content-Disposition: inline; filename=0002-tracing-combine-the-default-tracers-into-one-config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Both event tracer and sched switch plugin are selected by default
by all generic tracers. But if no generic tracer is enabled, their options
appear. But ether one of them will select the other, thus it only
makes sense to have the default tracers be selected by one option.

[ Impact: clean up kconfig menu ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 6e55cc3..4a13e5a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -192,27 +192,14 @@ config SCHED_TRACER
 	  This tracer tracks the latency of the highest priority task
 	  to be scheduled in, starting from the point it has woken up.
 
-config ENABLE_CONTEXT_SWITCH_TRACER
-	bool "Trace process context switches"
-	depends on !GENERIC_TRACER
-	select TRACING
-	select CONTEXT_SWITCH_TRACER
-	help
-	  This tracer gets called from the context switch and records
-	  all switching of tasks.
-
-config ENABLE_EVENT_TRACING
-	bool "Trace various events in the kernel"
+config ENABLE_DEFAULT_TRACERS
+	bool "Trace process context switches and events"
 	depends on !GENERIC_TRACER
 	select TRACING
 	help
 	  This tracer hooks to various trace points in the kernel
 	  allowing the user to pick and choose which trace point they
-	  want to trace.
-
-	  Note, all tracers enable event tracing. This option is
-	  only a convenience to enable event tracing when no other
-	  tracers are selected.
+	  want to trace. It also includes the sched_switch tracer plugin.
 
 config FTRACE_SYSCALLS
 	bool "Trace syscalls"
-- 
1.6.3.1

-- 
