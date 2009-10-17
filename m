Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZJQAIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZJQAIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZJQAIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:08:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbZJQAIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:08:02 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 9/9] perf: Add perf-probe document
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 16 Oct 2009 20:08:27 -0400
Message-ID: <20091017000827.16556.73539.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add perf-probe subcommand document and add it to command-list.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
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
---

 tools/perf/Documentation/perf-probe.txt |   48 +++++++++++++++++++++++++++++++
 tools/perf/command-list.txt             |    1 +
 2 files changed, 49 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-probe.txt

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
new file mode 100644
index 0000000..6b6c6ae
--- /dev/null
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -0,0 +1,48 @@
+perf-probe(1)
+=============
+
+NAME
+----
+perf-probe - Define new dynamic tracepoints
+
+SYNOPSIS
+--------
+[verse]
+'perf probe' [-k <file>] -P 'PROBE' [-P 'PROBE' ...]
+
+
+DESCRIPTION
+-----------
+This command defines dynamic tracepoint events, by symbol and registers
+without debuginfo, or by C expressions (C line numbers, C function names,
+and C local variables) with debuginfo.
+
+
+OPTIONS
+-------
+-k::
+--vmlinux::
+	Specify vmlinux path which has debuginfo (Dwarf binary).
+
+-v::
+--verbose::
+        Be more verbose (show parsed arguments, etc).
+
+-P::
+--probe::
+	Define a probe point (see PROBE SYNTAX for detail)
+
+PROBE SYNTAX
+------------
+Probe points are defined by following syntax.
+
+ "TYPE:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]"
+
+'TYPE' specifies the type of probe point, you can use either "p" (kprobe) or "r" (kretprobe) for 'TYPE'. 'GRP' specifies the group name of this probe, and 'NAME' specifies the event name. If 'GRP' is omitted, "kprobes" is used for its group name.
+'FUNC' and 'OFFS' specifies function and offset (in byte) where probe will be put. In addition, 'SRC' specifies a source file which has that function (this is mainly for inline functions).
+You can specify a probe point by the source line number by using '@SRC:LINE' syntax, where 'SRC' is the source file path and 'LINE' is the line number.
+'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
+
+SEE ALSO
+--------
+linkperf:perf-trace[1], linkperf:perf-record[1]
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 00326e2..6475db4 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -11,3 +11,4 @@ perf-stat			mainporcelain common
 perf-timechart			mainporcelain common
 perf-top			mainporcelain common
 perf-trace			mainporcelain common
+perf-probe			mainporcelain common


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
