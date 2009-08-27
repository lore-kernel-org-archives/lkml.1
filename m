Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZH0Qh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZH0Qh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZH0QhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:37:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:58033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZH0QhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:37:24 -0400
Date: Thu, 27 Aug 2009 16:36:36 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090827161732.GA7618@nowhere>
References: <20090827161732.GA7618@nowhere>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Undef TRACE_EVENT_FN between trace events headers inclusion
Message-ID: <tip-6c347d43eea29221a8ebab9ff9cbe7a00cddac98@git.kernel.org>
Git-Commit-ID: 6c347d43eea29221a8ebab9ff9cbe7a00cddac98
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 27 Aug 2009 16:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c347d43eea29221a8ebab9ff9cbe7a00cddac98
Gitweb:     http://git.kernel.org/tip/6c347d43eea29221a8ebab9ff9cbe7a00cddac98
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 27 Aug 2009 18:17:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 27 Aug 2009 18:32:54 +0200

tracing: Undef TRACE_EVENT_FN between trace events headers inclusion

The recent commit:

	tracing/events: fix the include file dependencies

fixed a file dependency problem while including more than
one trace event header file.

This fix undefined TRACE_EVENT after an event header macro
preprocessing in order to make tracepoint.h able to correctly declare
the tracepoints necessary for the next event header file.

But now we also need to undefine TRACE_EVENT_FN at the end of an event
header file preprocessing for the same reason.

This fixes the following build error:

In file included from include/trace/events/napi.h:5,
                 from net/core/net-traces.c:28:
include/linux/tracepoint.h:285:1: warning: "TRACE_EVENT_FN" redefined
In file included from include/trace/define_trace.h:61,
                 from include/trace/events/skb.h:40,
                 from net/core/net-traces.c:27:
include/trace/ftrace.h:50:1: warning: this is the location of the previous definition
In file included from include/trace/events/napi.h:5,
                 from net/core/net-traces.c:28:
include/linux/tracepoint.h:285:1: warning: "TRACE_EVENT_FN" redefined
In file included from include/trace/define_trace.h:61,
                 from include/trace/events/skb.h:40,
                 from net/core/net-traces.c:27:
include/trace/ftrace.h:50:1: warning: this is the location of the previous definition

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <20090827161732.GA7618@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/define_trace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index a89ed59..2a4b3bf 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -62,6 +62,7 @@
 #endif
 
 #undef TRACE_EVENT
+#undef TRACE_EVENT_FN
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
