Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZCJVGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZCJVGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZCJVFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:05:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41976 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbZCJVFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:05:35 -0400
Message-Id: <20090310210530.633351762@goodmis.org>
References: <20090310210408.419131392@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 17:04:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/7] tracing: fix printk format specifier
Content-Disposition: inline; filename=0001-tracing-fix-printk-format-specifier.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The offsetof and sizeof are of type size_t, and instead of typecasting
them to unsigned int for printk formatting, one could just use %zu.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1880a64..a0b41cc 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -338,8 +338,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 #undef FIELD
 #define FIELD(type, name)						\
-	#type, #name, (unsigned int)offsetof(typeof(field), name),	\
-		(unsigned int)sizeof(field.name)
+	#type, #name, offsetof(typeof(field), name), sizeof(field.name)
 
 static int trace_write_header(struct trace_seq *s)
 {
@@ -347,11 +346,11 @@ static int trace_write_header(struct trace_seq *s)
 
 	/* struct trace_entry */
 	return trace_seq_printf(s,
-				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
-				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
-				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
-				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
-				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
+				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
+				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
+				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
+				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
+				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\n",
 				FIELD(unsigned char, type),
 				FIELD(unsigned char, flags),
-- 
1.6.1.3

-- 
