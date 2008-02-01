Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYBAKdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYBAKdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbYBAKdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:33:35 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55026 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbYBAKde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:33:34 -0500
Date: Fri, 01 Feb 2008 02:40:37 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] make loglevel related commandline to early_param
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <200802010240.37799.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] make loglevel related command_line to early_param

so we can use them for early console like console=uart8250 or earlycon=uart8250 or early_printk

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/init/main.c b/init/main.c
index cb81ed1..a774a93 100644
--- a/init/main.c
+++ b/init/main.c
@@ -232,22 +232,18 @@ EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 10;
 	return 1;
 }
 
 static int __init quiet_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 4;
 	return 1;
 }
 
-__setup("debug", debug_kernel);
-__setup("quiet", quiet_kernel);
+early_param("debug", debug_kernel);
+early_param("quiet", quiet_kernel);
 
 static int __init loglevel(char *str)
 {
@@ -255,7 +251,7 @@ static int __init loglevel(char *str)
 	return 1;
 }
 
-__setup("loglevel=", loglevel);
+early_param("loglevel", loglevel);
 
 /*
  * Unknown boot options get handed to init, unless they look like
diff --git a/kernel/printk.c b/kernel/printk.c
index 58bbec6..8c25e37 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -458,7 +458,7 @@ static int __init ignore_loglevel_setup(char *str)
 	return 1;
 }
 
-__setup("ignore_loglevel", ignore_loglevel_setup);
+early_param("ignore_loglevel", ignore_loglevel_setup);
 
 /*
  * Write out chars from start to end - 1 inclusive
