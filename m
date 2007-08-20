Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbXHTWxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbXHTWxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbXHTWwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:52:34 -0400
Received: from ns.suse.de ([195.135.220.2]:60143 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbXHTWwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:33 -0400
Message-Id: <20070820225057.958888000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:09 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, kay.sievers@vrfy.org
Subject: [patch 03/14] Convert from class_device to device for block/aoechr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=aoechr.patch

Convert from class_device to device for block/aoechr.  This is part of the
work to eliminate struct class_device.

---
 drivers/block/aoe/aoechr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -259,9 +259,8 @@ aoechr_init(void)
 		return PTR_ERR(aoe_class);
 	}
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
-		class_device_create(aoe_class, NULL,
-					MKDEV(AOE_MAJOR, chardevs[i].minor),
-					NULL, chardevs[i].name);
+		device_create(aoe_class, NULL,
+			      MKDEV(AOE_MAJOR, chardevs[i].minor), chardevs[i].name);
 
 	return 0;
 }
@@ -272,7 +271,7 @@ aoechr_exit(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
-		class_device_destroy(aoe_class, MKDEV(AOE_MAJOR, chardevs[i].minor));
+		device_destroy(aoe_class, MKDEV(AOE_MAJOR, chardevs[i].minor));
 	class_destroy(aoe_class);
 	unregister_chrdev(AOE_MAJOR, "aoechr");
 }

-- 
