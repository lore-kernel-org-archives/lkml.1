Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0BDHIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:08:20 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51420 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab0BDHIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:08:18 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf lock: Fix and add misc documentally things
Date: Thu,  4 Feb 2010 16:08:15 +0900
Message-Id: <1265267295-8388-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20100201072752.GB12039@elte.hu>
References: <20100201072752.GB12039@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've forgot to add 'perf lock' line to command-list.txt,
so users of perf could not find perf lock when they type 'perf'.

Fixing command-list.txt requires document
(tools/perf/Documentation/perf-lock.txt).
But perf lock is too under construction tool to write document,
so this is something like pseudo document now.

And I wrote description of perf lock at help section of
CONFIG_LOCK_STAT, this will navigate users of lock trace events.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 lib/Kconfig.debug                      |    6 ++++++
 tools/perf/Documentation/perf-lock.txt |   29 +++++++++++++++++++++++++++++
 tools/perf/command-list.txt            |    1 +
 3 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-lock.txt

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..994d58c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -520,6 +520,12 @@ config LOCK_STAT
 
 	 For more details, see Documentation/lockstat.txt
 
+	 You can analyze lock events with "perf lock", subcommand of perf.
+	 If you want to use "perf lock", you need to turn on CONFIG_FTRACE.
+
+	 CONFIG_LOCK_STAT defines events of contended and acquired.
+ 	 (CONFIG_LOCKDEP defines events of acquire and release.)
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP
diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
new file mode 100644
index 0000000..77e6c74
--- /dev/null
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -0,0 +1,29 @@
+perf-lock(1)
+============
+
+NAME
+----
+perf-lock - Analyze lock events
+
+SYNOPSIS
+--------
+[verse]
+'perf lock' {record|report|trace}
+
+DESCRIPTION
+-----------
+You can analyze various lock behaviour
+and statistics with this 'perf lock' command.
+
+  'perf lock record <command>' records events of lock
+  between start and end <command>. And this command
+  produces the file "perf.data" which containts tracing
+  result of lock events.
+
+  'perf lock trace' shows raw events of lock.
+
+  'perf lock report' reoprts statistical data.
+
+SEE ALSO
+--------
+linkperf:perf[1]
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 9afcff2..db6ee94 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -18,3 +18,4 @@ perf-top			mainporcelain common
 perf-trace			mainporcelain common
 perf-probe			mainporcelain common
 perf-kmem			mainporcelain common
+perf-lock			mainporcelain common
-- 
1.6.5.2

