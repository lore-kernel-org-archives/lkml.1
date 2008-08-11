Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYHKSl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYHKSl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYHKSlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:41:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36882 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYHKSlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:41:17 -0400
Date: Mon, 11 Aug 2008 19:40:49 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [WATCHDOG] v2.6.27-rc watchdog fixes
Message-ID: <20080811184049.GB21967@flint.arm.linux.org.uk>
References: <20080810204527.GF2773@infomag.infomag.iguana.be> <20080810213520.GA2847@flint.arm.linux.org.uk> <20080811183604.GA26249@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811183604.GA26249@infomag.infomag.iguana.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 08:36:04PM +0200, Wim Van Sebroeck wrote:
> Hi Russell,
> 
> > Note that s3c2410_wdt still gives an additional warning that I've
> > fixed in my set of ARM watchdog fixes.
> 
> Where can I find your patch-set?

It's in part of my general ARM updates, and I combined Adrian's three
patches together, along with the remaining bits from my s3c2410 patch.
Here's the mbox mail corresponding with the commit:

>From rmk Sun Aug 10 23:28:46 2008
References: <git-1218407325-9dd428680573d7867ee5e40fa3f059a98301d416@dyn-67.arm.linux.org.uk>
Message-ID: <git-1218407325-af6c0f4a48e42e6c1837a317e20cd715036afd03@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Sun, 10 Aug 2008 23:28:46 +0100
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: [PATCH] [ARM] Fix a pile of broken watchdog drivers

From: Adrian Bunk <bunk@kernel.org>

These patches from Adrian fix:
- ixp4xx_wdt: 20d35f3e50ea7e573f9568b9fce4e98523aaee5d
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

- at91rm9200_wdt: 2760600da2a13d5a2a335ba012d0f3ad5df4c098
  CC      drivers/watchdog/at91rm9200_wdt.o
at91rm9200_wdt.c:188: error: 'at91_wdt_ioctl' undeclared here (not in a
make[3]: *** [drivers/watchdog/at91rm9200_wdt.o] Error 1

- wdt285: d0e58eed05f9baf77c4f75e794ae245f6dae240a
  CC [M]  drivers/watchdog/wdt285.o
wdt285.c: In function 'footbridge_watchdog_init':
wdt285.c:211: error: 'KERN_WARN' undeclared (first use in this function)
wdt285.c:211: error: (Each undeclared identifier is reported only once
wdt285.c:211: error: for each function it appears in.)
wdt285.c:212: error: expected ')' before string constant
make[3]: *** [drivers/watchdog/wdt285.o] Error 1

And this patch from rmk:
- s3c2410_wdt: 41dc8b72e37c514f7332cbc3f3dd864910c2a1fa
  CC      drivers/watchdog/s3c2410_wdt.o
s3c2410_wdt.c: In function `s3c2410wdt_start':
s3c2410_wdt.c:161: warning: `return' with a value, in function returning void

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/watchdog/at91rm9200_wdt.c |    4 ++--
 drivers/watchdog/ixp4xx_wdt.c     |    2 +-
 drivers/watchdog/s3c2410_wdt.c    |    2 --
 drivers/watchdog/wdt285.c         |    2 +-
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index bacd867..ba01dac 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -128,8 +128,8 @@ static struct watchdog_info at91_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static long at91_wdt_ioct(struct file *file,
-					unsigned int cmd, unsigned long arg)
+static long at91_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
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
 
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 3da2b90..22715e3 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -157,8 +157,6 @@ static void s3c2410wdt_start(void)
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 	spin_unlock(&wdt_lock);
-
-	return 0;
 }
 
 static int s3c2410wdt_set_heartbeat(int timeout)
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index c8d7f1b..db362c3 100644
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



-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
