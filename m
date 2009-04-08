Return-Path: <linux-kernel-owner+w=401wt.eu-S1763065AbZDHJDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763065AbZDHJDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZDHJDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:03:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56829 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759431AbZDHJDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:03:22 -0400
Message-ID: <49DC679D.2090901@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 17:00:13 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ftrace: Output REC->var instead of __entry->var for trace
 format
References: <49DC6751.30308@cn.fujitsu.com>
In-Reply-To: <49DC6751.30308@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print fmt: "irq=%d return=%s", __entry->irq, __entry->ret ? \"handled\" : \"unhandled\"

"__entry" should be convert to "REC" by __stringify() macro.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_events_stage_2.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 9e47c39..d694a8a 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -108,10 +108,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 		return 0;
 
 #undef __entry
-#define __entry "REC"
+#define __entry REC
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, #args
+#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-- 
1.5.5.3


