Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZGUBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZGUBqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZGUBqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:46:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47622 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbZGUBqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:46:10 -0400
Message-Id: <20090721014609.019651017@goodmis.org>
References: <20090721014528.716901277@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Jul 2009 21:45:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/4] tracing/events: add missing type info of dynamic arrays
Content-Disposition: inline; filename=0001-tracing-events-add-missing-type-info-of-dynamic-arra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The format file doesn't contain enough information for
__dynamic_array/__string. The type name is missing.

Before:
  # cat format:
  name: irq_handler_entry
  ...
          field:__data_loc name;  offset:16;      size:2;

After:
  # cat format:
  name: irq_handler_entry
  ...
          field:__data_loc char[] name;  offset:16;      size:2;

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4A5E962E.9020900@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1867553..cc78943 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -120,7 +120,7 @@
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
-	ret = trace_seq_printf(s, "\tfield:__data_loc " #item ";\t"	       \
+	ret = trace_seq_printf(s, "\tfield:__data_loc " #type "[] " #item ";\t"\
 			       "offset:%u;\tsize:%u;\n",		       \
 			       (unsigned int)offsetof(typeof(field),	       \
 					__data_loc_##item),		       \
@@ -279,7 +279,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
-	ret = trace_define_field(event_call, "__data_loc" "[" #type "]", #item,\
+	ret = trace_define_field(event_call, "__data_loc " #type "[]", #item,  \
 				offsetof(typeof(field), __data_loc_##item),    \
 				 sizeof(field.__data_loc_##item), 0);
 
-- 
1.6.3.3

-- 
