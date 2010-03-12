Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0CLPq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 10:46:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:42028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0CLPq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 10:46:58 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf newt: Use newtGetScreenSize
Date: Fri, 12 Mar 2010 12:46:47 -0300
Message-Id: <1268408808-13595-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For consistency, use the newt API more fully.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 2a4308a..f6ec6f5 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -52,7 +52,7 @@ static size_t hist_entry__append_browser(struct hist_entry *self,
 static void hist_entry__annotate_browser(struct hist_entry *self)
 {
 	FILE *fp;
-	struct winsize ws;
+	int cols, rows;
 	newtComponent form, listbox;
 	struct newtExitStruct es;
 	char *str;
@@ -71,8 +71,8 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 		goto out_free_str;
 
 	newtPushHelpLine("Press ESC to exit");
-	get_term_dimensions(&ws);
-	listbox = newtListbox(0, 0, ws.ws_row - 5, NEWT_FLAG_SCROLL);
+	newtGetScreenSize(&cols, &rows);
+	listbox = newtListbox(0, 0, rows - 5, NEWT_FLAG_SCROLL);
 
 	while (!feof(fp)) {
 		if (getline(&line, &line_len, fp) < 0 || !line_len)
@@ -87,13 +87,13 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	fclose(fp);
 	free(line);
 
-	max_usable_width = ws.ws_col - 22;
+	max_usable_width = cols - 22;
 	if (max_line_len > max_usable_width)
 		max_line_len = max_usable_width;
 
 	newtListboxSetWidth(listbox, max_line_len);
 
-	newtCenteredWindow(max_line_len + 2, ws.ws_row - 5, self->sym->name);
+	newtCenteredWindow(max_line_len + 2, rows - 5, self->sym->name);
 	form = newt_form__new();
 	newtFormAddComponents(form, listbox, NULL);
 
@@ -112,7 +112,7 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	struct rb_node *nd;
 	unsigned int width;
 	char *col_width = symbol_conf.col_width_list_str;
-	struct winsize ws;
+	int rows;
 	size_t max_len = 0;
 	char str[1024];
 	newtComponent form, listbox;
@@ -122,13 +122,13 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	newtDrawRootText(0, 0, str);
 	newtPushHelpLine(helpline);
 
-	get_term_dimensions(&ws);
+	newtGetScreenSize(NULL, &rows);
 
 	form = newt_form__new();
 
-	listbox = newtListbox(1, 1, ws.ws_row - 2, (NEWT_FLAG_SCROLL |
-						    NEWT_FLAG_BORDER |
-						    NEWT_FLAG_RETURNEXIT));
+	listbox = newtListbox(1, 1, rows - 2, (NEWT_FLAG_SCROLL |
+					       NEWT_FLAG_BORDER |
+					       NEWT_FLAG_RETURNEXIT));
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
-- 
1.6.2.5

