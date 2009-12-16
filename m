Return-Path: <linux-kernel-owner+w=401wt.eu-S934896AbZLPQKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934896AbZLPQKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934515AbZLPQKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:10:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073AbZLPQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:10:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf diff: Change the default sort order to "dso,symbol"
Date: Wed, 16 Dec 2009 14:09:53 -0200
Message-Id: <1260979793-1981-1-git-send-email-acme@infradead.org>
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

$ perf diff | head -8
     9.02%     +1.00%  libc-2.10.1.so               [.] _IO_vfprintf_internal
     2.91%     -1.00%  [kernel]                     [k] __kmalloc
     2.85%     -1.00%  [kernel]                     [k] ext4_htree_store_dirent
     1.99%     -1.00%  [kernel]                     [k] _atomic_dec_and_lock
     2.44%             [kernel]
$

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 66f100d..4d33b55 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -18,6 +18,7 @@
 
 static char const *input_old = "perf.data.old",
 		  *input_new = "perf.data";
+static char	  diff__default_sort_order[] = "dso,symbol";
 static int  force;
 static bool show_displacement;
 
@@ -220,6 +221,7 @@ static const struct option options[] = {
 
 int cmd_diff(int argc, const char **argv, const char *prefix __used)
 {
+	sort_order = diff__default_sort_order;
 	argc = parse_options(argc, argv, options, diff_usage, 0);
 	if (argc) {
 		if (argc > 2)
-- 
1.6.2.5

