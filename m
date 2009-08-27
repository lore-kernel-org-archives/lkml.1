Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZH0Cdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZH0Cdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZH0Cdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:33:39 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54351 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbZH0CdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=EsuK4gX79aE+Al0Mqho0Ri1WmsqDgTmY/9CZcH/Jz7kpuduxgkVkOGpDxlY0iqX8HP
         pQ9q6BvdtQUfMpKLbOHb52Bh7K1tXR6TzNHIxr7AjglS3qSUeiOmlzJ/IliaX1f9fEnH
         MfIQvJkWjfH6El5wjknSac80eBBu4dKPlEL8w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 17/18] tracing/kprobes: Change trace_arg to probe_arg
Date: Thu, 27 Aug 2009 04:32:16 +0200
Message-Id: <1251340337-5640-18-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Change trace_arg_string() and parse_trace_arg() to probe_arg_string()
and parse_probe_arg(), since those are kprobe-tracer local functions.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
LKML-Reference: <20090821194351.12478.15247.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kprobe.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1a9ca79..f4ec3fc 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -220,7 +220,7 @@ static __kprobes void *probe_address(struct trace_probe *tp)
 	return (probe_is_return(tp)) ? tp->rp.kp.addr : tp->kp.addr;
 }
 
-static int trace_arg_string(char *buf, size_t n, struct fetch_func *ff)
+static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
 {
 	int ret = -EINVAL;
 
@@ -250,7 +250,7 @@ static int trace_arg_string(char *buf, size_t n, struct fetch_func *ff)
 		if (ret >= n)
 			goto end;
 		l += ret;
-		ret = trace_arg_string(buf + l, n - l, &id->orig);
+		ret = probe_arg_string(buf + l, n - l, &id->orig);
 		if (ret < 0)
 			goto end;
 		l += ret;
@@ -408,7 +408,7 @@ static int split_symbol_offset(char *symbol, long *offset)
 #define PARAM_MAX_ARGS 16
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
-static int parse_trace_arg(char *arg, struct fetch_func *ff, int is_return)
+static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 {
 	int ret = 0;
 	unsigned long param;
@@ -499,7 +499,7 @@ static int parse_trace_arg(char *arg, struct fetch_func *ff, int is_return)
 			if (!id)
 				return -ENOMEM;
 			id->offset = offset;
-			ret = parse_trace_arg(arg, &id->orig, is_return);
+			ret = parse_probe_arg(arg, &id->orig, is_return);
 			if (ret)
 				kfree(id);
 			else {
@@ -617,7 +617,7 @@ static int create_trace_probe(int argc, char **argv)
 			ret = -ENOSPC;
 			goto error;
 		}
-		ret = parse_trace_arg(argv[i], &tp->args[i], is_return);
+		ret = parse_probe_arg(argv[i], &tp->args[i], is_return);
 		if (ret)
 			goto error;
 	}
@@ -680,7 +680,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 		seq_printf(m, " 0x%p", probe_address(tp));
 
 	for (i = 0; i < tp->nr_args; i++) {
-		ret = trace_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
+		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
 		if (ret < 0) {
 			pr_warning("Argument%d decoding error(%d).\n", i, ret);
 			return ret;
@@ -997,7 +997,7 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 		sprintf(buf, "arg%d", i);
 		DEFINE_FIELD(unsigned long, args[i], buf, 0);
 		/* Set argument string as an alias field */
-		ret = trace_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
+		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
 		if (ret < 0)
 			return ret;
 		DEFINE_FIELD(unsigned long, args[i], buf, 0);
@@ -1024,7 +1024,7 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 		sprintf(buf, "arg%d", i);
 		DEFINE_FIELD(unsigned long, args[i], buf, 0);
 		/* Set argument string as an alias field */
-		ret = trace_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
+		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
 		if (ret < 0)
 			return ret;
 		DEFINE_FIELD(unsigned long, args[i], buf, 0);
@@ -1041,7 +1041,7 @@ static int __probe_event_show_format(struct trace_seq *s,
 
 	/* Show aliases */
 	for (i = 0; i < tp->nr_args; i++) {
-		ret = trace_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
+		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
 		if (ret < 0)
 			return ret;
 		if (!trace_seq_printf(s, "\talias: %s;\toriginal: arg%d;\n",
-- 
1.6.2.3

