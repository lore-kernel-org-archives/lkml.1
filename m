Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415Ab0ARRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0ARRWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407Ab0ARRWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:22:17 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab0ARRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Ldg8q4S45NpU55oBeeX+oh+hM8KQVCh7UD1EDMNoEF0bAZqlVGnlAcJTTYyyegPGEm
         uzSp1CuLy48Xl+UWFeVQOffHz3bCDq4mvxKskC3qCRRQhiBQRtTXIZrhyxsqmWdssmbD
         I041erLRqlWM/BryzrIcT9gwzqLa8liFDOzkI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:20:58 +0100
Message-Id: <20100118172058.14623.81306.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 50/64] ide-timings: use ->pio_mode value to determine fastest PIO speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-timings: use ->pio_mode value to determine fastest PIO speed

Use the current PIO mode value instead of the physical maximum one
to determine the fastest allowed PIO for shared PIO/DMA timings.

Affected host drivers: amd74xx and via82cxxx.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-timings.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -189,8 +189,7 @@ int ide_timing_compute(ide_drive_t *driv
 	 * DMA cycle timing is slower/equal than the fastest PIO timing.
 	 */
 	if (speed >= XFER_SW_DMA_0) {
-		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
-		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
+		ide_timing_compute(drive, drive->pio_mode, &p, T, UT);
 		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
 	}
 
