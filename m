Return-Path: <linux-kernel-owner+w=401wt.eu-S932345Ab0ANUaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0ANUaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033Ab0ANUaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:30:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab0ANUaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:30:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Aristeu Rozanski <aris@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ulrich Drepper <drepper@redhat.com>
Subject: [PATCH 1/3] perf tools: Convert getpagesize() uses to sysconf(_SC_GETPAGESIZE)
Date: Thu, 14 Jan 2010 18:30:04 -0200
Message-Id: <1263501006-14185-1-git-send-email-acme@infradead.org>
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

Using the more portable and equivalent sysconf call.

Reported-by: Aristeu Rozanski <aris@redhat.com>
Reported-by: Ulrich Drepper <drepper@redhat.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c          |    2 +-
 tools/perf/util/trace-event-info.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 604e14f..1951e33 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -384,7 +384,7 @@ int perf_session__process_events(struct perf_session *self,
 
 	perf_event_ops__fill_defaults(ops);
 
-	page_size = getpagesize();
+	page_size = sysconf(_SC_PAGESIZE);
 
 	head = self->header.data_offset;
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 407fd65..5ea8973 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -515,7 +515,7 @@ int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 	write_or_die(buf, 1);
 
 	/* save page_size */
-	page_size = getpagesize();
+	page_size = sysconf(_SC_PAGESIZE);
 	write_or_die(&page_size, 4);
 
 	read_header_files();
-- 
1.6.2.5

