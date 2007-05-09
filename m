Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXEIXnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXEIXnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760252AbXEIXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:41:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:49385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759240AbXEIXll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:41:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="226366826"
Date: Wed, 9 May 2007 16:38:41 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 6/7] SCSI: save disk in scsi_device
Message-Id: <20070509163841.83b0cc40.kristen.c.accardi@intel.com>
In-Reply-To: <20070510072247.063476979@intel.com>
References: <20070510072247.063476979@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give anyone who has access to scsi_device access to the genhd struct as well.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/scsi/sd.c
===================================================================
--- 2.6-git.orig/drivers/scsi/sd.c
+++ 2.6-git/drivers/scsi/sd.c
@@ -1673,6 +1673,7 @@ static int sd_probe(struct device *dev)
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
+	sdp->disk = gd;
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
Index: 2.6-git/drivers/scsi/sr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/sr.c
+++ 2.6-git/drivers/scsi/sr.c
@@ -606,6 +606,7 @@ static int sr_probe(struct device *dev)
 	if (sdev->media_change_notify)
 		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 	add_disk(disk);
+	sdev->disk = disk;
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
Index: 2.6-git/include/scsi/scsi_device.h
===================================================================
--- 2.6-git.orig/include/scsi/scsi_device.h
+++ 2.6-git/include/scsi/scsi_device.h
@@ -140,7 +140,7 @@ struct scsi_device {
 
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
-
+	struct gendisk 		*disk;
 	struct execute_work	ew; /* used to get process context on put */
 
 	enum scsi_device_state sdev_state;

-- 
