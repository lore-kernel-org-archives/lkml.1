Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYBKVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYBKVeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYBKVeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:34:10 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:50765 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYBKVeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:34:08 -0500
Date: Mon, 11 Feb 2008 22:34:06 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Michael Schmitz <schmitz@debian.org>, linux-ide@vger.kernel.org,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] ide: Add missing base addresses for falconide and macide
Message-ID: <Pine.LNX.4.64.0802112232060.7963@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 29dd59755a849cc6475faa6a75f3b804e23a6fc2 ("ide: remove ide_setup_ports")
forgot to take into account the base addresses for the CONTROL registers for
falconide and macide, as pointed out by Michael Schmitz.

Falconide was tested on Aranym.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@debian.org>
---
 drivers/ide/legacy/falconide.c |    2 +-
 drivers/ide/legacy/macide.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -54,7 +54,7 @@ static void __init falconide_setup_ports
 	for (i = 1; i < 8; i++)
 		hw->io_ports[i] = ATA_HD_BASE + 1 + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ATA_HD_CONTROL;
+	hw->io_ports[IDE_CONTROL_OFFSET] = ATA_HD_BASE + ATA_HD_CONTROL;
 
 	hw->irq = IRQ_MFP_IDE;
 	hw->ack_intr = NULL;
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -74,7 +74,7 @@ static void __init macide_setup_ports(hw
 	for (i = 0; i < 8; i++)
 		hw->io_ports[i] = base + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = IDE_CONTROL;
+	hw->io_ports[IDE_CONTROL_OFFSET] = base + IDE_CONTROL;
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
