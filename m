Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYBPQY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYBPQY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbYBPQYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:24:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:14693 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbYBPQYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:24:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZOYLtBf4MYs4vCQAjS6bRZjdsQCk65A/6FXkdzisskY+v5G+50qzJT5UzCaW5cHwVSo5cTvv9tOEv+AHrU5pQEpBklINQIXHqkCqbT5mOFwjdzcZIcUjcOaEabqRr6YfFD5sLmShi48sm0IVm1flSLqycRYw/7SnoLk2wKK/Vbc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 17:39:04 +0100
Message-Id: <20080216163904.10174.29572.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/12] ide: remove ppc ifdef from init_ide_data()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PPC32 ide_init_default_irq() is non-zero only for PPLUS and PPC_PREP
(the latter marked as BROKEN currently) so this ifdef can be removed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -214,11 +214,9 @@ static void __init init_ide_data (void)
 		ide_std_init_ports(&hw, io_addr, ctl_addr);
 		memcpy(hwif->io_ports, hw.io_ports, sizeof(hw.io_ports));
 		hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
-#if !defined(CONFIG_PPC32) || defined(CONFIG_PPLUS) || !defined(CONFIG_PCI)
 		hwif->irq =
 			ide_init_default_irq(hwif->io_ports[IDE_DATA_OFFSET]);
 #endif
-#endif
 	}
 }
 
