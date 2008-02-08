Return-Path: <linux-kernel-owner+w=401wt.eu-S934691AbYBHLKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbYBHLKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964841AbYBHLK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:10:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:52574 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933207AbYBHLKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:10:25 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1//suh4SvT/8hczYefmq8pmMGNIhZPVrLExZzcq7D
	Zd9Dhi+gfdbe5m
Date: Fri, 8 Feb 2008 12:10:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Protect pca953x from being unloaded while its GPIOs are
 in use
Message-ID: <Pine.LNX.4.64.0802081203280.5301@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the newly introduced owner field in struct gpio_chip to protect 
pca953x from being unloaded as long as its GPIOs are in use.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 0bd594d..89cee66 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -188,6 +188,7 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
 	gc->label = chip->client->name;
+	gc->owner = THIS_MODULE;
 }
 
 static int __devinit pca953x_probe(struct i2c_client *client)
