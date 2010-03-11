Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab0CKWOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:14:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab0CKWNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:13:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/6] perf tools: Use eprintf for pr_{err,warning,info} too
Date: Thu, 11 Mar 2010 19:13:34 -0300
Message-Id: <1268345617-31863-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268345617-31863-1-git-send-email-acme@infradead.org>
References: <1268345617-31863-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like we do for pr_debug, so that we can have a single point where to
redirect to the currently used output system, be it stdio or newt.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.h                |    2 --
 tools/perf/util/include/linux/kernel.h |    9 ++++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index c6c24c5..58720a1 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -7,8 +7,6 @@
 extern int verbose;
 extern int dump_trace;
 
-int eprintf(int level,
-	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
 
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index f261165..388ab1b 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -85,16 +85,19 @@ simple_strtoul(const char *nptr, char **endptr, int base)
 	return strtoul(nptr, endptr, base);
 }
 
+int eprintf(int level,
+	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
+
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
 
 #define pr_err(fmt, ...) \
-	do { fprintf(stderr, pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
-	do { fprintf(stderr, pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
-	do { fprintf(stderr, pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug(fmt, ...) \
 	eprintf(1, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debugN(n, fmt, ...) \
-- 
1.5.5.1

