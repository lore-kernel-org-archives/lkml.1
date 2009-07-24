Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbZGXIx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbZGXIx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZGXIx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:53:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZGXIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:53:27 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] block: fix improper kobject release in blk_integrity_unregister
Date: Fri, 24 Jul 2009 16:52:28 +0800
Message-Id: <1248425548-30600-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_integrity_unregister should use kobject_put to release the kobject,
otherwise after bi is freed, memory of bi->kobj->name is leaked.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 block/blk-integrity.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 73e28d3..15c6308 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -379,6 +379,7 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
 	kobject_del(&bi->kobj);
+	kobject_put(&bi->kobj);
 	kmem_cache_free(integrity_cachep, bi);
 	disk->integrity = NULL;
 }
-- 
1.6.2.5

