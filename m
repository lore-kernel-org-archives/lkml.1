Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522Ab0A2QGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0A2QGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559Ab0A2QGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:07 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab0A2QGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AX5t7XE+N/KLyZJrdMe3ySMgXh1c4eq8dXQgRp1OYs+G4/pW5ypBFnIlsgGcNTe7/b
         BbrJUgg3EA+hE4+SUrm5qWDDgrGZST8N4/66l6NTv2bURfVjYLb+8k9K5VaIHwbe0NLk
         qKgLE62R97eLYgIXYzbFLJSicSQrBw1eGJn4M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:05:57 +0100
Message-Id: <20100129160557.21495.29619.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 26/68] piix: always program control bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] piix: always program control bits

This matches behavior of libata ata_piix host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/piix.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -103,20 +103,16 @@ static void piix_set_pio_mode(ide_hwif_t
 	if (is_slave) {
 		master_data |=  0x4000;
 		master_data &= ~0x0070;
-		if (pio > 1) {
-			/* Set PPE, IE and TIME */
-			master_data |= control << 4;
-		}
+		/* Set PPE, IE and TIME */
+		master_data |= control << 4;
 		pci_read_config_byte(dev, slave_port, &slave_data);
 		slave_data &= hwif->channel ? 0x0f : 0xf0;
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) <<
 			       (hwif->channel ? 4 : 0);
 	} else {
 		master_data &= ~0x3307;
-		if (pio > 1) {
-			/* enable PPE, IE and TIME */
-			master_data |= control;
-		}
+		/* enable PPE, IE and TIME */
+		master_data |= control;
 		master_data |= (timings[pio][0] << 12) | (timings[pio][1] << 8);
 	}
 	pci_write_config_word(dev, master_port, master_data);
