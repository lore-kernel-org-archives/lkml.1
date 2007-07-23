Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbXGWOkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbXGWOkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXGWOkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:40:01 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:21286 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXGWOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:sender;
        b=ok/Q2Ug39hYzeNDXK0Cenp7XzOtef7gFXyjLEHi+KuGo0H6I4fuzbJWmHVUoPyBcDsSW1pSz+JylZG8JsYJ+tt+tkw02yzsc/MPvOoWBg5S/eVzM1WmVVI/tAcNGgD+dBFq50pZ4AkrG5oNfAxQRniAedhs5qnrm2EU8up9nE3c=
Date: Mon, 23 Jul 2007 16:36:38 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: James.Bottomley@SteelEye.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: [patch] drivers/scsi/scsi_sysfs.c:718: warning: unused variable `rq'
Message-ID: <20070723143637.GB23448@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

A compile of the latest git on arm triggers the following warning:
  CC [M]  drivers/scsi/scsi_sysfs.o
  drivers/scsi/scsi_sysfs.c: In function `scsi_sysfs_add_sdev':
  drivers/scsi/scsi_sysfs.c:718: warning: unused variable `rq'

The following patch kills the intermediary variable.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 34cdce6..9e5cc4f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -715,7 +715,6 @@ static int attr_add(struct device *dev, struct device_attribute *attr)
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
 	int error, i;
-	struct request_queue *rq = sdev->request_queue;
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
@@ -736,7 +735,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
 
-	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);
+	error = bsg_register_queue(sdev->request_queue,
+				   &sdev->sdev_gendev, NULL);
 
 	if (error)
 		sdev_printk(KERN_INFO, sdev,
