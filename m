Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509Ab0ARRXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0ARRXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296Ab0ARRXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:23:33 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60556 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab0ARRX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:23:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Z4T8RK5a4MM+mjqW57dOnjKds6aonjbt2XoGpqPiK+/iZNjfw9EpaSYxeVJXxHY774
         xqaK3MVdL/GcV5n8vEoBoPPiZty9SgFkuPkrD/e0a/OA15rb+NEImvWqKu70EL/O1O5p
         9sxxn+AA8zuB/YHBriHmISv7yhae07zGG1RRA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:22:16 +0100
Message-Id: <20100118172216.14623.20590.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 61/64] siimage: use ->pio_mode value to determine pair device speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] siimage: use ->pio_mode value to determine pair device speed

Use the current PIO mode value instead of the physical maximum one
of the pair device on the port to determine PIO commmand timings used
for both devices on the port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/siimage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -258,7 +258,7 @@ static void sil_set_pio_mode(ide_hwif_t
 
 	/* trim *taskfile* PIO to the slowest of the master/slave */
 	if (pair) {
-		u8 pair_pio = ide_get_best_pio_mode(pair, 255, 4);
+		u8 pair_pio = pair->pio_mode - XFER_PIO_0;
 
 		if (pair_pio < tf_pio)
 			tf_pio = pair_pio;
