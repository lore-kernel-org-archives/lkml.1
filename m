Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYA3QqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYA3QqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:46:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYA3Qpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:45:53 -0500
Received: from mail.atmel.fr ([81.80.104.162]:51097 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYA3Qpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:45:52 -0500
Message-ID: <47A0A9BC.7090705@atmel.com>
Date: Wed, 30 Jan 2008 17:45:48 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <avictor.za@gmail.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] at91_mci: minor cleanup
References: <200801151444.21140.marc.pignat@hevs.ch>
In-Reply-To: <200801151444.21140.marc.pignat@hevs.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Pignat <marc.pignat@hevs.ch>

MMC_POWER_ON is a noop, no need to set the power pin again.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
MMC_POWER_OFF/MMC_POWER_UP turn the power OFF/ON, there is nothing to change
when ios->power_mode==MMC_POWER_ON.

Also changed indentation for the switch (CodingStyle), because there is no other
switch statement in this driver.

--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -658,13 +658,14 @@ static void at91_mci_set_ios(struct mmc_
 	/* maybe switch power to the card */
 	if (host->board->vcc_pin) {
 		switch (ios->power_mode) {
-			case MMC_POWER_OFF:
-				at91_set_gpio_value(host->board->vcc_pin, 0);
-				break;
-			case MMC_POWER_UP:
-			case MMC_POWER_ON:
-				at91_set_gpio_value(host->board->vcc_pin, 1);
-				break;
+		case MMC_POWER_OFF:
+			at91_set_gpio_value(host->board->vcc_pin, 0);
+			break;
+		case MMC_POWER_UP:
+			at91_set_gpio_value(host->board->vcc_pin, 1);
+			break;
+		default:
+			break;
 		}
 	}
 }


