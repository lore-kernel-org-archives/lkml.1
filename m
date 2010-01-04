Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745Ab0ADSTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0ADSTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708Ab0ADSTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:19:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:53946 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0ADSTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:19:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] perf symbols: Export symbol_type__is_a
Date: Mon,  4 Jan 2010 16:19:27 -0200
Message-Id: <1262629169-22797-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262629169-22797-1-git-send-email-acme@infradead.org>
References: <1262629169-22797-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be needed by the new HEADER_DSO_INFO feature that will be a
HEADER_BUILD_ID superset, replacing it.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 +-
 tools/perf/util/symbol.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b9e0da5..5dffcd1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -64,7 +64,7 @@ static void dso__set_sorted_by_name(struct dso *self, enum map_type type)
 	self->sorted_by_name |= (1 << type);
 }
 
-static bool symbol_type__is_a(char symbol_type, enum map_type map_type)
+bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 {
 	switch (map_type) {
 	case MAP__FUNCTION:
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 21313e8..b2b5330 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -139,6 +139,8 @@ int kallsyms__parse(void *arg, int (*process_symbol)(void *arg, const char *name
 						     char type, u64 start));
 
 int symbol__init(void);
+bool symbol_type__is_a(char symbol_type, enum map_type map_type);
+
 int perf_session__create_kernel_maps(struct perf_session *self);
 
 extern struct list_head dsos__user, dsos__kernel;
-- 
1.6.2.5

