Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbXKVPBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbXKVPBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 10:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbXKVPAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 10:00:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbXKVPAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 10:00:53 -0500
Message-ID: <47459985.4080700@redhat.com>
Date: Thu, 22 Nov 2007 16:00:21 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: [PATCH] block: Fix memory leak in alloc_disk_node()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak in alloc_disk_node(). Don't forget to free 'dkstats' when the allocation of 'part' failed.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 genhd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/genhd.c b/block/genhd.c
index e609996..f2ac914 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -715,6 +715,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 			disk->part = kmalloc_node(size,
 				GFP_KERNEL | __GFP_ZERO, node_id);
 			if (!disk->part) {
+				free_disk_stats(disk);
 				kfree(disk);
 				return NULL;
 			}
