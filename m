Return-Path: <linux-kernel-owner+w=401wt.eu-S934169AbZHELTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169AbZHELTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZHELTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:19:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:56938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZHELTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:19:16 -0400
Date: Wed, 5 Aug 2009 11:18:37 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1249467921-10450-1-git-send-email-penberg@cs.helsinki.fi>
References: <1249467921-10450-1-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:perfcounters/urgent] perf report: Make --sort comm,dso,symbol the default
Message-ID: <tip-114cfab222233f50f46d7162cf7d99fdc6c271e5@git.kernel.org>
Git-Commit-ID: 114cfab222233f50f46d7162cf7d99fdc6c271e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 11:18:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  114cfab222233f50f46d7162cf7d99fdc6c271e5
Gitweb:     http://git.kernel.org/tip/114cfab222233f50f46d7162cf7d99fdc6c271e5
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Wed, 5 Aug 2009 13:25:21 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Aug 2009 13:16:04 +0200

perf report: Make --sort comm,dso,symbol the default

If you're doing performance testing, you're interested in the
symbols anyway so lets make "--sort comm,dso,symbol" the
default sort option.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com
LKML-Reference: <1249467921-10450-1-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ce4f286..8cb58d6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -31,7 +31,7 @@
 static char		const *input_name = "perf.data";
 static char		*vmlinux = NULL;
 
-static char		default_sort_order[] = "comm,dso";
+static char		default_sort_order[] = "comm,dso,symbol";
 static char		*sort_order = default_sort_order;
 static char		*dso_list_str, *comm_list_str, *sym_list_str,
 			*col_width_list_str;
@@ -1424,7 +1424,7 @@ print_entries:
 	if (sort_order == default_sort_order &&
 			parent_pattern == default_parent_pattern) {
 		fprintf(fp, "#\n");
-		fprintf(fp, "# (For more details, try: perf report --sort comm,dso,symbol)\n");
+		fprintf(fp, "# (For a higher level overview, try: perf report --sort comm,dso)\n");
 		fprintf(fp, "#\n");
 	}
 	fprintf(fp, "\n");
