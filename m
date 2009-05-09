Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZEIOpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZEIOpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZEIOnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:43:01 -0400
Received: from kroah.org ([198.145.64.141]:54190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbZEIOnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:43:00 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:35 2009
Message-Id: <20090509143634.850078750@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:10 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 09/13] Driver Core: raw: add nodename for raw devices
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-raw-add-nodename-for-raw-devices.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the raw driver to report the proper device name to
userspace for the raw devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/raw.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -261,6 +261,11 @@ static const struct file_operations raw_
 
 static struct cdev raw_cdev;
 
+static char *raw_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "raw/%s", dev_name(dev));
+}
+
 static int __init raw_init(void)
 {
 	dev_t dev = MKDEV(RAW_MAJOR, 0);
@@ -284,6 +289,7 @@ static int __init raw_init(void)
 		ret = PTR_ERR(raw_class);
 		goto error_region;
 	}
+	raw_class->nodename = raw_nodename;
 	device_create(raw_class, NULL, MKDEV(RAW_MAJOR, 0), NULL, "rawctl");
 
 	return 0;


