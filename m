Return-Path: <linux-kernel-owner+w=401wt.eu-S1030880AbXAZQwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030880AbXAZQwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXAZQvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:51:54 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:19143 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030810AbXAZQv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:51:26 -0500
Date: Fri, 26 Jan 2007 17:51:18 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Use device_{create,remove}_bin_file.
Message-ID: <20070126165118.GN11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Use device_{create,remove}_bin_file.

Create/remove the channel measurement binary files with
device_{create,remove}_bin_file instead of sysfs_{create,remove}_bin_file.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chsc.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/chsc.c linux-2.6-patched/drivers/s390/cio/chsc.c
--- linux-2.6/drivers/s390/cio/chsc.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/chsc.c	2007-01-26 17:27:59.000000000 +0100
@@ -967,8 +967,8 @@ static struct bin_attribute chp_measurem
 static void
 chsc_remove_chp_cmg_attr(struct channel_path *chp)
 {
-	sysfs_remove_bin_file(&chp->dev.kobj, &chp_measurement_chars_attr);
-	sysfs_remove_bin_file(&chp->dev.kobj, &chp_measurement_attr);
+	device_remove_bin_file(&chp->dev, &chp_measurement_chars_attr);
+	device_remove_bin_file(&chp->dev, &chp_measurement_attr);
 }
 
 static int
@@ -976,14 +976,12 @@ chsc_add_chp_cmg_attr(struct channel_pat
 {
 	int ret;
 
-	ret = sysfs_create_bin_file(&chp->dev.kobj,
-				    &chp_measurement_chars_attr);
+	ret = device_create_bin_file(&chp->dev, &chp_measurement_chars_attr);
 	if (ret)
 		return ret;
-	ret = sysfs_create_bin_file(&chp->dev.kobj, &chp_measurement_attr);
+	ret = device_create_bin_file(&chp->dev, &chp_measurement_attr);
 	if (ret)
-		sysfs_remove_bin_file(&chp->dev.kobj,
-				      &chp_measurement_chars_attr);
+		device_remove_bin_file(&chp->dev, &chp_measurement_chars_attr);
 	return ret;
 }
 
