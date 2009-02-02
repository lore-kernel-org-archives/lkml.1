Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbZBBWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbZBBWAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZBBWA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:00:27 -0500
Received: from xenotime.net ([72.52.64.118]:43541 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756232AbZBBWA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:00:26 -0500
Message-ID: <49876CF7.9070100@xenotime.net>
Date: Mon, 02 Feb 2009 14:00:23 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH mmotm] touchscreen/ad787x: don't use bus_id
References: <200902022010.n12KAXcN026264@imap1.linux-foundation.org>
In-Reply-To: <200902022010.n12KAXcN026264@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/input/touchscreen/ad7879.c:421: error: 'struct device' has no member named 'bus_id'
drivers/input/touchscreen/ad7877.c:716: error: 'struct device' has no member named 'bus_id'
drivers/input/touchscreen/ad7877.c:743: error: 'struct device' has no member named 'bus_id'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/ad7877.c |    6 +++---
 drivers/input/touchscreen/ad7879.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- mmotm-2009-0202-1210.orig/drivers/input/touchscreen/ad7879.c
+++ mmotm-2009-0202-1210/drivers/input/touchscreen/ad7879.c
@@ -418,7 +418,7 @@ static int __devinit ad7879_construct(bu
 	else
 		ts->gpio_init = AD7879_GPIO_EN | AD7879_GPIODIR;
 
-	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", bus->dev.bus_id);
+	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", dev_name(&bus->dev));
 
 	input_dev->name = "AD7879 Touchscreen";
 	input_dev->phys = ts->phys;
--- mmotm-2009-0202-1210.orig/drivers/input/touchscreen/ad7877.c
+++ mmotm-2009-0202-1210/drivers/input/touchscreen/ad7877.c
@@ -713,7 +713,7 @@ static int __devinit ad7877_probe(struct
 	ts->averaging = pdata->averaging;
 	ts->pen_down_acc_interval = pdata->pen_down_acc_interval;
 
-	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", spi->dev.bus_id);
+	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", dev_name(&spi->dev));
 
 	input_dev->name = "AD7877 Touchscreen";
 	input_dev->phys = ts->phys;
@@ -740,8 +740,8 @@ static int __devinit ad7877_probe(struct
 	verify = ad7877_read(spi, AD7877_REG_SEQ1);
 
 	if (verify != AD7877_MM_SEQUENCE){
-		dev_err(&spi->dev, "%s: Failed to probe %s\n", spi->dev.bus_id,
-			 input_dev->name);
+		dev_err(&spi->dev, "%s: Failed to probe %s\n",
+			dev_name(&spi->dev), input_dev->name);
 		err = -ENODEV;
 		goto err_free_mem;
 	}
