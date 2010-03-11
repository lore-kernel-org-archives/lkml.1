Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab0CKWNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:13:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:57075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513Ab0CKWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:13:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/6] perf tools: Add missing bytes printed in hist_entry__fprintf
Date: Thu, 11 Mar 2010 19:13:36 -0300
Message-Id: <1268345617-31863-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268345617-31863-1-git-send-email-acme@infradead.org>
References: <1268345617-31863-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need those to properly size the browser widht in the newt TUI.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9a5be25..d43be34 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -485,9 +485,9 @@ size_t hist_entry__fprintf(struct hist_entry *self,
 
 	if (symbol_conf.show_nr_samples) {
 		if (sep)
-			fprintf(fp, "%c%lld", *sep, count);
+			ret += fprintf(fp, "%c%lld", *sep, count);
 		else
-			fprintf(fp, "%11lld", count);
+			ret += fprintf(fp, "%11lld", count);
 	}
 
 	if (pair_session) {
@@ -518,9 +518,9 @@ size_t hist_entry__fprintf(struct hist_entry *self,
 				snprintf(bf, sizeof(bf), " ");
 
 			if (sep)
-				fprintf(fp, "%c%s", *sep, bf);
+				ret += fprintf(fp, "%c%s", *sep, bf);
 			else
-				fprintf(fp, "%6.6s", bf);
+				ret += fprintf(fp, "%6.6s", bf);
 		}
 	}
 
@@ -528,7 +528,7 @@ size_t hist_entry__fprintf(struct hist_entry *self,
 		if (se->elide)
 			continue;
 
-		fprintf(fp, "%s", sep ?: "  ");
+		ret += fprintf(fp, "%s", sep ?: "  ");
 		ret += se->print(fp, self, se->width ? *se->width : 0);
 	}
 
@@ -544,8 +544,8 @@ size_t hist_entry__fprintf(struct hist_entry *self,
 			left_margin -= thread__comm_len(self->thread);
 		}
 
-		hist_entry_callchain__fprintf(fp, self, session_total,
-					      left_margin);
+		ret += hist_entry_callchain__fprintf(fp, self, session_total,
+						     left_margin);
 	}
 
 	return ret;
-- 
1.5.5.1

