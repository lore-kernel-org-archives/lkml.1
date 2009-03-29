Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZC2Ud0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZC2Ud0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZC2UdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:33:15 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:47701 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbZC2UdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:33:14 -0400
Date: Sun, 29 Mar 2009 22:33:03 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] de: drivers/ide/ide-atapi.c needs <linux/scatterlist.h>
Message-ID: <Pine.LNX.4.64.0903292229400.23398@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k:
| drivers/ide/ide-atapi.c: In function 'ide_io_buffers':
| drivers/ide/ide-atapi.c:87: error: implicit declaration of function 'sg_page'
| drivers/ide/ide-atapi.c:87: warning: passing argument 1 of 'PageHighMem' makes pointer from integer without a cast
| drivers/ide/ide-atapi.c:91: warning: passing argument 1 of 'kmap_atomic' makes pointer from integer without a cast
| drivers/ide/ide-atapi.c:96: error: implicit declaration of function 'sg_virt'
| drivers/ide/ide-atapi.c:96: warning: assignment makes pointer from integer without a cast
| drivers/ide/ide-atapi.c:107: error: implicit declaration of function 'sg_next'
| drivers/ide/ide-atapi.c:107: warning: assignment makes pointer from integer without a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
No idea where it got introduced. 2.6.29 was fine.

 drivers/ide/ide-atapi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 6adc5b4..445d157 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -6,6 +6,8 @@
 #include <linux/cdrom.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
+#include <linux/scatterlist.h>
+
 #include <scsi/scsi.h>
 
 #ifdef DEBUG
-- 
1.6.2.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
