Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbYBPQ0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbYBPQ0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbYBPQYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:24:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:28570 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587AbYBPQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:24:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=WXZQD4APKEt7b64AMyELBtczBj7Mu46zCEaSpHH93j5ewrKCuvCYMzEwuxfInXl4U332VFWLWQFi0JetxyYVtL6DH614Dvi0d0GmwGXjIi0lEpHAKwZ3B0L74wgw2WoEec9uQugUEKrkqSorcqcEuTB+/Rv2bFplB4AhxKO/4j0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 17:39:18 +0100
Message-Id: <20080216163918.10174.58524.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/12] cmd640: cleanup setup_device_ptrs()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This loop is no longer needed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd640.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -409,19 +409,9 @@ static void __init check_prefetch (unsig
  */
 static void __init setup_device_ptrs (void)
 {
-	unsigned int i;
+	cmd_hwif0 = &ide_hwifs[0];
+	cmd_hwif1 = &ide_hwifs[1];
 
-	cmd_hwif0 = &ide_hwifs[0]; /* default, if not found below */
-	cmd_hwif1 = &ide_hwifs[1]; /* default, if not found below */
-	for (i = 0; i < MAX_HWIFS; i++) {
-		ide_hwif_t *hwif = &ide_hwifs[i];
-		if (hwif->chipset == ide_unknown) {
-			if (hwif->io_ports[IDE_DATA_OFFSET] == 0x1f0)
-				cmd_hwif0 = hwif;
-			else if (hwif->io_ports[IDE_DATA_OFFSET] == 0x170)
-				cmd_hwif1 = hwif;
-		}
-	}
 	cmd_drives[0] = &cmd_hwif0->drives[0];
 	cmd_drives[1] = &cmd_hwif0->drives[1];
 	cmd_drives[2] = &cmd_hwif1->drives[0];
