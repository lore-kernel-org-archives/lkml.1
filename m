Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbYCAGYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbYCAGYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYCAGYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:24:42 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:27069 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbYCAGYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:24:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=iwwkU/8D2vF9LO7LSkGPWjII9MYiaRXYuXZwnKV7zcK7V7Mb8jNxtwUShl9xeP9DpS7Vp1lJYFTrif0JaB4K7xcwZ6zIdRNm8HoNp5WE8hESFlen8JoCx9g+NklavyBM+tt699CFLgnBsqBucI+NGDjUD0VQF9ZzvuMGnWk4lZo=
Message-ID: <47C8F5A6.6010701@gmail.com>
Date: Sat, 01 Mar 2008 00:20:22 -0600
From: Jon Schindler <jkschind@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/9] /drivers/net/8390.c replaced init_module&cleanup_module
 with module_init&module_exit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
 
+module_init(ns8390_module_init);
+module_exit(ns8390_module_exit);
 #endif /* MODULE */
 MODULE_LICENSE("GPL");
