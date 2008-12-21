Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYLUVFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYLUVFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYLUVFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:05:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:6957 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYLUVFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:05:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=IHRj8TT8wz+GzxTwMadyhiZ1ZA+q4CSseBJOHdE0RDZgmrA6KtD16mx2NIW/S+7r5N
         Czxdfm4+GH1Qgp9niP2sTE6Tihw7zKPPoPeNL5AAy1vQhYiMIFvgq0c+kwvCgRRSCjT4
         yYuRmlkzs/ZQ56kGsVrrZkIZHUt45740PlkH0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2008 21:59:58 +0100
Message-Id: <20081221205958.23791.22069.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/7] amd74xx: use ide_get_pair_dev() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] amd74xx: use ide_get_pair_dev() helper

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
updates for pata-2.6 tree

 drivers/ide/amd74xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -82,7 +82,7 @@ static void amd_set_drive(ide_drive_t *d
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
+	ide_drive_t *peer = ide_get_pair_dev(drive);
 	struct ide_timing t, p;
 	int T, UT;
 	u8 udma_mask = hwif->ultra_mask;
@@ -92,7 +92,7 @@ static void amd_set_drive(ide_drive_t *d
 
 	ide_timing_compute(drive, speed, &t, T, UT);
 
-	if (peer->dev_flags & IDE_DFLAG_PRESENT) {
+	if (peer) {
 		ide_timing_compute(peer, peer->current_speed, &p, T, UT);
 		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
 	}
