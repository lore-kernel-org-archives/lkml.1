Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbYCEFwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbYCEFwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761753AbYCEFuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:50:25 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:16938 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761707AbYCEFuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:50:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=TcKHkVu7fG/vWeOphgDsJupTxt4YVKaMWP2Hr1JHG1v78k5FhgN6MFmD2OffrLLXMy8/MCd2YkM6wXyv+d6EjZY6PgxFvk23YttBzE7ZRWn7+aLAzNx9djATG6XFpFk8yknIcOEzFQO80y4UcX05PlDdSBGzwR6E7k8Vw80ysKQ=
Message-ID: <47CE34A2.40402@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:50:26 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 8/11] /drivers/net/3c515.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/3c515.c b/drivers/net/3c515.c
index 6ab84b6..107d1ff 100644
--- a/drivers/net/3c515.c
+++ b/drivers/net/3c515.c
@@ -415,7 +415,7 @@ MODULE_PARM_DESC(max_interrupt_work, "3c515 maximum events handled per interrupt
 /* we will need locking (and refcounting) if we ever use it for more */
 static LIST_HEAD(root_corkscrew_dev);
 
-int init_module(void)
+static int __init tc515_module_init(void)
 {
 	int found = 0;
 	if (debug >= 0)
@@ -426,6 +426,7 @@ int init_module(void)
 		found++;
 	return found ? 0 : -ENODEV;
 }
+module_init(tc515_module_init);
 
 #else
 struct net_device *tc515_probe(int unit)
@@ -1565,7 +1566,7 @@ static const struct ethtool_ops netdev_ethtool_ops = {
 
 
 #ifdef MODULE
-void cleanup_module(void)
+static void __exit tc515_module_exit(void)
 {
 	while (!list_empty(&root_corkscrew_dev)) {
 		struct net_device *dev;
@@ -1579,6 +1580,8 @@ void cleanup_module(void)
 		free_netdev(dev);
 	}
 }
+module_exit(tc515_module_exit);
+
 #endif				/* MODULE */
 
 /*
