Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYLUVBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYLUVBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbYLUVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:00:24 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34166 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYLUVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=DKk0Fvv8vXxQAD6ZWgQH4pVlfMG8Mnr0d62nrfG5xw8h5MGLAY/ncWrHDqsE+GVwiS
         j+SY8x8KegXb78MGxGIyY6Q2dqFBnp26htzj4uejhTKC9VC0okCUZViw+YYUlQw2UKIy
         r30vHYiyUr1O3mqvp2vi9PIqgd8R0KczNAxUM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2008 22:00:22 +0100
Message-Id: <20081221210022.23795.64425.sendpatchset@localhost.localdomain>
In-Reply-To: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
References: <20081221210007.23795.27999.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/7] cmd64x: use ide_get_pair_dev() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cmd64x: use ide_get_pair_dev() helper

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cmd64x.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -138,10 +138,12 @@ static void cmd64x_tune_pio(ide_drive_t 
 	 * the slowest address setup timing ourselves.
 	 */
 	if (hwif->channel) {
-		ide_drive_t *drives = hwif->drives;
+		ide_drive_t *pair = ide_get_pair_dev(drive);
 
 		drive->drive_data = setup_count;
-		setup_count = max(drives[0].drive_data, drives[1].drive_data);
+
+		if (pair)
+			setup_count = max_t(u8, setup_count, pair->drive_data);
 	}
 
 	if (setup_count > 5)		/* shouldn't actually happen... */
