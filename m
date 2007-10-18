Return-Path: <linux-kernel-owner+w=401wt.eu-S1764020AbXJRA5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764020AbXJRA5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761225AbXJRA4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:56:25 -0400
Received: from ozlabs.org ([203.10.76.45]:36524 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760834AbXJRA4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:56:24 -0400
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Linux IDE <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 18 Oct 2007 10:56:20 +1000
Subject: [PATCH 2/3] ide: Fix siimage driver accessing beyond array boundary
In-Reply-To: <1192668978.21882.719539599813.qpush@grosgo>
Message-Id: <20071018005623.153C7DDEBD@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The siimage use an incorrect construct to access the other drive
of a pair, causing it to access beyond an array boundary on non-0
interfaces. This fixes it by using the new ide_get_paired_drive()
hepler instead.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/ide/pci/siimage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-work/drivers/ide/pci/siimage.c
===================================================================
--- linux-work.orig/drivers/ide/pci/siimage.c	2007-10-18 10:42:56.000000000 +1000
+++ linux-work/drivers/ide/pci/siimage.c	2007-10-18 10:43:09.000000000 +1000
@@ -180,7 +180,7 @@ static void sil_set_pio_mode(ide_drive_t
 	const u16 data_speed[]	= { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
 
 	ide_hwif_t *hwif	= HWIF(drive);
-	ide_drive_t *pair	= &hwif->drives[drive->dn ^ 1];
+	ide_drive_t *pair	= ide_get_paired_drive(drive);
 	u32 speedt		= 0;
 	u16 speedp		= 0;
 	unsigned long addr	= siimage_seldev(drive, 0x04);
