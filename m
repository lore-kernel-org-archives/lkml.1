Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148Ab0ATHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0ATHOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132Ab0ATHOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:14:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:40214 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab0ATHOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:14:11 -0500
Date: Wed, 20 Jan 2010 07:13:09 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi,
       xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1263921803-10214-1-git-send-email-penberg@cs.helsinki.fi>
References: <1263921803-10214-1-git-send-email-penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kmem: Increase "Hit" column length
Message-ID: <tip-47103277f8861dcb48ab845533db331ddb9427ca@git.kernel.org>
Git-Commit-ID: 47103277f8861dcb48ab845533db331ddb9427ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 07:13:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47103277f8861dcb48ab845533db331ddb9427ca
Gitweb:     http://git.kernel.org/tip/47103277f8861dcb48ab845533db331ddb9427ca
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 19 Jan 2010 19:23:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Jan 2010 07:20:07 +0100

perf kmem: Increase "Hit" column length

It's fairly easy to overflow the "Hit" column with just few
seconds of tracing so increase the column length to avoid broken
formatting.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <1263921803-10214-1-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
