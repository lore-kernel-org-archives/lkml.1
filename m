Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZEDU1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZEDU1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZEDU0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:26:40 -0400
Received: from kroah.org ([198.145.64.141]:37877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZEDU0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:26:39 -0400
Date: Mon, 4 May 2009 13:14:29 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Subject: [PATCH] parport: remove driver_data direct access of struct device
Message-ID: <20090504201429.GA23129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/parport/parport_gsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -376,14 +376,14 @@ static int __devinit parport_init_chip(s
 			/* PARPORT_IRQ_NONE */ PARPORT_DMA_NONE, NULL);
 	if (p)
 		parport_count++;
-	dev->dev.driver_data = p;
+	dev_set_drvdata(&dev->dev, p);
 
 	return 0;
 }
 
 static int __devexit parport_remove_chip(struct parisc_device *dev)
 {
-	struct parport *p = dev->dev.driver_data;
+	struct parport *p = dev_get_drvdata(&dev->dev)
 	if (p) {
 		struct parport_gsc_private *priv = p->private_data;
 		struct parport_operations *ops = p->ops;
