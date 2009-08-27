Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbZH0Ccv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbZH0Ccv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbZH0Cct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:32:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:42091 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbZH0Ccq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=peoDlldKnJLr1SjL8zwFwtt0uLl5ckBagXhlj6jlaZ3x3uaeqc2gSDPt0IvkPwxF3q
         pQ8czdbdmuenLKgJV3PN7aEn6WM7JCle9hxX0D9/mptGxFZPEyotMRH9l/KOhjT9zoRJ
         emlJealRzjNl0mzluBfCaU2zTns+gc43l9wXA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/18] tracing: Kprobe-tracer supports more than 6 arguments
Date: Thu, 27 Aug 2009 04:32:09 +0200
Message-Id: <1251340337-5640-11-git-send-email-fweisbec@gmail.com>
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

Support up to 128 arguments to fetch for each kprobes event.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
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
LKML-Reference: <20090813203518.31965.96979.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |    2 +-
 kernel/trace/trace_kprobe.c         |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index efff6eb..c9c09b4 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -32,7 +32,7 @@ Synopsis of kprobe_events
  SYMBOL[+offs|-offs]	: Symbol+offset where the probe is inserted.
  MEMADDR		: Address where the probe is inserted.
 
- FETCHARGS		: Arguments.
+ FETCHARGS		: Arguments. Each probe can have up to 128 args.
   %REG	: Fetch register REG
   sN	: Fetch Nth entry of stack (N >= 0)
   sa	: Fetch stack address.
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 0c4f00a..6d488ef 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -32,7 +32,7 @@
 #include "trace.h"
 #include "trace_output.h"
 
-#define TRACE_KPROBE_ARGS 6
+#define MAX_TRACE_ARGS 128
 #define MAX_ARGSTR_LEN 63
 
 /* currently, trace_kprobe only supports X86. */
@@ -184,11 +184,15 @@ struct trace_probe {
 		struct kretprobe	rp;
 	};
 	const char		*symbol;	/* symbol name */
-	unsigned int		nr_args;
-	struct fetch_func	args[TRACE_KPROBE_ARGS];
 	struct ftrace_event_call	call;
+	unsigned int		nr_args;
+	struct fetch_func	args[];
 };
 
+#define SIZEOF_TRACE_PROBE(n)			\
+	(offsetof(struct trace_probe, args) +	\
+	(sizeof(struct fetch_func) * (n)))
+
 static int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_trace_func(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
@@ -263,11 +267,11 @@ static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
 
 static struct trace_probe *alloc_trace_probe(const char *symbol,
-					     const char *event)
+					     const char *event, int nargs)
 {
 	struct trace_probe *tp;
 
-	tp = kzalloc(sizeof(struct trace_probe), GFP_KERNEL);
+	tp = kzalloc(SIZEOF_TRACE_PROBE(nargs), GFP_KERNEL);
 	if (!tp)
 		return ERR_PTR(-ENOMEM);
 
@@ -573,9 +577,10 @@ static int create_trace_probe(int argc, char **argv)
 		if (offset && is_return)
 			return -EINVAL;
 	}
+	argc -= 2; argv += 2;
 
 	/* setup a probe */
-	tp = alloc_trace_probe(symbol, event);
+	tp = alloc_trace_probe(symbol, event, argc);
 	if (IS_ERR(tp))
 		return PTR_ERR(tp);
 
@@ -594,8 +599,8 @@ static int create_trace_probe(int argc, char **argv)
 		kp->addr = addr;
 
 	/* parse arguments */
-	argc -= 2; argv += 2; ret = 0;
-	for (i = 0; i < argc && i < TRACE_KPROBE_ARGS; i++) {
+	ret = 0;
+	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
 		if (strlen(argv[i]) > MAX_ARGSTR_LEN) {
 			pr_info("Argument%d(%s) is too long.\n", i, argv[i]);
 			ret = -ENOSPC;
-- 
1.6.2.3

