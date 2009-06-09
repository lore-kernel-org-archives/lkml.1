Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZFIVyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZFIVyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758446AbZFIVxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:53:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910AbZFIVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:53:38 -0400
Message-Id: <20090609215340.000084253@goodmis.org>
References: <20090609215211.307980196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 17:52:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 7/8] tracing/events: modify lockdep print to new format
Content-Disposition: inline; filename=0007-tracing-events-modify-lockdep-print-to-new-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use new format for better parsing of lockdep events.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/lockdep.h |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 0e956c9..f9d74c8 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -27,9 +27,8 @@ TRACE_EVENT(lock_acquire,
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s%s%s", (__entry->flags & 1) ? "try " : "",
-		  (__entry->flags & 2) ? "read " : "",
-		  __get_str(name))
+	TP_FORMAT("<ifmask:flags:1:try :><ifmask:flags:2:read :>"
+		  "<string:name>")
 );
 
 TRACE_EVENT(lock_release,
@@ -46,7 +45,7 @@ TRACE_EVENT(lock_release,
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_FORMAT("<string:name>")
 );
 
 #ifdef CONFIG_LOCK_STAT
@@ -65,7 +64,7 @@ TRACE_EVENT(lock_contended,
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_FORMAT("<string:name>")
 );
 
 TRACE_EVENT(lock_acquired,
@@ -83,8 +82,7 @@ TRACE_EVENT(lock_acquired,
 		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
 		__entry->wait_usec = (unsigned long) waittime;
 	),
-	TP_printk("%s (%lu.%03lu us)", __get_str(name), __entry->wait_usec,
-				       __entry->wait_nsec_rem)
+	TP_FORMAT("<sting:name> (<uint:wait_usec>.<printf:wait_nsec_rem:03lu> us)")
 );
 
 #endif
-- 
1.6.3.1

-- 
