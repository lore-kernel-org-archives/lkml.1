Return-Path: <linux-kernel-owner+w=401wt.eu-S934785AbYCFCdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785AbYCFCdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbYCFCZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61432 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbYCFCZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lnspSXSiQeZ+nf6vF/SMSLHJvKJHOvwrFppwy0jkQNlat+gc3oRmgCYYb/RJXqx7OMD+Ym5nigS93aKxgsMrvRA9q/VH9fcK/csn4FXocElC8d8+S93CjrTlf/PcCrd+AgFAddl1iW7L96EXcWQ28l8FtJ7L3rM8Nxl4S+psjf0=
Subject: [PATCH 16/16] drivers: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:25:00 -0800
Message-Id: <1204770300.14154.52.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, these are the leftovers.

 drivers/gpio/gpiolib.c         |    4 ++--
 drivers/hwmon/ads7828.c        |    2 +-
 drivers/mfd/asic3.c            |    6 +++---
 drivers/mfd/sm501.c            |    4 ++--
 drivers/parport/parport_gsc.c  |    4 ++--
 drivers/parport/parport_pc.c   |    8 ++++----
 drivers/sbus/char/cpwatchdog.c |    2 +-
 drivers/sbus/char/uctrl.c      |    4 ++--
 drivers/w1/w1_log.h            |    2 +-
 9 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d8db2f8..5e7e0d1 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -291,7 +291,7 @@ fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	if (status)
 		pr_debug("%s: gpio-%d status %d\n",
-			__FUNCTION__, gpio, status);
+			__func__, gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_input);
@@ -329,7 +329,7 @@ fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	if (status)
 		pr_debug("%s: gpio-%d status %d\n",
-			__FUNCTION__, gpio, status);
+			__func__, gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output);
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index ed71a8b..5c8b6e0 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -224,7 +224,7 @@ static int ads7828_detect(struct i2c_adapter *adapter, int address, int kind)
 			if (in_data & 0xF000) {
 				printk(KERN_DEBUG
 				"%s : Doesn't look like an ads7828 device\n",
-				__FUNCTION__);
+				__func__);
 				goto exit_free;
 			}
 		}
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 63fb1ff..b373c55 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -132,7 +132,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 
 	if (iter >= MAX_ASIC_ISR_LOOPS)
 		printk(KERN_ERR "%s: interrupt processing overrun\n",
-		       __FUNCTION__);
+		       __func__);
 }
 
 static inline int asic3_irq_to_bank(struct asic3 *asic, int irq)
@@ -409,7 +409,7 @@ int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio)
 		return asic3_get_gpio_d(asic, Status) & mask;
 	default:
 		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
-		       __FUNCTION__, gpio);
+		       __func__, gpio);
 		return -EINVAL;
 	}
 }
@@ -437,7 +437,7 @@ void asic3_gpio_set_value(struct asic3 *asic, unsigned gpio, int val)
 		return;
 	default:
 		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
-		       __FUNCTION__, gpio);
+		       __func__, gpio);
 		return;
 	}
 }
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 13bac53..a86ce27 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -348,11 +348,11 @@ int sm501_unit_power(struct device *dev, unsigned int unit, unsigned int to)
 	mode &= 3;		/* get current power mode */
 
 	if (unit >= ARRAY_SIZE(sm->unit_power)) {
-		dev_err(dev, "%s: bad unit %d\n", __FUNCTION__, unit);
+		dev_err(dev, "%s: bad unit %d\n", __func__, unit);
 		goto already;
 	}
 
