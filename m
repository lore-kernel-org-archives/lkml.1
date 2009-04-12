Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZDLNBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZDLNBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZDLNBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:01:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:40220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZDLNBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:01:13 -0400
Date: Sun, 12 Apr 2009 13:00:39 GMT
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, tytso@mit.edu, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, arjan@linux.intel.com, srostedt@redhat.com,
       tglx@linutronix.de, tytso@mit.edu, mingo@elte.hu
In-Reply-To: <1239479479-2603-4-git-send-email-tytso@mit.edu>
References: <1239479479-2603-4-git-send-email-tytso@mit.edu>
Subject: [tip:tracing/core] tracing: Add documentation for the power tracer
Message-ID: <tip-56c49951747f250d8398582509e02ae5ce1d36d1@git.kernel.org>
Git-Commit-ID: 56c49951747f250d8398582509e02ae5ce1d36d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 13:00:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56c49951747f250d8398582509e02ae5ce1d36d1
Gitweb:     http://git.kernel.org/tip/56c49951747f250d8398582509e02ae5ce1d36d1
Author:     Theodore Ts'o <tytso@mit.edu>
AuthorDate: Sat, 11 Apr 2009 15:51:19 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 14:51:42 +0200

tracing: Add documentation for the power tracer

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
LKML-Reference: <1239479479-2603-4-git-send-email-tytso@mit.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/trace/power.txt |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/power.txt b/Documentation/trace/power.txt
new file mode 100644
index 0000000..cd805e1
--- /dev/null
+++ b/Documentation/trace/power.txt
@@ -0,0 +1,17 @@
+The power tracer collects detailed information about C-state and P-state
+transitions, instead of just looking at the high-level "average"
+information.
+
+There is a helper script found in scrips/tracing/power.pl in the kernel
+sources which can be used to parse this information and create a
+Scalable Vector Graphics (SVG) picture from the trace data.
+
+To use this tracer:
+
+	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+	echo power > /sys/kernel/debug/tracing/current_tracer
+	echo 1 > /sys/kernel/debug/tracing/tracing_enabled
+	sleep 1
+	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+	cat /sys/kernel/debug/tracing/trace | \
+		perl scripts/tracing/power.pl > out.sv
