Return-Path: <linux-kernel-owner+w=401wt.eu-S1761635AbZFMBDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761635AbZFMBDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 21:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934536AbZFMBDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 21:03:10 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48424 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934540AbZFMBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 21:03:08 -0400
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 18:03:10 -0700
X-Google-Sender-Auth: 3df123a298d93170
Message-ID: <c8284b5b0906121803u359e6ff8y172895ca43c29aae@mail.gmail.com>
Subject: [PATCH 6/6] Unified AVR32/AT91 MCI Platform Driver Support for a VCC 
	Pin
From: Rob Emanuele <poorarm@shoreis.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the at91sam9g20ek board and support files for a VCC pin
using the atmel-mci driver.

Please read the whole set, try it out, and comment.

Thank you,

Rob Emanuele

---
 arch/arm/mach-at91/at91sam9260_devices.c |    2 ++
 arch/arm/mach-at91/board-sam9g20ek.c     |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260_devices.c
b/arch/arm/mach-at91/at91sam9260_devices.c
index e7cc46a..fe4467e 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -327,6 +327,8 @@ void __init at91_add_device_mmc(short mmc_id,
struct mci_platform_data *data)
 			}
 			if (data->slot[i].wp_pin)
 				at91_set_gpio_input(data->slot[i].wp_pin, 1);
+			if (data->slot[i].vcc_pin)
+				at91_set_gpio_output(data->slot[i].vcc_pin, 0);

 			switch(i) {
 			case 0:
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c
b/arch/arm/mach-at91/board-sam9g20ek.c
index ca70042..5b7ae06 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -210,8 +210,11 @@ static struct mci_platform_data __initdata ek_mmc_data = {
 	.slot[0] = {
 #if defined(CONFIG_AT91_2MMC)
 		.bus_width	= 4,
+		.vcc_pin	= AT91_PIN_PA30,
+		.vcc_pin_act_low= 1,
 #else
 		.bus_width	= 0,
+		.vcc_pin	= -ENODEV,
 #endif
 		.detect_pin	= -ENODEV,
 		.wp_pin		= -ENODEV,
@@ -220,6 +223,7 @@ static struct mci_platform_data __initdata ek_mmc_data = {
 		.bus_width	= 4,
 		.detect_pin	= -ENODEV,
 		.wp_pin		= -ENODEV,
+		.vcc_pin	= -ENODEV,
 	},

 };
-- 
1.6.0.4