-	dev_dbg(sm->dev, "%s: unit %d, cur %d, to %d\n", __FUNCTION__, unit,
+	dev_dbg(sm->dev, "%s: unit %d, cur %d, to %d\n", __func__, unit,
 		sm->unit_power[unit], to);
 
 	if (to == 0 && sm->unit_power[unit] == 0) {
diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 0e77ae2..e6a7e84 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -365,11 +365,11 @@ static int __devinit parport_init_chip(struct parisc_device *dev)
 	if (boot_cpu_data.cpu_type > pcxt && !pdc_add_valid(port+4)) {
 
 		/* Initialize bidirectional-mode (0x10) & data-tranfer-mode #1 (0x20) */
-		printk("%s: initialize bidirectional-mode.\n", __FUNCTION__);
+		printk("%s: initialize bidirectional-mode.\n", __func__);
 		parport_writeb ( (0x10 + 0x20), port + 4);
 
 	} else {
-		printk("%s: enhanced parport-modes not supported.\n", __FUNCTION__);
+		printk("%s: enhanced parport-modes not supported.\n", __func__);
 	}
 	
 	p = parport_gsc_probe_port(port, 0, dev->irq,
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index d76d37b..7f70898 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1415,7 +1415,7 @@ static void __devinit winbond_check(int io, int key)
 {
 	int devid,devrev,oldid,x_devid,x_devrev,x_oldid;
 
-	if (!request_region(io, 3, __FUNCTION__))
+	if (!request_region(io, 3, __func__))
 		return;
 
 	/* First probe without key */
@@ -1449,7 +1449,7 @@ static void __devinit winbond_check2(int io,int key)
 {
         int devid,devrev,oldid,x_devid,x_devrev,x_oldid;
 
-	if (!request_region(io, 3, __FUNCTION__))
+	if (!request_region(io, 3, __func__))
 		return;
 
 	/* First probe without the key */
@@ -1482,7 +1482,7 @@ static void __devinit smsc_check(int io, int key)
 {
         int id,rev,oldid,oldrev,x_id,x_rev,x_oldid,x_oldrev;
 
-	if (!request_region(io, 3, __FUNCTION__))
+	if (!request_region(io, 3, __func__))
 		return;
 
 	/* First probe without the key */
@@ -1547,7 +1547,7 @@ static void __devinit detect_and_report_it87(void)
 	u8 r;
 	if (verbose_probing)
 		printk(KERN_DEBUG "IT8705 Super-IO detection, now testing port 2E ...\n");
-	if (!request_region(0x2e, 1, __FUNCTION__))
+	if (!request_region(0x2e, 1, __func__))
 		return;
 	outb(0x87, 0x2e);
 	outb(0x01, 0x2e);
diff --git a/drivers/sbus/char/cpwatchdog.c b/drivers/sbus/char/cpwatchdog.c
index a4e7581..2357034 100644
--- a/drivers/sbus/char/cpwatchdog.c
+++ b/drivers/sbus/char/cpwatchdog.c
@@ -637,7 +637,7 @@ static int wd_inittimer(int whichdog)
 			break;
 		default:
 			printk("%s: %s: invalid watchdog id: %i\n",
-				WD_OBPNAME, __FUNCTION__, whichdog);
+				WD_OBPNAME, __func__, whichdog);
 			return(1);
 	}
 	if(0 != misc_register(whichmisc))
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 44d2ef9..383f32c 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -393,13 +393,13 @@ static int __init ts102_uctrl_init(void)
 	err = request_irq(driver->irq, uctrl_interrupt, 0, "uctrl", driver);
 	if (err) {
 		printk("%s: unable to register irq %d\n",
-		       __FUNCTION__, driver->irq);
+		       __func__, driver->irq);
 		return err;
 	}
 
 	if (misc_register(&uctrl_dev)) {
 		printk("%s: unable to get misc minor %d\n",
-		       __FUNCTION__, uctrl_dev.minor);
+		       __func__, uctrl_dev.minor);
 		free_irq(driver->irq, driver);
 		return -ENODEV;
 	}
diff --git a/drivers/w1/w1_log.h b/drivers/w1/w1_log.h
index fe6bdf4..2f37c77 100644
--- a/drivers/w1/w1_log.h
+++ b/drivers/w1/w1_log.h
@@ -30,7 +30,7 @@
 #  define assert(expr) \
         if(unlikely(!(expr))) {				        \
         printk(KERN_ERR "Assertion failed! %s,%s,%s,line=%d\n",	\
-        #expr,__FILE__,__FUNCTION__,__LINE__);		        \
+	#expr, __FILE__, __func__, __LINE__);		        \
         }
 #endif
 
-- 
1.5.4.GIT

