Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZCYAhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZCYAhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbZCYA36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:58 -0400
Received: from kroah.org ([198.145.64.141]:54086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755812AbZCYA3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 19/61] dio: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:23 -0700
Message-Id: <1237940825-22904-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/dio/dio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index 10c3c49..55dd88d 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -182,7 +182,7 @@ static int __init dio_init(void)
 
 	/* Initialize the DIO bus */ 
 	INIT_LIST_HEAD(&dio_bus.devices);
-	strcpy(dio_bus.dev.bus_id, "dio");
+	dev_set_name(&dio_bus.dev, "dio");
 	error = device_register(&dio_bus.dev);
 	if (error) {
 		pr_err("DIO: Error registering dio_bus\n");
@@ -237,7 +237,7 @@ static int __init dio_init(void)
 		dev->scode = scode;
 		dev->resource.start = pa;
 		dev->resource.end = pa + DIO_SIZE(scode, va);
-		sprintf(dev->dev.bus_id,"%02x", scode);
+		dev_set_name(&dev->dev, "%02x", scode);
 
                 /* read the ID byte(s) and encode if necessary. */
 		prid = DIO_ID(va);
-- 
1.6.2

