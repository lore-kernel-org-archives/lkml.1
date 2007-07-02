Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbXGBWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbXGBWP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXGBWPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:15:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:50247 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263AbXGBWPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:15:16 -0400
Date: Mon, 2 Jul 2007 18:15:13 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] fix the libata fix
Message-ID: <20070702221512.GA29760@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(this pulls everything in 'upstream-linus', too)

Please pull from the 'upstream-linus2' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus2

to receive the previously sent changes, and in addition, the following fix:

commit 531e3a61f55261bf466d0415c48999511334933c
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Jul 2 18:12:19 2007 -0400

    [libata] sata_nv: undo merge error
    
    Only the ADMA entry was supposed to be able to change queue depth.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/sata_nv.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index d53cb8c..b265686 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -307,7 +307,6 @@ static struct scsi_host_template nv_sht = {
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
