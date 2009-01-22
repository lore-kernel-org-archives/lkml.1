Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbZAVOUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbZAVOUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZAVOSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:18:22 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:58120 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbZAVOST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=nxYztJB80O5o7zTPhNaGbo28sNvvcceT4/E8Z6IYD8KfYn80xnhwqgVEn7BWUZviAZ
         7bqY9FKthpUm/YrLDNh7JPtqfA54A17BUb3tGVjHXoNXlC/ZWwGMOak0ImESI+95yVpi
         AcS+ShqFkgJAMsnrGxKEZbjntLpheknx3DIh4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2009 15:18:48 +0100
Message-Id: <20090122141848.25516.13248.sendpatchset@localhost.localdomain>
In-Reply-To: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
References: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/8] ide: clear drive IRQ after re-enabling local IRQs in ide_driveid_update()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: clear drive IRQ after re-enabling local IRQs in ide_driveid_update()

Clear drive IRQ after re-enabling local IRQs in ide_driveid_update()
to match try_to_identify().

Also remove superfluous local_irq_enable() call while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -341,10 +341,10 @@ int ide_driveid_update(ide_drive_t *driv
 
 	local_irq_save(flags);
 	tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
-	(void)tp_ops->read_status(hwif);	/* clear drive IRQ */
-	local_irq_enable();
 	local_irq_restore(flags);
 
+	(void)tp_ops->read_status(hwif); /* clear drive IRQ */
+
 	ide_fix_driveid(id);
 
 	SELECT_MASK(drive, 0);
