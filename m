Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566Ab0ARRYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0ARRYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461Ab0ARRXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:23:13 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51627 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0ARRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wgt4Hi+dBP4PgytdMXiyP15a865P3U09Vry37WITHCkW0DNV6Rpum6mOBzsCqrSbgf
         0X9Dj3PwA+kgyhkak0qb8hsqddjP4oeuj1GwJ91XEqZMh6NVmaBkik7PEtzC/NAyflWc
         2KvYwbXkElUPA32bGvSuBauAZ0eQB0yrAsRFo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:21:55 +0100
Message-Id: <20100118172155.14623.42696.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 58/64] cs5536: use ->pio_mode value to determine pair device speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cs5536: use ->pio_mode value to determine pair device speed

Use the current PIO mode value instead of the physical maximum one
of the pair device on the port to determine PIO commmand timings used
for both devices on the port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cs5536.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/cs5536.c
===================================================================
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -152,7 +152,7 @@ static void cs5536_set_pio_mode(ide_hwif
 	u8 cmd_pio = pio;
 
 	if (pair)
-		cmd_pio = min(pio, ide_get_best_pio_mode(pair, 255, 4));
+		cmd_pio = min_t(u8, pio, pair->pio_mode - XFER_PIO_0);
 
 	timings &= (IDE_DRV_MASK << 8);
 	timings |= drv_timings[pio];
