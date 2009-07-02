Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZGBTnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZGBTnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZGBTnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:43:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:46467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZGBTnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:43:31 -0400
Date: Thu, 2 Jul 2009 19:42:56 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1246558475-10624-3-git-send-email-fweisbec@gmail.com>
References: <1246558475-10624-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Display percents of hits in callchain with overhead colors
Message-ID: <tip-24b57c6988c5791628c89a8838910991abc9cc1e@git.kernel.org>
Git-Commit-ID: 24b57c6988c5791628c89a8838910991abc9cc1e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 19:42:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24b57c6988c5791628c89a8838910991abc9cc1e
Gitweb:     http://git.kernel.org/tip/24b57c6988c5791628c89a8838910991abc9cc1e
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 2 Jul 2009 20:14:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 21:38:38 +0200

perf_counter tools: Display percents of hits in callchain with overhead colors

This adds the use of colors to signal at a glance the important
overhead thresholds in callchains hit rates.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246558475-10624-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c9dbe33..283773d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -824,7 +824,7 @@ ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
 			double percent;
 
 			percent = hits * 100.0 / total_samples;
-			ret += fprintf(fp, "--%2.2f%%-- ", percent);
+			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
 		} else
 			ret += fprintf(fp, "%s", "          ");
 	}
@@ -924,7 +924,8 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 		chain = rb_entry(rb_node, struct callchain_node, rb_node);
 		percent = chain->hit * 100.0 / total_samples;
 		if (callchain_mode == FLAT) {
-			ret += fprintf(fp, "           %6.2f%%\n", percent);
+			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
+						     percent);
 			ret += callchain__fprintf_flat(fp, chain, total_samples);
 		} else if (callchain_mode == GRAPH) {
 			ret += callchain__fprintf_graph(fp, chain,
