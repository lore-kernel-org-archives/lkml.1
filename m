Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZCTBr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZCTBr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZCTBrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:47:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58921 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbZCTBrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:47:12 -0400
Message-ID: <49C2F5B2.8000800@cn.fujitsu.com>
Date: Fri, 20 Mar 2009 09:47:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] blktrace: fix possible memory leak
References: <49C2F599.3060306@cn.fujitsu.com>
In-Reply-To: <49C2F599.3060306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we failed to create "block" debugfs dir, we should do come cleanups.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3

