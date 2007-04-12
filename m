Return-Path: <linux-kernel-owner+w=401wt.eu-S965427AbXDLHFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbXDLHFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965426AbXDLHFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:05:04 -0400
Received: from ns1.suse.de ([195.135.220.2]:48960 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbXDLHFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:05:02 -0400
Subject: patch driver-core-switch-firmware_class-to-uevent_suppress.patch added to gregkh-2.6 tree
To: cornelia.huck@de.ibm.com, akpm@linux-foundation.org,
       eric.rannaud@gmail.com, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, ranty@debian.org
From: <gregkh@suse.de>
Date: Thu, 12 Apr 2007 00:04:30 -0700
In-Reply-To: <20070329111214.1c3aa250@gondolin.boeblingen.de.ibm.com>
Message-Id: <20070412070500.28A53B63041@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Driver core: switch firmware_class to uevent_suppress.

to my gregkh-2.6 tree.  Its filename is

     driver-core-switch-firmware_class-to-uevent_suppress.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From cornelia.huck@de.ibm.com Thu Mar 29 02:10:23 2007
From: Cornelia Huck <cornelia.huck@de.ibm.com>
Date: Thu, 29 Mar 2007 11:12:14 +0200
Subject: Driver core: switch firmware_class to uevent_suppress.
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg K-H <greg@kroah.com>, Manuel Estrada Sainz <ranty@debian.org>, Eric Rannaud <eric.rannaud@gmail.com>
Message-ID: <20070329111214.1c3aa250@gondolin.boeblingen.de.ibm.com>


From: Cornelia Huck <cornelia.huck@de.ibm.com>

Use uevent_suppress instead of returning an error code in
firmware_uevent(). Get rid of the now unneeded FW_STATUS_READY
and FW_STATUS_READY_NOHOTPLUG.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/base/firmware_class.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -31,8 +31,6 @@ enum {
 	FW_STATUS_LOADING,
 	FW_STATUS_DONE,
 	FW_STATUS_ABORT,
-	FW_STATUS_READY,
-	FW_STATUS_READY_NOHOTPLUG,
 };
 
 static int loading_timeout = 60;	/* In seconds */
@@ -96,9 +94,6 @@ static int firmware_uevent(struct device
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	int i = 0, len = 0;
 
-	if (!test_bit(FW_STATUS_READY, &fw_priv->status))
-		return -ENODEV;
-
 	if (add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
 			   "FIRMWARE=%s", fw_priv->fw_id))
 		return -ENOMEM;
@@ -333,6 +328,7 @@ static int fw_register_device(struct dev
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
+	f_dev->uevent_suppress = 1;
 	retval = device_register(f_dev);
 	if (retval) {
 		printk(KERN_ERR "%s: device_register failed\n",
@@ -382,9 +378,7 @@ static int fw_setup_device(struct firmwa
 	}
 
 	if (uevent)
-                set_bit(FW_STATUS_READY, &fw_priv->status);
-        else
-                set_bit(FW_STATUS_READY_NOHOTPLUG, &fw_priv->status);
+		f_dev->uevent_suppress = 0;
 	*dev_p = f_dev;
 	goto out;
 


Patches currently in gregkh-2.6 which might be from cornelia.huck@de.ibm.com are

