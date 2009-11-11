Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbZKKUfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbZKKUfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbZKKUfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:35:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:54434 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748AbZKKUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:35:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=NhQAErYlksnxfA5O6YZSTnTku9SNvgGne0sYqHXwjmO8ySGlRerE+3SSFmu3KuvFCM
         e1+s+wZfZgbB2Yl1T91tPoRQ5Yww6OOhl7vlm3btnPcmvL/GkZnkJyb7CYEkX1R79IbK
         c5Uvt+k6ODbsDIdMiOiTq2ohAtKXc3+iZoAwk=
Message-ID: <4AFB22CA.2050106@gmail.com>
Date: Wed, 11 Nov 2009 21:47:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd: error return -EIO instead of EIO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return a negative error value instead of a positive

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/mtd/maps/physmap.c    |    2 +-
 drivers/mtd/maps/vmu-flash.c  |    2 +-
 drivers/mtd/nand/atmel_nand.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 380648e..a5a72b2 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -130,7 +130,7 @@ static int physmap_flash_probe(struct platform_device *dev)
 						 info->map[i].size);
 		if (info->map[i].virt == NULL) {
 			dev_err(&dev->dev, "Failed to ioremap flash region\n");
-			err = EIO;
+			err = -EIO;
 			goto err_out;
 		}
 
diff --git a/drivers/mtd/maps/vmu-flash.c b/drivers/mtd/maps/vmu-flash.c
index 1f73297..b02db6f 100644
--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -621,7 +621,7 @@ static int __devinit vmu_connect(struct maple_device *mdev)
 
 	card = kmalloc(sizeof(struct memcard), GFP_KERNEL);
 	if (!card) {
-		error = ENOMEM;
+		error = -ENOMEM;
 		goto fail_nomem;
 	}
 
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index f8e9975..e4aeeed 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -464,7 +464,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 	if (host->board->det_pin) {
 		if (gpio_get_value(host->board->det_pin)) {
 			printk(KERN_INFO "No SmartMedia card inserted.\n");
-			res = ENXIO;
+			res = -ENXIO;
 			goto err_no_card;
 		}
 	}
@@ -535,7 +535,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 
 	if ((!partitions) || (num_partitions == 0)) {
 		printk(KERN_ERR "atmel_nand: No partitions defined, or unsupported device.\n");
-		res = ENXIO;
+		res = -ENXIO;
 		goto err_no_partitions;
 	}
 
