Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbXHTW5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbXHTW5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761626AbXHTWxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:53:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:53980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431AbXHTWxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:53:20 -0400
Message-Id: <20070820225145.074790000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:20 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: calle@calle.de, kkeil@suse.de, kay.sievers@vrfy.org
Subject: [patch 14/14] Convert from class_device to device for ISDN capi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=isdn-capi.patch

Convert from class_device to device for drivers/isdn/capi.  This is
part of the work to eliminate struct class_device.

---
 drivers/isdn/capi/capi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1544,11 +1544,11 @@ static int __init capi_init(void)
 		return PTR_ERR(capi_class);
 	}
 
-	class_device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi");
+	device_create(capi_class, NULL, MKDEV(capi_major, 0), "capi");
 
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 	if (capinc_tty_init() < 0) {
-		class_device_destroy(capi_class, MKDEV(capi_major, 0));
+		device_destroy(capi_class, MKDEV(capi_major, 0));
 		class_destroy(capi_class);
 		unregister_chrdev(capi_major, "capi20");
 		return -ENOMEM;
@@ -1576,7 +1576,7 @@ static void __exit capi_exit(void)
 {
 	proc_exit();
 
-	class_device_destroy(capi_class, MKDEV(capi_major, 0));
+	device_destroy(capi_class, MKDEV(capi_major, 0));
 	class_destroy(capi_class);
 	unregister_chrdev(capi_major, "capi20");
 

-- 
