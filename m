Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYE1VsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYE1VsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbYE1Vp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:45:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:51381 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbYE1VpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mdlZNN7SHSj9qFOFRw/IssX2ePHEZPkN2WoWdA91hE35G70YSHznxgUmpVk/qo7v7N8WZ32nInxnUyz4BIwmq985Cihm6tjNbttilXnR9scNIiqAu5ttFyOW0tm6Y7PN/VqF5xWHmZIOkyNE4Ru3k6a5znjS0uKBEkgWphfq6VI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:42:58 +0200
Message-Id: <20080528214258.16327.89370.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/21] sl82c105: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig        |    1 +
 drivers/ide/pci/sl82c105.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -704,6 +704,7 @@ config BLK_DEV_SIS5513
 config BLK_DEV_SL82C105
 	tristate "Winbond SL82c105 support"
 	depends on (PPC || ARM)
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  If you have a Winbond SL82c105 IDE controller, say Y here to enable
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -47,10 +47,11 @@
  */
 static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 {
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cmd_on, cmd_off;
 	u8 iordy = 0;
 
-	cmd_on  = (ide_pio_timings[pio].active_time + 29) / 30;
+	cmd_on  = (t->active + 29) / 30;
 	cmd_off = (ide_pio_cycle_time(drive, pio) - 30 * cmd_on + 29) / 30;
 
 	if (cmd_on == 0)
