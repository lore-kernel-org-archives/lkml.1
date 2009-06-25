Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZFYTbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZFYTbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZFYTbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:31:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZFYTbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:31:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] dm table: pass device's data start to blk_stack_limits() in bytes
Date: Thu, 25 Jun 2009 15:31:10 -0400
Message-Id: <1245958270-23578-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offset passed to blk_stack_limits() must be in bytes not sectors.
Fixes false warnings like the following:
device-mapper: table: 254:1: target device sda6 is misaligned

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>

--
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -495,7 +495,7 @@ int dm_set_device_limits(struct dm_targe
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start) < 0)
+	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
 		DMWARN("%s: target device %s is misaligned",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
 
