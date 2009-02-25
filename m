Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbZBYC6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbZBYC6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZBYC55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:57:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZBYC54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:57:56 -0500
Message-Id: <20090225025753.547618424@goodmis.org>
References: <20090225025608.956691460@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Feb 2009 21:56:09 -0500
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
Subject: [PATCH 1/4] tracing: add DEFINE_TRACE_FMT to tracepoint.h
Content-Disposition: inline; filename=0001-tracing-add-DEFINE_TRACE_FMT-to-tracepoint.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch creates a DEFINE_TRACE_FMT to map to DECLARE_TRACE.
This allows for the developers to place format strings and
args in with their tracepoint declaration. A tracer may now
override the DEFINE_TRACE_FMT macro and use it to record
a default format.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 7570054..34ae464 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -153,4 +153,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	synchronize_sched();
 }
 
+#define DEFINE_TRACE_FMT(name, proto, args, fmt)		\
+	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
+
 #endif
-- 
1.5.6.5

-- 
