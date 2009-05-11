Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZEKLex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZEKLex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZEKLen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:34:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:37347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZEKLem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:34:42 -0400
Date: Mon, 11 May 2009 11:33:30 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       Alan.Brunelle@hp.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, Alan.Brunelle@hp.com,
       jens.axboe@oracle.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <4A07CE86.5090301@cn.fujitsu.com>
References: <4A07CE86.5090301@cn.fujitsu.com>
Subject: [tip:tracing/core] blktrace: from-sector redundant in trace_block_remap, cleanup
Message-ID: <tip-79c5d3ce614d8fe706545c7bca2158b63db6bb5e@git.kernel.org>
Git-Commit-ID: 79c5d3ce614d8fe706545c7bca2158b63db6bb5e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 11:33:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79c5d3ce614d8fe706545c7bca2158b63db6bb5e
Gitweb:     http://git.kernel.org/tip/79c5d3ce614d8fe706545c7bca2158b63db6bb5e
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 11 May 2009 15:06:46 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 13:30:24 +0200

blktrace: from-sector redundant in trace_block_remap, cleanup

The last argument of block_remap prober is the original sector
before remap, so it should be 'from', not 'to'.

[ Impact: clean up ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
LKML-Reference: <4A07CE86.5090301@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/block.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/block.h b/include/trace/block.h
index 8ac945b..5b12efa 100644
--- a/include/trace/block.h
+++ b/include/trace/block.h
@@ -70,7 +70,7 @@ DECLARE_TRACE(block_split,
 
 DECLARE_TRACE(block_remap,
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t to),
-	      TP_ARGS(q, bio, dev, to));
+		 sector_t from),
+	      TP_ARGS(q, bio, dev, from));
 
 #endif
