Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYBKAXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYBKAXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYBKAXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:23:08 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:43067 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756805AbYBKAXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:23:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=WA4eO82rphcEviCoQpiPEhT79f6uvQxAwxUrHk69OojSD/l03GU8mu0OVDbC1oztdE9NDuMrJELptZBELj5UV6FdFeY3bgDw41wE7Om2qQ8VYJoc1Ux+tZd6aExf9PRmmhCruVn8TMlVcdrT3sw1rijcvGnInYoEy3izKfmu0p8=  ;
X-YMail-OSG: 2bKn254VM1kAKnUu6dIvUoI5xec7tMFhHaL146GF30UYSCzMH1k62u.v4Ovu6wSUJiDTchDzXQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc1 2/3] gpiolib: i2c/spi drivers handler rmmod better
Date: Sun, 10 Feb 2008 16:22:16 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802101622.16712.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Use the newly introduced owner field in struct gpio_chip to protect 
the current (small) set of non-SOC GPIO drivers from being unloaded
while any of their GPIOs are in use.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
[ add mcp23s08 and pcf857x ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/mcp23s08.c |    1 +
 drivers/gpio/pca953x.c  |    1 +
 drivers/gpio/pcf857x.c  |    1 +
 3 files changed, 3 insertions(+)

--- g26.orig/drivers/gpio/mcp23s08.c	2008-02-10 16:06:30.000000000 -0800
+++ g26/drivers/gpio/mcp23s08.c	2008-02-10 16:09:52.000000000 -0800
@@ -239,6 +239,7 @@ static int mcp23s08_probe(struct spi_dev
 	mcp->chip.base = pdata->base;
 	mcp->chip.ngpio = 8;
 	mcp->chip.can_sleep = 1;
+	mcp->chip.owner = THIS_MODULE;
 
 	spi_set_drvdata(spi, mcp);
 
--- g26.orig/drivers/gpio/pca953x.c	2008-02-10 16:06:30.000000000 -0800
+++ g26/drivers/gpio/pca953x.c	2008-02-10 16:09:52.000000000 -0800
@@ -188,6 +188,7 @@ static void pca953x_setup_gpio(struct pc
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
 	gc->label = chip->client->name;
+	gc->owner = THIS_MODULE;
 }
 
 static int __devinit pca953x_probe(struct i2c_client *client)
--- g26.orig/drivers/gpio/pcf857x.c	2008-02-10 16:06:30.000000000 -0800
+++ g26/drivers/gpio/pcf857x.c	2008-02-10 16:09:52.000000000 -0800
@@ -159,6 +159,7 @@ static int pcf857x_probe(struct i2c_clie
 
 	gpio->chip.base = pdata->gpio_base;
 	gpio->chip.can_sleep = 1;
+	gpio->chip.owner = THIS_MODULE;
 
 	/* NOTE:  the OnSemi jlc1562b is also largely compatible with
 	 * these parts, notably for output.  It has a low-resolution

