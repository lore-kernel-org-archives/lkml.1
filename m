Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbZHZOvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbZHZOvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZHZOvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:51:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZHZOvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:51:35 -0400
Date: Wed, 26 Aug 2009 11:51:26 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] perf top: Show RIP only in verbose mode
Message-ID: <20090826145126.GA5255@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 62b55ec..4002ccb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -483,11 +483,16 @@ static void print_sym_table(void)
 	if (nr_counters == 1)
 		printf("             samples    pcnt");
 	else
-		printf("  weight     samples    pcnt");
+		printf("   weight    samples    pcnt");
 
-	printf("         RIP          kernel function\n"
-	       	       "  ______     _______   _____   ________________   _______________\n\n"
-	);
+	if (verbose)
+		printf("         RIP       ");
+	printf("   kernel function\n");
+	printf("   %s    _______   _____",
+	       nr_counters == 1 ? "      " : "______");
+	if (verbose)
+		printf("   ________________");
+	printf("   _______________\n\n");
 
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct symbol *sym;
@@ -508,7 +513,9 @@ static void print_sym_table(void)
 			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
 
 		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
-		printf(" - %016llx : %s", sym->start, sym->name);
+		if (verbose)
+			printf(" - %016llx", sym->start);
+		printf(" : %s", sym->name);
 		if (sym->module)
 			printf("\t[%s]", sym->module->name);
 		printf("\n");
-- 
1.6.2.5


