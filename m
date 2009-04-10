Return-Path: <linux-kernel-owner+w=401wt.eu-S938702AbZDJOH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938702AbZDJOH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 10:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938644AbZDJOHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 10:07:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:58576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759760AbZDJOHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 10:07:11 -0400
Date: Fri, 10 Apr 2009 14:06:25 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49DC679D.2090901@cn.fujitsu.com>
References: <49DC679D.2090901@cn.fujitsu.com>
Subject: [tip:tracing/urgent] ftrace: Output REC->var instead of __entry->var for trace format
Message-ID: <tip-0462b5664b2bda5a18fef7efb5bb32ce36590c1a@git.kernel.org>
Git-Commit-ID: 0462b5664b2bda5a18fef7efb5bb32ce36590c1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 14:06:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0462b5664b2bda5a18fef7efb5bb32ce36590c1a
Gitweb:     http://git.kernel.org/tip/0462b5664b2bda5a18fef7efb5bb32ce36590c1a
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Wed, 8 Apr 2009 17:00:13 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 15:48:53 +0200

ftrace: Output REC->var instead of __entry->var for trace format

print fmt: "irq=%d return=%s", __entry->irq, __entry->ret ? \"handled\" : \"unhandled\"

"__entry" should be convert to "REC" by __stringify() macro.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49DC679D.2090901@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_stage_2.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 30743f7..d363c66 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -105,10 +105,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 		return 0;
 
 #undef __entry
-#define __entry "REC"
+#define __entry REC
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, #args
+#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
