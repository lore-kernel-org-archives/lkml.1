Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYB1Hei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYB1Hei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbYB1Hc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:32:56 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:43453 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217AbYB1Hcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:32:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=lPpzCNGY28m+G+fiqTfxCGcOsQzOMgsAxrbZp2rxZQQ5tACiY2OjSo6BaC7GiCO0rjtD2RZ853/u8AyLibkAePt+XWpbCeBQ7iNqdxH3JfT4fuwVgoL70Oi6jOZ+ZGU0AP1CkljMI2y/KrLC+T4C6yDQzJ7HXOp8dew0dQv/NIw=
Message-ID: <47C66346.80108@watson.wustl.edu>
Date: Thu, 28 Feb 2008 01:31:18 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/9] /drivers/net/atarilance.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/atarilance.c b/drivers/net/atarilance.c
index b74dbee..8422e3b 100644
--- a/drivers/net/atarilance.c
+++ b/drivers/net/atarilance.c
@@ -1156,7 +1156,7 @@ static int lance_set_mac_address( struct net_device *dev, void *addr )
 #ifdef MODULE
 static struct net_device *atarilance_dev;
 
-int __init init_module(void)
+static int __init atarilance_module_init(void)
 {
 	atarilance_dev = atarilance_probe(-1);
 	if (IS_ERR(atarilance_dev))
@@ -1164,13 +1164,14 @@ int __init init_module(void)
 	return 0;
 }
 
-void __exit cleanup_module(void)
+static void __exit atarilance_module_exit(void)
 {
 	unregister_netdev(atarilance_dev);
 	free_irq(atarilance_dev->irq, atarilance_dev);
 	free_netdev(atarilance_dev);
 }
-
+module_init(atarilance_module_init);
+module_exit(atarilance_module_exit);
 #endif /* MODULE */
 
 
