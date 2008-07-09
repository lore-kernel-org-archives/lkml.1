Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYGIKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYGIKuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYGIKti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:49:38 -0400
Received: from hull.simtec.co.uk ([78.105.113.97]:42487 "EHLO
	ivanova.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752914AbYGIKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:49:36 -0400
Message-Id: <20080709104932.475821512@fluff.org>
References: <20080709104916.200210922@fluff.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 11:49:17 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Cc: sameo@openedhand.com, dbaryshkov@gmail.com,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/4] MFD: Use to_platform_device instead of container_of.
Content-Disposition: inline; filename=mfd-fix-platform-device-translation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mfd_remove_devices_fn() to use to_platform_device()
instead of doing container_of().

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
===================================================================
--- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c	2008-07-09 10:13:53.000000000 +0100
+++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c	2008-07-09 10:14:26.000000000 +0100
@@ -99,8 +99,7 @@ EXPORT_SYMBOL(mfd_add_devices);
 
 static int mfd_remove_devices_fn(struct device *dev, void *unused)
 {
-	platform_device_unregister(
-			container_of(dev, struct platform_device, dev));
+	platform_device_unregister(to_platform_device(dev));
 	return 0;
 }
 

-- 
