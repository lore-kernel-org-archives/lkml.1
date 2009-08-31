Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZHaIiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZHaIiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZHaIiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:38:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:57245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZHaIiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:38:14 -0400
Date: Mon, 31 Aug 2009 08:37:43 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1251693921-6579-3-git-send-email-fweisbec@gmail.com>
References: <1251693921-6579-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Unify swapper tasks naming
Message-ID: <tip-9b8055a52c8986167e0a7357460d528a00db67e6@git.kernel.org>
Git-Commit-ID: 9b8055a52c8986167e0a7357460d528a00db67e6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 08:37:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b8055a52c8986167e0a7357460d528a00db67e6
Gitweb:     http://git.kernel.org/tip/9b8055a52c8986167e0a7357460d528a00db67e6
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 31 Aug 2009 06:45:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 10:04:49 +0200

perf tools: Unify swapper tasks naming

In perf tools, we hardcode the pid 0 cmdline resolving to
"idle" because the init task is not included in the COMM
events.

But the idle tasks secondary cpus are resolved into their
"init" name through the COMM events.

We have then such strange result in perf report (ditto with
trace):

    19.66%       init    [kernel]          [k] acpi_idle_enter_c1
    17.32%       [idle]  [kernel]          [k] acpi_idle_enter_c1

It's then better to unify the swapper tasks into a single init
name.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1251693921-6579-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>


---
 tools/perf/util/thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 3acd37f..7635928 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -85,7 +85,7 @@ register_idle_thread(struct rb_root *threads, struct thread **last_match)
 {
 	struct thread *thread = threads__findnew(0, threads, last_match);
 
-	if (!thread || thread__set_comm(thread, "[idle]")) {
+	if (!thread || thread__set_comm(thread, "[init]")) {
 		fprintf(stderr, "problem inserting idle task.\n");
 		exit(-1);
 	}
