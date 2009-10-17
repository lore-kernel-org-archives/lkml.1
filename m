Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZJQKJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZJQKJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZJQKJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:09:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:33253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbZJQKJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:09:21 -0400
Date: Sat, 17 Oct 2009 10:06:55 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091017000827.16556.73539.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000827.16556.73539.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf: Add perf-probe document
Message-ID: <tip-595c36490deb49381dc51231a3d5e6b66786ed27@git.kernel.org>
Git-Commit-ID: 595c36490deb49381dc51231a3d5e6b66786ed27
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:06:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  595c36490deb49381dc51231a3d5e6b66786ed27
Gitweb:     http://git.kernel.org/tip/595c36490deb49381dc51231a3d5e6b66786ed27
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 16 Oct 2009 20:08:27 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Oct 2009 09:54:01 +0200

perf: Add perf-probe document

Add perf-probe subcommand document and add it to command-list.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091017000827.16556.73539.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-probe.txt |   48 +++++++++++++++++++++++++++++++
 tools/perf/command-list.txt             |    1 +
 2 files changed, 49 insertions(+), 0 deletions(-)

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
