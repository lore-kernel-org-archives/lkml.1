Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbZCYAoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbZCYAoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZCYAaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:25 -0400
Received: from kroah.org ([198.145.64.141]:54150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755438AbZCYAaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/61] scsi/m68k: Kill NCR_700_detect() warnings
Date: Tue, 24 Mar 2009 17:26:43 -0700
Message-Id: <1237940825-22904-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

The patch from Ming Lei <tom.leiming@gmail.com> entitled:
    platform driver: fix incorrect use of 'platform_bus_type' with 'struct devic
introduced the following warnings on m68k, as `dev' is now a `struct
platform_device *' instead of a `struct device *':

| drivers/scsi/a4000t.c:64: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type
| drivers/scsi/mvme16x_scsi.c:67: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type
| drivers/scsi/bvme6000_scsi.c:61: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type

I think the below is missing (untested on real hardware).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/a4000t.c        |    3 ++-
 drivers/scsi/bvme6000_scsi.c |    3 ++-
 drivers/scsi/mvme16x_scsi.c  |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index 6d25aca..61af3d9 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -61,7 +61,8 @@ static int __devinit a4000t_probe(struct platform_device *dev)
 	hostdata->dcntl_extra = EA_710;
 
 	/* and register the chip */
-	host = NCR_700_detect(&a4000t_scsi_driver_template, hostdata, dev);
+	host = NCR_700_detect(&a4000t_scsi_driver_template, hostdata,
+			      &dev->dev);
 	if (!host) {
 		printk(KERN_ERR "a4000t-scsi: No host detected; "
 				"board configuration problem?\n");
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
index 9e9a82b..5799cb5 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -58,7 +58,8 @@ bvme6000_probe(struct platform_device *dev)
 	hostdata->ctest7_extra = CTEST7_TT1;
 
 	/* and register the chip */
-	host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata, dev);
+	host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata,
+			      &dev->dev);
 	if (!host) {
 		printk(KERN_ERR "bvme6000-scsi: No host detected; "
 				"board configuration problem?\n");
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index 7794fc1..b5fbfd6 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -64,7 +64,8 @@ mvme16x_probe(struct platform_device *dev)
 	hostdata->ctest7_extra = CTEST7_TT1;
 
 	/* and register the chip */
-	host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata, dev);
+	host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata,
+			      &dev->dev);
 	if (!host) {
 		printk(KERN_ERR "mvme16x-scsi: No host detected; "
 				"board configuration problem?\n");
-- 
1.6.2

