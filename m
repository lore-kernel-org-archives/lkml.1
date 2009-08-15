Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZHOKH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZHOKH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZHOKHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:52686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZHOKHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:07:20 -0400
Date: Sat, 15 Aug 2009 10:06:52 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, drepper@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090814182632.GF3490@ghostprotocols.net>
References: <20090814182632.GF3490@ghostprotocols.net>
Subject: [tip:perfcounters/urgent] perf record: Fix typo in pid_synthesize_comm_event
Message-ID: <tip-39e6dd73502f64e2ae3236b304e160ae30de9384@git.kernel.org>
Git-Commit-ID: 39e6dd73502f64e2ae3236b304e160ae30de9384
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 10:06:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39e6dd73502f64e2ae3236b304e160ae30de9384
Gitweb:     http://git.kernel.org/tip/39e6dd73502f64e2ae3236b304e160ae30de9384
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 14 Aug 2009 15:26:32 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 11:59:06 +0200

perf record: Fix typo in pid_synthesize_comm_event

We were using 'fd' locally, but there was a global 'fd' too, so
when converting from open to fopen the test made against fd
should be made against 'fp', but since we have that global
it didnt get discovered ...

Reported-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090814182632.GF3490@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3d051b9..89a5ddc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -219,7 +219,7 @@ static pid_t pid_synthesize_comm_event(pid_t pid, int full)
 	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
 
 	fp = fopen(filename, "r");
-	if (fd == NULL) {
+	if (fp == NULL) {
 		/*
 		 * We raced with a task exiting - just return:
 		 */
