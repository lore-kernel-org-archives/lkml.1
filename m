Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbYFTVfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbYFTVfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbYFTVch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:22386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761533AbYFTVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vGurHfhAtO0MjShv4CekISlxQSSNtRzRnNgczvH3uwP1PWtBipFFPPQpkm95eOpUbD
         C7aQY73rH2MEY2pvKHz2q/S2IcSG2OdKqL/kO6z/BSR4mtZtHFMMRFdNIVcnNEj/pCvp
         FhhPSwXQoPPNuMoqWkOC8SrNt0S4bA2NzBKHA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:34:31 +0200
Message-Id: <20080620213431.13202.79378.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/18] ide: change order of register access in ide_config_drive_speed()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write ATA Feature register before ATA Sector Count register as
a preparation to use ->tf_load in ide_config_drive_speed().

This change shouldn't affect anything (just an usual paranoia).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -828,8 +828,8 @@ int ide_config_drive_speed(ide_drive_t *
 	SELECT_MASK(drive, 0);
 	udelay(1);
 	hwif->set_irq(hwif, 0);
-	hwif->OUTB(speed, io_ports->nsect_addr);
 	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
+	hwif->OUTB(speed, io_ports->nsect_addr);
 	hwif->exec_command(hwif, WIN_SETFEATURES);
 	if (drive->quirk_list == 2)
 		hwif->set_irq(hwif, 1);
