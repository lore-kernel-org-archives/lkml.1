Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYEKRn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYEKRn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbYEKRn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:43:29 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:50017 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542AbYEKRn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:43:27 -0400
Message-Id: <20080511174439.356312255@sortiz.org>
References: <20080511173653.869192035@sortiz.org>
User-Agent: quilt/0.46-1
Date: Sun, 11 May 2008 19:36:55 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: [PATCH -mm 2/5] asic3: Remove children platform data
Content-Disposition: inline; filename=asic3-keys_pdata.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform devices should be dynamically allocated, and each supported
device should have its own platform data.
For now we just remove this buggy code.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
---
 drivers/mfd/asic3.c       |    8 --------
 include/linux/mfd/asic3.h |    3 ---
 2 files changed, 11 deletions(-)

Index: linux-2.6-htc-asic3/drivers/mfd/asic3.c
===================================================================
--- linux-2.6-htc-asic3.orig/drivers/mfd/asic3.c	2008-05-11 17:30:04.000000000 +0200
+++ linux-2.6-htc-asic3/drivers/mfd/asic3.c	2008-05-11 17:38:45.000000000 +0200
@@ -604,14 +604,6 @@ static int asic3_probe(struct platform_d
 		goto out_irq;
 	}
 
-	if (pdata->children) {
-		int i;
-		for (i = 0; i < pdata->n_children; i++) {
-			pdata->children[i]->dev.parent = &pdev->dev;
-			platform_device_register(pdata->children[i]);
-		}
-	}
-
 	printk(KERN_INFO "ASIC3 Core driver\n");
 
 	return 0;
Index: linux-2.6-htc-asic3/include/linux/mfd/asic3.h
===================================================================
--- linux-2.6-htc-asic3.orig/include/linux/mfd/asic3.h	2008-05-11 17:34:42.000000000 +0200
+++ linux-2.6-htc-asic3/include/linux/mfd/asic3.h	2008-05-11 17:37:17.000000000 +0200
@@ -32,9 +32,6 @@ struct asic3_platform_data {
 	unsigned int irq_base;
 
 	unsigned int gpio_base;
-
-	struct platform_device **children;
-	unsigned int n_children;
 };
 
 #define ASIC3_NUM_GPIO_BANKS	4

-- 
