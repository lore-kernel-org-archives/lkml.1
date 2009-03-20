Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZCTBr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZCTBr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZCTBrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:47:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53246 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZCTBro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:47:44 -0400
Message-ID: <49C2F5D3.8090104@cn.fujitsu.com>
Date: Fri, 20 Mar 2009 09:48:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] blktrace: make blk_tracer_enabled a bool flag
References: <49C2F599.3060306@cn.fujitsu.com>
In-Reply-To: <49C2F599.3060306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't have to be a counter, and it can be a bool flag instead.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index fb3bc53..73845b7 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -30,7 +30,7 @@
 static unsigned int blktrace_seq __read_mostly = 1;
 
 static struct trace_array *blk_tr;
-static int __read_mostly  blk_tracer_enabled;
+static bool blk_tracer_enabled __read_mostly;
 
 /* Select an alternative, minimalistic output than the original one */
 #define TRACE_BLK_OPT_CLASSIC	0x1
@@ -1111,9 +1111,7 @@ static int blk_tracer_init(struct trace_array *tr)
 {
 	blk_tr = tr;
 	blk_tracer_start(tr);
-	mutex_lock(&blk_probe_mutex);
-	blk_tracer_enabled++;
-	mutex_unlock(&blk_probe_mutex);
+	blk_tracer_enabled = true;
 	return 0;
 }
 
@@ -1131,11 +1129,7 @@ static void blk_tracer_reset(struct trace_array *tr)
 	if (!atomic_read(&blk_probes_ref))
 		return;
 
-	mutex_lock(&blk_probe_mutex);
-	blk_tracer_enabled--;
-	WARN_ON(blk_tracer_enabled < 0);
-	mutex_unlock(&blk_probe_mutex);
-
+	blk_tracer_enabled = false;
 	blk_tracer_stop(tr);
 }
 
-- 
1.5.4.rc3
