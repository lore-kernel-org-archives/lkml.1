Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZL3ShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZL3ShH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZL3ShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:37:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:35616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbZL3ShF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:37:05 -0500
Date: Wed, 30 Dec 2009 18:36:32 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mhiramat@redhat.com
In-Reply-To: <4B273D27.5040009@cn.fujitsu.com>
References: <4B273D27.5040009@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/kprobe: Show sign of fields in trace_kprobe format files
Message-ID: <tip-79b408210885b9f7f0b067b07a09d68f4da3a700@git.kernel.org>
Git-Commit-ID: 79b408210885b9f7f0b067b07a09d68f4da3a700
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79b408210885b9f7f0b067b07a09d68f4da3a700
Gitweb:     http://git.kernel.org/tip/79b408210885b9f7f0b067b07a09d68f4da3a700
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 15 Dec 2009 15:39:19 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 30 Dec 2009 10:27:03 -0500

tracing/kprobe: Show sign of fields in trace_kprobe format files

The format files of trace_kprobe do not show the sign of the fields.
The other format files show the field signed type of the fields and
this patch makes the trace_kprobe formats consistent with the others.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D27.5040009@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ecab06..83f1e6e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1182,10 +1182,11 @@ static int __probe_event_show_format(struct trace_seq *s,
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
