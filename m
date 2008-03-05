Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbYCEFxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbYCEFxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760478AbYCEFuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:50:46 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:17288 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762108AbYCEFun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:50:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=Xd1KOgaW3MPt/I281PH1kAsxJ92XbPuI1YrZ7Ck00JO/aRVaHtmJ8HDcwembZu0wuM8wFdXY7BUdtt4JCn+4UnDi4o+WdOX+ezTyodqAXLYvEgC7eY5lG/l+QRdLie/MVZ5N1JvU/kb5iYTBUCZZAQBoaQzUIx+1yrFG0WxUHVQ=
Message-ID: <47CE34B7.9070109@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:50:47 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/11] /drivers/net/3c527.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index b72b89d..4740a80 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -1631,23 +1631,24 @@ static const struct ethtool_ops netdev_ethtool_ops = {
 static struct net_device *this_device;
 
 /**
- *	init_module		-	entry point
+ *	tc527_module_init	-	entry point
  *
  *	Probe and locate a 3c527 card. This really should probe and locate
  *	all the 3c527 cards in the machine not just one of them. Yes you can
  *	insmod multiple modules for now but it's a hack.
  */
 
-int __init init_module(void)
+static int __init tc527_module_init(void)
 {
 	this_device = mc32_probe(-1);
 	if (IS_ERR(this_device))
 		return PTR_ERR(this_device);
 	return 0;
 }
+module_init(tc527_module_init);
 
 /**
- *	cleanup_module	-	free resources for an unload
+ *	tc527_module_exit	-	free resources for an unload
  *
  *	Unloading time. We release the MCA bus resources and the interrupt
  *	at which point everything is ready to unload. The card must be stopped
@@ -1657,11 +1658,12 @@ int __init init_module(void)
  *	transmit operations are allowed to start scribbling into memory.
  */
 
-void __exit cleanup_module(void)
+static void __exit tc527_module_exit(void)
 {
 	unregister_netdev(this_device);
 	cleanup_card(this_device);
 	free_netdev(this_device);
 }
+module_exit(tc527_module_exit);
 
 #endif /* MODULE */
