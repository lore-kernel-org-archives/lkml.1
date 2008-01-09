Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYAIXlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYAIXlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbYAIXlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:41:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:2113 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908AbYAIXlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:41:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mVcRHGZMdWnZb78BpFnC9ErkJ06WKoQHMHq1Qi0dXJjYJKhSaCwNY6dDinSQqOe1hV4n8Pako5xHLsRnn6Oi8z9e4TKqdUDzRjaFgptBX3EqP8SKngWUeZdZ1H1FJoszIWfAFekxjB8vd0KECBu70hdSjdR40ZV2wH3QriKtzk0=
Message-ID: <47855B99.3080302@gmail.com>
Date: Thu, 10 Jan 2008 08:41:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata and starting/stopping ATAPI floppy devices
References: <200801051647.58866.linux@rainbow-software.org> <4784344C.5060208@gmail.com> <200801091853.15601.linux@rainbow-software.org>
In-Reply-To: <200801091853.15601.linux@rainbow-software.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Prevent libata from starting/stopping non-ATA devices (like ATAPI floppy 
drives) as they don't seem to like it:

sd 1:0:1:0: [sdb] Starting disk
ata2.01: configured for PIO2
sd 1:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
sd 1:0:1:0: [sdb] Sense Key : 0x2 [current]
sd 1:0:1:0: [sdb] ASC=0x3a ASCQ=0x0

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Trimmed message body and reformatted such that it's script friendly.

 drivers/ata/libata-scsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.23-orig/drivers/ata/libata-scsi.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23-pentium/drivers/ata/libata-scsi.c	2008-01-05 15:50:16.000000000 +0100
@@ -802,7 +802,8 @@
 
 	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
 
-	sdev->manage_start_stop = 1;
+	if (dev->class == ATA_DEV_ATA)
+		sdev->manage_start_stop = 1;
 
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);

