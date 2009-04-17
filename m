Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbZDQVOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbZDQVOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbZDQVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:12:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48558 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbZDQVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:12:34 -0400
Message-Id: <20090417211230.960443524@goodmis.org>
References: <20090417211135.408179566@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 17:11:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] tracing: add EXPORT_SYMBOL_GPL for trace commits
Content-Disposition: inline; filename=0002-tracing-add-EXPORT_SYMBOL_GPL-for-trace-commits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Not all the necessary symbols were exported to allow for tracing
by modules. This patch adds them in.

[ Impact: allow modules to commit data to the ring buffer ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f681f64..183d788 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -894,18 +894,20 @@ void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
 {
 	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
 }
+EXPORT_SYMBOL(trace_current_buffer_unlock_commit);
 
 void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
 	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
 }
+EXPORT_SYMBOL(trace_nowake_buffer_unlock_commit);
 
 void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
 {
 	ring_buffer_discard_commit(global_trace.buffer, event);
 }
-EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
+EXPORT_SYMBOL_GPL(trace_current_buffer_discard_commit);
 
 void
 trace_function(struct trace_array *tr,
-- 
1.6.2.1

-- 
