Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbZJLW0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbZJLW0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbZJLW0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:26:02 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48844 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234AbZJLW0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Nwajip/dfBKerpngb3pkPd2xR13MesgAUEwYGEBb6Tgmkrzaa1V1LvT4zLC9C9IJ7m
         TLg/1siYKvZQix4c8i+WBb/JIiljcHWAedgv0dCXa8tWYVrZ89stA/V1n+SLW9M9Fv63
         NUcc9U4v3+/2V7xJ6TmUyK4+lL57sioS3Y1bE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/7] tracing/kprobes: Make special variable names more self-explainable
Date: Tue, 13 Oct 2009 00:25:05 +0200
Message-Id: <1255386309-4992-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
References: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Rename special variables to more self-explainable names as below:
- $rv to $retval
- $sa to $stack
- $aN to $argN
- $sN to $stackN

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
LKML-Reference: <20091007222759.1684.3319.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |   22 +++++++-------
 kernel/trace/trace_kprobe.c         |   52 ++++++++++++++++-------------------
 2 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 4208253..1541524 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -35,13 +35,13 @@ Synopsis of kprobe_events
  MEMADDR	: Address where the probe is inserted.
 
  FETCHARGS	: Arguments. Each probe can have up to 128 args.
-  %REG	: Fetch register REG
-  @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
+  %REG		: Fetch register REG
+  @ADDR		: Fetch memory at ADDR (ADDR should be in kernel)
   @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
-  $sN	: Fetch Nth entry of stack (N >= 0)
-  $sa	: Fetch stack address.
-  $aN	: Fetch function argument. (N >= 0)(*)
-  $rv	: Fetch return value.(**)
+  $stackN	: Fetch Nth entry of stack (N >= 0)
+  $stack	: Fetch stack address.
+  $argN		: Fetch function argument. (N >= 0)(*)
+  $retval	: Fetch return value.(**)
   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(***)
   NAME=FETCHARG: Set NAME as the argument name of FETCHARG.
 
@@ -84,13 +84,13 @@ Usage examples
 To add a probe as a new event, write a new definition to kprobe_events
 as below.
 
-  echo p:myprobe do_sys_open dfd=$a0 filename=$a1 flags=$a2 mode=$a3 > /sys/kernel/debug/tracing/kprobe_events
+  echo p:myprobe do_sys_open dfd=$arg0 filename=$arg1 flags=$arg2 mode=$arg3 > /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kprobe on the top of do_sys_open() function with recording
 1st to 4th arguments as "myprobe" event. As this example shows, users can
 choose more familiar names for each arguments.
 
-  echo r:myretprobe do_sys_open $rv >> /sys/kernel/debug/tracing/kprobe_events
+  echo r:myretprobe do_sys_open $retval >> /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kretprobe on the return point of do_sys_open() function with
 recording return value as "myretprobe" event.
@@ -137,11 +137,11 @@ events, you need to enable it.
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
            <...>-1447  [001] 1038282.286875: myprobe: (do_sys_open+0x0/0xd6) dfd=3 filename=7fffd1ec4440 flags=8000 mode=0
-           <...>-1447  [001] 1038282.286878: myretprobe: (sys_openat+0xc/0xe <- do_sys_open) $rv=fffffffffffffffe
+           <...>-1447  [001] 1038282.286878: myretprobe: (sys_openat+0xc/0xe <- do_sys_open) $retval=fffffffffffffffe
            <...>-1447  [001] 1038282.286885: myprobe: (do_sys_open+0x0/0xd6) dfd=ffffff9c filename=40413c flags=8000 mode=1b6
-           <...>-1447  [001] 1038282.286915: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $rv=3
+           <...>-1447  [001] 1038282.286915: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $retval=3
            <...>-1447  [001] 1038282.286969: myprobe: (do_sys_open+0x0/0xd6) dfd=ffffff9c filename=4041c6 flags=98800 mode=10
-           <...>-1447  [001] 1038282.286976: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $rv=3
+           <...>-1447  [001] 1038282.286976: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $retval=3
 
 
  Each line shows when the kernel hits an event, and <- SYMBOL means kernel
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ba6d3bd..3313fa7 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -215,22 +215,22 @@ static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
 	int ret = -EINVAL;
 
 	if (ff->func == fetch_argument)
