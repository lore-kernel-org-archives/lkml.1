Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750Ab0CMAFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:05:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:57789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab0CMAFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:05:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf tools: Fix non-newt build
Date: Fri, 12 Mar 2010 21:05:10 -0300
Message-Id: <1268438710-32697-1-git-send-email-acme@infradead.org>
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

The use_browser needs to be in a file that is always built and also we
need a browser__show_help stub in that case.

Reported-by: Anton Blanchard <anton@samba.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c       |    2 ++
 tools/perf/util/debug.h |    8 ++++++++
 tools/perf/util/newt.c  |    2 --
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 9ff186b..0d4b9ed 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -16,6 +16,8 @@
 #include "util/string.h"
 #include "util/debugfs.h"
 
+bool use_browser;
+
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
 
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 03accb8..0172edf 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -9,6 +9,14 @@ extern int dump_trace;
 
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
+
+#ifdef NO_NEWT_SUPPORT
+static inline int browser__show_help(const char *format __used, va_list ap __used)
+{
+	return 0;
+}
+#else
 int browser__show_help(const char *format, va_list ap);
+#endif
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index f6ec6f5..2836394 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -189,8 +189,6 @@ int browser__show_help(const char *format, va_list ap)
 	return ret;
 }
 
-bool use_browser;
-
 void setup_browser(void)
 {
 	if (!isatty(1))
-- 
1.6.2.5

