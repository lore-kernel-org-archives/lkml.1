Return-Path: <linux-kernel-owner+w=401wt.eu-S1764363AbYCEFy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764363AbYCEFy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761512AbYCEFvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:51:00 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:16938 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762297AbYCEFu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=PaIFaV834mJSSN80orW0TwKuXHwphJHfS0YhBSFohLx1yyqeqWju+KGeEgdulLHm4FHq9u479oypOoiUp90/PsB4Fr8kkm2gPWdaoyHNTkBM9ND0ovpxIsY0dMDpvXqhMLqyEtBgqkutsaQ8sHVHdZ0izkcX3zA6tbqot8beKFQ=
Message-ID: <47CE34C5.6010805@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:51:01 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/11] /drivers/net/82596.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/82596.c b/drivers/net/82596.c
index 2797da7..344308a 100644
--- a/drivers/net/82596.c
+++ b/drivers/net/82596.c
@@ -1567,7 +1567,7 @@ static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "i82596 debug mask");
 
-int __init init_module(void)
+static int __init i82596_module_init(void)
 {
 	if (debug >= 0)
 		i596_debug = debug;
@@ -1576,8 +1576,9 @@ int __init init_module(void)
 		return PTR_ERR(dev_82596);
 	return 0;
 }
+module_init(i82596_module_init);
 
-void __exit cleanup_module(void)
+static void __exit i82596_module_exit(void)
 {
 	unregister_netdev(dev_82596);
 #ifdef __mc68000__
@@ -1595,7 +1596,7 @@ void __exit cleanup_module(void)
 #endif
 	free_netdev(dev_82596);
 }
-
+module_exit(i82596_module_exit);
 #endif				/* MODULE */
 
 /*
