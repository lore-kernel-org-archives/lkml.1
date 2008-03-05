Return-Path: <linux-kernel-owner+w=401wt.eu-S1763092AbYCEFvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763092AbYCEFvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761506AbYCEFt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:49:56 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:16938 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228AbYCEFty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:49:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=xVMRpjDdbr7mSx5CAANQw2nwPUVRFU257JJ66IT6q5g5TjDQ5m+30lf9Kwih++jimz6DMu4Zqr2CUslk7z+wh9G8QPg2LYMhwLNMUOS9S2O7XoVplmolbmnM8UxTLvXcgJ6G6T2/Fb4aEQZP7S4WQGwTiDvoSZs5sQ/Mo/EEu7A=
Message-ID: <47CE3486.7010609@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:49:58 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/11] /drivers/net/3c505.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/3c505.c b/drivers/net/3c505.c
index 9c65734..7eed97f 100644
--- a/drivers/net/3c505.c
+++ b/drivers/net/3c505.c
@@ -1615,7 +1615,7 @@ MODULE_PARM_DESC(io, "EtherLink Plus I/O base address(es)");
 MODULE_PARM_DESC(irq, "EtherLink Plus IRQ number(s) (assigned)");
 MODULE_PARM_DESC(dma, "EtherLink Plus DMA channel(s)");
 
-int __init init_module(void)
+static int __init tc505_module_init(void)
 {
 	int this_dev, found = 0;
 
@@ -1651,8 +1651,9 @@ int __init init_module(void)
 		return -ENODEV;
 	return 0;
 }
+module_init(tc505_module_init);
 
-void __exit cleanup_module(void)
+static void __exit tc505_module_exit(void)
 {
 	int this_dev;
 
@@ -1665,6 +1666,7 @@ void __exit cleanup_module(void)
 		}
 	}
 }
+module_exit(tc505_module_exit);
 
 #endif				/* MODULE */
 MODULE_LICENSE("GPL");
