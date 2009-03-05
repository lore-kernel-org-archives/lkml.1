Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbZCEXX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbZCEXX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZCEXXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:23:44 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33135 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbZCEXXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:23:43 -0500
Message-Id: <20090305225519.304825297@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:48:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 34/41] Marker header API update
Content-Disposition: inline; filename=marker.h-api-update.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add channel id field to marker structure. Identifies the buffer group in which
the event will be written.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/marker.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2009-02-06 15:46:14.000000000 -0500
+++ linux-2.6-lttng/include/linux/marker.h	2009-02-06 15:46:28.000000000 -0500
@@ -22,6 +22,7 @@ struct marker;
 
 /**
  * marker_probe_func - Type of a marker probe function
+ * @mdata: marker data
  * @probe_private: probe private data
  * @call_private: call site private data
  * @fmt: format string
@@ -32,7 +33,8 @@ struct marker;
  * Type of marker probe functions. They receive the mdata and need to parse the
  * format string to recover the variable argument list.
  */
-typedef void marker_probe_func(void *probe_private, void *call_private,
+typedef void marker_probe_func(const struct marker *mdata,
+		void *probe_private, void *call_private,
 		const char *fmt, va_list *args);
 
 struct marker_probe_closure {
@@ -49,7 +51,7 @@ struct marker {
 	DEFINE_IMV(char, state);/* Immediate value state. */
 	char ptype;		/* probe type : 0 : single, 1 : multi */
 				/* Probe wrapper */
-	u16 chan_id;		/* Numeric channel identifier, dynamic */
+	u16 channel_id;		/* Numeric channel identifier, dynamic */
 	u16 event_id;		/* Numeric event identifier, dynamic */
 	void (*call)(const struct marker *mdata, void *call_private, ...);
 	struct marker_probe_closure single;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
