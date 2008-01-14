Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbYANVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbYANVJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYANVJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:09:05 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56575 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYANVJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:09:04 -0500
Date: Mon, 14 Jan 2008 23:08:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ondrej Zary <linux@rainbow-software.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: libata-scsi.c: new check-after-use
Message-ID: <20080114210805.GH9847@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 9b8e8de7e59b3a2dab3113d620b52dc8ba890fb3 did:

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -872,7 +872,8 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	ata_scsi_sdev_config(sdev);
 
-	sdev->manage_start_stop = 1;
+	if (dev->class == ATA_DEV_ATA)
+		sdev->manage_start_stop = 1;
 
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);


The Coverity checker spotted that this introduced a check-after-use
for "dev".


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

