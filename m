Return-Path: <linux-kernel-owner+w=401wt.eu-S1764674AbZFQA4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764674AbZFQA4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762994AbZFQAzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:55:37 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:38915 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762880AbZFQAzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:55:36 -0400
From: Rob Emanuele <rob@emanuele.us>
To: nicolas.ferre@atmel.com
Cc: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, Rob Emanuele <rob@emanuele.us>
Subject: [PATCH 6/6] atmel-mci: Platform driver MMC slot power control
Date: Tue, 16 Jun 2009 17:54:39 -0700
Message-Id: <1245200079-6323-6-git-send-email-rob@emanuele.us>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1245200079-6323-1-git-send-email-rob@emanuele.us>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the at91sam9g20ek_2mmc platform (board-sam9g20ek-2slot-mmc.c) and support files for a VCC pin using the atmel-mci driver.

Signed-off-by: Rob Emanuele <rob@emanuele.us>
---
 arch/arm/mach-at91/at91sam9260_devices.c       |    2 ++
 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index c372f4f..7634632 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -328,6 +328,8 @@ void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data)
 			}
 			if (data->slot[i].wp_pin)
 				at91_set_gpio_input(data->slot[i].wp_pin, 1);
+			if (data->slot[i].vcc_pin)
+				at91_set_gpio_output(data->slot[i].vcc_pin, 0);
 
 			switch(i) {
 			case 0:
diff --git a/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c b/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
index a28e53f..20c6738 100644
--- a/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
+++ b/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
@@ -202,11 +202,14 @@ static struct mci_platform_data __initdata ek_mmc_data = {
 		.bus_width	= 4,
 		.detect_pin	= -ENODEV,
 		.wp_pin		= -ENODEV,
+		.vcc_pin	= AT91_PIN_PA30,
+		.vcc_active_low	= 1,
 	},
 	.slot[1] = {
 		.bus_width	= 4,
 		.detect_pin	= -ENODEV,
 		.wp_pin		= -ENODEV,
+		.vcc_pin	= -ENODEV,
 	},
 
 };
-- 
1.6.0.4

