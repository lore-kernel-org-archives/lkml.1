Return-Path: <linux-kernel-owner+w=401wt.eu-S934540AbZLPCTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934540AbZLPCTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934510AbZLPCTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:19:40 -0500
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:46847 "HELO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934500AbZLPCTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:19:39 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] gpiolib.c: use pr_fmt()
Date: Tue, 15 Dec 2009 21:19:38 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EC5C@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gpiolib.c: use pr_fmt()
Thread-Index: Acp99jew4HaMpm/9T6CQxBvwv0se3A==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 16 Dec 2009 02:19:37.0493 (UTC) FILETIME=[3731FC50:01CA7DF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_fmt() to add the __func__ prefix to all pr_<level> messages.  In
addition, add the module name to the messages to help with debugging.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 50de0f5..2c84cc0 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
@@ -100,7 +102,7 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
 			"autorequest GPIO-%d\n", gpio)) {
 		if (!try_module_get(chip->owner)) {
-			pr_err("GPIO-%d: module can't be gotten \n", gpio);
+			pr_err("GPIO-%d: module can't be gotten\n", gpio);
 			clear_bit(FLAG_REQUESTED, &desc->flags);
 			/* lose */
 			return -EIO;
@@ -144,7 +146,7 @@ static int gpiochip_find_base(int ngpio)
 	}
 
 	if (gpio_is_valid(base))
-		pr_debug("%s: found new base at %d\n", __func__, base);
+		pr_debug("found new base at %d\n", base);
 	return base;
 }
 
@@ -181,8 +183,7 @@ int __init gpiochip_reserve(int start, int ngpio)
 		set_bit(FLAG_RESERVED, &desc->flags);
 	}
 
-	pr_debug("%s: reserved gpios from %d to %d\n",
-		 __func__, start, start + ngpio - 1);
+	pr_debug("reserved gpios from %d to %d\n", start, start + ngpio - 1);
 err:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
@@ -562,7 +563,7 @@ static ssize_t export_store(struct class *class, const char *buf, size_t len)
 
 done:
 	if (status)
-		pr_debug("%s: status %d\n", __func__, status);
+		pr_debug("status %d\n", status);
 	return status ? : len;
 }
 
@@ -591,7 +592,7 @@ static ssize_t unexport_store(struct class *class, const char *buf, size_t len)
 	}
 done:
 	if (status)
-		pr_debug("%s: status %d\n", __func__, status);
+		pr_debug("status %d\n", status);
 	return status ? : len;
 }
 
@@ -633,7 +634,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
-		pr_debug("%s: called too early!\n", __func__);
+		pr_debug("called too early!\n");
 		return -ENOENT;
 	}
 
@@ -688,7 +689,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("gpio%d status %d\n", gpio, status);
 
 	return status;
 }
@@ -738,7 +739,7 @@ int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
 
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("gpio%d status %d\n", gpio, status);
 
 	return status;
 }
@@ -779,7 +780,7 @@ void gpio_unexport(unsigned gpio)
 	mutex_unlock(&sysfs_lock);
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("gpio%d status %d\n", gpio, status);
 }
 EXPORT_SYMBOL_GPL(gpio_unexport);
 
@@ -818,8 +819,7 @@ static int gpiochip_export(struct gpio_chip *chip)
 			gpio_desc[gpio++].chip = NULL;
 		spin_unlock_irqrestore(&gpio_lock, flags);
 
-		pr_debug("%s: chip %s status %d\n", __func__,
-				chip->label, status);
+		pr_debug("chip %s status %d\n", chip->label, status);
 	}
 
 	return status;
@@ -842,8 +842,7 @@ static void gpiochip_unexport(struct gpio_chip *chip)
 	mutex_unlock(&sysfs_lock);
 
 	if (status)
-		pr_debug("%s: chip %s status %d\n", __func__,
-				chip->label, status);
+		pr_debug("chip %s status %d\n", chip->label, status);
 }
 
 static int __init gpiolib_sysfs_init(void)
@@ -966,7 +965,7 @@ unlock:
 fail:
 	/* failures here can mean systems won't boot... */
 	if (status)
-		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
+		pr_err("gpios %d..%d (%s) not registered\n",
 			chip->base, chip->base + chip->ngpio - 1,
 			chip->label ? : "generic");
 	return status;
@@ -1059,7 +1058,7 @@ int gpio_request(unsigned gpio, const char *label)
 
 done:
 	if (status)
-		pr_debug("gpio_request: gpio-%d (%s) status %d\n",
+		pr_debug("gpio-%d (%s) status %d\n",
 			gpio, label ? : "?", status);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
@@ -1189,8 +1188,7 @@ lose:
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	if (status)
-		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
+		pr_debug("gpio-%d status %d\n", gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_input);
@@ -1242,8 +1240,7 @@ lose:
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	if (status)
-		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
+		pr_debug("gpio-%d status %d\n", gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output); 
