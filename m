Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZHJMwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZHJMwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZHJMwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:52:20 -0400
Received: from india.einfochips.com ([203.88.139.151]:2474 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754187AbZHJMwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:52:20 -0400
From: Dhaval Vasa <dhaval.vasa@einfochips.com>
To: nico@cam.org
Cc: linux-kernel@vger.kernel.org, rabeeh@marvell.com,
       linux-arm-kernel@lists.arm.linux.org.uk, ron@debian.org,
       dhaval.vasa@einfochips.com
Subject: [PATCH v2] Kirkwood: Initialise SATA for OpenRD-Base
Date: Mon, 10 Aug 2009 18:23:48 +0530
Message-Id: <1249908828-665-1-git-send-email-dhaval.vasa@einfochips.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ron <ron@debian.org>

Signed-off-by: Ron Lee <ron@debian.org>
Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
---
 arch/arm/mach-kirkwood/openrd_base-setup.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
index b713644..f9a2166 100644
--- a/arch/arm/mach-kirkwood/openrd_base-setup.c
+++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/partitions.h>
+#include <linux/ata_platform.h>
 #include <linux/mv643xx_eth.h>
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
@@ -41,6 +42,10 @@ static struct mv643xx_eth_platform_data openrd_base_ge00_data = {
 	.phy_addr	= MV643XX_ETH_PHY_ADDR(8),
 };
 
+static struct mv_sata_platform_data openrd_base_sata_data = {
+	.n_ports	= 2,
+};
+
 static struct mvsdio_platform_data openrd_base_mvsdio_data = {
 	.gpio_card_detect = 29,	/* MPP29 used as SD card detect */
 };
@@ -64,6 +69,7 @@ static void __init openrd_base_init(void)
 	kirkwood_ehci_init();
 
 	kirkwood_ge00_init(&openrd_base_ge00_data);
+	kirkwood_sata_init(&openrd_base_sata_data);
 	kirkwood_sdio_init(&openrd_base_mvsdio_data);
 }
 
-- 
1.6.3.3

-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
_____________________________________________________________________
 
