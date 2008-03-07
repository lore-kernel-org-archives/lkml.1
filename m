Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbYCGJXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbYCGJXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762939AbYCGJNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:13:30 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:63359 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762603AbYCGJNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:13:25 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071013.837692778@firstfloor.org>
In-Reply-To: <200803071013.837692778@firstfloor.org>
To: jgarzik@pobox.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/7] Convert open coded reference in libata to q->bounce_gfp to blk_kmalloc
Message-Id: <20080307091322.EF4311B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:13:22 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:06:52.0689 (UTC) FILETIME=[959D4010:01C88032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Only difference in behaviour is that GFP_NOIO is not passed here now,
but I think that is ok in this case because this is not in a write out path.

Cc: jgarzik@pobox.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/ata/libata-scsi.c
===================================================================
--- linux.orig/drivers/ata/libata-scsi.c
+++ linux/drivers/ata/libata-scsi.c
@@ -868,7 +868,7 @@ static int ata_scsi_dev_config(struct sc
 		blk_queue_dma_pad(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
-		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
+		buf = blk_kmalloc(q, ATAPI_MAX_DRAIN, GFP_KERNEL);
 		if (!buf) {
 			ata_dev_printk(dev, KERN_ERR,
 				       "drain buffer allocation failed\n");
