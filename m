Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZGBSPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZGBSPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZGBSOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:14:41 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:45924 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbZGBSOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TOkV4hNTCdXGMJBjQfWn68mnRFzIHu6E2nmMSkONxVo/F4IGAFImByqJgB6LrTSm/T
         zrplBJYJF5/x0SV8X3qXiAmAtNamLhnNtqQU0c9Lz/IMOC/pmbCpvAdiNeQgjUdkUvlG
         FH7sjxDzOvyXjOf90ojTnK5SzoTdUWiIobjRQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] perfcounter: Display percents of hits in callchain with overhead colors
Date: Thu,  2 Jul 2009 20:14:35 +0200
Message-Id: <1246558475-10624-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246558475-10624-1-git-send-email-fweisbec@gmail.com>
References: <1246558475-10624-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the use of colors to signal at a glance the important
overhead thresholds in callchains hit rates.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-report.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bfca1e4..01902f0 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -819,7 +819,7 @@ ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
 			double percent;
 
 			percent = hits * 100.0 / total_samples;
-			ret += fprintf(fp, "--%2.2f%%-- ", percent);
+			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
 		} else
 			ret += fprintf(fp, "%s", "          ");
 	}
@@ -919,7 +919,8 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 		chain = rb_entry(rb_node, struct callchain_node, rb_node);
 		percent = chain->hit * 100.0 / total_samples;
 		if (callchain_mode == FLAT) {
-			ret += fprintf(fp, "           %6.2f%%\n", percent);
+			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
+						     percent);
 			ret += callchain__fprintf_flat(fp, chain, total_samples);
 		} else if (callchain_mode == GRAPH) {
 			ret += callchain__fprintf_graph(fp, chain,
-- 
1.6.2.3

