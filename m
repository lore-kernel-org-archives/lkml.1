Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbZDUBLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbZDUBLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZDUBLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:11:24 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:57954 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbZDUBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:11:21 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, gregkh@suse.de, kay.sievers@vrfy.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 1/4] driver core: use string format when name is another device's name
Date: Mon, 20 Apr 2009 21:17:13 -0300
Message-Id: <2289cd3dcbe25046472d90cd0b25e57fbef92dc1.1240272929.git.cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240273036-5995-1-git-send-email-cascardo@holoscopio.com>
References: <1240273036-5995-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <cover.1240272928.git.cascardo@holoscopio.com>
References: <cover.1240272928.git.cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a construct like dev_set_name(&xdev, "%s", dev_name(&dev)),
make sure the string specification is used as the format instead of
directly using the device name. This protects both against the case
where device name is NULL or includes any string specification.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/base/attribute_container.c |    2 +-
 drivers/base/firmware_class.c      |    2 +-
 drivers/ide/ide-cd.c               |    2 +-
 drivers/ide/ide-gd.c               |    2 +-
 drivers/ide/ide-tape.c             |    2 +-
 drivers/scsi/sd.c                  |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index b9cda05..e0f7859 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -167,7 +167,7 @@ attribute_container_add_device(struct device *dev,
 		ic->classdev.parent = get_device(dev);
 		ic->classdev.class = cont->class;
 		cont->class->dev_release = attribute_container_release;
-		dev_set_name(&ic->classdev, dev_name(dev));
+		dev_set_name(&ic->classdev, "%s", dev_name(dev));
 		if (fn)
 			fn(cont, dev, &ic->classdev);
 		else
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d3a59c6..f770811 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -315,7 +315,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	fw_priv->timeout.data = (u_long) fw_priv;
 	init_timer(&fw_priv->timeout);
 
-	dev_set_name(f_dev, dev_name(device));
+	dev_set_name(f_dev, "%s", dev_name(device));
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3aec19d..5c1efef 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1817,7 +1817,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 
 	info->dev.parent = &drive->gendev;
 	info->dev.release = ide_cd_release;
-	dev_set_name(&info->dev, dev_name(&drive->gendev));
+	dev_set_name(&info->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&info->dev))
 		goto out_free_disk;
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 1aebdf1..f91031a 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -345,7 +345,7 @@ static int ide_gd_probe(ide_drive_t *drive)
 
 	idkp->dev.parent = &drive->gendev;
 	idkp->dev.release = ide_disk_release;
-	dev_set_name(&idkp->dev, dev_name(&drive->gendev));
+	dev_set_name(&idkp->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&idkp->dev))
 		goto out_free_disk;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cb942a9..e5b6bea 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2384,7 +2384,7 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	tape->dev.parent = &drive->gendev;
 	tape->dev.release = ide_tape_release;
-	dev_set_name(&tape->dev, dev_name(&drive->gendev));
+	dev_set_name(&tape->dev, "%s", dev_name(&drive->gendev));
 
 	if (device_register(&tape->dev))
 		goto out_free_disk;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fcb64b..254bc3e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1918,7 +1918,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	device_initialize(&sdkp->dev);
 	sdkp->dev.parent = &sdp->sdev_gendev;
 	sdkp->dev.class = &sd_disk_class;
-	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
+	dev_set_name(&sdkp->dev, "%s", dev_name(&sdp->sdev_gendev));
 
 	if (device_add(&sdkp->dev))
 		goto out_free_index;
-- 
1.6.2.3

