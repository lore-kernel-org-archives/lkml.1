Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYGXT1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYGXT1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGXT1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:27:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:14109 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbYGXT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Tu7axmwjTPNdYNfiJ+O8MJGtp+d8w90EdQyoEKwLUOg+86Yi1LwPnXaD2bPVBenvDj
         HMHt82k5sqevaJ5AX1uIrf5alk5+C6lvG+pl5J92ILwGNb422hW/S8RHxsWSc5eQdT5m
         qNVLwF0MuE6l3HuPDtz8sF7e/x8StIEFmBqpU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] isd200: use ATA_* defines instead of *_STAT and *_ERR ones
Date: Thu, 24 Jul 2008 21:23:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242123.42923.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/usb/storage/isd200.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: b/drivers/usb/storage/isd200.c
===================================================================
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -373,19 +373,19 @@ static void isd200_build_sense(struct us
 		buf->Flags = UNIT_ATTENTION;
 		buf->AdditionalSenseCode = 0;
 		buf->AdditionalSenseCodeQualifier = 0;
-	} else if(error & MCR_ERR) {
+	} else if (error & ATA_MCR) {
 		buf->ErrorCode = 0x70 | SENSE_ERRCODE_VALID;
 		buf->AdditionalSenseLength = 0xb;
 		buf->Flags =  UNIT_ATTENTION;
 		buf->AdditionalSenseCode = 0;
 		buf->AdditionalSenseCodeQualifier = 0;
-	} else if(error & TRK0_ERR) {
+	} else if (error & ATA_TRK0NF) {
 		buf->ErrorCode = 0x70 | SENSE_ERRCODE_VALID;
 		buf->AdditionalSenseLength = 0xb;
 		buf->Flags =  NOT_READY;
 		buf->AdditionalSenseCode = 0;
 		buf->AdditionalSenseCodeQualifier = 0;
-	} else if(error & ECC_ERR) {
+	} else if (error & ATA_UNC) {
 		buf->ErrorCode = 0x70 | SENSE_ERRCODE_VALID;
 		buf->AdditionalSenseLength = 0xb;
 		buf->Flags =  DATA_PROTECT;
@@ -898,22 +898,22 @@ static int isd200_try_enum(struct us_dat
 			break;
 
 		if (!detect) {
-			if (regs[ATA_REG_STATUS_OFFSET] & BUSY_STAT) {
+			if (regs[ATA_REG_STATUS_OFFSET] & ATA_BUSY) {
 				US_DEBUGP("   %s status is still BSY, try again...\n",mstr);
 			} else {
 				US_DEBUGP("   %s status !BSY, continue with next operation\n",mstr);
 				break;
 			}
 		}
-		/* check for BUSY_STAT and */
-		/* WRERR_STAT (workaround ATA Zip drive) and */ 
-		/* ERR_STAT (workaround for Archos CD-ROM) */
+		/* check for ATA_BUSY and */
+		/* ATA_DF (workaround ATA Zip drive) and */
+		/* ATA_ERR (workaround for Archos CD-ROM) */
 		else if (regs[ATA_REG_STATUS_OFFSET] &
-			 (BUSY_STAT | WRERR_STAT | ERR_STAT )) {
+			 (ATA_BUSY | ATA_DF | ATA_ERR)) {
 			US_DEBUGP("   Status indicates it is not ready, try again...\n");
 		}
 		/* check for DRDY, ATA devices set DRDY after SRST */
-		else if (regs[ATA_REG_STATUS_OFFSET] & READY_STAT) {
+		else if (regs[ATA_REG_STATUS_OFFSET] & ATA_DRDY) {
 			US_DEBUGP("   Identified ATA device\n");
 			info->DeviceFlags |= DF_ATA_DEVICE;
 			info->DeviceHead = master_slave;
