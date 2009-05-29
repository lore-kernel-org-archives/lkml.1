Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZE2DXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZE2DXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 23:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZE2DXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 23:23:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59348 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZE2DXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 23:23:38 -0400
Message-ID: <4A1F558B.2050705@cn.fujitsu.com>
Date: Fri, 29 May 2009 11:24:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/events: fix a typo in __string() format output
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be '\t'. Also remove the space before "__str_loc".

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

[ Impact: fix the output of __string field in format file ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index edb02bc..006af4c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -187,8 +187,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
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
1.5.4.rc3
