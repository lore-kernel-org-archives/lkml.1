Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYGVXgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYGVXgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758370AbYGVX2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:28:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758376AbYGVX22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:28:28 -0400
Date: Tue, 22 Jul 2008 16:27:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@pengutronix.de,
       Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.26-rc5] gpio: sysfs interface (updated)
Message-Id: <20080722162751.e8584d46.akpm@linux-foundation.org>
In-Reply-To: <200806121153.36557.david-b@pacbell.net>
References: <200806121153.36557.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 11:53:36 -0700
David Brownell <david-b@pacbell.net> wrote:

> This adds a simple sysfs interface for GPIOs.

device_create_drvdata() has magically vanished from today's linux-next,
so this code doesn't compile any more.

This:

--- a/drivers/gpio/gpiolib.c~gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix
+++ a/drivers/gpio/gpiolib.c
@@ -453,8 +453,8 @@ int gpio_export(unsigned gpio, bool dire
 	if (status == 0) {
 		struct device	*dev;
 
-		dev = device_create_drvdata(&gpio_class, desc->chip->dev, 0,
-				desc, "gpio%d", gpio);
+		dev = device_create(&gpio_class, desc->chip->dev, 0, desc,
+					"gpio%d", gpio);
 		if (dev) {
 			if (direction_may_change)
 				status = sysfs_create_group(&dev->kobj,
@@ -537,8 +537,8 @@ static int gpiochip_export(struct gpio_c
 
 	/* use chip->base for the ID; it's already known to be unique */
 	mutex_lock(&sysfs_lock);
-	dev = device_create_drvdata(&gpio_class, chip->dev, 0, chip,
-			"gpiochip%d", chip->base);
+	dev = device_create(&gpio_class, chip->dev, 0, chip, "gpiochip%d",
+				chip->base);
 	if (dev) {
 		status = sysfs_create_group(&dev->kobj,
 				&gpiochip_attr_group);
_

seems to compile.
