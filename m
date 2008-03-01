Return-Path: <linux-kernel-owner+w=401wt.eu-S1761919AbYCAGZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919AbYCAGZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760965AbYCAGY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:24:57 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:48506 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220AbYCAGYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:24:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=iZHKy86L1n/Mva8D7JvH5YW38q8gW2nguD/hTZYnUCqsS5SqoiOeFa+riFPKkc5ckjMvd133751qDBlaQGpGvUNhzGfqBJCUYvX5/Xj3+6UECNKtJOj6fatHhYKQkLeI8hPVrQZuzoSQgA4mXgLJvMvkQI3IdblGe1Iz7ihVmUo=
Message-ID: <47C8F5BB.3080500@gmail.com>
Date: Sat, 01 Mar 2008 00:20:43 -0600
From: Jon Schindler <jkschind@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/9] /drivers/net/ac3200.c replaced init_module&cleanup_module
 with module_init&module_exit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced init_module and cleanup_module with static functions and module_init/module_exit.

Signed-off-by: Jon Schindler <jkschind@gmail.com>
---
diff --git a/drivers/net/ac3200.c b/drivers/net/ac3200.c
index 5136d94..b144863 100644
--- a/drivers/net/ac3200.c
+++ b/drivers/net/ac3200.c
@@ -369,7 +369,7 @@ MODULE_PARM_DESC(mem, "Memory base address(es)");
 MODULE_DESCRIPTION("Ansel AC3200 EISA ethernet driver");
 MODULE_LICENSE("GPL");
 
-int __init init_module(void)
+static int __init ac3200_module_init(void)
 {
 	struct net_device *dev;
 	int this_dev, found = 0;
@@ -404,8 +404,7 @@ static void cleanup_card(struct net_device *dev)
 	iounmap(ei_status.mem);
 }
 
-void __exit
-cleanup_module(void)
+static void __exit ac3200_module_exit(void)
 {
 	int this_dev;
 
@@ -418,4 +417,6 @@ cleanup_module(void)
 		}
 	}
 }
+module_init(ac3200_module_init);
+module_exit(ac3200_module_exit);
 #endif /* MODULE */
