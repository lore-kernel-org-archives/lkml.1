Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZDQVNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZDQVNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZDQVMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:12:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZDQVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:12:32 -0400
Message-Id: <20090417211230.723241189@goodmis.org>
References: <20090417211135.408179566@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 17:11:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] tracing/events: enable code with EVENT_TRACING not EVENT_TRACER
Content-Disposition: inline; filename=0001-tracing-events-enable-code-with-EVENT_TRACING-not-E.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The CONFIG_EVENT_TRACER is the way to turn on event tracing when no
other tracing has been configured. All code to get enabled should
depend on CONFIG_EVENT_TRACING. That is what is enabled when TRACING
(or CONFIG_EVENT_TRACER) is selected.

This patch enables the include/trace/ftrace.h file when
CONFIG_EVENT_TRACING is enabled.

[ Impact: fix warning in event tracer selftest ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/define_trace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 1886941..7f1f23d 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -56,7 +56,7 @@
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#ifdef CONFIG_EVENT_TRACER
+#ifdef CONFIG_EVENT_TRACING
 #include <trace/ftrace.h>
 #endif
 
-- 
1.6.2.1

-- 
