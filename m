Return-Path: <linux-kernel-owner+w=401wt.eu-S935033AbZLPQb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033AbZLPQb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935021AbZLPQb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:31:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935013AbZLPQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:31:58 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf diff: Percent calcs should use double values
Date: Wed, 16 Dec 2009 14:31:49 -0200
Message-Id: <1260981109-2621-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index ecf853c..1bf8658 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -494,9 +494,9 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 		double old_percent = 0, new_percent = 0, diff;
 
 		if (total > 0)
-			old_percent = (count * 100) / total;
+			old_percent = (count * 100.0) / total;
 		if (session->events_stats.total > 0)
-			new_percent = (self->count * 100) / session->events_stats.total;
+			new_percent = (self->count * 100.0) / session->events_stats.total;
 
 		diff = old_percent - new_percent;
 
-- 
1.6.2.5

