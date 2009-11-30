Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZK3IXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZK3IXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZK3IXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:23:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:37831 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZK3IXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:23:33 -0500
Date: Mon, 30 Nov 2009 08:23:15 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259133352-23685-8-git-send-email-tzanussi@gmail.com>
References: <1259133352-23685-8-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/scripting] perf trace: Add a scripts/perl/bin for perf trace shell scripts
Message-ID: <tip-1ae4a971250c55e473ca53c78011fcf73809885d@git.kernel.org>
Git-Commit-ID: 1ae4a971250c55e473ca53c78011fcf73809885d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ae4a971250c55e473ca53c78011fcf73809885d
Gitweb:     http://git.kernel.org/tip/1ae4a971250c55e473ca53c78011fcf73809885d
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 25 Nov 2009 01:15:52 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Nov 2009 10:04:27 +0100

perf trace: Add a scripts/perl/bin for perf trace shell scripts

To capture the relevant events for a given Perl script and to
avoid having to continually remember and type in long
command-lines, add a scripts/perl/bin directory containing two
simple shell scripts for each Perl script, one for recording and
one for processing/display. For example, to record perf data for
the rw-by-pid.pl script, run scripts/perl/bin/rw-by-pid-record
and to actually run the script and display the output run
scripts/perl/bin/rw-by-pid-report.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: anton@samba.org
Cc: hch@infradead.org
LKML-Reference: <1259133352-23685-8-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 .../perf/scripts/perl/bin/check-perf-trace-record  |    7 +++++++
 .../perf/scripts/perl/bin/check-perf-trace-report  |    5 +++++
 tools/perf/scripts/perl/bin/rw-by-file-record      |    2 ++
 tools/perf/scripts/perl/bin/rw-by-file-report      |    5 +++++
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 ++
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    5 +++++
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    6 ++++++
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    5 +++++
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 ++
 tools/perf/scripts/perl/bin/workqueue-stats-report |    6 ++++++
 10 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-record b/tools/perf/scripts/perl/bin/check-perf-trace-record
new file mode 100644
index 0000000..c7ec5de
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/check-perf-trace-record
@@ -0,0 +1,7 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry
+
+
+
+
+
diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-report b/tools/perf/scripts/perl/bin/check-perf-trace-report
new file mode 100644
index 0000000..89948b0
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/check-perf-trace-report
@@ -0,0 +1,5 @@
+#!/bin/bash
+perf trace -s ~/libexec/perf-core/scripts/perl/check-perf-trace.pl
+
+
+
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-record b/tools/perf/scripts/perl/bin/rw-by-file-record
new file mode 100644
index 0000000..b25056e
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/rw-by-file-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_enter_write
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
new file mode 100644
index 0000000..f5dcf9c
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -0,0 +1,5 @@
+#!/bin/bash
+perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl
+
+
+
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-record b/tools/perf/scripts/perl/bin/rw-by-pid-record
new file mode 100644
index 0000000..8903979
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-report b/tools/perf/scripts/perl/bin/rw-by-pid-report
new file mode 100644
index 0000000..cea16f7
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-report
@@ -0,0 +1,5 @@
+#!/bin/bash
+perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
+
+
+
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-record b/tools/perf/scripts/perl/bin/wakeup-latency-record
new file mode 100644
index 0000000..6abedda
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-record
@@ -0,0 +1,6 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e sched:sched_switch -e sched:sched_wakeup
+
+
+
+
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-report b/tools/perf/scripts/perl/bin/wakeup-latency-report
new file mode 100644
index 0000000..85769dc
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-report
@@ -0,0 +1,5 @@
+#!/bin/bash
+perf trace -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
+
+
+
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-record b/tools/perf/scripts/perl/bin/workqueue-stats-record
new file mode 100644
index 0000000..fce6637
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
new file mode 100644
index 0000000..aa68435
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-report
@@ -0,0 +1,6 @@
+#!/bin/bash
+perf trace -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
+
+
+
+
