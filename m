Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbXHTWx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbXHTWx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759458AbXHTWwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:52:42 -0400
Received: from ns1.suse.de ([195.135.220.2]:60149 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759426AbXHTWwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:41 -0400
Message-Id: <20070820225105.840344000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:11 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: kas@fi.muni.cz, kay.sievers@vrfy.org
Subject: [patch 05/14] Convert from class_device to device for cosa sync driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=wan.patch

Convert from class_device to device for drivers/net/wan/cosa.  This is part of 
the work to eliminate struct class_device.

---
 drivers/net/wan/cosa.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -395,8 +395,7 @@ static int __init cosa_init(void)
 		goto out_chrdev;
 	}
 	for (i=0; i<nr_cards; i++) {
-		class_device_create(cosa_class, NULL, MKDEV(cosa_major, i),
-				NULL, "cosa%d", i);
+		device_create(cosa_class, NULL, MKDEV(cosa_major, i), "cosa%d", i);
 	}
 	err = 0;
 	goto out;
@@ -415,7 +414,7 @@ static void __exit cosa_exit(void)
 	printk(KERN_INFO "Unloading the cosa module\n");
 
 	for (i=0; i<nr_cards; i++)
-		class_device_destroy(cosa_class, MKDEV(cosa_major, i));
+		device_destroy(cosa_class, MKDEV(cosa_major, i));
 	class_destroy(cosa_class);
 	for (cosa=cosa_cards; nr_cards--; cosa++) {
 		/* Clean up the per-channel data */

-- 
