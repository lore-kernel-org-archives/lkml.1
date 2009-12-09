Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZLIHPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZLIHPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbZLIHPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:15:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52255 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbZLIHPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:15:51 -0500
Message-ID: <4B1F4E80.4050507@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 15:15:12 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/10] trace_kprobe: shows signs of fields in format files
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


format files of trace_kprobe don't shows signs, it is
different from all other format files, incorrect API to user.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index e3c80e9..3ef66d4 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1163,10 +1163,11 @@ static int __probe_event_show_format(struct trace_seq *s,
 #undef SHOW_FIELD
 #define SHOW_FIELD(type, item, name)					\
 	do {								\
-		ret = trace_seq_printf(s, "\tfield: " #type " %s;\t"	\
-				"offset:%u;\tsize:%u;\n", name,		\
+		ret = trace_seq_printf(s, "\tfield:" #type " %s;\t"	\
+				"offset:%u;\tsize:%u;\tsigned:%d;\n", name,\
 				(unsigned int)offsetof(typeof(field), item),\
-				(unsigned int)sizeof(type));		\
+				(unsigned int)sizeof(type),		\
+				is_signed_type(type));			\
 		if (!ret)						\
 			return 0;					\
 	} while (0)



