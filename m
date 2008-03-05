Return-Path: <linux-kernel-owner+w=401wt.eu-S1762247AbYCEFuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762247AbYCEFuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760776AbYCEFtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:49:33 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:17288 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760706AbYCEFtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:49:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=fzsKIbAbzBxhzoSOA55ZQDZgQ/FzfDhtMfkgypvlQZndN+VwIosPBi7ZUBhx4QRK+hYbbSqOLr+5hdahHEveSWPjWsCBJaLXcKwZq2MQpC5Orak1NW4dZCCgahTY7wx1PCbkOVxxQuEB/2hJYnm0AnKmYeHm3zbGoqTqJENtfxY=
Message-ID: <47CE3470.90400@watson.wustl.edu>
Date: Tue, 04 Mar 2008 23:49:36 -0600
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/11] /drivers/ide/ide.c replaced init_module&cleanup_module
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
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 477833f..cff8da2 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1641,7 +1641,7 @@ static char *options = NULL;
 module_param(options, charp, 0);
 MODULE_LICENSE("GPL");
 
-static void __init parse_options (char *line)
+static void __init parse_options(char *line)
 {
 	char *next = line;
 
@@ -1655,13 +1655,14 @@ static void __init parse_options (char *line)
 	}
 }
 
-int __init init_module (void)
+static int __init ide_module_init(void)
 {
 	parse_options(options);
 	return ide_init();
 }
+module_init(ide_module_init);
 
-void __exit cleanup_module (void)
+static void __exit ide_module_exit(void)
 {
 	int index;
 
@@ -1672,6 +1673,7 @@ void __exit cleanup_module (void)
 
 	bus_unregister(&ide_bus_type);
 }
+module_exit(ide_module_exit);
 
 #else /* !MODULE */
 
