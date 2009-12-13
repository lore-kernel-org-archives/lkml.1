Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZLMTLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZLMTLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZLMTLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:11:13 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:45087 "HELO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753913AbZLMTLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:11:12 -0500
Date: Sun, 13 Dec 2009 20:11:06 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christian Pellegrin <chripell@fsfe.org>,
       Wolfgang Grandegger <wg@grandegger.com>,
       "David S. Miller" <davem@davemloft.net>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] can: CAN_MCP251X should depend on HAS_DMA
Message-ID: <alpine.DEB.2.00.0912132008100.21225@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building for Sun 3:

drivers/net/can/mcp251x.c:1074: undefined reference to `dma_free_coherent'
drivers/net/can/mcp251x.c:976: undefined reference to `dma_alloc_coherent'
drivers/net/can/mcp251x.c:1050: undefined reference to `dma_free_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/can/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 8c485aa..05b7517 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -50,7 +50,7 @@ config CAN_TI_HECC
 
 config CAN_MCP251X
 	tristate "Microchip MCP251x SPI CAN controllers"
-	depends on CAN_DEV && SPI
+	depends on CAN_DEV && SPI && HAS_DMA
 	---help---
 	  Driver for the Microchip MCP251x SPI CAN controllers.
 
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
