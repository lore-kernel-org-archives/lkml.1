Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXDJVaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXDJVaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXDJVaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:30:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:43087 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbXDJVau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:mime-version:content-type:content-transfer-encoding;
        b=CaLZkgIUXAL2LYLovRSuhUPi+9gLSP1CEtSE6FCoSmBmhpcVJY0LU5ORJhHplAanVJfN8MQ5fYHhjnE958UhELMFeq1QuWdeP/K1V3WF4U0X+Vt3972ZPIoy0X+gVHtaXDM9oGC6qXifKy8jicf8Dtw8Pl/JZG5X93Tn4DghV24=
Date: Wed, 11 Apr 2007 00:30:58 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <774343545.20070411003058@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
CC: David Brownell <david-b@pacbell.net>
Subject: [RFC, PATCH 1/3] gpiodev - API definitions
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux-arm-kernel,

GPIODEV API: Core API definitions. Provided are:
1. struct gpiodev_ops which must be included into platform_data structure
of a device which will provide GPIODEV API; driver for a device must
initialize this structure.
2. Structural definition of generalized GPIO identifier (struct gpio).
2. Set of API calls for clients. This fully follow Generic GPIO API
naming and semantics, except that they have "gpiodev" prefix and
accept struct gpio instead of integer gpio identifiers.


Index: include/linux/gpiodev.h
===================================================================
RCS file: include/linux/gpiodev.h
diff -N include/linux/gpiodev.h
--- /dev/null   1 Jan 1970 00:00:00 -0000
+++ include/linux/gpiodev.h     10 Apr 2007 19:17:12 -0000      1.5
@@ -0,0 +1,43 @@
+#ifndef __GPIODEV_H
+#define __GPIODEV_H
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <asm/gpio.h>
+
+/* Interface */
+
+/* This structure must be first member of device platform_data structure 
+   of a device which provides gpiodev interface */
+struct gpiodev_ops {
+        int (*get)(struct device *this, int gpio_no);
+        void (*set)(struct device *this, int gpio_no, int val);
+        int (*to_irq)(struct device *this, int gpio_no);
+};
+       
+/* Generalized GPIO structure */
+
+struct gpio {
+       struct platform_device *gpio_dev;
+       int gpio_no;
+};
+
+/* API functions */
+
+static inline int gpiodev_get_value(struct gpio *gpio)
+{
+       struct gpiodev_ops *ops = gpio->gpio_dev->dev.platform_data;
+       return ops->get(&gpio->gpio_dev->dev, gpio->gpio_no);
+}
+static inline void gpiodev_set_value(struct gpio *gpio, int val)
+{
+       struct gpiodev_ops *ops = gpio->gpio_dev->dev.platform_data;
+       ops->set(&gpio->gpio_dev->dev, gpio->gpio_no, val);
+}
+static inline int gpiodev_to_irq(struct gpio *gpio)
+{
+       struct gpiodev_ops *ops = gpio->gpio_dev->dev.platform_data;
+       return ops->to_irq(&gpio->gpio_dev->dev, gpio->gpio_no);
+}
+
+#endif /* __GPIODEV_H */


-- 
Best regards,
 Paul                          mailto:pmiscml@gmail.com

