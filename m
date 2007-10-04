Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbXJDLb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbXJDLb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbXJDL2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:28:44 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:57483 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbXJDL2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:25 -0400
Message-Id: <20071004112827.572861959@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 11/34] cio: Fix device attributes for early devices.
Content-Disposition: inline; filename=011-cio-early-attributes.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Don't forget to set dev->groups for early ccw devices like the
console device so the default attributes are created.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -1123,6 +1123,7 @@ io_subchannel_probe (struct subchannel *
 		 * device, e.g. the console.
 		 */
 		cdev = sch->dev.driver_data;
+		cdev->dev.groups = ccwdev_attr_groups;
 		device_initialize(&cdev->dev);
 		ccw_device_register(cdev);
 		/*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

