Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZEIOpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZEIOpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZEIOnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:43:03 -0400
Received: from kroah.org ([198.145.64.141]:54193 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbZEIOnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:43:01 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:35 2009
Message-Id: <20090509143635.398798980@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:11 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 10/13] Driver Core: drm: add nodename for drm devices
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-drm-add-nodename-for-drm-devices.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the drm core to report the proper device name to
userspace for the drm devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/drm_sysfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -70,6 +70,11 @@ static ssize_t version_show(struct class
 		       CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
 }
 
+static char *drm_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "dri/%s", dev_name(dev));
+}
+
 static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
 
 /**
@@ -101,6 +106,8 @@ struct class *drm_sysfs_create(struct mo
 	if (err)
 		goto err_out_class;
 
+	class->nodename = drm_nodename;
+
 	return class;
 
 err_out_class:


