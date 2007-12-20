Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbXLTBl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbXLTBl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759125AbXLTBfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386AbXLTBe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hEVPDKsT2mXzYsEITmag5TB6uch08salnTBuJPuox9N4QYON4yHe+f5YG2IRQdWiCuqhbcUNIjKhhIn0xlV4kJNBlU4Ipi7BPZ1RnKF5FLDqZ+dyTFTx2+5Osyro1BDfo7RifSMBWaXKZi0Dmwk54K5zDdbLb/1dRpn9sp/sDtE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 22/63] ide-cd: remove struct atapi_{mechstat_header,changer_info,slot}
Date: Thu, 20 Dec 2007 02:09:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200209.24164.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Remove ->changer_info from struct cdrom_info (it is never allocated).

* Remove unused struct atapi_{mechstat_header,changer_info,slot}.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-11 bytes
 drivers/ide/ide-cd.c |    1 
 drivers/ide/ide-cd.h |   55 ---------------------------------------------------
 2 files changed, 56 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2948,7 +2948,6 @@ static void ide_cd_release(struct kref *
 
 	kfree(info->buffer);
 	kfree(info->toc);
-	kfree(info->changer_info);
 	if (devinfo->handle == drive && unregister_cdrom(devinfo))
 		printk(KERN_ERR "%s: %s failed to unregister device from the cdrom "
 				"driver.\n", __FUNCTION__, drive->name);
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -357,59 +357,6 @@ struct atapi_capabilities_page {
 	char pad[4];
 };
 
-
-struct atapi_mechstat_header {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 fault         : 1;
-	__u8 changer_state : 2;
-	__u8 curslot       : 5;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8 curslot       : 5;
-	__u8 changer_state : 2;
-	__u8 fault         : 1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 mech_state    : 3;
-	__u8 door_open     : 1;
-	__u8 reserved1     : 4;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8 reserved1     : 4;
-	__u8 door_open     : 1;
-	__u8 mech_state    : 3;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-	byte     curlba[3];
-	byte     nslots;
-	__u16	 slot_tablelen;
-};
-
-
-struct atapi_slot {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	__u8 disc_present : 1;
-	__u8 reserved1    : 6;
-	__u8 change       : 1;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8 change       : 1;
-	__u8 reserved1    : 6;
-	__u8 disc_present : 1;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-	byte reserved2[3];
-};
-
-struct atapi_changer_info {
-	struct atapi_mechstat_header hdr;
-	struct atapi_slot slots[0];
-};
-
 /* Extra per-device info for cdrom drives. */
 struct cdrom_info {
 	ide_drive_t	*drive;
@@ -434,8 +381,6 @@ struct cdrom_info {
 	int dma;
 	unsigned long last_block;
 	unsigned long start_seek;
-	/* Buffer to hold mechanism status and changer slot table. */
-	struct atapi_changer_info *changer_info;
 
 	struct ide_cd_config_flags	config_flags;
 	struct ide_cd_state_flags	state_flags;
