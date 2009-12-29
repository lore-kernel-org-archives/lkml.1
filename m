Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZL2AtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZL2AtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 19:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZL2Asy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 19:48:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbZL2Asr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 19:48:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/5] perf report: Add --hide-unresolved/-U command line option
Date: Mon, 28 Dec 2009 22:48:34 -0200
Message-Id: <1262047716-23171-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262047716-23171-1-git-send-email-acme@infradead.org>
References: <1262047716-23171-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Useful to match the 'overhead' column in 'perf report' with the 'baseline' one
in 'perf diff'.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 508934b..4292d7a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -34,6 +34,7 @@
 static char		const *input_name = "perf.data";
 
 static int		force;
+static bool		hide_unresolved;
 
 static int		show_threads;
 static struct perf_read_values	show_threads_values;
@@ -121,7 +122,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return -1;
 	}
 
-	if (al.filtered)
+	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
 	if (perf_session__add_hist_entry(session, &al, data.callchain, data.period)) {
@@ -342,6 +343,8 @@ static const struct option options[] = {
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
+	OPT_BOOLEAN('U', "hide-unresolved", &hide_unresolved,
+		    "Only display entries resolved to a symbol"),
 	OPT_END()
 };
 
-- 
1.5.5.1

