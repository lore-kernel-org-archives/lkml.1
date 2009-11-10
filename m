Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZKJRq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZKJRq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbZKJRq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:46:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbZKJRq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:46:26 -0500
Date: Tue, 10 Nov 2009 18:45:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20091110174542.GA13642@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Pekka Enberg (1):
      perf tools: Fix permission checks

Thadeu Lima de Souza Cascardo (1):
      perf_events: Fix some typo in the perf events config description


 init/Kconfig                |    4 ++--
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 09c5c64..3b8c7bc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -937,7 +937,7 @@ config PERF_EVENTS
 	  Enable kernel support for various performance events provided
 	  by software and hardware.
 
-	  Software events are supported either build-in or via the
+	  Software events are supported either built-in or via the
 	  use of generic tracepoints.
 
 	  Most modern CPUs support performance events via performance
@@ -949,7 +949,7 @@ config PERF_EVENTS
 	  used to profile the code that runs on that CPU.
 
 	  The Linux Performance Event subsystem provides an abstraction of
-	  these software and hardware cevent apabilities, available via a
+	  these software and hardware event capabilities, available via a
 	  system call and used by the "perf" utility in tools/perf/. It
 	  provides per task and per CPU counters, and it provides event
 	  capabilities on top of those.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3eeef33..a4be453 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -426,7 +426,7 @@ try_again:
 	if (fd[nr_cpu][counter] < 0) {
 		int err = errno;
 
-		if (err == EPERM)
+		if (err == EPERM || err == EACCES)
 			die("Permission error - are you root?\n");
 		else if (err ==  ENODEV && profile_cpu != -1)
 			die("No such device - did you specify an out-of-range profile CPU?\n");
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a1b1d10..e23bc74 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1027,7 +1027,7 @@ try_again:
 	if (fd[i][counter] < 0) {
 		int err = errno;
 
-		if (err == EPERM)
+		if (err == EPERM || err == EACCES)
 			die("No permission - are you root?\n");
 		/*
 		 * If it's cycles then fall back to hrtimer
