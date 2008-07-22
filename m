Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYGVVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYGVVTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbYGVVPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:15:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:37860 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbYGVVPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rqwu/vfvwHWqtr44UnPW247MooLnksGxj7RKpx2kMfwEjGZzhjeDVuRitCXhYxo5zE
         Md9mQiSmb1XxyB3O7qOhrgpkdYytpy7jZsMiE+8HaByuox5zRhkexqpBdiqNQKPGGkGW
         pTUldcLVNPJhhuHVfn74GMZSt1WK4Mna+2ZQs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:13:11 +0200
Message-Id: <20080722211311.20478.47051.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/10] ide-disk: use ata_id_hpa_enabled()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idedisk_supports_hpa() -> ata_id_hpa_enabled().

The latter one also checks validity of words 82 & 85.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -379,17 +379,6 @@ static unsigned long long sectors_to_MB(
 }
 
 /*
- * Bits 10 of command_set_1 and cfs_enable_1 must be equal,
- * so on non-buggy drives we need test only one.
- * However, we should also check whether these fields are valid.
- */
-static inline int idedisk_supports_hpa(const u16 *id)
-{
-	return (id[ATA_ID_COMMAND_SET_1] & 0x0400) &&
-	       (id[ATA_ID_CFS_ENABLE_1] & 0x0400);
-}
-
-/*
  * The same here.
  */
 static inline int idedisk_supports_lba48(const u16 *id)
@@ -468,7 +457,7 @@ static void init_idedisk_capacity(ide_dr
 	 * If this drive supports the Host Protected Area feature set,
 	 * then we may need to change our opinion about the drive's capacity.
 	 */
-	int hpa = idedisk_supports_hpa(id);
+	int hpa = ata_id_hpa_enabled(id);
 
 	if (idedisk_supports_lba48(id)) {
 		/* drive speaks 48-bit LBA */
@@ -946,7 +935,7 @@ static int ide_disk_probe(ide_drive_t *d
  */
 static void ide_disk_resume(ide_drive_t *drive)
 {
-	if (idedisk_supports_hpa(drive->id))
+	if (ata_id_hpa_enabled(drive->id))
 		init_idedisk_capacity(drive);
 }
 
