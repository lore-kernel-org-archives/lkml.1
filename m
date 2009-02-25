Return-Path: <linux-kernel-owner+w=401wt.eu-S1762988AbZBYWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762988AbZBYWOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbZBYWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:13:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670AbZBYWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:13:47 -0500
Message-Id: <20090225221345.268246032@goodmis.org>
References: <20090225221304.097297742@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 17:13:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] tracing: wrap arguments with PARAMS
Content-Disposition: inline; filename=0002-tracing-wrap-arguments-with-PARAMS.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Peter Zijlstra warned that TPPROTO and TPARGS might become something
other than a simple copy of itself. To prevent this from having
side effects in the TRACE_FORMAT macro in tracepoint.h, we add a
PARAMS() macro to be defined as just a wrapper.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 3de09fa..62d1339 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -153,7 +153,8 @@ static inline void tracepoint_synchronize_unregister(void)
 	synchronize_sched();
 }
 
+#define PARAMS(args...) args
 #define TRACE_FORMAT(name, proto, args, fmt)		\
-	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
 #endif
-- 
1.5.6.5

-- 
