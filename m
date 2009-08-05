Return-Path: <linux-kernel-owner+w=401wt.eu-S933845AbZHEITe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbZHEITe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933768AbZHEITd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:19:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:38362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933637AbZHEITa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:19:30 -0400
Date: Wed, 5 Aug 2009 08:19:00 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4A5E962E.9020900@cn.fujitsu.com>
References: <4A5E962E.9020900@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: add missing type info of dynamic arrays
Message-ID: <tip-68fd60a8c8bca6af51805c45f286f0f2572ac977@git.kernel.org>
Git-Commit-ID: 68fd60a8c8bca6af51805c45f286f0f2572ac977
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 08:19:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68fd60a8c8bca6af51805c45f286f0f2572ac977
Gitweb:     http://git.kernel.org/tip/68fd60a8c8bca6af51805c45f286f0f2572ac977
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 16 Jul 2009 10:53:34 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 20 Jul 2009 10:52:51 -0400

tracing/events: add missing type info of dynamic arrays

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
 
