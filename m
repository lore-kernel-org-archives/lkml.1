Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbXEUPPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbXEUPPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbXEUPPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:15:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:54063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232AbXEUPPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:15:37 -0400
Date: Mon, 21 May 2007 17:15:26 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] [scsi] Remove __GFP_DMA
Message-ID: <20070521151525.GA581@suse.de>
Mail-Followup-To: linux-scsi@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	James Bottomley <James.Bottomley@SteelEye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] [scsi] Remove __GFP_DMA

After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to alloate a
DMA buffer any more in sd.c.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1515,7 +1515,7 @@ static int sd_revalidate_disk(struct gen
 	if (!scsi_device_online(sdp))
 		goto out;
 
-	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
+	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer) {
 		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
 			  "allocation failure.\n");
