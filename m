Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZEIOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZEIOqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZEIOnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:43:05 -0400
Received: from kroah.org ([198.145.64.141]:54195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZEIOnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:43:03 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:36 2009
Message-Id: <20090509143635.946889660@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:12 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 11/13] Driver Core: aoe: add nodename for aoe devices
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-aoe-add-nodename-for-aoe-devices.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the AOE core to report the proper device name to
userspace for the AOE devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/aoe/aoechr.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -266,6 +266,11 @@ static const struct file_operations aoe_
 	.owner = THIS_MODULE,
 };
 
+static char *aoe_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "etherd/%s", dev_name(dev));
+}
+
 int __init
 aoechr_init(void)
 {
@@ -283,6 +288,8 @@ aoechr_init(void)
 		unregister_chrdev(AOE_MAJOR, "aoechr");
 		return PTR_ERR(aoe_class);
 	}
+	aoe_class->nodename = aoe_nodename;
+
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
 		device_create(aoe_class, NULL,
 			      MKDEV(AOE_MAJOR, chardevs[i].minor), NULL,


