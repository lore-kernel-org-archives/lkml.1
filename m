Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYHHP72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYHHP72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYHHP7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:59:20 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46165 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYHHP7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:59:20 -0400
Date: Fri, 8 Aug 2008 18:57:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@redhat.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fix watchdog/at91rm9200_wdt.c compilation
Message-ID: <20080808155744.GD14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC      drivers/watchdog/at91rm9200_wdt.o
at91rm9200_wdt.c:188: error: 'at91_wdt_ioctl' undeclared here (not in a 
make[3]: *** [drivers/watchdog/at91rm9200_wdt.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0cbc8aa3114bc48a868de8cc9a1706b6c81dd3f4 
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index 2313f44..09363f1 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -129,7 +129,7 @@ static struct watchdog_info at91_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static long at91_wdt_ioct(struct file *file,
+static long at91_wdt_ioctl(struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;

