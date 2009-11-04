Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZKDARm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZKDARm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZKDARl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:17:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZKDARk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:17:40 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 1/5] perf/probe: Update
	Documentation/perf-probe.txt
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 03 Nov 2009 19:12:13 -0500
Message-ID: <20091104001212.3454.19415.stgit@harusame>
In-Reply-To: <20091104001204.3454.75999.stgit@harusame>
References: <20091104001204.3454.75999.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Documentation/perf-probe.txt accoding to syntax change.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/Documentation/perf-probe.txt |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 6b6c6ae..c47e54e 100644
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
+'FUNC' specifies a probed function name, and it may have one of following options; '+OFFS' is the offset from function entry address in byte, 'RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. In addition, 'SRC' specifies a source file which has that function.
+It is also possible to specify a probe point by the source line number by using 'SRC:ALN' syntax, where 'SRC' is the source file path and 'ALN' is the line number.
 'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
 
 SEE ALSO


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
