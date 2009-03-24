Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZCXIEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZCXIEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZCXIEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:04:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57325 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZCXIEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:04:13 -0400
Message-ID: <49C89415.5080503@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 16:04:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] blktrace: mark ddir_act and what2act const
References: <49C893FC.9080905@cn.fujitsu.com>
In-Reply-To: <49C893FC.9080905@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ddir_act and what2act are always stay immutable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3

