Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbYB1Hc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbYB1Hc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbYB1Hc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:32:28 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:38768 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbYB1Hc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=hFWJvUfKUGg9xdLoVI2LWPgSqsdKkr17b8gOGrQM1QeH5Opsbc8K1mcPMrrQmwd5cKvtxF+RlpPEdsQBpkkBAOrXSWbG5HGfUACUTycP/keIhxiBoCqH3FU1WPlSZtduEje/KsavrjTVFP4PC+uHFTaXQ8c6qHkUBM67UKxEfb0=
Message-ID: <47C6632A.2000505@watson.wustl.edu>
Date: Thu, 28 Feb 2008 01:30:50 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/9] /drivers/net/appletalk/cops.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index 92c3a4c..65b901e 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -1010,7 +1010,7 @@ module_param(io, int, 0);
 module_param(irq, int, 0);
 module_param(board_type, int, 0);
 
-int __init init_module(void)
+static int __init cops_module_init(void)
 {
 	if (io == 0)
 		printk(KERN_WARNING "%s: You shouldn't autoprobe with insmod\n",
@@ -1021,12 +1021,14 @@ int __init init_module(void)
         return 0;
 }
 
-void __exit cleanup_module(void)
+static void __exit cops_module_exit(void)
 {
 	unregister_netdev(cops_dev);
 	cleanup_card(cops_dev);
 	free_netdev(cops_dev);
 }
+module_init(cops_module_init);
+module_exit(cops_module_exit);
 #endif /* MODULE */
 
 /*
