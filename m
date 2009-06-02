Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZFBUTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZFBUTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZFBUST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:18:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:39547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331AbZFBUSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:18:17 -0400
Date: Tue, 2 Jun 2009 20:17:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Separate out idle threads
Message-ID: <tip-436224a6d8bb3e29fe0cc18122f8d1f593da67b8@git.kernel.org>
Git-Commit-ID: 436224a6d8bb3e29fe0cc18122f8d1f593da67b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:17:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  436224a6d8bb3e29fe0cc18122f8d1f593da67b8
Gitweb:     http://git.kernel.org/tip/436224a6d8bb3e29fe0cc18122f8d1f593da67b8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 21:02:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:34 +0200

perf report: Separate out idle threads

Introduce the special comm name [idle] for idle theads.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 19c1e05..6d68f3a 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -612,6 +612,17 @@ static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 	return ret;
 }
 
+static void register_idle_thread(void)
+{
+	struct thread *thread = threads__findnew(0);
+
+	if (thread == NULL ||
+			thread__set_comm(thread, "[idle]")) {
+		fprintf(stderr, "problem inserting idle task.\n");
+		exit(-1);
+	}
+}
+
 
 static int __cmd_report(void)
 {
@@ -626,6 +637,8 @@ static int __cmd_report(void)
 	char cwd[PATH_MAX], *cwdp = cwd;
 	int cwdlen;
 
+	register_idle_thread();
+
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
 		perror("failed to open file");
