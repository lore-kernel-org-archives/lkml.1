Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313Ab0AVQfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab0AVQfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371Ab0AVQfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:35:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0AVQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:35:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf symbols: Use the right variable to check for kallsyms in the cache
Date: Fri, 22 Jan 2010 14:35:02 -0200
Message-Id: <1264178102-4203-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264178102-4203-1-git-send-email-acme@infradead.org>
References: <1264178102-4203-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Probably this wasn't noticed when testing this on my parisc machine
because I must have copied manually to its cache the vmlinux file used
in the x86_64 machine, now that I tried looking on a x86-32 machine with
a fresh cache, kernel symbols weren't being resolved even with the right
kallsyms copy on its cache, duh.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1270cf8..f1f609d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1650,12 +1650,12 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 			     getenv("HOME"), sbuild_id) == -1)
 			return -1;
 
+		kallsyms_filename = kallsyms_allocated_filename;
+
 		if (access(kallsyms_filename, F_OK)) {
 			free(kallsyms_allocated_filename);
 			return -1;
 		}
-
-		kallsyms_filename = kallsyms_allocated_filename;
 	} else {
 		/*
 		 * Last resort, if we don't have a build-id and couldn't find
-- 
1.6.2.5

