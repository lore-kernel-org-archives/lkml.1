Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704Ab0ASRX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0ASRX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439Ab0ASRX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:23:27 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:42811 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab0ASRX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:23:27 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH] perf kmem: Increase "Hit" column length
Date: Tue, 19 Jan 2010 19:23:23 +0200
Message-Id: <1263921803-10214-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's fairly easy to overflow the "Hit" column with just few seconds of tracing
so increase the column length to avoid broken formatting.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 tools/perf/builtin-kmem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7ceb741..33bb9df 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -375,7 +375,7 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 
 	printf("%.102s\n", graph_dotted_line);
 	printf(" %-34s |",  is_caller ? "Callsite": "Alloc Ptr");
-	printf(" Total_alloc/Per | Total_req/Per   | Hit   | Ping-pong | Frag\n");
+	printf(" Total_alloc/Per | Total_req/Per   | Hit      | Ping-pong | Frag\n");
 	printf("%.102s\n", graph_dotted_line);
 
 	next = rb_first(root);
@@ -401,7 +401,7 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 			snprintf(buf, sizeof(buf), "%#Lx", addr);
 		printf(" %-34s |", buf);
 
-		printf(" %9llu/%-5lu | %9llu/%-5lu | %6lu | %8lu | %6.3f%%\n",
+		printf(" %9llu/%-5lu | %9llu/%-5lu | %8lu | %8lu | %6.3f%%\n",
 		       (unsigned long long)data->bytes_alloc,
 		       (unsigned long)data->bytes_alloc / data->hit,
 		       (unsigned long long)data->bytes_req,
-- 
1.6.0.4

