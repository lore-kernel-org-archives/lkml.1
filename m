Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbZH1Lwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbZH1Lwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 07:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZH1Lwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 07:52:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:51310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZH1Lww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 07:52:52 -0400
Date: Fri, 28 Aug 2009 11:52:09 GMT
From: tip-bot for Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, pierre.habouzit@intersec.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       pierre.habouzit@intersec.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090827075902.GF19653@laphroaig.corp>
References: <20090827075902.GF19653@laphroaig.corp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: do not complain if root is owning perf.data
Message-ID: <tip-119e7a22bb70d84849384e5113792cd45afa4f85@git.kernel.org>
Git-Commit-ID: 119e7a22bb70d84849384e5113792cd45afa4f85
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 11:52:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  119e7a22bb70d84849384e5113792cd45afa4f85
Gitweb:     http://git.kernel.org/tip/119e7a22bb70d84849384e5113792cd45afa4f85
Author:     Pierre Habouzit <pierre.habouzit@intersec.com>
AuthorDate: Thu, 27 Aug 2009 09:59:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Aug 2009 13:47:43 +0200

perf tools: do not complain if root is owning perf.data

This improves patch fa6963b24 so that perf.data stuff that has
been dumped as root can be read (annotate/report) by a user
without the use of the --force.

Rationale is that root has plenty of ways to screw us (usually)
that do not require twisted schemes involving specially
crafting a perf.data.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
LKML-Reference: <20090827075902.GF19653@laphroaig.corp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-report.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4ac618b..4c7bc44 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -984,8 +984,8 @@ static int __cmd_annotate(void)
 		exit(-1);
 	}
 
-	if (!force && (input_stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d2e2882..ea6328a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1405,8 +1405,8 @@ static int __cmd_report(void)
 		exit(-1);
 	}
 
-	if (!force && (input_stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
