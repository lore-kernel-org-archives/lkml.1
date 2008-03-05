Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbYCEFuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbYCEFuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbYCEFtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:49:24 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:17288 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725AbYCEFtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:49:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=Es82fyHJYZRruhygdZ5SKwCKko5RJ0SqJ52Ji6RxTKLdVSqv8gQme52hXdnBjVUZSaknMRjtX4PUtaxvd7RJm1OWvjtHdhA3bRvy1mCl/HHRJkQedhTWogtSjclkYmbsKVrMuZxpnfN1u356W+XksU/YY0G2sy90KCNg0oihKYk=
Message-ID: <47CE3466.5050306@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:49:26 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/11] /drivers/char/ip2/ip2main.c replaced init_module&cleanup_module
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
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index b1d6cad..048e7c8 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -354,14 +354,15 @@ have_requested_irq( char irq )
 /* the driver initialisation function and returns what it returns.            */
 /******************************************************************************/
 #ifdef MODULE
-int
-init_module(void)
+static int __init
+ip2_init_module(void)
 {
 #ifdef IP2DEBUG_INIT
 	printk (KERN_DEBUG "Loading module ...\n" );
 #endif
     return 0;
 }
+module_init(ip2_init_module);
 #endif /* MODULE */
 
 /******************************************************************************/
@@ -380,8 +381,8 @@ init_module(void)
 /* driver should be returned since it may be unloaded from memory.            */
 /******************************************************************************/
 #ifdef MODULE
-void
-cleanup_module(void)
+void __exit
+ip2_cleanup_module(void)
 {
 	int err;
 	int i;
@@ -451,6 +452,7 @@ cleanup_module(void)
 	printk (KERN_DEBUG "IP2 Unloaded\n" );
 #endif
 }
+module_exit(ip2_cleanup_module);
 #endif /* MODULE */
 
 static const struct tty_operations ip2_ops = {
