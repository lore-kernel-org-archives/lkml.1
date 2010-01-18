Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550Ab0ARRYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0ARRYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468Ab0ARRXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:23:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:50713 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab0ARRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:23:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=btVGFMWGb2z7R8ZTxUFlYuGpLvLH/2ex9vQdK5d/vrcuViklsI4aOBstT1sxnmybkB
         z5WeVQem330PzPYwd7Fa0tcyTy4i6Nw0Uld1Nb574zqDPX2S/8twP4tSpmWcV3RxoCZn
         XLfp/GKD9XvpIBQbORXL2hTHAqP9D6E5TM44Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:22:09 +0100
Message-Id: <20100118172209.14623.38294.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 60/64] palm_bk3710: use ->pio_mode value to determine pair device speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] palm_bk3710: use ->pio_mode value to determine pair device speed

Use the current PIO mode value instead of the physical maximum one
of the pair device on the port to determine PIO commmand timings used
for both devices on the port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/palm_bk3710.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -166,7 +166,7 @@ static void palm_bk3710_setpiomode(void
 	writel(val32, base + BK3710_DATRCVR);
 
 	if (mate) {
-		u8 mode2 = ide_get_best_pio_mode(mate, 255, 4);
+		u8 mode2 = mate->pio_mode - XFER_PIO_0;
 
 		if (mode2 < mode)
 			mode = mode2;
