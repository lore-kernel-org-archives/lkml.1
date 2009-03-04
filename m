Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZCDCx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZCDCx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZCDCwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:52:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbZCDCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:52:53 -0500
Message-Id: <20090304025250.587839414@goodmis.org>
References: <20090304024921.153061228@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 21:49:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ring-buffer: replace sizeof of event header with offsetof
Content-Disposition: inline; filename=0003-ring-buffer-replace-sizeof-of-event-header-with-off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to possible alignment problems on some archs.

Some arch compilers include an NULL char array in the sizeof field.
Since the ring_buffer_event type includes one of these, it is better
to use the "offsetof" instead, to avoid strange bugs on these archs.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2ad6bae..27cf834 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -132,7 +132,7 @@ void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
 
-#define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
+#define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	28
 
-- 
1.5.6.5

-- 
