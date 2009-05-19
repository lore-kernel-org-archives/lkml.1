Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZESVPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZESVPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZESVOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:14:43 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:48523 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZESVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=C7wzPg2xvoLHkmeJ5G6RiXi7VxDVvFfs2Sg6zNh6F0PsbopgiXvo8tnLdEP8Il2hbi
         0ZA1DuTEaApeZ8YhNtCZsvkGEQkvZC/vlsgMAOtEgalV88VwizqC5OysKabToAOo7FxD
         Lk+ICv+0UHWrAHZX8+ndq4RZot6FJ1aucKhvc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: fix printk() levels in ide_dump_ata[pi]_error()
Date: Tue, 19 May 2009 23:17:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Martin Lottermoser <Martin.Lottermoser@t-online.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905192317.24120.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes "<3>" in error messages like this one:

hdc: cdrom_decode_status: error=0x40 <3>{ LastFailedSense=0x04 }

Reported-by: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -91,7 +91,7 @@ static void ide_dump_sector(ide_drive_t 
 
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	printk(KERN_CONT "{ ");
 	if (err & ATA_ABORTED)
 		printk(KERN_CONT "DriveStatusError ");
 	if (err & ATA_ICRC)
@@ -121,7 +121,7 @@ static void ide_dump_ata_error(ide_drive
 
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	printk(KERN_CONT "{ ");
 	if (err & ATAPI_ILI)
 		printk(KERN_CONT "IllegalLengthIndication ");
 	if (err & ATAPI_EOM)
