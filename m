Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYB1HdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYB1HdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYB1Hch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:32:37 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:40533 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbYB1Hcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:32:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=o9Sj1dthP80cakwMgKtnPPJQygRqgz2D2fjrwiSvbYQvmUs3HwmZrD7fO8TS1nf6nvYgtMhciLXaHZndjrXnnnV1d/P43jJeSJDWyy5ZU7e8vjcPzIHI9zMU6Tx2at2Z6Vk1ca7z9Uqshupt03UpaHf4vVIXWRtEiGqMlBznlOk=
Message-ID: <47C66334.7080003@watson.wustl.edu>
Date: Thu, 28 Feb 2008 01:31:00 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/9] /drivers/net/appletalk/ltpc.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index 6ab2c2d..fef5560 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -1252,7 +1252,7 @@ module_param(irq, int, 0);
 module_param(dma, int, 0);
 
 
-int __init init_module(void)
+static int __init ltpc_module_init(void)
 {
         if(io == 0)
 		printk(KERN_NOTICE
@@ -1263,6 +1263,7 @@ int __init init_module(void)
 		return PTR_ERR(dev_ltpc);
 	return 0;
 }
+module_init(ltpc_module_init);
 #endif
 
 static void __exit ltpc_cleanup(void)
