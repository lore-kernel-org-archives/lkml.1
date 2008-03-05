Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbYCEFwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbYCEFwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761310AbYCEFuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:50:14 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:16938 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbYCEFuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:50:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=Rzq4Q06xDpxFwzu/w8DYstswOqDV1JMbXOx/uOSEaRzx2ExN8z++wCe3VvNefj4gx/JiOxDby+fqQc2SX5/wex6J/roOYl196+dTtS0cvPmVJ8/6i1jfsUx2ixsGsYzurw4rY0Ly5Fih0ROacbMxo6xUTbtUbZUBkXUxzICCH8I=
Message-ID: <47CE3497.4000403@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:50:15 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7/11] /drivers/net/3c507.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/3c507.c b/drivers/net/3c507.c
index 030c147..07b6d7d 100644
--- a/drivers/net/3c507.c
+++ b/drivers/net/3c507.c
@@ -918,16 +918,16 @@ module_param(irq, int, 0);
 MODULE_PARM_DESC(io, "EtherLink16 I/O base address");
 MODULE_PARM_DESC(irq, "(ignored)");
 
-int __init init_module(void)
+static int __init tc507_module_init(void)
 {
 	if (io == 0)
 		printk("3c507: You should not use auto-probing with insmod!\n");
 	dev_3c507 = el16_probe(-1);
 	return IS_ERR(dev_3c507) ? PTR_ERR(dev_3c507) : 0;
 }
+module_init(tc507_module_init);
 
-void __exit
-cleanup_module(void)
+static void __exit tc507_module_exit(void)
 {
 	struct net_device *dev = dev_3c507;
 	unregister_netdev(dev);
@@ -936,6 +936,8 @@ cleanup_module(void)
 	release_region(dev->base_addr, EL16_IO_EXTENT);
 	free_netdev(dev);
 }
+module_exit(tc507_module_exit);
+
 #endif /* MODULE */
 MODULE_LICENSE("GPL");
 
