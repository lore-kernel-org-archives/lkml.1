Return-Path: <linux-kernel-owner+w=401wt.eu-S1161386AbXEDSU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161386AbXEDSU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161373AbXEDSUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:20:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:15898 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161430AbXEDSUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:20:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,493,1170662400"; 
   d="scan'208";a="239394113"
Date: Fri, 4 May 2007 11:17:33 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       akpm@linux-foundation.org
Subject: [patch 6/7] SCSI: save disk in scsi_device - resend
Message-Id: <20070504111733.f507501d.kristen.c.accardi@intel.com>
In-Reply-To: <20070424074856.005152262@intel.com>
References: <20070424074856.005152262@intel.com>
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
@@ -1711,6 +1711,7 @@ static int sd_probe(struct device *dev)
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
+	sdp->disk = gd;
 
 	sdev_printk(KERN_NOTICE, sdp, "Attached scsi %sdisk %s\n",
 		    sdp->removable ? "removable " : "", gd->disk_name);
Index: 2.6-git/drivers/scsi/sr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/sr.c
+++ 2.6-git/drivers/scsi/sr.c
@@ -604,6 +604,7 @@ static int sr_probe(struct device *dev)
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
@@ -138,7 +138,7 @@ struct scsi_device {
 
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
-
+	struct gendisk 		*disk;
 	struct execute_work	ew; /* used to get process context on put */
 
 	enum scsi_device_state sdev_state;

-- 
