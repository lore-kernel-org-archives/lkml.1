Return-Path: <linux-kernel-owner+w=401wt.eu-S1751741AbZL2Asz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbZL2Asz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 19:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZL2Asw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 19:48:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZL2Asr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 19:48:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/5] perf diff: Don't add the period for unresolved symbols
Date: Mon, 28 Dec 2009 22:48:35 -0200
Message-Id: <1262047716-23171-4-git-send-email-acme@infradead.org>
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

Since we don't add histograms buckets for them, this way the sum of baselines
should be 100%.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1cbecaf..876a4b9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -51,12 +51,12 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 		return -1;
 	}
 
-	if (al.filtered)
+	if (al.filtered || al.sym == NULL)
 		return 0;
 
 	event__parse_sample(event, session->sample_type, &data);
 
-	if (al.sym && perf_session__add_hist_entry(session, &al, data.period)) {
+	if (perf_session__add_hist_entry(session, &al, data.period)) {
 		pr_warning("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
-- 
1.5.5.1

