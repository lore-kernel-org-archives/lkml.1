Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYJPWrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYJPWrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYJPWrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:47:37 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:24776 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYJPWrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:47:37 -0400
Date: Thu, 16 Oct 2008 17:47:36 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkml.scsi@roadking.ldev.net,
       alan.brunelle@hp.com
Subject: [PATCH 1/2] cciss: fix regression broken sysfs symlink (again)
Message-ID: <20081016224736.GA26564@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 of 2

The regression was introduced by commit
6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
This patch obsoletes the one I sent yesterday. It fixes a broken symlink in
sysfs. The previous patch appeared to work but was wrong as reported by Alan
Brunelle.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1e1f915..0f367b1 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1365,6 +1365,7 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
 	disk->private_data = &h->drv[drv_index];
+	disk->driverfs_dev = &h->pdev->dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
