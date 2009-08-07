Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZHGWr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZHGWr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZHGWrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:47:55 -0400
Received: from ppp121-45-198-187.lns10.adl2.internode.on.net ([121.45.198.187]:50953
	"EHLO audi.shelbyville.oz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751539AbZHGWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:47:55 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 18:47:54 EDT
Date: Sat, 8 Aug 2009 08:08:51 +0930
From: Ron <ron@debian.org>
To: Nicolas Pitre <nico@cam.org>
Cc: Dhaval Vasa <dhaval.vasa@einfochips.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rabeeh Khoury <rabeeh@marvell.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH] [ARM] Kirkwood: Initialise SATA for OpenRD-Base
Message-ID: <20090807223851.GR11898@audi.shelbyville.oz>
References: <1249567753-724-1-git-send-email-dhaval.vasa@einfochips.com>
 <alpine.LFD.2.00.0908071149460.16073@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908071149460.16073@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Ron Lee <ron@debian.org>
---

Please include this patch in with that set also.  I can confirm this
enables me to boot an OpenRD-Base board from SATA with 2.6.31-rc5.

 arch/arm/mach-kirkwood/openrd_base-setup.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
index 6e290fd..d8c846d 100644
--- a/arch/arm/mach-kirkwood/openrd_base-setup.c
+++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/partitions.h>
+#include <linux/ata_platform.h>
 #include <linux/mv643xx_eth.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
@@ -42,6 +43,10 @@ static struct mv643xx_eth_platform_data openrd_base_ge00_data = {
 	.phy_addr	= MV643XX_ETH_PHY_ADDR(8),
 };
 
+static struct mv_sata_platform_data openrd_base_sata_data = {
+	.n_ports	= 2,
+};
+
 static struct mvsdio_platform_data openrd_base_mvsdio_data = {
 	.gpio_card_detect = MPP29_GPIO,	/* MPP29 used as SD card detect */
 };
@@ -64,6 +69,7 @@ static void __init openrd_base_init(void)
 	kirkwood_ehci_init();
 
 	kirkwood_ge00_init(&openrd_base_ge00_data);
+	kirkwood_sata_init(&openrd_base_sata_data);
 	kirkwood_sdio_init(&openrd_base_mvsdio_data);
 }
 
-- 
1.6.3.3

