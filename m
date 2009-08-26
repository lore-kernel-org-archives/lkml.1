Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZHZHY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZHZHY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbZHZHY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:24:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:46909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098AbZHZHYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:24:24 -0400
Date: Wed, 26 Aug 2009 07:23:54 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, yjwei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, yjwei@cn.fujitsu.com, tglx@linutronix.de,
       xiaoguangrong@cn.fujitsu.com
In-Reply-To: <4A937F5E.3020802@cn.fujitsu.com>
References: <4A937F5E.3020802@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/events: fix the include file dependencies
Message-ID: <tip-5ac35daa9343936038a3c9c4f4d6d3fe6a2a7bd8@git.kernel.org>
Git-Commit-ID: 5ac35daa9343936038a3c9c4f4d6d3fe6a2a7bd8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 07:23:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ac35daa9343936038a3c9c4f4d6d3fe6a2a7bd8
Gitweb:     http://git.kernel.org/tip/5ac35daa9343936038a3c9c4f4d6d3fe6a2a7bd8
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Tue, 25 Aug 2009 14:06:22 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 26 Aug 2009 00:32:09 -0400

tracing/events: fix the include file dependencies

The TRACE_EVENT depends on the include/linux/tracepoint.h first
and include/trace/ftrace.h later, if we include the ftrace.h early,
a building error will occur.

Both define TRACE_EVENT in trace_a.h and trace_b.h, if we include
those in .c file, like this:

#define CREATE_TRACE_POINTS
include <trace/events/trace_a.h>
include <trace/events/trace_b.h>

The above will not work, because the TRACE_EVENT was re-defined by
the previous .h file.

Reported-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <4A937F5E.3020802@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 include/linux/tracepoint.h   |    3 +--
 include/trace/define_trace.h |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 5984ed0..8170985 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -180,6 +180,7 @@ static inline void tracepoint_synchronize_unregister(void)
 }
 
 #define PARAMS(args...) args
+#endif
 
 #ifndef TRACE_EVENT
 /*
@@ -287,5 +288,3 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #endif
-
-#endif
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f7a7ae1..cd150b9 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -56,6 +56,7 @@
 #include <trace/ftrace.h>
 #endif
 
+#undef TRACE_EVENT
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
