Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0CLNsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:48:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:45801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab0CLNsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:48:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf newt: Add 'Q', 'q' and Ctrl+C as ways to exit from forms
Date: Fri, 12 Mar 2010 10:48:12 -0300
Message-Id: <1268401692-9361-1-git-send-email-acme@infradead.org>
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

These are keys people expect when pressed to exit the current widget, so
have associate all of them to this semantic.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 3d3a936..2a4308a 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -4,6 +4,7 @@
 
 #include <stdlib.h>
 #include <newt.h>
+#include <sys/ttydefaults.h>
 
 #include "cache.h"
 #include "hist.h"
@@ -11,6 +12,22 @@
 #include "sort.h"
 #include "symbol.h"
 
+static void newt_form__set_exit_keys(newtComponent self)
+{
+	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
+	newtFormAddHotKey(self, 'Q');
+	newtFormAddHotKey(self, 'q');
+	newtFormAddHotKey(self, CTRL('c'));
+}
+
+static newtComponent newt_form__new(void)
+{
+	newtComponent self = newtForm(NULL, NULL, 0);
+	if (self)
+		newt_form__set_exit_keys(self);
+	return self;
+}
+
 static size_t hist_entry__append_browser(struct hist_entry *self,
 					 newtComponent listbox, u64 total)
 {
@@ -77,8 +94,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	newtListboxSetWidth(listbox, max_line_len);
 
 	newtCenteredWindow(max_line_len + 2, ws.ws_row - 5, self->sym->name);
-	form = newtForm(NULL, NULL, 0);
-	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
+	form = newt_form__new();
 	newtFormAddComponents(form, listbox, NULL);
 
 	newtFormRun(form, &es);
@@ -108,8 +124,7 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 
 	get_term_dimensions(&ws);
 
-	form = newtForm(NULL, NULL, 0);
-	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
+	form = newt_form__new();
 
 	listbox = newtListbox(1, 1, ws.ws_row - 2, (NEWT_FLAG_SCROLL |
 						    NEWT_FLAG_BORDER |
-- 
1.6.2.5

