Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbZLTFtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbZLTFtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 00:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZLTFtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 00:49:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZLTFtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 00:49:39 -0500
Message-ID: <4B2DBA7E.8010205@cn.fujitsu.com>
Date: Sun, 20 Dec 2009 13:47:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_event: fix 'perf record'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'-a' parameter works abnormal in 'perf record', it conduces
'perf sched record' and 'perf kmem record' unwork.

This bug was introduced by:
commit 856e96608a72412d319e498a3a7c557571f811bd

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 63136d0..105ea23 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -483,7 +483,7 @@ static int __cmd_record(int argc __used, const char **argv)
 
 	atexit(atexit_header);
 
-	if (target_pid == -1) {
+	if (target_pid == -1 && argc) {
 		pid = fork();
 		if (pid < 0) {
 			perror("failed to fork");
@@ -667,7 +667,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
+	if (!argc && target_pid == -1 && !system_wide && profile_cpu == -1)
 		usage_with_options(record_usage, options);
 
 	symbol__init();
-- 
1.6.1.2



 
