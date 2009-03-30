Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZC3BUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZC3BUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZC3BU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:20:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:33019 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbZC3BU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:20:27 -0400
Date: Mon, 30 Mar 2009 01:19:32 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49CC37C2.7050307@cn.fujitsu.com>
References: <49CC37C2.7050307@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: make classic output more classic
Message-ID: <tip-300dc4f1581ef42567a90cb640d994d24d41bf9c@git.kernel.org>
Git-Commit-ID: 300dc4f1581ef42567a90cb640d994d24d41bf9c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 30 Mar 2009 01:19:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  300dc4f1581ef42567a90cb640d994d24d41bf9c
Gitweb:     http://git.kernel.org/tip/300dc4f1581ef42567a90cb640d994d24d41bf9c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 27 Mar 2009 10:19:46 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Mar 2009 03:15:42 +0200

blktrace: make classic output more classic

Impact: fix ftrace plugin timestamp output

In the classic user-space blktrace, the output timestamp is sec.nsec
not sec.usec.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49CC37C2.7050307@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d43cdac..5b28f0f 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -994,8 +994,8 @@ static void get_pdu_remap(const struct trace_entry *ent,
 static int blk_log_action_iter(struct trace_iterator *iter, const char *act)
 {
 	char rwbs[6];
-	unsigned long long ts  = ns2usecs(iter->ts);
-	unsigned long usec_rem = do_div(ts, USEC_PER_SEC);
+	unsigned long long ts  = iter->ts;
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
