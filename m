Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZFAHeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZFAHeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZFAHd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:33:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60062 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZFAHd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:33:56 -0400
Message-ID: <4A2384B1.90100@cn.fujitsu.com>
Date: Mon, 01 Jun 2009 15:35:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/events: put TP_fast_assign into braces
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently TP_fast_assin has a limitation that we can't define local
variables in it.

Here's one use case when we introduce __dynamic_array():

TP_fast_assign(
	type *p = __get_dynamic_array(item);

	foo(p);
	bar(p);
),

[ Impact: allow defining local variables in TP_fast_assign ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3


