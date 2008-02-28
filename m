Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYB1Hdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYB1Hdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbYB1Hcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:32:47 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:43047 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089AbYB1Hcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:32:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=kZAWWDstkpZLXWKVBEMtKUL6Zto/MNnnMRLjkuZVh4h6QKQ6sfdRpzEJEEjkbDSZwCICHxtso9bOL8AKC/4dQ1U4r1F/JL2StZus96uJvykRH+uw6xw6dvEPS4z1GUiyKlcplu4s14QiGUWHBVr2XwH0IMaOjUy9C8ALvj1Lreg=
Message-ID: <47C6633C.4000505@watson.wustl.edu>
Date: Thu, 28 Feb 2008 01:31:08 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/9] /drivers/net/arcnet/com20020.c replaced init_module&cleanup_module
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
diff --git a/drivers/net/arcnet/com20020.c b/drivers/net/arcnet/com20020.c
index 7cf0a25..8b51313 100644
--- a/drivers/net/arcnet/com20020.c
+++ b/drivers/net/arcnet/com20020.c
@@ -348,14 +348,15 @@ MODULE_LICENSE("GPL");
 
 #ifdef MODULE
 
-int init_module(void)
+static int __init com20020_module_init(void)
 {
 	BUGLVL(D_NORMAL) printk(VERSION);
 	return 0;
 }
 
-void cleanup_module(void)
+static void __exit com20020_module_exit(void)
 {
 }
-
+module_init(com20020_module_init);
+module_exit(com20020_module_exit);
 #endif				/* MODULE */
