Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487Ab0ARRX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0ARRX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470Ab0ARRXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:23:14 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34219 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab0ARRXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:23:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pG3MC3mTK6WE+cXyY3fhyrjIEs5X/hjA/Ln97n9CgEcgQrWyfrDX2K9JbO5m75jkyX
         pwsgTDUdkEyoORCm6J28xvB8AFMtGhvRJG1ldXD1DcffmZfMAvNGZyXHvlz3+VAZdZsH
         d1ezLPMPsxfXpU7jVH+eMnykK0Um5wL6Uvi6E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:22:02 +0100
Message-Id: <20100118172202.14623.99244.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 59/64] it821x: use ->pio_mode value to determine pair device speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] it821x: use ->pio_mode value to determine pair device speed

Use the current PIO mode value instead of the physical maximum one
of the pair device on the port to determine PIO commmand timings used
for both devices on the port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/it821x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -252,7 +252,7 @@ static void it821x_set_pio_mode(ide_hwif
 	 * on the cable.
 	 */
 	if (pair) {
-		u8 pair_pio = ide_get_best_pio_mode(pair, 255, 4);
+		u8 pair_pio = pair->pio_mode - XFER_PIO_0;
 		/* trim PIO to the slowest of the master/slave */
 		if (pair_pio < set_pio)
 			set_pio = pair_pio;
