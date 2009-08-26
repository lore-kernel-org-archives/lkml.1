Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZHZFBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZHZFBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZHZFA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:00:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbZHZFAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:51 -0400
Message-Id: <20090826050052.694614817@goodmis.org>
References: <20090826045945.201094161@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Aug 2009 00:59:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 8/8] tracing: add comments to explain TRACE_EVENT out of protection
Content-Disposition: inline; filename=0008-tracing-add-comments-to-explain-TRACE_EVENT-out-of-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The commit:
  commit 5ac35daa9343936038a3c9c4f4d6d3fe6a2a7bd8
  Author: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
  tracing/events: fix the include file dependencies

Moved the TRACE_EVENT out of the ifdef protection of tracepoints.h
but uses the define of TRACE_EVENT itself as protection. This patch
adds comments to explain why.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 8170985..0341f2e 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -180,7 +180,15 @@ static inline void tracepoint_synchronize_unregister(void)
 }
 
 #define PARAMS(args...) args
-#endif
+
+#endif /* _LINUX_TRACEPOINT_H */
+
+/*
+ * Note: we keep the TRACE_EVENT outside the include file ifdef protection.
+ *  This is due to the way trace events work. If a file includes two
+ *  trace event headers under one "CREATE_TRACE_POINTS" the first include
+ *  will override the TRACE_EVENT and break the second include.
+ */
 
 #ifndef TRACE_EVENT
 /*
@@ -287,4 +295,5 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
-#endif
+
+#endif /* ifdef TRACE_EVENT (see note above) */
-- 
1.6.3.3

-- 
