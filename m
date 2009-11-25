Return-Path: <linux-kernel-owner+w=401wt.eu-S934575AbZKYHRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbZKYHRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbZKYHQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:16:10 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:35501 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbZKYHQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:16:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WPwSYRgAyczEaZzamHx0+ggp288iiE98oIVYqOgVp27VWXSTPwMgegTjuNFPKNdn+o
         OvsZX1hyMhYuADBV1oYIDPuZPo+O94OI8nkm0OnXAUv2/M8caQPu4xISN91C6QHAECQP
         DsZWB5fs0FzbR98xp9nF/I93kWP40DCUeIlNQ=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [RFC][PATCH 7/7] perf trace: Add a scripts/perl/bin for perf trace shell scripts
Date: Wed, 25 Nov 2009 01:15:52 -0600
Message-Id: <1259133352-23685-8-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To capture the relevant events for a given Perl script and to avoid
having to continually remember and type in long command-lines, add a
scripts/perl/bin directory containing two simple shell scripts for
each Perl script, one for recording and one for processing/display.
For example, to record perf data for the rw-by-pid.pl script, run
scripts/perl/bin/rw-by-pid-record and to actually run the script and
display the output run scripts/perl/bin/rw-by-pid-report.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
 create mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-record
 create mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-report
 create mode 100644 tools/perf/scripts/perl/bin/rw-by-file-record
 create mode 100644 tools/perf/scripts/perl/bin/rw-by-file-report
 create mode 100644 tools/perf/scripts/perl/bin/rw-by-pid-record
 create mode 100644 tools/perf/scripts/perl/bin/rw-by-pid-report
 create mode 100644 tools/perf/scripts/perl/bin/wakeup-latency-record
 create mode 100644 tools/perf/scripts/perl/bin/wakeup-latency-report
 create mode 100644 tools/perf/scripts/perl/bin/workqueue-stats-record
 create mode 100644 tools/perf/scripts/perl/bin/workqueue-stats-report

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
-- 
1.6.4.GIT

