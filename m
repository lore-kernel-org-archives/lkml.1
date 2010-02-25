Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0BYKJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:09:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:47574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab0BYKJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:09:05 -0500
Date: Thu, 25 Feb 2010 10:08:11 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264580883-15324-8-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-8-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/scripts: Add syscall tracing scripts
Message-ID: <tip-4d161f0360d00d46a89827b3fd6da395f00c5d90@git.kernel.org>
Git-Commit-ID: 4d161f0360d00d46a89827b3fd6da395f00c5d90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:08:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d161f0360d00d46a89827b3fd6da395f00c5d90
Gitweb:     http://git.kernel.org/tip/4d161f0360d00d46a89827b3fd6da395f00c5d90
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 27 Jan 2010 02:27:58 -0600
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 25 Feb 2010 04:07:48 +0100

perf/scripts: Add syscall tracing scripts

Adds a set of scripts that aggregate system call totals and system
call errors.  Most are Python scripts that also test basic
functionality of the new Python engine, but there's also one Perl
script added for comparison and for reference in some new
Documentation contained in a later patch.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1264580883-15324-8-git-send-email-tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile                                |    3 +
 .../perf/scripts/perl/bin/check-perf-trace-record  |    2 +-
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +
 tools/perf/scripts/perl/bin/failed-syscalls-report |    4 +
 tools/perf/scripts/perl/failed-syscalls.pl         |   38 +++++++++
 .../python/bin/failed-syscalls-by-pid-record       |    2 +
 .../python/bin/failed-syscalls-by-pid-report       |    4 +
 .../python/bin/syscall-counts-by-pid-record        |    2 +
 .../python/bin/syscall-counts-by-pid-report        |    4 +
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +
 .../perf/scripts/python/bin/syscall-counts-report  |    4 +
 tools/perf/scripts/python/check-perf-trace.py      |   83 ++++++++++++++++++++
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   68 ++++++++++++++++
 tools/perf/scripts/python/syscall-counts-by-pid.py |   64 +++++++++++++++
 tools/perf/scripts/python/syscall-counts.py        |   58 ++++++++++++++
 15 files changed, 339 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1427316..54a5b50 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1032,7 +1032,10 @@ install: all
 	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
 	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
