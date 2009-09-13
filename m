Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZIMDqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZIMDqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbZIMDqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:46:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZIMDqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:46:33 -0400
Message-Id: <20090913034635.933408354@goodmis.org>
References: <20090913034302.134417216@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:43:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/6] tracing: allow filter predicates to handle ksym symbols
Content-Disposition: inline; filename=0001-tracing-allow-filter-predicates-to-handle-ksym-symbo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch increases the max string used by predicates to
handle KSYM_SYMBOL_LEN.

Also moves an include to look nicer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0608b0f..bd099ba 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -1,8 +1,8 @@
 #ifndef _LINUX_FTRACE_EVENT_H
 #define _LINUX_FTRACE_EVENT_H
 
-#include <linux/trace_seq.h>
 #include <linux/ring_buffer.h>
+#include <linux/trace_seq.h>
 #include <linux/percpu.h>
 
 struct trace_array;
@@ -135,7 +135,7 @@ struct ftrace_event_call {
 };
 
 #define MAX_FILTER_PRED		32
-#define MAX_FILTER_STR_VAL	128
+#define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
 extern void destroy_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
-- 
1.6.3.3

-- 
