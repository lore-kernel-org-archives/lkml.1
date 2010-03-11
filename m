Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0CKXMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 18:12:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0CKXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 18:12:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 2/5] perf top: Export get_window_dimensions
Date: Thu, 11 Mar 2010 20:12:41 -0300
Message-Id: <1268349164-5822-2-git-send-email-acme@infradead.org>
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

Will be used by the newt code too.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    2 +-
 tools/perf/perf.h        |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ec48223..57e232f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -133,7 +133,7 @@ static inline struct symbol *sym_entry__symbol(struct sym_entry *self)
        return ((void *)self) + symbol_conf.priv_size;
 }
 
-static void get_term_dimensions(struct winsize *ws)
+void get_term_dimensions(struct winsize *ws)
 {
 	char *s = getenv("LINES");
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 6fb379b..aa78615 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -1,6 +1,10 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
+struct winsize;
+
+void get_term_dimensions(struct winsize *ws);
+
 #if defined(__i386__)
 #include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-- 
1.6.2.5

