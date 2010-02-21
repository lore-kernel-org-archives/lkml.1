Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0BUQ45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:56:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58341 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0BUQ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:56:55 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:56:42 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/8] firewire: core: combine a bit of repeated code
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
Message-ID: <tkrat.fb747c7b15b6ff30@s5r6.in-berlin.de>
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1349,6 +1349,9 @@ static int dispatch_ioctl(struct client 
 	union ioctl_arg buffer;
 	int ret;
 
+	if (fw_device_is_shutdown(client->device))
+		return -ENODEV;
+
 	if (_IOC_TYPE(cmd) != '#' ||
 	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
 		return -EINVAL;
@@ -1375,24 +1378,14 @@ static int dispatch_ioctl(struct client 
 static long fw_device_op_ioctl(struct file *file,
 			       unsigned int cmd, unsigned long arg)
 {
-	struct client *client = file->private_data;
-
-	if (fw_device_is_shutdown(client->device))
-		return -ENODEV;
-
-	return dispatch_ioctl(client, cmd, (void __user *) arg);
+	return dispatch_ioctl(file->private_data, cmd, (void __user *)arg);
 }
 
 #ifdef CONFIG_COMPAT
 static long fw_device_op_compat_ioctl(struct file *file,
 				      unsigned int cmd, unsigned long arg)
 {
-	struct client *client = file->private_data;
-
-	if (fw_device_is_shutdown(client->device))
-		return -ENODEV;
-
-	return dispatch_ioctl(client, cmd, compat_ptr(arg));
+	return dispatch_ioctl(file->private_data, cmd, compat_ptr(arg));
 }
 #endif
 

-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

