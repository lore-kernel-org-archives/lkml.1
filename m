Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZKDPZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZKDPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZKDPZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:25:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:57278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbZKDPZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:25:24 -0500
Date: Wed, 4 Nov 2009 15:24:48 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091104001212.3454.19415.stgit@harusame>
References: <20091104001212.3454.19415.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf/probes: Update Documentation/perf-probe.txt
Message-ID: <tip-c43f9d1e61e265c6bfafdd65c7f07c8d71a7efc3@git.kernel.org>
Git-Commit-ID: c43f9d1e61e265c6bfafdd65c7f07c8d71a7efc3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c43f9d1e61e265c6bfafdd65c7f07c8d71a7efc3
Gitweb:     http://git.kernel.org/tip/c43f9d1e61e265c6bfafdd65c7f07c8d71a7efc3
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 3 Nov 2009 19:12:13 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:02:46 +0100

perf/probes: Update Documentation/perf-probe.txt

Update Documentation/perf-probe.txt accoding to recent
syntax changes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091104001212.3454.19415.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-probe.txt |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 6b6c6ae..9270594 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -8,7 +8,9 @@ perf-probe - Define new dynamic tracepoints
 SYNOPSIS
 --------
 [verse]
-'perf probe' [-k <file>] -P 'PROBE' [-P 'PROBE' ...]
+'perf probe' [options] --add 'PROBE' [--add 'PROBE' ...]
+or
+'perf probe' [options] 'PROBE' ['PROBE' ...]
 
 
 DESCRIPTION
@@ -21,26 +23,25 @@ and C local variables) with debuginfo.
 OPTIONS
 -------
 -k::
---vmlinux::
+--vmlinux=PATH::
 	Specify vmlinux path which has debuginfo (Dwarf binary).
 
 -v::
 --verbose::
         Be more verbose (show parsed arguments, etc).
 
--P::
---probe::
+-a::
+--add::
 	Define a probe point (see PROBE SYNTAX for detail)
 
 PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
 
- "TYPE:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]"
+ "FUNC[+OFFS|:RLN|%return][@SRC]|SRC:ALN [ARG ...]"
 
-'TYPE' specifies the type of probe point, you can use either "p" (kprobe) or "r" (kretprobe) for 'TYPE'. 'GRP' specifies the group name of this probe, and 'NAME' specifies the event name. If 'GRP' is omitted, "kprobes" is used for its group name.
-'FUNC' and 'OFFS' specifies function and offset (in byte) where probe will be put. In addition, 'SRC' specifies a source file which has that function (this is mainly for inline functions).
-You can specify a probe point by the source line number by using '@SRC:LINE' syntax, where 'SRC' is the source file path and 'LINE' is the line number.
+'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, 'RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. In addition, 'SRC' specifies a source file which has that function.
+It is also possible to specify a probe point by the source line number by using 'SRC:ALN' syntax, where 'SRC' is the source file path and 'ALN' is the line number.
 'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
 
 SEE ALSO
