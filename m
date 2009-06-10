Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbZFJFo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbZFJFo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbZFJFm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:42:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45676 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbZFJFmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:53 -0400
Message-Id: <20090610054254.618822592@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:15 -0400
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
Subject: [PATCH 09/11] tracing: check full name for field
Content-Disposition: inline; filename=0009-tracing-check-full-name-for-field.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The check for print format fields only compared the name of the field
up to the length of the field to look for. But it did not test if the
field name itself matched but was larger. The wrong field could be
found as a match.

 ie. str could match str_arr.

[ Impact: fix the matching of fields ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_read_binary.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
index 9ff4ed8..779de20 100644
--- a/kernel/trace/trace_read_binary.c
+++ b/kernel/trace/trace_read_binary.c
@@ -388,7 +388,8 @@ find_field(struct ftrace_event_call *call, const char *name, int len)
 	struct ftrace_event_field *field;
 
 	list_for_each_entry(field, &call->fields, link) {
-		if (!strncmp(field->name, name, len))
+		if (!strncmp(field->name, name, len) &&
+		    !field->name[len])
 			return field;
 	}
 
-- 
1.6.3.1

-- 
