Return-Path: <linux-kernel-owner+w=401wt.eu-S935623AbXHHOmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935623AbXHHOmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933427AbXHHOm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:42:26 -0400
Received: from rtr.ca ([64.26.128.89]:3698 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764900AbXHHOmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:42:25 -0400
Message-ID: <46B9D64E.6070609@rtr.ca>
Date: Wed, 08 Aug 2007 10:42:22 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata git tree, mbox queue status and contents
References: <46B35344.3090208@garzik.org>
In-Reply-To: <46B35344.3090208@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

This patch (below) is needed by WD drives that powerup-in-standby.

Cheers

Mark

-------- Original Message --------
Subject: + libata-adjust-libata-to-ignore-errors-after.patch added to -mm tree
Date: Wed, 18 Jul 2007 17:03:29 -0700
From: akpm@linux-foundation.org
To: mm-commits@vger.kernel.org
CC: rpower@sysreset.com, htejun@gmail.com, jeff@garzik.org,	liml@rtr.ca


The patch titled
     libata: adjust libata to ignore errors after spinup
has been added to the -mm tree.  Its filename is
     libata-adjust-libata-to-ignore-errors-after.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: adjust libata to ignore errors after spinup
From: Ryan Power <rpower@sysreset.com>

Adjust libata to ignore errors after spinup

This patch is to ignore errors from the spinup attempt if the drive is
in the "standby id" state.

Signed-off-by: Ryan Power <rpower@sysreset.com>
Acked-by: Mark Lord <liml@rtr.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN /dev/null /dev/null
diff -puN drivers/ata/libata-core.c~libata-adjust-libata-to-ignore-errors-after drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-adjust-libata-to-ignore-errors-after
+++ a/drivers/ata/libata-core.c
@@ -1723,7 +1723,7 @@ int ata_dev_read_id(struct ata_device *d
 		tf.protocol = ATA_PROT_NODATA;
 		tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 		err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
-		if (err_mask) {
+		if (err_mask && id[2] != 0x738c) {
 			rc = -EIO;
 			reason = "SPINUP failed";
 			goto err_out;
_

Patches currently in -mm which might be from rpower@sysreset.com are

libata-adjust-libata-to-ignore-errors-after.patch
