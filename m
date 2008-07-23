Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYGWSvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYGWSvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYGWSu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:50:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:1624 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbYGWSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=AYTKI6xXCVc0QDjfWg2Euiz+mZ0GCVXM3WT2jEt7sWSywQNcvKwMX1gDBB6+SgwBT8
         pNcX2DnZNK7B8scHhrrMXY7OFu0uQ2YGlB63ARbpNQje3hvjeWcw2fgprGWq2fprAlV2
         L0VHMvbsPvsVIRAV5XELxAbWxLE3WseoYcWjE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/7] isd200: WIN_* -> ATA_CMD_*
Date: Wed, 23 Jul 2008 20:44:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807232044.45700.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use ATA_CMD_* defines instead of WIN_* ones.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/usb/storage/isd200.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: b/drivers/usb/storage/isd200.c
===================================================================
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -501,14 +501,14 @@ static int isd200_action( struct us_data
 		ata.generic.ActionSelect = ACTION_SELECT_1|ACTION_SELECT_5;
 		ata.generic.RegisterSelect = REG_DEVICE_HEAD | REG_COMMAND;
 		ata.write.DeviceHeadByte = info->DeviceHead;
-		ata.write.CommandByte = WIN_SRST;
+		ata.write.CommandByte = ATA_CMD_DEV_RESET;
 		isd200_set_srb(info, DMA_NONE, NULL, 0);
 		break;
 
 	case ACTION_IDENTIFY:
 		US_DEBUGP("   isd200_action(IDENTIFY)\n");
 		ata.generic.RegisterSelect = REG_COMMAND;
-		ata.write.CommandByte = WIN_IDENTIFY;
+		ata.write.CommandByte = ATA_CMD_ID_ATA;
 		isd200_set_srb(info, DMA_FROM_DEVICE, info->id,
 				ATA_ID_WORDS * 2);
 		break;
@@ -1288,7 +1288,7 @@ static int isd200_scsi_to_ata(struct scs
 		ataCdb->write.CylinderHighByte = (unsigned char)(cylinder>>8);
 		ataCdb->write.CylinderLowByte = (unsigned char)cylinder;
 		ataCdb->write.DeviceHeadByte = (head | ATA_ADDRESS_DEVHEAD_STD);
-		ataCdb->write.CommandByte = WIN_READ;
+		ataCdb->write.CommandByte = ATA_CMD_PIO_READ;
 		break;
 
 	case WRITE_10:
@@ -1320,7 +1320,7 @@ static int isd200_scsi_to_ata(struct scs
 		ataCdb->write.CylinderHighByte = (unsigned char)(cylinder>>8);
 		ataCdb->write.CylinderLowByte = (unsigned char)cylinder;
 		ataCdb->write.DeviceHeadByte = (head | ATA_ADDRESS_DEVHEAD_STD);
-		ataCdb->write.CommandByte = WIN_WRITE;
+		ataCdb->write.CommandByte = ATA_CMD_PIO_WRITE;
 		break;
 
 	case ALLOW_MEDIUM_REMOVAL:
@@ -1334,7 +1334,7 @@ static int isd200_scsi_to_ata(struct scs
 			ataCdb->generic.TransferBlockSize = 1;
 			ataCdb->generic.RegisterSelect = REG_COMMAND;
 			ataCdb->write.CommandByte = (srb->cmnd[4] & 0x1) ?
-				WIN_DOORLOCK : WIN_DOORUNLOCK;
+				ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			US_DEBUGP("   Not removeable media, just report okay\n");
