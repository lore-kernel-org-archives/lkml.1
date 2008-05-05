Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYEETPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYEETPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYEETP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:15:26 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:47725 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYEETPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:15:25 -0400
Date: Mon, 5 May 2008 21:15:19 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] m68k: Fix falconide `data_adr' typo
Message-ID: <Pine.LNX.4.64.0805052114380.15634@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

    commit 9567b349f7e7dd7e2483db99ee8e4a6fe0caca38
    Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
    Date:   Mon Apr 28 23:44:36 2008 +0200

    ide: merge ->atapi_*put_bytes and ->ata_*put_data methods

introduced a typo (`data_adr' instead of `data_addr'), leading to a compile
failure.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/ide/legacy/falconide.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -61,7 +61,7 @@ static void falconide_output_data(ide_dr
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
 	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
-		return outsw(data_adr, buf, (len + 1) / 2);
+		return outsw(data_addr, buf, (len + 1) / 2);
 
 	outsw_swapw(data_addr, buf, (len + 1) / 2);
 }

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
