Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbYG1VDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbYG1VDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYG1VDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:03:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:20312 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYG1VDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=YObhrTq+gokDi5sp4KxTtpvqcSd+CezA9T/i+FEpacp2EQNRAw9si/DN4uLRdS3uvo
         f4bHWR7dljhFqgXV1+a807Kk8UMIjfkIrwgTayo5WB8Moo/w6y/Kc0tNnE6518PUrIB9
         A2We8dOa13Srnw1LVH4pBYImLC3MjH3HAdjTY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: ide_dev_has_iordy() -> ata_id_has_iordy()
Date: Mon, 28 Jul 2008 22:55:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807282255.58904.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove (id[ATA_ID_FIELD_VALID] & 2) check from ide_dev_has_iordy()
  (it is for validity of words 64-70, IORDY is in word 49).

* ide_dev_has_iordy() -> ata_id_has_iordy()

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sl82c105.c |    2 +-
 include/linux/ide.h        |    5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -61,7 +61,7 @@ static unsigned int get_pio_timings(ide_
 	if (cmd_off == 0)
 		cmd_off = 1;
 
-	if (pio > 2 || ide_dev_has_iordy(drive->id))
+	if (pio > 2 || ata_id_has_iordy(drive->id))
 		iordy = 0x40;
 
 	return (cmd_on - 1) << 8 | (cmd_off - 1) | iordy;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1391,11 +1391,6 @@ const char *ide_xfer_verbose(u8 mode);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 
-static inline int ide_dev_has_iordy(u16 *id)
-{
-	return ((id[ATA_ID_FIELD_VALID] & 2) && ata_id_has_iordy(id)) ? 1 : 0;
-}
-
 static inline int ide_dev_is_sata(u16 *id)
 {
 	/*
