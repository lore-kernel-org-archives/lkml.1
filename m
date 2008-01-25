Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbYAYHXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbYAYHXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbYAYHPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:42 -0500
Received: from ns.suse.de ([195.135.220.2]:52545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758504AbYAYHPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 028/196] cosa: Convert from class_device to device for cosa sync driver
Date: Thu, 24 Jan 2008 23:09:26 -0800
Message-Id: <1201245134-4876-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

struct class_device is going away, this converts the code to use struct
device instead.

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wan/cosa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index ff37bf4..1d706ea 100644
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
1.5.3.8

