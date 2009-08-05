Return-Path: <linux-kernel-owner+w=401wt.eu-S934192AbZHEKuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbZHEKuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934059AbZHEKuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:50:50 -0400
Received: from smtp6.welho.com ([213.243.153.40]:60032 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933995AbZHEKuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:50:50 -0400
X-Greylist: delayed 1528 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2009 06:50:49 EDT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl
Subject: [PATCH] perf report: Make --sort comm,dso,symbol the default
Date: Wed,  5 Aug 2009 13:25:21 +0300
Message-Id: <1249467921-10450-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're doing performance testing, you're interested in the symbols
anyway so lets make "--sort comm,dso,symbol" the default sort option.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 tools/perf/builtin-report.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b20a4b6..181cef1 100644
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
@@ -1423,7 +1423,7 @@ print_entries:
 	if (sort_order == default_sort_order &&
 			parent_pattern == default_parent_pattern) {
 		fprintf(fp, "#\n");
-		fprintf(fp, "# (For more details, try: perf report --sort comm,dso,symbol)\n");
+		fprintf(fp, "# (For an high level overview, try: perf report --sort comm,dso)\n");
 		fprintf(fp, "#\n");
 	}
 	fprintf(fp, "\n");
-- 
1.5.6.3