+	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
+	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 
 ifdef BUILT_INS
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-record b/tools/perf/scripts/perl/bin/check-perf-trace-record
index 3c15744..e6cb147 100644
--- a/tools/perf/scripts/perl/bin/check-perf-trace-record
+++ b/tools/perf/scripts/perl/bin/check-perf-trace-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry
+perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry -e kmem:kfree
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-record b/tools/perf/scripts/perl/bin/failed-syscalls-record
new file mode 100644
index 0000000..f8885d3
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_exit
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-report b/tools/perf/scripts/perl/bin/failed-syscalls-report
new file mode 100644
index 0000000..8bfc660
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-report
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: system-wide failed syscalls
+# args: [comm]
+perf trace -s ~/libexec/perf-core/scripts/perl/failed-syscalls.pl $1
diff --git a/tools/perf/scripts/perl/failed-syscalls.pl b/tools/perf/scripts/perl/failed-syscalls.pl
new file mode 100644
index 0000000..c18e7e2
--- /dev/null
+++ b/tools/perf/scripts/perl/failed-syscalls.pl
@@ -0,0 +1,38 @@
+# failed system call counts
+# (c) 2010, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Displays system-wide failed system call totals
+# If a [comm] arg is specified, only syscalls called by [comm] are displayed.
+
+use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+use lib "./Perf-Trace-Util/lib";
+use Perf::Trace::Core;
+use Perf::Trace::Context;
+use Perf::Trace::Util;
+
+my %failed_syscalls;
+
+sub raw_syscalls::sys_exit
+{
+	my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	    $common_pid, $common_comm,
+	    $id, $ret) = @_;
+
+	if ($ret < 0) {
+	    $failed_syscalls{$common_comm}++;
+	}
+}
+
+sub trace_end
+{
+    printf("\nfailed syscalls by comm:\n\n");
+
+    printf("%-20s  %10s\n", "comm", "# errors");
+    printf("%-20s  %6s  %10s\n", "--------------------", "----------");
+
+    foreach my $comm (sort {$failed_syscalls{$b} <=> $failed_syscalls{$a}}
+		      keys %failed_syscalls) {
+	    printf("%-20s  %10s\n", $comm, $failed_syscalls{$comm});
+    }
+}
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
new file mode 100644
index 0000000..f8885d3
--- /dev/null
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_exit
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
new file mode 100644
index 0000000..1e0c0a8
--- /dev/null
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: system-wide failed syscalls, by pid
+# args: [comm]
+perf trace -s ~/libexec/perf-core/scripts/python/failed-syscalls-by-pid.py $1
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
new file mode 100644
index 0000000..45a8c50
--- /dev/null
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
new file mode 100644
index 0000000..f8044d1
--- /dev/null
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: system-wide syscall counts, by pid
+# args: [comm]
+perf trace -s ~/libexec/perf-core/scripts/python/syscall-counts-by-pid.py $1
diff --git a/tools/perf/scripts/python/bin/syscall-counts-record b/tools/perf/scripts/python/bin/syscall-counts-record
new file mode 100644
index 0000000..45a8c50
--- /dev/null
+++ b/tools/perf/scripts/python/bin/syscall-counts-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter
diff --git a/tools/perf/scripts/python/bin/syscall-counts-report b/tools/perf/scripts/python/bin/syscall-counts-report
new file mode 100644
index 0000000..a366aa6
--- /dev/null
+++ b/tools/perf/scripts/python/bin/syscall-counts-report
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: system-wide syscall counts
+# args: [comm]
+perf trace -s ~/libexec/perf-core/scripts/python/syscall-counts.py $1
diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/scripts/python/check-perf-trace.py
new file mode 100644
index 0000000..964d934
--- /dev/null
+++ b/tools/perf/scripts/python/check-perf-trace.py
@@ -0,0 +1,83 @@
+# perf trace event handlers, generated by perf trace -g python
+# (c) 2010, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# This script tests basic functionality such as flag and symbol
+# strings, common_xxx() calls back into perf, begin, end, unhandled
+# events, etc.  Basically, if this script runs successfully and
+# displays expected results, Python scripting support should be ok.
+
+import os
+import sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from Core import *
+from perf_trace_context import *
+
+unhandled = autodict()
+
+def trace_begin():
+	print "trace_begin"
+	pass
+
+def trace_end():
+        print_unhandled()
+
+def irq__softirq_entry(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	vec):
+		print_header(event_name, common_cpu, common_secs, common_nsecs,
+			common_pid, common_comm)
+
+                print_uncommon(context)
+
+		print "vec=%s\n" % \
+		(symbol_str("irq__softirq_entry", "vec", vec)),
+
+def kmem__kmalloc(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	call_site, ptr, bytes_req, bytes_alloc,
+	gfp_flags):
+		print_header(event_name, common_cpu, common_secs, common_nsecs,
+			common_pid, common_comm)
+
+                print_uncommon(context)
+
+		print "call_site=%u, ptr=%u, bytes_req=%u, " \
+		"bytes_alloc=%u, gfp_flags=%s\n" % \
+		(call_site, ptr, bytes_req, bytes_alloc,
+
+		flag_str("kmem__kmalloc", "gfp_flags", gfp_flags)),
+
+def trace_unhandled(event_name, context, common_cpu, common_secs, common_nsecs,
+		common_pid, common_comm):
+    try:
+        unhandled[event_name] += 1
+    except TypeError:
+        unhandled[event_name] = 1
+
+def print_header(event_name, cpu, secs, nsecs, pid, comm):
+	print "%-20s %5u %05u.%09u %8u %-20s " % \
+	(event_name, cpu, secs, nsecs, pid, comm),
+
+# print trace fields not included in handler args
+def print_uncommon(context):
+    print "common_preempt_count=%d, common_flags=%s, common_lock_depth=%d, " \
+        % (common_pc(context), trace_flag_str(common_flags(context)), \
+               common_lock_depth(context))
+
+def print_unhandled():
+    keys = unhandled.keys()
+    if not keys:
+        return
+
+    print "\nunhandled events:\n\n",
+
+    print "%-40s  %10s\n" % ("event", "count"),
+    print "%-40s  %10s\n" % ("----------------------------------------", \
+                                 "-----------"),
+
+    for event_name in keys:
+	print "%-40s  %10d\n" % (event_name, unhandled[event_name])
diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/perf/scripts/python/failed-syscalls-by-pid.py
new file mode 100644
index 0000000..0ca0227
--- /dev/null
+++ b/tools/perf/scripts/python/failed-syscalls-by-pid.py
@@ -0,0 +1,68 @@
+# failed system call counts, by pid
+# (c) 2010, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Displays system-wide failed system call totals, broken down by pid.
+# If a [comm] arg is specified, only syscalls called by [comm] are displayed.
+
+import os
+import sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+
+usage = "perf trace -s syscall-counts-by-pid.py [comm]\n";
+
+for_comm = None
+
+if len(sys.argv) > 2:
+	sys.exit(usage)
+
+if len(sys.argv) > 1:
+	for_comm = sys.argv[1]
+
+syscalls = autodict()
+
+def trace_begin():
+	pass
+
+def trace_end():
+	print_error_totals()
+
+def raw_syscalls__sys_exit(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, ret):
+	if for_comm is not None:
+		if common_comm != for_comm:
+			return
+
+	if ret < 0:
+		try:
+			syscalls[common_comm][common_pid][id][ret] += 1
+		except TypeError:
+			syscalls[common_comm][common_pid][id][ret] = 1
+
+def print_error_totals():
+    if for_comm is not None:
+	    print "\nsyscall errors for %s:\n\n" % (for_comm),
+    else:
+	    print "\nsyscall errors:\n\n",
+
+    print "%-30s  %10s\n" % ("comm [pid]", "count"),
+    print "%-30s  %10s\n" % ("------------------------------", \
+                                 "----------"),
+
+    comm_keys = syscalls.keys()
+    for comm in comm_keys:
+	    pid_keys = syscalls[comm].keys()
+	    for pid in pid_keys:
+		    print "\n%s [%d]\n" % (comm, pid),
+		    id_keys = syscalls[comm][pid].keys()
+		    for id in id_keys:
+			    print "  syscall: %-16d\n" % (id),
+			    ret_keys = syscalls[comm][pid][id].keys()
+			    for ret, val in sorted(syscalls[comm][pid][id].iteritems(), key = lambda(k, v): (v, k),  reverse = True):
+				    print "    err = %-20d  %10d\n" % (ret, val),
diff --git a/tools/perf/scripts/python/syscall-counts-by-pid.py b/tools/perf/scripts/python/syscall-counts-by-pid.py
new file mode 100644
index 0000000..af722d6
--- /dev/null
+++ b/tools/perf/scripts/python/syscall-counts-by-pid.py
@@ -0,0 +1,64 @@
+# system call counts, by pid
+# (c) 2010, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Displays system-wide system call totals, broken down by syscall.
+# If a [comm] arg is specified, only syscalls called by [comm] are displayed.
+
+import os
+import sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+
+usage = "perf trace -s syscall-counts-by-pid.py [comm]\n";
+
+for_comm = None
+
+if len(sys.argv) > 2:
+	sys.exit(usage)
+
+if len(sys.argv) > 1:
+	for_comm = sys.argv[1]
+
+syscalls = autodict()
+
+def trace_begin():
+	pass
+
+def trace_end():
+	print_syscall_totals()
+
+def raw_syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	if for_comm is not None:
+		if common_comm != for_comm:
+			return
+	try:
+		syscalls[common_comm][common_pid][id] += 1
+	except TypeError:
+		syscalls[common_comm][common_pid][id] = 1
+
+def print_syscall_totals():
+    if for_comm is not None:
+	    print "\nsyscall events for %s:\n\n" % (for_comm),
+    else:
+	    print "\nsyscall events by comm/pid:\n\n",
+
+    print "%-40s  %10s\n" % ("comm [pid]/syscalls", "count"),
+    print "%-40s  %10s\n" % ("----------------------------------------", \
+                                 "----------"),
+
+    comm_keys = syscalls.keys()
+    for comm in comm_keys:
+	    pid_keys = syscalls[comm].keys()
+	    for pid in pid_keys:
+		    print "\n%s [%d]\n" % (comm, pid),
+		    id_keys = syscalls[comm][pid].keys()
+		    for id, val in sorted(syscalls[comm][pid].iteritems(), \
+				  key = lambda(k, v): (v, k),  reverse = True):
+			    print "  %-38d  %10d\n" % (id, val),
diff --git a/tools/perf/scripts/python/syscall-counts.py b/tools/perf/scripts/python/syscall-counts.py
new file mode 100644
index 0000000..f977e85
--- /dev/null
+++ b/tools/perf/scripts/python/syscall-counts.py
@@ -0,0 +1,58 @@
+# system call counts
+# (c) 2010, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Displays system-wide system call totals, broken down by syscall.
+# If a [comm] arg is specified, only syscalls called by [comm] are displayed.
+
+import os
+import sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+
+usage = "perf trace -s syscall-counts.py [comm]\n";
+
+for_comm = None
+
+if len(sys.argv) > 2:
+	sys.exit(usage)
+
+if len(sys.argv) > 1:
+	for_comm = sys.argv[1]
+
+syscalls = autodict()
+
+def trace_begin():
+	pass
+
+def trace_end():
+	print_syscall_totals()
+
+def raw_syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	if for_comm is not None:
+		if common_comm != for_comm:
+			return
+	try:
+		syscalls[id] += 1
+	except TypeError:
+		syscalls[id] = 1
+
+def print_syscall_totals():
+    if for_comm is not None:
+	    print "\nsyscall events for %s:\n\n" % (for_comm),
+    else:
+	    print "\nsyscall events:\n\n",
+
+    print "%-40s  %10s\n" % ("event", "count"),
+    print "%-40s  %10s\n" % ("----------------------------------------", \
+                                 "-----------"),
+
+    for id, val in sorted(syscalls.iteritems(), key = lambda(k, v): (v, k), \
+				  reverse = True):
+	    print "%-40d  %10d\n" % (id, val),
