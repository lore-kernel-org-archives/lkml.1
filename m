Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892Ab0A2QSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0A2QSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814Ab0A2QRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:17:49 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab0A2QGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qZQzOpVPWo2INsqymeX1Y4059N8OZX45Z45LTPcyp5nn5pPOeUxrJkYNSeaO1qBpIE
         S741XtTYLUj20ue6toS4FXjEiBZkdjavQvfNWmlutCWbE7zEIkSOCEqICVdjNIFCmKX5
         HK+87p6+6IMuQgYiOmwa2CYQg7TmEqqJGWCsU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:03 +0100
Message-Id: <20100129160603.21495.85374.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 27/68] slc90e66: always program control bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] slc90e66: always program control bits

This matches behavior of libata pata_efar host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/slc90e66.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: b/drivers/ide/slc90e66.c
===================================================================
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -50,20 +50,16 @@ static void slc90e66_set_pio_mode(ide_hw
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
