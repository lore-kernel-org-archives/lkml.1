Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbXHHERi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbXHHERi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXHHER1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:17:27 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:60735 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbXHHER0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:17:26 -0400
Message-ID: <46B943D3.9020207@lwfinger.net>
Date: Tue, 07 Aug 2007 23:17:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Error message from device_rename in drivers/base/core.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting the following error message from drivers/base/core.c:

net eth1: device_rename: sysfs_create_symlink failed (-17)

Upon investigation, the call generating the error is renaming 'eth1' to 'eth1'. The following patch 
suppresses the error.


Index: wireless-dev/drivers/base/core.c
===================================================================
--- wireless-dev.orig/drivers/base/core.c
+++ wireless-dev/drivers/base/core.c
@@ -1256,7 +1256,7 @@ int device_rename(struct device *dev, ch
  		sysfs_remove_link(&dev->class->subsys.kobj, old_device_name);
  		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
  					  dev->bus_id);
-		if (error) {
+		if (error && memcmp(dev->bus_id, new_name, sizeof(new_name))) {
  			/* Uh... how to unravel this if restoring can fail? */
  			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
  				__FUNCTION__, error);


Larry
