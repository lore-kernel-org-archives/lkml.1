Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbXGPDex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbXGPDex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 23:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXGPDeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 23:34:46 -0400
Received: from www.sysreset.com ([209.97.229.250]:10582 "EHLO sysreset"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759038AbXGPDep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 23:34:45 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jul 2007 23:34:45 EDT
Message-Id: <6.2.0.14.2.20070715210841.02fcab90@linux.sysreset.com>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.0.14
Date: Sun, 15 Jul 2007 21:28:39 -0600
To: linux-ide@vger.kernel.org
From: Ryan Power <rpower@sysreset.com>
Subject: [PATCH 2.6.22.1] libata: Adjust libata to ignore errors after
  spinup
Cc: jgarzik@pobox.com, Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46982875.60503@rtr.ca>
References: <6.2.0.14.2.20070713000748.031a2660@linux.sysreset.com>
 <469775E0.2000609@rtr.ca>
 <6.2.0.14.2.20070713184231.02db2d20@linux.sysreset.com>
 <46982875.60503@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Power <rpower@sysreset.com>

Adjust libata to ignore errors after spinup

This patch is to ignore errors from the spinup attempt if the drive is
in the "standby id" state.

Signed-off-by: Ryan Power <rpower@sysreset.com>

---

Index: drivers.new/ata/libata-core.c
--- drivers/ata/libata-core.c   2007-07-10 12:56:30.000000000 -0600
+++ drivers.new/ata/libata-core.c       2007-07-15 01:58:49.000000000 -0600
@@ -1750,7 +1750,7 @@ int ata_dev_read_id(struct ata_device *d
                 tf.protocol = ATA_PROT_NODATA;
                 tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
                 err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, 
NULL, 0);
-               if (err_mask) {
+               if (err_mask && id[2] != 0x738c) {
                         rc = -EIO;
                         reason = "SPINUP failed";
                         goto err_out;


