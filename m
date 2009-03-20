Return-Path: <linux-kernel-owner+w=401wt.eu-S1762781AbZCTK3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762781AbZCTK3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762502AbZCTK0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:26:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:35303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762494AbZCTK0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:26:50 -0400
Date: Fri, 20 Mar 2009 10:26:01 GMT
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
In-Reply-To: <49C2F5D3.8090104@cn.fujitsu.com>
References: <49C2F5D3.8090104@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: make blk_tracer_enabled a bool flag
Message-ID: <tip-e73fe657c9a1edba1611b4642b2d226634c1a652@git.kernel.org>
Git-Commit-ID: e73fe657c9a1edba1611b4642b2d226634c1a652
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:26:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e73fe657c9a1edba1611b4642b2d226634c1a652
Gitweb:     http://git.kernel.org/tip/e73fe657c9a1edba1611b4642b2d226634c1a652
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 20 Mar 2009 09:48:03 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:20:04 +0100

blktrace: make blk_tracer_enabled a bool flag

It doesn't have to be a counter, and it can be a bool flag instead.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C2F5D3.8090104@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
