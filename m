Return-Path: <linux-kernel-owner+w=401wt.eu-S937522AbXGTQse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937522AbXGTQse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765671AbXGTQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:44:27 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:58334 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764807AbXGTQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:44:21 -0400
Message-Id: <20070720164323.848002388@mail.of.borg>
References: <20070720164043.523003359@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Fri, 20 Jul 2007 18:40:45 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
Subject: [patch 2/3] netdev: i82596 Ethernet needs <asm/cacheflush.h>
Content-Disposition: inline; filename=m68k-82596-needs-asm-cacheflush.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

netdev: i82596 Ethernet needs <asm/cacheflush.h> on m68k

drivers/net/82596.c: In function 'init_rx_bufs':
drivers/net/82596.c:552: error: implicit declaration of function 'cache_clear'
drivers/net/82596.c: In function 'i596_start_xmit':
drivers/net/82596.c:1104: error: implicit declaration of function 'cache_push'

The driver still compiles on ia32 (CONFIG_APRICOT=y)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/82596.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/82596.c
+++ b/drivers/net/82596.c
@@ -57,6 +57,7 @@
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/pgtable.h>
+#include <asm/cacheflush.h>
 
 static char version[] __initdata =
 	"82596.c $Revision: 1.5 $\n";

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

