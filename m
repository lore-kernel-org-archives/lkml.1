Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYJPRS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYJPRS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYJPROQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:16 -0400
Received: from kroah.org ([198.145.64.141]:46940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756121AbYJPRON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 09/46] device create: s390: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:10 -0700
Message-Id: <1224177047-11859-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/char/raw3270.c    |   14 ++++++--------
 drivers/s390/char/tape_class.c |    6 +++---
 drivers/s390/char/vmlogrdr.c   |    8 ++++----
 drivers/s390/char/vmur.c       |    5 ++---
 4 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 1792b2c..0b15cf1 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -1168,19 +1168,17 @@ static int raw3270_create_attributes(struct raw3270 *rp)
 	if (rc)
 		goto out;
 
-	rp->clttydev = device_create_drvdata(class3270, &rp->cdev->dev,
-					     MKDEV(IBM_TTY3270_MAJOR, rp->minor),
-					     NULL,
-					     "tty%s", dev_name(&rp->cdev->dev));
+	rp->clttydev = device_create(class3270, &rp->cdev->dev,
+				     MKDEV(IBM_TTY3270_MAJOR, rp->minor), NULL,
+				     "tty%s", dev_name(&rp->cdev->dev));
 	if (IS_ERR(rp->clttydev)) {
 		rc = PTR_ERR(rp->clttydev);
 		goto out_ttydev;
 	}
 
-	rp->cltubdev = device_create_drvdata(class3270, &rp->cdev->dev,
-					     MKDEV(IBM_FS3270_MAJOR, rp->minor),
-					     NULL,
-					     "tub%s", dev_name(&rp->cdev->dev));
+	rp->cltubdev = device_create(class3270, &rp->cdev->dev,
+				     MKDEV(IBM_FS3270_MAJOR, rp->minor), NULL,
+				     "tub%s", dev_name(&rp->cdev->dev));
 	if (!IS_ERR(rp->cltubdev))
 		goto out;
 
diff --git a/drivers/s390/char/tape_class.c b/drivers/s390/char/tape_class.c
index 12c2a5a..ddc914c 100644
--- a/drivers/s390/char/tape_class.c
+++ b/drivers/s390/char/tape_class.c
@@ -69,9 +69,9 @@ struct tape_class_device *register_tape_dev(
 	if (rc)
 		goto fail_with_cdev;
 
-	tcd->class_device = device_create_drvdata(tape_class, device,
-						  tcd->char_device->dev,
-						  NULL, "%s", tcd->device_name);
+	tcd->class_device = device_create(tape_class, device,
+					  tcd->char_device->dev, NULL,
+					  "%s", tcd->device_name);
 	rc = IS_ERR(tcd->class_device) ? PTR_ERR(tcd->class_device) : 0;
 	if (rc)
 		goto fail_with_cdev;
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index 42173cc..2476272 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -747,10 +747,10 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 		device_unregister(dev);
 		return ret;
 	}
-	priv->class_device = device_create_drvdata(vmlogrdr_class, dev,
-						   MKDEV(vmlogrdr_major,
-							 priv->minor_num),
-						   priv, "%s", dev_name(dev));
+	priv->class_device = device_create(vmlogrdr_class, dev,
+					   MKDEV(vmlogrdr_major,
+						 priv->minor_num),
+					   priv, "%s", dev_name(dev));
 	if (IS_ERR(priv->class_device)) {
 		ret = PTR_ERR(priv->class_device);
 		priv->class_device=NULL;
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index 6fdfa5d..9020eba 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -896,9 +896,8 @@ static int ur_set_online(struct ccw_device *cdev)
 		goto fail_free_cdev;
 	}
 
-	urd->device = device_create_drvdata(vmur_class, NULL,
-					    urd->char_device->dev, NULL,
-					    "%s", node_id);
+	urd->device = device_create(vmur_class, NULL, urd->char_device->dev,
+				    NULL, "%s", node_id);
 	if (IS_ERR(urd->device)) {
 		rc = PTR_ERR(urd->device);
 		TRACE("ur_set_online: device_create rc=%d\n", rc);
-- 
1.6.0.2

