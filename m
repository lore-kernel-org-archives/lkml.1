Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbZFBEom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbZFBEom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbZFBEnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:43:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41669 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbZFBEni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:43:38 -0400
Message-Id: <20090602044339.977624129@goodmis.org>
References: <20090602044315.439593107@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 00:43:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 04/10] tracing/events: fix a typo in __string() format output
Content-Disposition: inline; filename=0004-tracing-events-fix-a-typo-in-__string-format-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

"tsize" should be "\tsize". Also remove the space before "__str_loc".

Before:
 # cat tracing/events/irq/irq_handler_entry/format
        ...
        field:int irq;  offset:12;      size:4;
        field: __str_loc name;  offset:16;tsize:2;
        ...

After:
 # cat tracing/events/irq/irq_handler_entry/format
	...
        field:int irq;  offset:12;      size:4;
        field:__str_loc name;   offset:16;      size:2;
	...

[ Impact: standardize __string field description in events format file ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index b4ec83a..9276ec4 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -209,8 +209,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
 #undef __string
 #define __string(item, src)						       \
-	ret = trace_seq_printf(s, "\tfield: __str_loc " #item ";\t"	       \
-			       "offset:%u;tsize:%u;\n",			       \
+	ret = trace_seq_printf(s, "\tfield:__str_loc " #item ";\t"	       \
+			       "offset:%u;\tsize:%u;\n",		       \
 			       (unsigned int)offsetof(typeof(field),	       \
 					__str_loc_##item),		       \
 			       (unsigned int)sizeof(field.__str_loc_##item));  \
-- 
1.6.3.1

-- 
