Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbZAVOT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbZAVOT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758523AbZAVOSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:18:13 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:58120 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbZAVOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:18:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=U+93530sHkX4qVUncf7vztfv6WcSadaVdl8jiqXZh02MATjvtAbakGI+Cvf+F2HXfe
         +AnXpbXTfIxDEPlFnmJ7zsxFoopvNGot5GRANWuUTUx34NYndnqBTepCp+PVp2BIAQ/E
         0Yq3avkjV/jb7DlgJLSwR+z7hZaSIe0juRhW4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2009 15:18:41 +0100
Message-Id: <20090122141841.25516.85672.sendpatchset@localhost.localdomain>
In-Reply-To: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
References: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/8] ide: sanitize SELECT_MASK() usage in ide_driveid_update()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: sanitize SELECT_MASK() usage in ide_driveid_update()

Call SELECT_MASK() after ide_fix_driveid().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -340,13 +340,15 @@ int ide_driveid_update(ide_drive_t *driv
 	}
 
 	local_irq_save(flags);
-	SELECT_MASK(drive, 0);
 	tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
 	(void)tp_ops->read_status(hwif);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
+
 	ide_fix_driveid(id);
 
+	SELECT_MASK(drive, 0);
+
 	drive->id[ATA_ID_UDMA_MODES]  = id[ATA_ID_UDMA_MODES];
 	drive->id[ATA_ID_MWDMA_MODES] = id[ATA_ID_MWDMA_MODES];
 	drive->id[ATA_ID_SWDMA_MODES] = id[ATA_ID_SWDMA_MODES];
