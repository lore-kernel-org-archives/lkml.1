Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYB1HeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYB1HeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbYB1Hct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:32:49 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:40533 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188AbYB1Hcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=sPtMLA2lbQ6ebF219afx4roEp71VOdEGMAjdoicPrlW38J9HNBYAyvqjnRgiRZI1CCSBrPaheXCSJBrdnu819UgBpYpV6kQH63NgRRdS+lhRKGxYihke0bKxsS4ozCcljaYVyP8JiujeScq6Jnc0QWwXwiBaf9p9TYR5VV6LCO8=
Message-ID: <47C66340.6030704@watson.wustl.edu>
Date: Thu, 28 Feb 2008 01:31:12 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 8/9] /drivers/net/at1700.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/at1700.c b/drivers/net/at1700.c
index 24d81f9..7e874d4 100644
--- a/drivers/net/at1700.c
+++ b/drivers/net/at1700.c
@@ -881,7 +881,7 @@ MODULE_PARM_DESC(io, "AT1700/FMV18X I/O base address");
 MODULE_PARM_DESC(irq, "AT1700/FMV18X IRQ number");
 MODULE_PARM_DESC(net_debug, "AT1700/FMV18X debug level (0-6)");
 
-int __init init_module(void)
+static int __init at1700_module_init(void)
 {
 	if (io == 0)
 		printk("at1700: You should not use auto-probing with insmod!\n");
@@ -891,13 +891,14 @@ int __init init_module(void)
 	return 0;
 }
 
-void __exit
-cleanup_module(void)
+static void __exit at1700_module_exit(void)
 {
 	unregister_netdev(dev_at1700);
 	cleanup_card(dev_at1700);
 	free_netdev(dev_at1700);
 }
+module_init(at1700_module_init);
+module_exit(at1700_module_exit);
 #endif /* MODULE */
 MODULE_LICENSE("GPL");
 
