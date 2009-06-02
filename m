Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZFBEox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZFBEox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbZFBEnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:43:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49644 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbZFBEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:43:39 -0400
Message-Id: <20090602044340.209165838@goodmis.org>
References: <20090602044315.439593107@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 00:43:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 05/10] tracing/events: put TP_fast_assign into braces
Content-Disposition: inline; filename=0005-tracing-events-put-TP_fast_assign-into-braces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Currently TP_fast_assign has a limitation that we can't define local
variables in it.

Here's one use case when we introduce __dynamic_array():

TP_fast_assign(
	type *p = __get_dynamic_array(item);

	foo(p);
	bar(p);
),

[ Impact: allow defining local variables in TP_fast_assign ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A2384B1.90100@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 9276ec4..ee92682 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -471,7 +471,7 @@ static void ftrace_raw_event_##call(proto)				\
 		return;							\
 	entry	= ring_buffer_event_data(event);			\
 									\
-	assign;								\
+	{ assign; }							\
 									\
 	if (!filter_current_check_discard(event_call, entry, event))	\
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
-- 
1.6.3.1

-- 
