Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab0CKXMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 18:12:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab0CKXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 18:12:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 4/5] perf tools: Add missing bytes printed in hist_entry__fprintf
Date: Thu, 11 Mar 2010 20:12:43 -0300
Message-Id: <1268349164-5822-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268349164-5822-1-git-send-email-acme@infradead.org>
References: <1268349164-5822-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
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
 tools/perf/util/hist.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index bdcfd61..d43be34 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -455,11 +455,11 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-static size_t hist_entry__fprintf(struct hist_entry *self,
-				  struct perf_session *pair_session,
-				  bool show_displacement,
-				  long displacement, FILE *fp,
-				  u64 session_total)
+size_t hist_entry__fprintf(struct hist_entry *self,
+			   struct perf_session *pair_session,
+			   bool show_displacement,
+			   long displacement, FILE *fp,
+			   u64 session_total)
 {
 	struct sort_entry *se;
 	u64 count, total;
@@ -485,9 +485,9 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 
 	if (symbol_conf.show_nr_samples) {
 		if (sep)
-			fprintf(fp, "%c%lld", *sep, count);
+			ret += fprintf(fp, "%c%lld", *sep, count);
 		else
-			fprintf(fp, "%11lld", count);
+			ret += fprintf(fp, "%11lld", count);
 	}
 
 	if (pair_session) {
@@ -518,9 +518,9 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 				snprintf(bf, sizeof(bf), " ");
 
 			if (sep)
-				fprintf(fp, "%c%s", *sep, bf);
+				ret += fprintf(fp, "%c%s", *sep, bf);
 			else
-				fprintf(fp, "%6.6s", bf);
+				ret += fprintf(fp, "%6.6s", bf);
 		}
 	}
 
@@ -528,7 +528,7 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 		if (se->elide)
 			continue;
 
-		fprintf(fp, "%s", sep ?: "  ");
+		ret += fprintf(fp, "%s", sep ?: "  ");
 		ret += se->print(fp, self, se->width ? *se->width : 0);
 	}
 
@@ -544,8 +544,8 @@ static size_t hist_entry__fprintf(struct hist_entry *self,
 			left_margin -= thread__comm_len(self->thread);
 		}
 
-		hist_entry_callchain__fprintf(fp, self, session_total,
-					      left_margin);
+		ret += hist_entry_callchain__fprintf(fp, self, session_total,
+						     left_margin);
 	}
 
 	return ret;
-- 
1.6.2.5

