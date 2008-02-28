Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbYB1Hb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbYB1Hb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYB1Hbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:31:51 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:40533 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYB1Hbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:31:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=hwvbAHTL0dV1adW9XeoCm69nh+rEMwzS9MPXvstD2CY426Egf4daCKh/XAmrAzv2jr0b10yT9X36OP4NhGyj3SqqqsoaIih6JsjvEOYBRviKMSfnKO38GWxZPNlZndqiNmQdMy+5TVR1wOCu6w/0Vrvzf4ei89qynONcKluLymA=
Message-ID: <47C66306.7020006@watson.wustl.edu>
Date: Thu, 28 Feb 2008 01:30:14 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/9] /drivers/net/8390.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/8390.c b/drivers/net/8390.c
index a828076..0ed41a3 100644
--- a/drivers/net/8390.c
+++ b/drivers/net/8390.c
@@ -48,14 +48,16 @@ EXPORT_SYMBOL(__alloc_ei_netdev);
 
 #if defined(MODULE)
 
-int init_module(void)
+static int __init ns8390_module_init(void)
 {
 	return 0;
 }
 
-void cleanup_module(void)
+static void __exit ns8390_module_exit(void)
 {
 }
 
+module_init(ns8390_init_module);
+module_exit(ns8390_module_exit);
 #endif /* MODULE */
 MODULE_LICENSE("GPL");
