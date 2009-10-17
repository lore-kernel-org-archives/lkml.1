Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZJQKEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZJQKEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZJQKD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:03:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:36619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZJQKD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:03:58 -0400
Date: Sat, 17 Oct 2009 10:03:26 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, fche@redhat.com, paulus@samba.org,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       fche@redhat.com, linux-kernel@vger.kernel.org, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091007222748.1684.12711.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091007222748.1684.12711.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Remove '$ra' special variable
Message-ID: <tip-99329c44f28a1b7ac83beebfb4319e612042e319@git.kernel.org>
Git-Commit-ID: 99329c44f28a1b7ac83beebfb4319e612042e319
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:03:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99329c44f28a1b7ac83beebfb4319e612042e319
Gitweb:     http://git.kernel.org/tip/99329c44f28a1b7ac83beebfb4319e612042e319
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 7 Oct 2009 18:27:48 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 12 Oct 2009 19:24:05 +0200

tracing/kprobes: Remove '$ra' special variable

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
