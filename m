Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYJAHjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYJAHjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYJAHjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:39:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21638 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYJAHjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:39:31 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/7] block: Fix double put in blk_integrity_unregister
Date: Wed,  1 Oct 2008 03:38:38 -0400
Message-Id: <1222846723-18213-3-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - kobject_del already puts the parent.

 - Set integrity profile to NULL to prevent stale data.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-integrity.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 69023da..e3817a0 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -376,7 +376,7 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
 	kobject_del(&bi->kobj);
-	kobject_put(&disk_to_dev(disk)->kobj);
 	kmem_cache_free(integrity_cachep, bi);
+	disk->integrity = NULL;
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
-- 
1.6.0.2

