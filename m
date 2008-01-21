Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbYAUXSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbYAUXSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbYAUXRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:17:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43625 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947AbYAUXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:17:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=L1lNHk5FiKxjgsSclDnI8TTcNKRMkMi+Ou//ng/cEnMyk8OhyuN1y1Fq7l21a6LP5Hcu4f91zqzFqXx9zuIMdmt/WhvHTyLunQ/WDvyqNCrio674vIMUAD1bOsK8R4vqn3coesAQtx0I8jqcz0CtXYeWkk4BNrE3xWK8/uHvTVI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:30:56 +0100
Message-Id: <20080121233056.30311.5861.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/16] trm290: use ide_execute_command()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/trm290.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -177,10 +177,7 @@ static void trm290_selectproc (ide_drive
 
 static void trm290_dma_exec_cmd(ide_drive_t *drive, u8 command)
 {
-	BUG_ON(HWGROUP(drive)->handler != NULL);	/* paranoia check */
-	ide_set_handler(drive, &ide_dma_intr, WAIT_CMD, NULL);
-	/* issue cmd to drive */
-	outb(command, IDE_COMMAND_REG);
+	ide_execute_command(drive, command, &ide_dma_intr, WAIT_CMD, NULL);
 }
 
 static int trm290_dma_setup(ide_drive_t *drive)
