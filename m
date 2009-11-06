Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZKFI1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZKFI1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZKFI1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:27:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44785
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750AbZKFI1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:27:05 -0500
Date: Fri, 06 Nov 2009 00:27:31 -0800 (PST)
Message-Id: <20091106.002731.247254978.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristoffer@gaisler.com
Subject: Re: linux-next: sparc tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091106.002651.21006753.davem@davemloft.net>
References: <20091106180248.7a6aa9ba.sfr@canb.auug.org.au>
	<20091106.001930.121210402.davem@davemloft.net>
	<20091106.002651.21006753.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 06 Nov 2009 00:26:51 -0800 (PST)

> apbuart: Fix build and missing driver unregister.
> 
> linux/of_platform.h needs to be included
> 
> OF driver needs to be unregistered
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Sorry left out the patch :-)

Here it is:

diff --git a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
index 5f9dec3..a1e9503 100644
--- a/drivers/serial/apbuart.c
+++ b/drivers/serial/apbuart.c
@@ -25,6 +25,7 @@
 #include <linux/device.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/serial_core.h>
@@ -676,8 +677,7 @@ static int __init grlib_apbuart_init(void)
 		return ret;
 	}
 
-	ret = of_register_driver(&grlib_apbuart_of_driver, &of_platform_bus_type);
-
+	ret = of_register_platform_driver(&grlib_apbuart_of_driver);
 	if (ret) {
 		printk(KERN_ERR
 		       "%s: of_register_platform_driver failed (%i)\n",
@@ -698,7 +698,7 @@ static void __exit grlib_apbuart_exit(void)
 				     &grlib_apbuart_ports[i]);
 
 	uart_unregister_driver(&grlib_apbuart_driver);
-
+	of_unregister_platform_driver(&grlib_apbuart_of_driver);
 }
 
 module_init(grlib_apbuart_init);
-- 
1.6.5.2

