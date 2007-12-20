Return-Path: <linux-kernel-owner+w=401wt.eu-S936672AbXLTPhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936672AbXLTPhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934153AbXLTPW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:22:27 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:40936 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933411AbXLTPVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:11 -0500
Message-Id: <20071220152109.626799874@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:55 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Stefan Haberland <stefan.haberland@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 30/47] dasd: fix return value of dasd_generic_probe()
Content-Disposition: inline; filename=129-dasd-probe.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Haberland <stefan.haberland@de.ibm.com>

Using the return value of ccw_device_set_online as return value for 
dasd_generic_probe() causes the DASD to fail setting online

Signed-off-by: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: quilt-2.6/drivers/s390/block/dasd.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd.c
+++ quilt-2.6/drivers/s390/block/dasd.c
@@ -1969,9 +1969,10 @@ dasd_generic_probe (struct ccw_device *c
 		ret = ccw_device_set_online(cdev);
 	if (ret)
 		printk(KERN_WARNING
-		       "dasd_generic_probe: could not initially online "
-		       "ccw-device %s\n", cdev->dev.bus_id);
-	return ret;
+		       "dasd_generic_probe: could not initially "
+		       "online ccw-device %s; return code: %d\n",
+		       cdev->dev.bus_id, ret);
+	return 0;
 }
 
 /*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

