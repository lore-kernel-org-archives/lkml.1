Return-Path: <linux-kernel-owner+w=401wt.eu-S1762703AbYCEFvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703AbYCEFvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761241AbYCEFtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:49:45 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:17288 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761134AbYCEFtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=UtvkJXL4A5WzW0Diifq1CNUV4l8Lcl82Xi3TGh5AGeXJIIMwRlEnC/1+nswnQ0pMMWh03AEtFR4ccLOj/nwV4hTBfIzz/BEK0affS51IvN9sJgFPbQdRwKlYcxh4WC7Giyl6uXRqmYzJBlGk8KA4OB+GZFfz09q0SMNsFFYyXMM=
Message-ID: <47CE347B.3070309@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:49:47 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/11] /drivers/net/3c501.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/3c501.c b/drivers/net/3c501.c
index 7d25368..537b4e7 100644
--- a/drivers/net/3c501.c
+++ b/drivers/net/3c501.c
@@ -867,13 +867,14 @@ MODULE_PARM_DESC(irq, "EtherLink IRQ number");
  * here also causes the module to be unloaded
  */
 
-int __init init_module(void)
+static int __init tc501_module_init(void)
 {
 	dev_3c501 = el1_probe(-1);
 	if (IS_ERR(dev_3c501))
 		return PTR_ERR(dev_3c501);
 	return 0;
 }
+module_init(tc501_module_init);
 
 /**
  * cleanup_module:
@@ -882,13 +883,14 @@ int __init init_module(void)
  * and then free up the resources we took when the card was found.
  */
 
-void __exit cleanup_module(void)
+static void __exit tc501_module_exit(void)
 {
 	struct net_device *dev = dev_3c501;
 	unregister_netdev(dev);
 	release_region(dev->base_addr, EL1_IO_EXTENT);
 	free_netdev(dev);
 }
+module_exit(tc501_module_exit);
 
 #endif /* MODULE */
 
