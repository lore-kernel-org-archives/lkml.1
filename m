Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYHJLFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYHJLFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 07:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYHJLFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 07:05:22 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40649 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYHJLFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 07:05:21 -0400
Date: Sun, 10 Aug 2008 14:03:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@redhat.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fix watchdog/ixp4xx_wdt.c compilation
Message-ID: <20080810110341.GC16146@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 20d35f3e50ea7e573f9568b9fce4e98523aaee5d
([WATCHDOG 22/57] ixp4xx_wdt: unlocked_ioctl):

<--  snip  -->

...
  CC      drivers/watchdog/ixp4xx_wdt.o
ixp4xx_wdt.c:32: error: expected '=', ',', ';', 'asm' or '__attribute__' 
ixp4xx_wdt.c: In function 'wdt_enable':
ixp4xx_wdt.c:41: error: 'wdt_lock' undeclared (first use in this 
ixp4xx_wdt.c:41: error: (Each undeclared identifier is reported only 
ixp4xx_wdt.c:41: error: for each function it appears in.)
ixp4xx_wdt.c: In function 'wdt_disable':
ixp4xx_wdt.c:52: error: 'wdt_lock' undeclared (first use in this 
ixp4xx_wdt.c: In function 'ixp4xx_wdt_init':
ixp4xx_wdt.c:186: error: 'wdt_lock' undeclared (first use in this 
make[3]: *** [drivers/watchdog/ixp4xx_wdt.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9ff35bbffb5fb755104fc90825523b9ffa2b14cf 
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 41264a5..8302ef0 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -29,7 +29,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
 static unsigned long boot_status;
-static spin_lock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 #define WDT_TICK_RATE (IXP4XX_PERIPHERAL_BUS_CLOCK * 1000000UL)
 
