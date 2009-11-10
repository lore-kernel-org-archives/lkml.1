Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZKJNZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZKJNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbZKJNZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:25:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:34286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320AbZKJNZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:25:55 -0500
Date: Tue, 10 Nov 2009 13:25:30 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257853855-28934-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257853855-28934-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add new document about perf-bench
Message-ID: <tip-9fbc04f2493929a69fd9e53b5fb53c127d7950d5@git.kernel.org>
Git-Commit-ID: 9fbc04f2493929a69fd9e53b5fb53c127d7950d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fbc04f2493929a69fd9e53b5fb53c127d7950d5
Gitweb:     http://git.kernel.org/tip/9fbc04f2493929a69fd9e53b5fb53c127d7950d5
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Tue, 10 Nov 2009 20:50:54 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 14:14:36 +0100

perf bench: Add new document about perf-bench

This patch adds new document about perf-bench.
Man page and html will be provided for user.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1257853855-28934-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-bench.txt |  120 +++++++++++++++++++++++++++++++
 1 files changed, 120 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
new file mode 100644
index 0000000..ae525ac
--- /dev/null
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -0,0 +1,120 @@
+perf-bench(1)
+============
+
+NAME
+----
+perf-bench - General framework for benchmark suites
+
+SYNOPSIS
+--------
+[verse]
+'perf bench' [<common options>] <subsystem> <suite> [<options>]
+
+DESCRIPTION
+-----------
+This 'perf bench' command is general framework for benchmark suites.
+
+COMMON OPTIONS
+--------------
+-f::
+--format=::
+Specify format style.
+Current available format styles are,
+
+'default'::
+Default style. This is mainly for human reading.
+---------------------
+% perf bench sched pipe                      # with no style specify
+(executing 1000000 pipe operations between two tasks)
+        Total time:5.855 sec
+                5.855061 usecs/op
+		170792 ops/sec
+---------------------
+
+'simple'::
+This simple style is friendly for automated
+processing by scripts.
+---------------------
+% perf bench --format=simple sched pipe      # specified simple
+5.988
+---------------------
+
+SUBSYSTEM
+---------
+
+'sched'::
+	Scheduler and IPC mechanisms.
+
+SUITES FOR 'sched'
+~~~~~~~~~~~~~~~~~~
+*messaging*::
+Suite for evaluating performance of scheduler and IPC mechanisms.
+Based on hackbench by Rusty Russell.
+
+Options of *pipe*
+^^^^^^^^^^^^^^^^^
+-p::
+--pipe::
+Use pipe() instead of socketpair()
+
+-t::
+--thread::
+Be multi thread instead of multi process
+
+-g::
+--group=::
+Specify number of groups
+
+-l::
+--loop=::
+Specify number of loops
+
+Example of *messaging*
+^^^^^^^^^^^^^^^^^^^^^^
+
+---------------------
+% perf bench sched messaging                 # run with default
+options (20 sender and receiver processes per group)
+(10 groups == 400 processes run)
+
+      Total time:0.308 sec
+
+% perf bench sched messaging -t -g 20        # be multi-thread,with 20 groups
+(20 sender and receiver threads per group)
+(20 groups == 800 threads run)
+
+      Total time:0.582 sec
+---------------------
+
+*pipe*::
+Suite for pipe() system call.
+Based on pipe-test-1m.c by Ingo Molnar.
+
+Options of *pipe*
+^^^^^^^^^^^^^^^^^
+-l::
+--loop=::
+Specify number of loops.
+
+Example of *pipe*
+^^^^^^^^^^^^^^^^^
+
+---------------------
+% perf bench sched pipe
+(executing 1000000 pipe operations between two tasks)
+
+        Total time:8.091 sec
+                8.091833 usecs/op
+                123581 ops/sec
+
+% perf bench sched pipe -l 1000              # loop 1000
+(executing 1000 pipe operations between two tasks)
+
+        Total time:0.016 sec
+                16.948000 usecs/op
+                59004 ops/sec
+---------------------
+
+SEE ALSO
+--------
+linkperf:perf[1]
