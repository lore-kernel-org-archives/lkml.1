Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYHHQFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYHHQFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYHHQFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:05:21 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34632 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbYHHQFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:05:21 -0400
Date: Fri, 8 Aug 2008 19:03:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@redhat.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fix watchdog/wdt285.c compilation
Message-ID: <20080808160346.GE14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit d0e58eed05f9baf77c4f75e794ae245f6dae240a
([WATCHDOG 55/57] wdt285: switch to unlocked_ioctl and tidy up ...):

<--  snip  -->

...
  CC [M]  drivers/watchdog/wdt285.o
wdt285.c: In function 'footbridge_watchdog_init':
wdt285.c:211: error: 'KERN_WARN' undeclared (first use in this function)
wdt285.c:211: error: (Each undeclared identifier is reported only once
wdt285.c:211: error: for each function it appears in.)
wdt285.c:212: error: expected ')' before string constant
make[3]: *** [drivers/watchdog/wdt285.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9b218bec5065288e8ffe5479e534d3c0da52c3d0 
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index fea398a..06a743e 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -208,7 +208,7 @@ static int __init footbridge_watchdog_init(void)
 								soft_margin);
 
 	if (machine_is_cats())
-		printk(KERN_WARN
+		printk(KERN_WARNING
 		  "Warning: Watchdog reset may not work on this machine.\n");
 	return 0;
 }

