Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZJLW0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZJLW0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbZJLW0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:26:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:30539 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543AbZJLW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AEK3bykn1/bkDfJArj+ncwi0eT6PXnaCgJqY9y4khuN4ESYAMsSQtcKHHEMj9cVaba
         cc7NLfCmTrYbaYLdcV2cWYUBOefZ08quJzrZxkBsYF1gy3K7FSmrvjERJsEvwSNCyGmc
         QsYdpQN51RRbZLb8aujpbe87Gg5qL3dmZBBGk=
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
Subject: [PATCH 2/7] tracing/kprobes: Remove '$ra' special variable
Date: Tue, 13 Oct 2009 00:25:04 +0200
Message-Id: <1255386309-4992-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
References: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Remove '$ra' (return address) because it is already shown at the head of
each entry.

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
LKML-Reference: <20091007222748.1684.12711.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |   13 ++++++-------
 kernel/trace/trace_kprobe.c         |   11 -----------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 33f5318..4208253 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -1,4 +1,4 @@
-                         Kprobe-based Event Tracer
+                        Kprobe-based Event Tracer
                          =========================
 
                  Documentation is written by Masami Hiramatsu
@@ -42,7 +42,6 @@ Synopsis of kprobe_events
   $sa	: Fetch stack address.
   $aN	: Fetch function argument. (N >= 0)(*)
   $rv	: Fetch return value.(**)
-  $ra	: Fetch return address.(**)
   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(***)
   NAME=FETCHARG: Set NAME as the argument name of FETCHARG.
 
@@ -91,10 +90,10 @@ as below.
 1st to 4th arguments as "myprobe" event. As this example shows, users can
 choose more familiar names for each arguments.
 
-  echo r:myretprobe do_sys_open $rv $ra >> /sys/kernel/debug/tracing/kprobe_events
+  echo r:myretprobe do_sys_open $rv >> /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kretprobe on the return point of do_sys_open() function with
-recording return value and return address as "myretprobe" event.
+recording return value as "myretprobe" event.
  You can see the format of these events via
 /sys/kernel/debug/tracing/events/kprobes/<EVENT>/format.
 
@@ -138,11 +137,11 @@ events, you need to enable it.
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
            <...>-1447  [001] 1038282.286875: myprobe: (do_sys_open+0x0/0xd6) dfd=3 filename=7fffd1ec4440 flags=8000 mode=0
-           <...>-1447  [001] 1038282.286878: myretprobe: (sys_openat+0xc/0xe <- do_sys_open) $rv=fffffffffffffffe $ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286878: myretprobe: (sys_openat+0xc/0xe <- do_sys_open) $rv=fffffffffffffffe
            <...>-1447  [001] 1038282.286885: myprobe: (do_sys_open+0x0/0xd6) dfd=ffffff9c filename=40413c flags=8000 mode=1b6
-           <...>-1447  [001] 1038282.286915: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $rv=3 $ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286915: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $rv=3
            <...>-1447  [001] 1038282.286969: myprobe: (do_sys_open+0x0/0xd6) dfd=ffffff9c filename=4041c6 flags=98800 mode=10
-           <...>-1447  [001] 1038282.286976: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $rv=3 $ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286976: myretprobe: (sys_open+0x1b/0x1d <- do_sys_open) $rv=3
 
 
  Each line shows when the kernel hits an event, and <- SYMBOL means kernel
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f63ead0..ba6d3bd 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -85,11 +85,6 @@ static __kprobes unsigned long fetch_retvalue(struct pt_regs *regs,
 	return regs_return_value(regs);
 }
 
-static __kprobes unsigned long fetch_ip(struct pt_regs *regs, void *dummy)
-{
-	return instruction_pointer(regs);
-}
-
 static __kprobes unsigned long fetch_stack_address(struct pt_regs *regs,
 						   void *dummy)
 {
@@ -234,8 +229,6 @@ static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
 		ret = snprintf(buf, n, "@%s%+ld", sc->symbol, sc->offset);
 	} else if (ff->func == fetch_retvalue)
 		ret = snprintf(buf, n, "$rv");
-	else if (ff->func == fetch_ip)
-		ret = snprintf(buf, n, "$ra");
 	else if (ff->func == fetch_stack_address)
 		ret = snprintf(buf, n, "$sa");
 	else if (ff->func == fetch_indirect) {
@@ -448,9 +441,6 @@ static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
 		if (is_return && arg[1] == 'v') {
 			ff->func = fetch_retvalue;
 			ff->data = NULL;
-		} else if (is_return && arg[1] == 'a') {
-			ff->func = fetch_ip;
-			ff->data = NULL;
 		} else
 			ret = -EINVAL;
 		break;
@@ -560,7 +550,6 @@ static int create_trace_probe(int argc, char **argv)
 	 * Fetch args:
 	 *  $aN	: fetch Nth of function argument. (N:0-)
 	 *  $rv	: fetch return value
-	 *  $ra	: fetch return address
 	 *  $sa	: fetch stack address
 	 *  $sN	: fetch Nth of stack (N:0-)
 	 *  @ADDR	: fetch memory at ADDR (ADDR should be in kernel)
-- 
1.6.2.3

