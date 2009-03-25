Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbZCYNQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbZCYNQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbZCYNQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:16:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:37378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168AbZCYNQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:16:11 -0400
Date: Wed, 25 Mar 2009 13:15:29 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49C89447.5060303@cn.fujitsu.com>
References: <49C89447.5060303@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: fix off-by-one bug
Message-ID: <tip-89b0d8901c251548ee4d835da184dd08af67a3a7@git.kernel.org>
Git-Commit-ID: 89b0d8901c251548ee4d835da184dd08af67a3a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 13:15:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89b0d8901c251548ee4d835da184dd08af67a3a7
Gitweb:     http://git.kernel.org/tip/89b0d8901c251548ee4d835da184dd08af67a3a7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 24 Mar 2009 16:05:27 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 14:13:11 +0100

blktrace: fix off-by-one bug

'what' is used as the index of array what2act, so it can't >= the array size.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49C89447.5060303@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index a7f7ff5..d43cdac 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1152,7 +1152,7 @@ static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
 	if (!trace_print_context(iter))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
+	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
 		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
 	else {
 		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);
@@ -1199,7 +1199,7 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 	t = (const struct blk_io_trace *)iter->ent;
 	what = t->action & ((1 << BLK_TC_SHIFT) - 1);
 
-	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
+	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
 		ret = trace_seq_printf(&iter->seq, "Bad pc action %x\n", what);
 	else {
 		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);
