Return-Path: <linux-kernel-owner+w=401wt.eu-S1763653AbZC0CTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763653AbZC0CTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 22:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763542AbZC0CTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 22:19:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57683 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763510AbZC0CTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 22:19:17 -0400
Message-ID: <49CC37C2.7050307@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 10:19:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] blktrace: make classic output more classic
References: <49CC37AA.3060908@cn.fujitsu.com>
In-Reply-To: <49CC37AA.3060908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the classic user-space blktrace, the output timestamp is sec.nsec
not sec.usec.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d43cdac..933639a 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -995,7 +995,7 @@ static int blk_log_action_iter(struct trace_iterator *iter, const char *act)
 {
 	char rwbs[6];
 	unsigned long long ts  = ns2usecs(iter->ts);
-	unsigned long usec_rem = do_div(ts, USEC_PER_SEC);
+	unsigned long nsec_rem = do_div(ts, NSEC_PER_SEC);
 	unsigned secs	       = (unsigned long)ts;
 	const struct trace_entry *ent = iter->ent;
 	const struct blk_io_trace *t = (const struct blk_io_trace *)ent;
@@ -1003,9 +1003,9 @@ static int blk_log_action_iter(struct trace_iterator *iter, const char *act)
 	fill_rwbs(rwbs, t);
 
 	return trace_seq_printf(&iter->seq,
-				"%3d,%-3d %2d %5d.%06lu %5u %2s %3s ",
+				"%3d,%-3d %2d %5d.%09lu %5u %2s %3s ",
 				MAJOR(t->device), MINOR(t->device), iter->cpu,
-				secs, usec_rem, ent->pid, act, rwbs);
+				secs, nsec_rem, ent->pid, act, rwbs);
 }
 
 static int blk_log_action_seq(struct trace_seq *s, const struct blk_io_trace *t,
-- 
1.5.4.rc3

