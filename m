Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbZHZNF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbZHZNF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932962AbZHZNFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:05:25 -0400
Received: from pan.madism.org ([88.191.52.104]:57218 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbZHZNFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:05:25 -0400
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: do not complain if root is owning perf.data
Date: Wed, 26 Aug 2009 15:05:26 +0200
Message-Id: <1251291926-27174-1-git-send-email-pierre.habouzit@intersec.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This improves patch fa6963b24 so that perf.data stuff that has been dumped
as root can be read (annotate/report) by a user without the use of the
--force.

Rationale is that root has plenty of ways to screw us (usually) that do
not require twisted schemes involving specially crafting a perf.data.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-report.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 5e17de9..5010952 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -1335,8 +1335,8 @@ static int __cmd_annotate(void)
 		exit(-1);
 	}
 
-	if (!force && (stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && stat.st_uid && (stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8b2ec88..b8a75f6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1857,8 +1857,8 @@ static int __cmd_report(void)
 		exit(-1);
 	}
 
-	if (!force && (stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && stat.st_uid && (stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
-- 
1.6.4.1.331.gda1d56

