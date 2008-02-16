Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbYBPUOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbYBPUOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbYBPUMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:12:37 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:14552 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386AbYBPUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OJVbNPFNRfrm8aq4geoWpoAqgmleADn/ecwZB1CCi+5fG+zhrPyg5OL66xkQ55neVIkc2FNV68jk+VpEsxGPr+i5xbeX0guSXJIPItb4NAfzwzGFK5Jmhc5kkl2w9JV4yhPyptA/xnpmgJ6SD/E+/EK6M345fQZyVA6rpo2AN6M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:27:08 +0100
Message-Id: <20080216202708.25536.95262.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/9] umc8672: don't use ide_hwifs[] in umc_set_pio_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/umc8672.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -105,13 +105,13 @@ static void umc_set_speeds (u8 speeds[])
 
 static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
-	ide_hwgroup_t *hwgroup = ide_hwifs[HWIF(drive)->index^1].hwgroup;
 
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
 		drive->name, pio, pio_to_umc[pio]);
 	spin_lock_irqsave(&ide_lock, flags);
-	if (hwgroup && hwgroup->handler != NULL) {
+	if (hwif->mate && hwif->mate->hwgroup->handler) {
 		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
 	} else {
 		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
