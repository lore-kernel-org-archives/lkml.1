Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbYB1Hdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbYB1Hdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbYB1Hcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:32:45 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:40533 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020AbYB1Hcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:32:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=O6LxaS3zDC/1BNbPDYyegMgdYYFMTHquuNrseSYxUf7IC1W8Cd9GsC2jLgN6aMwrnmlX1g9efVdg+9/Ulevt7QZgRyjvfvz142hPwUbnqBVhlTr+Rmya/9iJYyUG/u0CvhgK9QW1CmVipHEau1xMs6rhIkH11bDtFDMG8XDaQ0s=
Message-ID: <47C66339.9090607@watson.wustl.edu>
Date: Thu, 28 Feb 2008 01:31:05 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/9] /drivers/net/arcnet/capmode.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/arcnet/capmode.c b/drivers/net/arcnet/capmode.c
index cc4610d..02cb8f1 100644
--- a/drivers/net/arcnet/capmode.c
+++ b/drivers/net/arcnet/capmode.c
@@ -80,17 +80,19 @@ void arcnet_cap_init(void)
 
 #ifdef MODULE
 
-int __init init_module(void)
+static int __init capmode_module_init(void)
 {
 	printk(VERSION);
 	arcnet_cap_init();
 	return 0;
 }
 
-void cleanup_module(void)
+static void __exit capmode_module_exit(void)
 {
 	arcnet_unregister_proto(&capmode_proto);
 }
+module_init(capmode_module_init);
+module_exit(capmode_module_exit);
 
 MODULE_LICENSE("GPL");
 #endif				/* MODULE */
