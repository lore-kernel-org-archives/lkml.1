Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJNSrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJNSrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYJNSq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:46:56 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:9533 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYJNSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:46:55 -0400
Date: Tue, 14 Oct 2008 13:46:49 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, JensAxboejens.axboe@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>, dchapman@redhat.com,
       hare@novell.com, sandy.garza@hp.com, karen.skweres@hp.com
Subject: [PATCH 1/1] cciss: fix regression, sysfs symlink missing
Message-ID: <20081014184649.GA12212@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 of 1

This patch fixes a regression where the device symlink to the pci address is
not created. Offending commit 6ae5ce8e8d4de666f31286808d2285aa6a50fa40,
cciss: rmove redundant code.

Please consider this for inclusion.

signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1e1f915..44fb98e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1365,6 +1365,7 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
 	disk->private_data = &h->drv[drv_index];
+	disk->driverfs_dev = &(hba[drv_index]->pdev->dev);
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
