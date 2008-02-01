Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYBAT2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYBAT2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbYBAT2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:28:32 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38813 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318AbYBAT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:28:31 -0500
Date: Fri, 01 Feb 2008 11:35:35 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] make loglevel related commandline to early_param v2
In-reply-to: <p73bq704zqs.fsf@bingen.suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-id: <200802011135.36475.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802010240.37799.yinghai.lu@sun.com>
 <p73bq704zqs.fsf@bingen.suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] make loglevel related commandline to early_param v2

so we can use them for early console like 
console=uart8250,io,0x3f8,115200n8
earlycon=uart8250,io,0x3f8,115200n8
early_printk

otherwise printk(KERN_DEBUG "debug msg") will not print out to console even
"debug" command line is used.

andi point out early_param need to return 0 instead 1.

Ingo had another patch in x86.git to process ignore_loglevel

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/init/main.c b/init/main.c
index cb81ed1..3741bda 100644
--- a/init/main.c
+++ b/init/main.c
@@ -232,30 +232,26 @@ EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 10;
-	return 1;
+	return 0;
 }
 
 static int __init quiet_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 4;
-	return 1;
+	return 0;
 }
 
-__setup("debug", debug_kernel);
-__setup("quiet", quiet_kernel);
+early_param("debug", debug_kernel);
+early_param("quiet", quiet_kernel);
 
 static int __init loglevel(char *str)
 {
 	get_option(&str, &console_loglevel);
-	return 1;
+	return 0;
 }
 
-__setup("loglevel=", loglevel);
+early_param("loglevel", loglevel);
 
 /*
  * Unknown boot options get handed to init, unless they look like
