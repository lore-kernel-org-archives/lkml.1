Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbZFJFoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbZFJFoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZFJFmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:42:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZFJFmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:52 -0400
Message-Id: <20090610054253.759019830@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:11 -0400
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
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 05/11] tracing: use << to print < instead of \<
Content-Disposition: inline; filename=0005-tracing-use-to-print-instead-of.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The print formats are passed through sprintf for processing. This means that
we can not use % or \ unless we process it for printk. Trying to use \< to
print a single < breaks the sprintf processing.

Instead, to print a single '<' a '<<' is used instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_read_binary.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
index a4b5eaa..d005138 100644
--- a/kernel/trace/trace_read_binary.c
+++ b/kernel/trace/trace_read_binary.c
@@ -35,7 +35,7 @@ static struct trace_seq buffer;
  * FALSE := print when field is zero or NULL
  * NAME := the name to write when a match is found
  *
- * A '\<' would print '<'
+ * A '<<' would print '<'
  *
  * Commands:
  *  int       : Print the field out as an signed integer. The size of the field
@@ -555,11 +555,11 @@ ftrace_initialize_print(struct ftrace_event_call *event, const char *fmt, ...)
 				goto err_free;
 			break;
 		}
-		if (*(tok - 1) == '\\') {
+		if (*(tok + 1) == '<') {
 			ret = add_less_than(event, fmt, tok);
 			if (ret)
 				goto err_free;
-			fmt = tok + 1;
+			fmt = tok + 2;
 			continue;
 		}
 
-- 
1.6.3.1

-- 
