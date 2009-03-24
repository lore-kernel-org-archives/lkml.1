Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZCXMN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZCXMN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZCXMNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:13:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZCXMNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:13:15 -0400
Date: Tue, 24 Mar 2009 12:12:28 GMT
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
In-Reply-To: <49C89415.5080503@cn.fujitsu.com>
References: <49C89415.5080503@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: mark ddir_act[] const
Message-ID: <tip-e4955c9986a27bb47ddeb6cd55803053f547e2e9@git.kernel.org>
Git-Commit-ID: e4955c9986a27bb47ddeb6cd55803053f547e2e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 12:12:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4955c9986a27bb47ddeb6cd55803053f547e2e9
Gitweb:     http://git.kernel.org/tip/e4955c9986a27bb47ddeb6cd55803053f547e2e9
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 24 Mar 2009 16:04:37 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 13:08:59 +0100

blktrace: mark ddir_act[] const

Impact: cleanup

ddir_act and what2act always stay immutable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <49C89415.5080503@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 108f4f7..1ffcbd4 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -147,8 +147,8 @@ static int act_log_check(struct blk_trace *bt, u32 what, sector_t sector,
 /*
  * Data direction bit lookup
  */
-static u32 ddir_act[2] __read_mostly = { BLK_TC_ACT(BLK_TC_READ),
-					 BLK_TC_ACT(BLK_TC_WRITE) };
+static const u32 ddir_act[2] = { BLK_TC_ACT(BLK_TC_READ),
+				 BLK_TC_ACT(BLK_TC_WRITE) };
 
 /* The ilog2() calls fall out because they're constant */
 #define MASK_TC_BIT(rw, __name) ((rw & (1 << BIO_RW_ ## __name)) << \
@@ -1116,10 +1116,10 @@ static void blk_tracer_reset(struct trace_array *tr)
 	blk_tracer_stop(tr);
 }
 
-static struct {
+static const struct {
 	const char *act[2];
 	int	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
-} what2act[] __read_mostly = {
+} what2act[] = {
 	[__BLK_TA_QUEUE]	= {{  "Q", "queue" },	   blk_log_generic },
 	[__BLK_TA_BACKMERGE]	= {{  "M", "backmerge" },  blk_log_generic },
 	[__BLK_TA_FRONTMERGE]	= {{  "F", "frontmerge" }, blk_log_generic },
