Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZKPGJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZKPGJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZKPGJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:09:04 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:58393 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZKPGJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:09:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=UaBn3cUwf+vKqsSk17pZ8Mi4m4TWbYruNezEM8ReP2iv0UwU6uhwAbI7EKzywEi8dZ
         ZwSNj8fWcs++jotaY3oqXjlP1/K1ycB5V8hfS+D4YMGMwNicah8ZvSWs0OaD3KhO+hEu
         tdw1ZKdWeAY1dkdTPaicBMMuUg0QxnyMkjlYg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5/5] mfd: pcf50633 - whitespace and formatting fixes
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       Balaji Rao <balajirrao@openmoko.org>
Date: Sun, 15 Nov 2009 22:09:05 -0800
Message-ID: <20091116060905.20162.50460.stgit@localhost.localdomain>
In-Reply-To: <20091116060611.20162.81714.stgit@localhost.localdomain>
References: <20091116060611.20162.81714.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/mfd/pcf50633-core.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 2126563..f3203bd 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -2,7 +2,7 @@
  *
  * (C) 2006-2008 by Openmoko, Inc.
  * Author: Harald Welte <laforge@openmoko.org>
- * 	   Balaji Rao <balajirrao@openmoko.org>
+ *	   Balaji Rao <balajirrao@openmoko.org>
  * All rights reserved.
  *
  *  This program is free software; you can redistribute  it and/or modify it
@@ -28,7 +28,7 @@
 /* Two MBCS registers used during cold start */
 #define PCF50633_REG_MBCS1		0x4b
 #define PCF50633_REG_MBCS2		0x4c
-#define PCF50633_MBCS1_USBPRES 		0x01
+#define PCF50633_MBCS1_USBPRES		0x01
 #define PCF50633_MBCS1_ADAPTPRES	0x01
 
 static int __pcf50633_read(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
@@ -53,7 +53,6 @@ static int __pcf50633_write(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
 		dev_err(pcf->dev, "Error writing %d regs at %d\n", num, reg);
 
 	return ret;
-
 }
 
 /* Read a block of upto 32 regs  */
@@ -348,8 +347,10 @@ static irqreturn_t pcf50633_irq(int irq, void *data)
 	/* defeat 8s death from lowsys on A5 */
 	pcf50633_reg_write(pcf, PCF50633_REG_OOCSHDWN,  0x04);
 
-	/* We immediately read the usb and adapter status. We thus make sure
-	 * only of USBINS/USBREM IRQ handlers are called */
+	/*
+	 * We immediately read the usb and adapter status. We thus make sure
+	 * only of USBINS/USBREM IRQ handlers are called.
+	 */
 	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
 		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
 		if (chgstat & (0x3 << 4))
@@ -367,12 +368,14 @@ static irqreturn_t pcf50633_irq(int irq, void *data)
 			pcf_int[0] &= ~(1 << PCF50633_INT1_ADPINS);
 	}
 
-	dev_dbg(pcf->dev, "INT1=0x%02x INT2=0x%02x INT3=0x%02x "
-			"INT4=0x%02x INT5=0x%02x\n", pcf_int[0],
-			pcf_int[1], pcf_int[2], pcf_int[3], pcf_int[4]);
+	dev_dbg(pcf->dev,
+		"INT1=0x%02x INT2=0x%02x INT3=0x%02x INT4=0x%02x INT5=0x%02x\n",
+		pcf_int[0], pcf_int[1], pcf_int[2], pcf_int[3], pcf_int[4]);
 
-	/* Some revisions of the chip don't have a 8s standby mode on
-	 * ONKEY1S press. We try to manually do it in such cases. */
+	/*
+	 * Some revisions of the chip don't have a 8s standby mode on
+	 * ONKEY1S press. We try to manually do it in such cases.
+	 */
 	if ((pcf_int[0] & PCF50633_INT1_SECOND) && pcf->onkey1s_held) {
 		dev_info(pcf->dev, "ONKEY1S held for %d secs\n",
 							pcf->onkey1s_held);
@@ -665,8 +668,10 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	}
 
 	if (enable_irq_wake(client->irq) < 0)
-		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
-			"in this hardware revision", client->irq);
+		dev_err(pcf->dev,
+			"IRQ %u cannot be enabled as wake-up source "
+			"in this hardware revision\n",
+			client->irq);
 
 	error = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
 	if (error) {