-		ret = snprintf(buf, n, "$a%lu", (unsigned long)ff->data);
+		ret = snprintf(buf, n, "$arg%lu", (unsigned long)ff->data);
 	else if (ff->func == fetch_register) {
 		const char *name;
 		name = regs_query_register_name((unsigned int)((long)ff->data));
 		ret = snprintf(buf, n, "%%%s", name);
 	} else if (ff->func == fetch_stack)
-		ret = snprintf(buf, n, "$s%lu", (unsigned long)ff->data);
+		ret = snprintf(buf, n, "$stack%lu", (unsigned long)ff->data);
 	else if (ff->func == fetch_memory)
 		ret = snprintf(buf, n, "@0x%p", ff->data);
 	else if (ff->func == fetch_symbol) {
 		struct symbol_cache *sc = ff->data;
 		ret = snprintf(buf, n, "@%s%+ld", sc->symbol, sc->offset);
 	} else if (ff->func == fetch_retvalue)
-		ret = snprintf(buf, n, "$rv");
+		ret = snprintf(buf, n, "$retval");
 	else if (ff->func == fetch_stack_address)
-		ret = snprintf(buf, n, "$sa");
+		ret = snprintf(buf, n, "$stack");
 	else if (ff->func == fetch_indirect) {
 		struct indirect_fetch_data *id = ff->data;
 		size_t l = 0;
@@ -427,40 +427,36 @@ static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
 	int ret = 0;
 	unsigned long param;
 
-	switch (arg[0]) {
-	case 'a':	/* argument */
-		ret = strict_strtoul(arg + 1, 10, &param);
-		if (ret || param > PARAM_MAX_ARGS)
-			ret = -EINVAL;
-		else {
-			ff->func = fetch_argument;
-			ff->data = (void *)param;
-		}
-		break;
-	case 'r':	/* retval or retaddr */
-		if (is_return && arg[1] == 'v') {
+	if (strcmp(arg, "retval") == 0) {
+		if (is_return) {
 			ff->func = fetch_retvalue;
 			ff->data = NULL;
 		} else
 			ret = -EINVAL;
-		break;
-	case 's':	/* stack */
-		if (arg[1] == 'a') {
+	} else if (strncmp(arg, "stack", 5) == 0) {
+		if (arg[5] == '\0') {
 			ff->func = fetch_stack_address;
 			ff->data = NULL;
-		} else {
-			ret = strict_strtoul(arg + 1, 10, &param);
+		} else if (isdigit(arg[5])) {
+			ret = strict_strtoul(arg + 5, 10, &param);
 			if (ret || param > PARAM_MAX_STACK)
 				ret = -EINVAL;
 			else {
 				ff->func = fetch_stack;
 				ff->data = (void *)param;
 			}
+		} else
+			ret = -EINVAL;
+	} else if (strncmp(arg, "arg", 3) == 0 && isdigit(arg[3])) {
+		ret = strict_strtoul(arg + 3, 10, &param);
+		if (ret || param > PARAM_MAX_ARGS)
+			ret = -EINVAL;
+		else {
+			ff->func = fetch_argument;
+			ff->data = (void *)param;
 		}
-		break;
-	default:
+	} else
 		ret = -EINVAL;
-	}
 	return ret;
 }
 
@@ -548,10 +544,10 @@ static int create_trace_probe(int argc, char **argv)
 	 *  - Add kprobe: p[:[GRP/]EVENT] KSYM[+OFFS]|KADDR [FETCHARGS]
 	 *  - Add kretprobe: r[:[GRP/]EVENT] KSYM[+0] [FETCHARGS]
 	 * Fetch args:
-	 *  $aN	: fetch Nth of function argument. (N:0-)
-	 *  $rv	: fetch return value
-	 *  $sa	: fetch stack address
-	 *  $sN	: fetch Nth of stack (N:0-)
+	 *  $argN	: fetch Nth of function argument. (N:0-)
+	 *  $retval	: fetch return value
+	 *  $stack	: fetch stack address
+	 *  $stackN	: fetch Nth of stack (N:0-)
 	 *  @ADDR	: fetch memory at ADDR (ADDR should be in kernel)
 	 *  @SYM[+|-offs] : fetch memory at SYM +|- offs (SYM is a data symbol)
 	 *  %REG	: fetch register REG
-- 
1.6.2.3

