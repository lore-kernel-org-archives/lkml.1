Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbZIOTZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbZIOTZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758657AbZIOTZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:25:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:51718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758619AbZIOTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:25:39 -0400
Message-Id: <20090915192242.553693570@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 16 Sep 2009 05:19:04 +1000
From: npiggin@suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 1/5] fs: make use of rcu helpers
References: <20090915191903.290006007@suse.de>
Content-Disposition: inline; filename=fs-bdiwb-rcu-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_add_tail_rcu contains required barriers.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -152,11 +152,6 @@ static void bdi_queue_work(struct backin
 		atomic_set(&work->pending, bdi->wb_cnt);
 		BUG_ON(!bdi->wb_cnt);
 
-		/*
-		 * Make sure stores are seen before it appears on the list
-		 */
-		smp_mb();
-
 		spin_lock(&bdi->wb_lock);
 		list_add_tail_rcu(&work->list, &bdi->work_list);
 		spin_unlock(&bdi->wb_lock);


