Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407Ab0ARRXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0ARRXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346Ab0ARRXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:23:08 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34219 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab0ARRW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:22:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OWSEuBLbbgtEm7M7Ztlokf7I/rntPOEqGuRXTrj1dkKMa1FEvdyIWxdw/LPIyxGbag
         h+iD2zMHk0rnLLy7oGqecCtbbhLrMbrhxFvSyxRn09Lv9pHoWsJinfPCfgAelI8Wm2Wp
         MXzrNQeAfKr0W3Ict9sJOJht/67+VIiuMbLiQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:21:48 +0100
Message-Id: <20100118172148.14623.18579.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 57/64] cs5535: use ->pio_mode value to determine pair device speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cs5535: use ->pio_mode value to determine pair device speed

Use the current PIO mode value instead of the physical maximum one
of the pair device on the port to determine PIO commmand timings used
for both devices on the port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cs5535.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/cs5535.c
===================================================================
--- a/drivers/ide/cs5535.c
+++ b/drivers/ide/cs5535.c
@@ -86,7 +86,7 @@ static void cs5535_set_speed(ide_drive_t
 		cmd = pioa = speed - XFER_PIO_0;
 
 		if (pair) {
-			u8 piob = ide_get_best_pio_mode(pair, 255, 4);
+			u8 piob = pair->pio_mode - XFER_PIO_0;
 
 			if (piob < cmd)
 				cmd = piob;
