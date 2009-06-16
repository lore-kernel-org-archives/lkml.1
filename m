Return-Path: <linux-kernel-owner+w=401wt.eu-S937093AbZFPGE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937093AbZFPGE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbZFPFvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:44 -0400
Received: from kroah.org ([198.145.64.141]:48473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935954AbZFPFvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/64] parport: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:46 -0700
Message-Id: <1245131213-24168-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/parport/parport_gsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index ea31a45..5d6de38 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -376,14 +376,14 @@ static int __devinit parport_init_chip(struct parisc_device *dev)
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
+	struct parport *p = dev_get_drvdata(&dev->dev);
 	if (p) {
 		struct parport_gsc_private *priv = p->private_data;
 		struct parport_operations *ops = p->ops;
-- 
1.6.3.2

