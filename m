Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYGVVSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYGVVSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbYGVVPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:15:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:36945 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbYGVVPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=nLl7wx6e+21OpIkRLXlf+VHm87BuewDKER18ee8ySqbZIAiZUxvNFepfrnDwdFDbd1
         T/clogTjLi59YZTKrAzTeryhb6oKwBDAurwbSk7tBeArNC0aLnck1ItRlJ/2OgtbHChD
         SNsGPzi8iMAeVbNe/37uyCSdWqo6HFHNQ+ciA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:13:04 +0200
Message-Id: <20080722211304.20478.1192.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/10] ide-disk: use ata_id_wcache_enabled()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded check by ata_id_wcache_enabled()
(which also checks validity of word 85).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -896,7 +896,7 @@ static void idedisk_setup(ide_drive_t *d
 			 drive->bios_cyl, drive->bios_head, drive->bios_sect);
 
 	/* write cache enabled? */
-	if ((id[ATA_ID_CSFO] & 1) || (id[ATA_ID_CFS_ENABLE_1] & (1 << 5)))
+	if ((id[ATA_ID_CSFO] & 1) || ata_id_wcache_enabled(id))
 		drive->wcache = 1;
 
 	write_cache(drive, 1);
