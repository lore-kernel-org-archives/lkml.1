Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYKIQ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYKIQ2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYKIQZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:25:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:60863 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbYKIQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:25:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=spml9wM62wtWMpKxpOxmKc/JYMaoBxdvV54iKwe3aNyJTqP3tejaBwdqVaHsX0dfhd
         F3ozxXNDSgXNy3Y3f4qd8L+v9eBOohF1CRqo5IKOP8339DZcZqzlGOtlxW21eq7IimkD
         QpdN3vs9J41cKUKLuI15TG9tC44SDLwHXTUW0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:23:24 +0100
Message-Id: <20081109162324.18999.29895.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/11] ide: remove superfluous local_irq_{save,restore}() from ide_dump_status()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove superfluous local_irq_{save,restore}() from ide_dump_status()

No reason to run this function with local IRQs off.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-lib.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -384,10 +384,8 @@ static void ide_dump_atapi_error(ide_dri
 
 u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 {
-	unsigned long flags;
 	u8 err = 0;
 
-	local_irq_save(flags);
 	printk(KERN_ERR "%s: %s: status=0x%02x { ", drive->name, msg, stat);
 	if (stat & ATA_BUSY)
 		printk(KERN_CONT "Busy ");
@@ -417,7 +415,6 @@ u8 ide_dump_status(ide_drive_t *drive, c
 			ide_dump_atapi_error(drive, err);
 	}
 	ide_dump_opcode(drive);
-	local_irq_restore(flags);
 	return err;
 }
 EXPORT_SYMBOL(ide_dump_status);
