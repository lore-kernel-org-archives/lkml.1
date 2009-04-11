Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZDKUaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZDKUaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZDKU3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:29:52 -0400
Received: from thunk.org ([69.25.196.29]:55353 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZDKU3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:29:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH, RFC 3/3] tracing: Add documentation for the power tracer
Date: Sat, 11 Apr 2009 15:51:19 -0400
Message-Id: <1239479479-2603-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239479479-2603-3-git-send-email-tytso@mit.edu>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu>
 <1239479479-2603-2-git-send-email-tytso@mit.edu>
 <1239479479-2603-3-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/power.txt |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power.txt

diff --git a/Documentation/power.txt b/Documentation/power.txt
new file mode 100644
index 0000000..16f95c9
--- /dev/null
+++ b/Documentation/power.txt
@@ -0,0 +1,19 @@
+The power trace collects detailed information about C-state and P-state
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
+
+    
-- 
1.5.6.3

