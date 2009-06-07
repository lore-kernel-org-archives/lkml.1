Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZFGQBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZFGQBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 12:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZFGQBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 12:01:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:56357 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZFGQBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 12:01:05 -0400
Date: Sun, 7 Jun 2009 16:00:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Print more expressive message in case of file open error
Message-ID: <tip-a14832ff977e78d1982cdf78cdabb1f2320d9ac8@git.kernel.org>
Git-Commit-ID: a14832ff977e78d1982cdf78cdabb1f2320d9ac8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 16:00:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a14832ff977e78d1982cdf78cdabb1f2320d9ac8
Gitweb:     http://git.kernel.org/tip/a14832ff977e78d1982cdf78cdabb1f2320d9ac8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 7 Jun 2009 17:58:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 17:58:23 +0200

perf report: Print more expressive message in case of file open error

Before:

 $ perf report
 failed to open file: No such file or directory

After:

 $ perf report
  failed to open file: perf.data  (try 'perf record' first)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 242e09f..f053a74 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1120,7 +1120,10 @@ static int __cmd_report(void)
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
-		perror("failed to open file");
+		fprintf(stderr, " failed to open file: %s", input_name);
+		if (!strcmp(input_name, "perf.data"))
+			fprintf(stderr, "  (try 'perf record' first)");
+		fprintf(stderr, "\n");
 		exit(-1);
 	}
 
