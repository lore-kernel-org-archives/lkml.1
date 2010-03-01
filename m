Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0CAHyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 02:54:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41823 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab0CAHyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 02:54:43 -0500
Date: Mon, 1 Mar 2010 18:54:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: manual merge of the usb tree with the block tree
Message-Id: <20100301185441.06014ba8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/storage/scsiglue.c between commit
086fa5ff0854c676ec333760f4c0154b3b242616 ("block: Rename
blk_queue_max_sectors to blk_queue_max_hw_sectors") from the block tree
and commit 628726dbb5ebbec77336019ac4e1f60cf3ba08c1 ("usb-storage: use
max_hw_sectors instead of max_sectors") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/storage/scsiglue.c
index aadc16b,354c38e..0000000
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@@ -133,8 -133,8 +133,8 @@@ static int slave_configure(struct scsi_
  
  		if (us->fflags & US_FL_MAX_SECTORS_MIN)
  			max_sectors = PAGE_CACHE_SIZE >> 9;
- 		if (queue_max_sectors(sdev->request_queue) > max_sectors)
+ 		if (queue_max_hw_sectors(sdev->request_queue) > max_sectors)
 -			blk_queue_max_sectors(sdev->request_queue,
 +			blk_queue_max_hw_sectors(sdev->request_queue,
  					      max_sectors);
  	} else if (sdev->type == TYPE_TAPE) {
  		/* Tapes need much higher max_sector limits, so just
@@@ -494,9 -494,9 +494,9 @@@ static ssize_t store_max_sectors(struc
  	struct scsi_device *sdev = to_scsi_device(dev);
  	unsigned short ms;
  
- 	if (sscanf(buf, "%hu", &ms) > 0 && ms <= SCSI_DEFAULT_MAX_SECTORS) {
+ 	if (sscanf(buf, "%hu", &ms) > 0) {
 -		blk_queue_max_sectors(sdev->request_queue, ms);
 +		blk_queue_max_hw_sectors(sdev->request_queue, ms);
- 		return strlen(buf);
+ 		return count;
  	}
  	return -EINVAL;	
  }
