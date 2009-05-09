Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZEIOqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZEIOqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZEIOnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:43:06 -0400
Received: from kroah.org ([198.145.64.141]:54199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbZEIOnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:43:03 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:36 2009
Message-Id: <20090509143636.442608948@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:13 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 12/13] Driver Core: bsg: add nodename for bsg driver
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-bsg-add-nodename-for-bsg-driver.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the BSG driver to report the proper device name to
userspace for the bsg devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/bsg.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1062,6 +1062,11 @@ EXPORT_SYMBOL_GPL(bsg_register_queue);
 
 static struct cdev bsg_cdev;
 
+static char *bsg_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "bsg/%s", dev_name(dev));
+}
+
 static int __init bsg_init(void)
 {
 	int ret, i;
@@ -1082,6 +1087,7 @@ static int __init bsg_init(void)
 		ret = PTR_ERR(bsg_class);
 		goto destroy_kmemcache;
 	}
+	bsg_class->nodename = bsg_nodename;
 
 	ret = alloc_chrdev_region(&devid, 0, BSG_MAX_DEVS, "bsg");
 	if (ret)


