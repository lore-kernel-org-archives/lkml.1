Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZLBIcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZLBIcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZLBIcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:32:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:46671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbZLBIb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:31:59 -0500
Date: Wed, 2 Dec 2009 08:31:06 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, xiaoguangrong@cn.fujitsu.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       xiaoguangrong@cn.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <4B162089.8000907@cn.fujitsu.com>
References: <4B162089.8000907@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: Fix compile error
Message-ID: <tip-bdad0db7dbdb37d0bb3c7d0f65cd3ff599ea6ecb@git.kernel.org>
Git-Commit-ID: bdad0db7dbdb37d0bb3c7d0f65cd3ff599ea6ecb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdad0db7dbdb37d0bb3c7d0f65cd3ff599ea6ecb
Gitweb:     http://git.kernel.org/tip/bdad0db7dbdb37d0bb3c7d0f65cd3ff599ea6ecb
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 2 Dec 2009 16:08:41 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 09:27:01 +0100

perf_event: Fix compile error

Fix:

 cc1: warnings being treated as errors
 builtin-probe.c: In function 'cmd_probe':
 builtin-probe.c:163: error: unused variable 'fd'

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4B162089.8000907@cn.fujitsu.com>
[ v2: use NO_LIBDWARF instead of __used ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index b5d15cf..a58e11b 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -160,7 +160,10 @@ static const struct option options[] = {
 
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
-	int i, j, fd, ret;
+	int i, j, ret;
+#ifndef NO_LIBDWARF
+	int fd;
+#endif
 	struct probe_point *pp;
 
 	argc = parse_options(argc, argv, options, probe_usage,
