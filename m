Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZGRJvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZGRJvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbZGRJve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:51:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:42287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZGRJvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:51:33 -0400
Date: Sat, 18 Jul 2009 09:50:53 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090716104817.803604373@samba.org>
References: <20090716104817.803604373@samba.org>
Subject: [tip:perfcounters/urgent] perf_counter: Make call graph option consistent
Message-ID: <tip-1483b19f8f5e8ad0c8816de368b099322dad4db5@git.kernel.org>
Git-Commit-ID: 1483b19f8f5e8ad0c8816de368b099322dad4db5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 09:50:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1483b19f8f5e8ad0c8816de368b099322dad4db5
Gitweb:     http://git.kernel.org/tip/1483b19f8f5e8ad0c8816de368b099322dad4db5
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 11:21:33 +0200

perf_counter: Make call graph option consistent

perf record uses -g for logging call graph data but perf report
uses -c to print call graph data. Be consistent and use -g
everywhere for call graph data.

Also update the help text to reflect the current default -
fractal,0.5

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090716104817.803604373@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4e5cc26..4b980cc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1891,9 +1891,9 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('c', "callchain", NULL, "output_type,min_percent",
+	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
 		     "Display callchains using output_type and min percent threshold. "
-		     "Default: flat,0", &parse_callchain_opt, callchain_default_opt),
+		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
 	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
