Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030596Ab0B0S0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:26:37 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:42978 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030444Ab0B0SZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kUakwBjsprtOukLgiW8AV5JovhVhbx+oEODE3F22dXUzKFO8y5bWLMIMslA2YnSrMO
         gWfOTvCM9PMDjGPAGmsWmnCaZb/mDlo7rony+QjVJ9uBu96nZAgNlrMY347i9CI1UEgh
         1ruEFE8X4LtxYuLYLv5lSehfsH8DKtRW/GEKQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] perf lock: Fix and add misc documentally things
Date: Sat, 27 Feb 2010 19:25:30 +0100
Message-Id: <1267295133-6320-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
References: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

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
 create mode 100644 tools/perf/Documentation/perf-lock.txt

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
-- 
1.6.2.3

