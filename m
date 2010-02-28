Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031629Ab0B1I6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:58:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:40288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031588Ab0B1I6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:58:22 -0500
Date: Sun, 28 Feb 2010 08:57:55 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de
In-Reply-To: <1265267295-8388-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1265267295-8388-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Fix and add misc documentally things
Message-ID: <tip-84c6f88fc8265d7a712d7d6ed8fc1a878dfc84d1@git.kernel.org>
Git-Commit-ID: 84c6f88fc8265d7a712d7d6ed8fc1a878dfc84d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Feb 2010 08:58:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84c6f88fc8265d7a712d7d6ed8fc1a878dfc84d1
Gitweb:     http://git.kernel.org/tip/84c6f88fc8265d7a712d7d6ed8fc1a878dfc84d1
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 4 Feb 2010 16:08:15 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sat, 27 Feb 2010 17:05:22 +0100

perf lock: Fix and add misc documentally things

I've forgot to add 'perf lock' line to command-list.txt,
so users of perf could not find perf lock when they type 'perf'.

Fixing command-list.txt requires document
(tools/perf/Documentation/perf-lock.txt).
But perf lock is too much "under construction" to write a
stable document, so this is something like pseudo document for now.

And I wrote description of perf lock at help section of
CONFIG_LOCK_STAT, this will navigate users of lock trace events.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
LKML-Reference: <1265267295-8388-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/Kconfig.debug                      |    6 ++++++
 tools/perf/Documentation/perf-lock.txt |   29 +++++++++++++++++++++++++++++
 tools/perf/command-list.txt            |    1 +
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..65f964e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -520,6 +520,12 @@ config LOCK_STAT
 
 	 For more details, see Documentation/lockstat.txt
 
+	 You can analyze lock events with "perf lock", subcommand of perf.
+	 If you want to use "perf lock", you need to turn on CONFIG_EVENT_TRACING.
+
+	 CONFIG_LOCK_STAT defines "contended" and "acquired" lock events.
+ 	 (CONFIG_LOCKDEP defines "acquire" and "release" events.)
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP
diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
new file mode 100644
index 0000000..b317102
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
+You can analyze various lock behaviours
+and statistics with this 'perf lock' command.
+
+  'perf lock record <command>' records lock events
+  between start and end <command>. And this command
+  produces the file "perf.data" which contains tracing
+  results of lock events.
+
+  'perf lock trace' shows raw lock events.
+
+  'perf lock report' reports statistical data.
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
