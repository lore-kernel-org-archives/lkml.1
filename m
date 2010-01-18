Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455Ab0ARRW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0ARRW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263Ab0ARRWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:22:49 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:55501 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0ARRWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:22:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SNmr6Yro7JbuUp8bvz5hB3uvoQBqRFQdtC3Qre1yZzhZ3/EQWGi0dKFXZMc/T0nDsL
         P6KwFfXWppUpLGfU9FVvUPWQxoXrzk8837DJ5H8gQ6H4XWo23VI75Ax75WtX6nVkMVhJ
         DR6heQxOjWJMdQuaMYXAfsqkBAf0iW25GJ3sQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:21:33 +0100
Message-Id: <20100118172133.14623.99453.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 55/64] amd74xx: use ->pio_mode value to determine pair device speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] amd74xx: use ->pio_mode value to determine pair device speed

Use the current PIO mode value instead of the current transfer speed
of the pair device on the port to determine PIO commmand timings used
for both devices on the port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/amd74xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -94,7 +94,7 @@ static void amd_set_drive(ide_hwif_t *hw
 	ide_timing_compute(drive, speed, &t, T, UT);
 
 	if (peer) {
-		ide_timing_compute(peer, peer->current_speed, &p, T, UT);
+		ide_timing_compute(peer, peer->pio_mode, &p, T, UT);
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
 
