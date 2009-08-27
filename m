Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbZH0Cev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbZH0Cev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbZH0Cet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:34:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:53185 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbZH0Ccn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=o1WlFDjuLNWnHDO0RhJmrX2NAzkE2POzN6SsKsbASvhLaZ0oZ45hIEQAzlamFl6Nib
         yCc5RMiOxNTpThX183WINfXLsf+dOpmQ6edvIkBaA6pkrT+aEgD/P/IMcgevEZgmOvSe
         A6csNubPtgjd0zBa/G8AhNpQ7YRFsUoAi4oek=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Avi Kivity <avi@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
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
Subject: [PATCH 09/18] tracing: Add kprobe-based event tracer documentation
Date: Thu, 27 Aug 2009 04:32:08 +0200
Message-Id: <1251340337-5640-10-git-send-email-fweisbec@gmail.com>
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

Add the documentation to use the kprobe based event tracer.

[fweisbec@gmail.com: Split tracer and its Documentation in two patchs]

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
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
LKML-Reference: <20090813203510.31965.29123.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |  139 +++++++++++++++++++++++++++++++++++
 1 files changed, 139 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/trace/kprobetrace.txt

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
new file mode 100644
index 0000000..efff6eb
--- /dev/null
+++ b/Documentation/trace/kprobetrace.txt
@@ -0,0 +1,139 @@
+                         Kprobe-based Event Tracer
+                         =========================
+
+                 Documentation is written by Masami Hiramatsu
+
+
+Overview
+--------
+This tracer is similar to the events tracer which is based on Tracepoint
+infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
+and kretprobe). It probes anywhere where kprobes can probe(this means, all
+functions body except for __kprobes functions).
+
+Unlike the function tracer, this tracer can probe instructions inside of
+kernel functions. It allows you to check which instruction has been executed.
+
+Unlike the Tracepoint based events tracer, this tracer can add and remove
+probe points on the fly.
+
+Similar to the events tracer, this tracer doesn't need to be activated via
+current_tracer, instead of that, just set probe points via
+/sys/kernel/debug/tracing/kprobe_events. And you can set filters on each
+probe events via /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.
+
+
+Synopsis of kprobe_events
+-------------------------
+  p[:EVENT] SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]	: Set a probe
+  r[:EVENT] SYMBOL[+0] [FETCHARGS]			: Set a return probe
+
+ EVENT			: Event name.
+ SYMBOL[+offs|-offs]	: Symbol+offset where the probe is inserted.
+ MEMADDR		: Address where the probe is inserted.
+
+ FETCHARGS		: Arguments.
+  %REG	: Fetch register REG
+  sN	: Fetch Nth entry of stack (N >= 0)
+  sa	: Fetch stack address.
+  @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
+  @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
+  aN	: Fetch function argument. (N >= 0)(*)
+  rv	: Fetch return value.(**)
+  ra	: Fetch return address.(**)
+  +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.(***)
+
+  (*) aN may not correct on asmlinkaged functions and at the middle of
+      function body.
+  (**) only for return probe.
+  (***) this is useful for fetching a field of data structures.
+
+
+Per-Probe Event Filtering
+-------------------------
+ Per-probe event filtering feature allows you to set different filter on each
+probe and gives you what arguments will be shown in trace buffer. If an event
+name is specified right after 'p:' or 'r:' in kprobe_events, the tracer adds
+an event under tracing/events/kprobes/<EVENT>, at the directory you can see
+'id', 'enabled', 'format' and 'filter'.
+
+enabled:
+  You can enable/disable the probe by writing 1 or 0 on it.
+
+format:
+  It shows the format of this probe event. It also shows aliases of arguments
+ which you specified to kprobe_events.
+
+filter:
+  You can write filtering rules of this event. And you can use both of aliase
+ names and field names for describing filters.
+
+
+Usage examples
+--------------
+To add a probe as a new event, write a new definition to kprobe_events
+as below.
+
+  echo p:myprobe do_sys_open a0 a1 a2 a3 > /sys/kernel/debug/tracing/kprobe_events
+
+ This sets a kprobe on the top of do_sys_open() function with recording
+1st to 4th arguments as "myprobe" event.
+
+  echo r:myretprobe do_sys_open rv ra >> /sys/kernel/debug/tracing/kprobe_events
+
+ This sets a kretprobe on the return point of do_sys_open() function with
+recording return value and return address as "myretprobe" event.
+ You can see the format of these events via
+/sys/kernel/debug/tracing/events/kprobes/<EVENT>/format.
+
+  cat /sys/kernel/debug/tracing/events/kprobes/myprobe/format
+name: myprobe
+ID: 23
+format:
+	field:unsigned short common_type;	offset:0;	size:2;
+	field:unsigned char common_flags;	offset:2;	size:1;
+	field:unsigned char common_preempt_count;	offset:3;	size:1;
+	field:int common_pid;	offset:4;	size:4;
+	field:int common_tgid;	offset:8;	size:4;
+
+	field: unsigned long ip;	offset:16;tsize:8;
+	field: int nargs;	offset:24;tsize:4;
+	field: unsigned long arg0;	offset:32;tsize:8;
+	field: unsigned long arg1;	offset:40;tsize:8;
+	field: unsigned long arg2;	offset:48;tsize:8;
+	field: unsigned long arg3;	offset:56;tsize:8;
+
+	alias: a0;	original: arg0;
+	alias: a1;	original: arg1;
+	alias: a2;	original: arg2;
+	alias: a3;	original: arg3;
+
+print fmt: "%lx: 0x%lx 0x%lx 0x%lx 0x%lx", ip, arg0, arg1, arg2, arg3
+
+
+ You can see that the event has 4 arguments and alias expressions
+corresponding to it.
+
+  echo > /sys/kernel/debug/tracing/kprobe_events
+
+ This clears all probe points. and you can see the traced information via
+/sys/kernel/debug/tracing/trace.
+
+  cat /sys/kernel/debug/tracing/trace
+# tracer: nop
+#
+#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
+#              | |       |          |         |
+           <...>-1447  [001] 1038282.286875: do_sys_open+0x0/0xd6: 0x3 0x7fffd1ec4440 0x8000 0x0
+           <...>-1447  [001] 1038282.286878: sys_openat+0xc/0xe <- do_sys_open: 0xfffffffffffffffe 0xffffffff81367a3a
+           <...>-1447  [001] 1038282.286885: do_sys_open+0x0/0xd6: 0xffffff9c 0x40413c 0x8000 0x1b6
+           <...>-1447  [001] 1038282.286915: sys_open+0x1b/0x1d <- do_sys_open: 0x3 0xffffffff81367a3a
+           <...>-1447  [001] 1038282.286969: do_sys_open+0x0/0xd6: 0xffffff9c 0x4041c6 0x98800 0x10
+           <...>-1447  [001] 1038282.286976: sys_open+0x1b/0x1d <- do_sys_open: 0x3 0xffffffff81367a3a
+
+
+ Each line shows when the kernel hits a probe, and <- SYMBOL means kernel
+returns from SYMBOL(e.g. "sys_open+0x1b/0x1d <- do_sys_open" means kernel
+returns from do_sys_open to sys_open+0x1b).
+
+
-- 
1.6.2.3

