Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbYBJPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbYBJPL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 10:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYBJPLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:11:18 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:38508 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYBJPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:11:18 -0500
Message-ID: <47AF1412.4090908@tiscali.nl>
Date: Sun, 10 Feb 2008 16:11:14 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: vitalywool@gmail.com
CC: i2c@lm-sensors.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [arch/arm/mach-pnx4008/gpio.c] duplication in if ... else
 if branches
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a duplication of code in the following section. Possibly it was
copy-pasted and it was forgotten to edit these lines? otherwise consider
removing the duplicate lines with the patch below.
---
Different if ... else if branches do the same, remove duplication

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/arm/mach-pnx4008/gpio.c b/arch/arm/mach-pnx4008/gpio.c
index 1ab84ce..7a3b190 100644
--- a/arch/arm/mach-pnx4008/gpio.c
+++ b/arch/arm/mach-pnx4008/gpio.c
@@ -122,16 +122,11 @@ int pnx4008_gpio_register_pin(unsigned short pin)
 	unsigned long bit = GPIO_BIT(pin);
 	int ret = -EBUSY;	/* Already in use */
 
 	gpio_lock();
 
-	if (GPIO_ISBID(pin)) {
-		if (access_map[GPIO_INDEX] & bit)
-			goto out;
-		access_map[GPIO_INDEX] |= bit;
-
-	} else if (GPIO_ISRAM(pin)) {
+	if (GPIO_ISBID(pin) || GPIO_ISRAM(pin)) {
 		if (access_map[GPIO_INDEX] & bit)
 			goto out;
 		access_map[GPIO_INDEX] |= bit;
 
 	} else if (GPIO_ISMUX(pin)) {
