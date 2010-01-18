Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538Ab0ARRXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0ARRXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425Ab0ARRXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:23:44 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51627 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab0ARRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:23:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=MpTIAHqrGZkKcYuG6JHGFgaO/sF6bniRkM9+RP7s7CwQXlV2DhKC4zUGGLRQmTDMuY
         81rBVUX1pjsn8zFk6uf5Jl1SogSARbI7+d7Uh7E/XNNM6EHOiZSnoLWWldAGyW1VPWtg
         ikleACVX/3aU1Wl5T3LxMv9vTRnJOpPAuQuAw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:22:30 +0100
Message-Id: <20100118172230.14623.55986.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 63/64] via82cxxx: use ->pio_mode value to determine pair device speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] via82cxxx: use ->pio_mode value to determine pair device speed

Use the current PIO mode value instead of the current transfer speed
of the pair device on the port to determine PIO commmand timings used
for both devices on the port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/via82cxxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -199,7 +199,7 @@ static void via_set_drive(ide_hwif_t *hw
 	ide_timing_compute(drive, speed, &t, T, UT);
 
 	if (peer) {
-		ide_timing_compute(peer, peer->current_speed, &p, T, UT);
+		ide_timing_compute(peer, peer->pio_mode, &p, T, UT);
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
 
