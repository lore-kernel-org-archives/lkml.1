Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZKVPVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZKVPVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 10:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZKVPVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 10:21:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:35363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbZKVPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 10:21:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf symbols: Show messages about module loading only if verbose >= 1
Date: Sun, 22 Nov 2009 13:21:41 -0200
Message-Id: <1258903301-20584-1-git-send-email-acme@infradead.org>
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

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f56158f..74b5b8a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1189,7 +1189,7 @@ static int dsos__set_modules_path_dir(char *dirname)
 	DIR *dir = opendir(dirname);
 
 	if (!dir) {
-		pr_err("%s: cannot open %s dir\n", __func__, dirname);
+		pr_debug("%s: cannot open %s dir\n", __func__, dirname);
 		return -1;
 	}
 
@@ -1500,8 +1500,8 @@ int kernel_maps__init(bool use_modules)
 		return -1;
 
 	if (use_modules && kernel_maps__create_module_maps() < 0)
-		pr_warning("Failed to load list of modules in use, "
-			   "continuing...\n");
+		pr_debug("Failed to load list of modules in use, "
+			 "continuing...\n");
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-- 
1.6.2.5

