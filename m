Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbXGTQty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbXGTQty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764831AbXGTQoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:44:30 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:38026 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898AbXGTQoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:44:22 -0400
Message-Id: <20070720164324.097994947@mail.of.borg>
References: <20070720164043.523003359@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Fri, 20 Jul 2007 18:40:46 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
Subject: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Content-Disposition: inline; filename=m68k-wd33c93-needs-asm-irq.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

wd33c93 SCSI needs <asm/irq.h> on m68k

drivers/scsi/wd33c93.c: In function 'wd33c93_host_reset':
drivers/scsi/wd33c93.c:1582: error: implicit declaration of function 'disable_irq'
drivers/scsi/wd33c93.c:1603: error: implicit declaration of function 'enable_irq'

The driver still compiles on MIPS (CONFIG_SGIWD93_SCSI=y)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/wd33c93.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -89,6 +89,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
+#include <asm/irq.h>
+
 #include "wd33c93.h"
 
 #define optimum_sx_per(hostdata) (hostdata)->sx_table[1].period_ns

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

