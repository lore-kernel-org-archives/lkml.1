Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZCUPTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZCUPTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbZCUPTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:19:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:59883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbZCUPTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:19:16 -0400
Date: Sat, 21 Mar 2009 15:18:25 GMT
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
In-Reply-To: <49C2F5B2.8000800@cn.fujitsu.com>
References: <49C2F5B2.8000800@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: fix possible memory leak
Message-ID: <tip-1a17662ea033674a58bad3603531b0b5d42572f6@git.kernel.org>
Git-Commit-ID: 1a17662ea033674a58bad3603531b0b5d42572f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Mar 2009 15:18:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a17662ea033674a58bad3603531b0b5d42572f6
Gitweb:     http://git.kernel.org/tip/1a17662ea033674a58bad3603531b0b5d42572f6
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 20 Mar 2009 09:47:30 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Mar 2009 16:15:47 +0100

blktrace: fix possible memory leak

When we failed to create "block" debugfs dir, we should do some
cleanups.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49C2F5B2.8000800@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b171778..fb3bc53 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -432,7 +432,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!blk_tree_root) {
 		blk_tree_root = debugfs_create_dir("block", NULL);
 		if (!blk_tree_root)
-			return -ENOMEM;
+			goto err;
 	}
 
 	dir = debugfs_create_dir(buts->name, blk_tree_root);
