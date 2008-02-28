Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYB1Hcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYB1Hcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbYB1HcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:32:10 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:40533 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbYB1HcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=BrTHVDUO1qGGdU7otJF/F5g8IX3qa9IvhpteOGAgoJXrd3GJq0T0g5gtwdMKQ18rkJxyYNYgpbYMsYBokd9Vw/BHon7/Q/paLmiYxlWuFqdZIS9FynrncvzdxN0G5dWKM8dokxn2Lb6hoXtKe4bW/WiXeVGhXgORX+Jlaw400E8=
Message-ID: <47C66319.9000200@watson.wustl.edu>
Date: Thu, 28 Feb 2008 01:30:33 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/9] /drivers/net/apne.c replaced init_module&cleanup_module
 with module_init&module_exit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Jon Schindler <jkschind@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced init_module and cleanup_module with static functions and module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
---
diff --git a/drivers/net/apne.c b/drivers/net/apne.c
index c12cbdf..47a8275 100644
--- a/drivers/net/apne.c
+++ b/drivers/net/apne.c
@@ -569,7 +569,7 @@ static irqreturn_t apne_interrupt(int irq, void *dev_id)
 #ifdef MODULE
 static struct net_device *apne_dev;
 
-int __init init_module(void)
+static int __init apne_module_init(void)
 {
 	apne_dev = apne_probe(-1);
 	if (IS_ERR(apne_dev))
@@ -577,7 +577,7 @@ int __init init_module(void)
 	return 0;
 }
 
-void __exit cleanup_module(void)
+static void __exit apne_module_exit(void)
 {
 	unregister_netdev(apne_dev);
 
@@ -591,7 +591,8 @@ void __exit cleanup_module(void)
 
 	free_netdev(apne_dev);
 }
-
+module_init(apne_module_init);
+module_exit(apne_module_exit);
 #endif
 
 static int init_pcmcia(void)
