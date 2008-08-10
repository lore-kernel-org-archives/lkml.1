Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYHJUpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYHJUpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 16:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYHJUph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 16:45:37 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:59633 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbYHJUpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 16:45:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAG7wnkhQyN7q/2dsb2JhbACBX6c4
Date: Sun, 10 Aug 2008 22:45:27 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, Adrian Bunk <bunk@kernel.org>
Subject: [WATCHDOG] v2.6.27-rc watchdog fixes
Message-ID: <20080810204527.GF2773@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 MAINTAINERS                       |    6 ------
 drivers/watchdog/Makefile         |    5 ++++-
 drivers/watchdog/at91rm9200_wdt.c |    2 +-
 drivers/watchdog/ixp4xx_wdt.c     |    2 +-
 drivers/watchdog/shwdt.c          |   24 ++++++++++++------------
 drivers/watchdog/txx9wdt.c        |    2 +-
 drivers/watchdog/wdt285.c         |    2 +-
 7 files changed, 20 insertions(+), 23 deletions(-)

with these Changes:

Author: Adrian Bunk <bunk@kernel.org>
Date:   Sun Aug 10 14:03:41 2008 +0300

    [WATCHDOG] fix watchdog/ixp4xx_wdt.c compilation
    
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
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Adrian Bunk <bunk@kernel.org>
Date:   Fri Aug 8 19:03:46 2008 +0300

    [WATCHDOG] fix watchdog/wdt285.c compilation
    
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
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Adrian Bunk <bunk@kernel.org>
Date:   Fri Aug 8 18:57:45 2008 +0300

    [WATCHDOG] fix watchdog/at91rm9200_wdt.c compilation
    
    This patch fixes the following compile error:
    
    <--  snip  -->
    
    ...
      CC      drivers/watchdog/at91rm9200_wdt.o
    at91rm9200_wdt.c:188: error: 'at91_wdt_ioctl' undeclared here (not in a
    make[3]: *** [drivers/watchdog/at91rm9200_wdt.o] Error 1
    
    <--  snip  -->
    
    Reported-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Adrian Bunk <bunk@kernel.org>
Date:   Fri Aug 8 18:39:11 2008 +0300

    [WATCHDOG] fix watchdog/shwdt.c compilation
    
    This patch fixes the following compile errors caused by
    commit 70b814ec1a484279a51bf9f7193551b996627247
    ([WATCHDOG 45/57] shwdt: coding style, cleanup, switch to unlocked_io):
    
    <--  snip  -->
    
    ...
      CC      drivers/watchdog/shwdt.o
    shwdt.c:64: error: 'WTCSR_CKS_4096' undeclared here (not in a function)
    shwdt.c: In function 'sh_wdt_start':
    shwdt.c:92: error: 'wdt_lock' undeclared (first use in this function)
    shwdt.c:92: error: (Each undeclared identifier is reported only once
    shwdt.c:92: error: for each function it appears in.)
    shwdt.c:97: error: implicit declaration of function 'sh_wdt_read_csr'
    shwdt.c:98: error: 'WTCSR_WT' undeclared (first use in this function)
    shwdt.c:99: error: implicit declaration of function 'sh_wdt_write_csr'
    shwdt.c:101: error: implicit declaration of function 'sh_wdt_write_cnt'
    shwdt.c:112: error: 'WTCSR_TME' undeclared (first use in this function)
    shwdt.c:113: error: 'WTCSR_RSTS' undeclared (first use in this function)
    shwdt.c: In function 'sh_wdt_stop':
    shwdt.c:142: error: 'wdt_lock' undeclared (first use in this function)
    shwdt.c:147: error: 'WTCSR_TME' undeclared (first use in this function)
    shwdt.c: In function 'sh_wdt_keepalive':
    shwdt.c:160: error: 'wdt_lock' undeclared (first use in this function)
    shwdt.c: In function 'sh_wdt_set_heartbeat':
    shwdt.c:176: error: 'wdt_lock' undeclared (first use in this function)
    shwdt.c: In function 'sh_wdt_ping':
    shwdt.c:192: error: 'wdt_lock' undeclared (first use in this function)
    shwdt.c:197: error: 'WTCSR_IOVF' undeclared (first use in this function)
    shwdt.c: At top level:
    shwdt.c:417: error: conflicting type qualifiers for 'sh_wdt_info'
    shwdt.c:71: error: previous declaration of 'sh_wdt_info' was here
    make[3]: *** [drivers/watchdog/shwdt.o] Error 1
    
    <--  snip  -->
    
    Reported-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Adrian Bunk <bunk@kernel.org>
Date:   Fri Aug 8 18:18:46 2008 +0300

    [WATCHDOG] fix watchdog/txx9wdt.c compilation
    
    This patch fixes the following compile error caused by
    commit 8dc244f7deac4c0e95ce0ffd26f494bb6e1534c0
    ([WATCHDOG 48/57] txx9: Fix locking, switch to unlocked_ioctl):
    
    <--  snip  -->
    
    ...
      CC      drivers/watchdog/txx9wdt.o
    txx9wdt.c:48: warning: type defaults to 'int' in declaration of
    txx9wdt.c:48: warning: parameter names (without types) in function
    txx9wdt.c: In function 'txx9wdt_ping':
    txx9wdt.c:52: error: 'txx9_lock' undeclared (first use in this function)
    txx9wdt.c:52: error: (Each undeclared identifier is reported only once
    txx9wdt.c:52: error: for each function it appears in.)
    txx9wdt.c: In function 'txx9wdt_start':
    txx9wdt.c:59: error: 'txx9_lock' undeclared (first use in this function)
    txx9wdt.c: In function 'txx9wdt_stop':
    txx9wdt.c:71: error: 'txx9_lock' undeclared (first use in this function)
    make[3]: *** [drivers/watchdog/txx9wdt.o] Error 1
    
    <--  snip  -->
    
    Reported-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Adrian Bunk <bunk@kernel.org>
Date:   Thu Aug 7 00:10:52 2008 +0300

    [WATCHDOG] MAINTAINERS: remove ZF MACHZ WATCHDOG entry
    
    - maintainer has not been active for years
    - maintainer email bounces
    - URL no longer exists
    - covered by the WATCHDOG DEVICE DRIVERS entry
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jean Delvare <khali@linux-fr.org>
Date:   Fri Aug 8 10:29:21 2008 +0200

    [WATCHDOG] Fix build with CONFIG_ITCO_VENDOR_SUPPORT=n
    
    The problem is that iTCO_vendor_support.ko is still being built while
    iTCO_vendor.h claims that its functions do not exist. The following
    Makefile update fixes that. It causes iTCO_vendor_support.ko to no
    longer be built if CONFIG_ITCO_VENDOR_SUPPORT=n.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/MAINTAINERS b/MAINTAINERS
index 41d7a1e..b343814 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4683,12 +4683,6 @@ L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
-ZF MACHZ WATCHDOG
-P:	Fernando Fuganti
-M:	fuganti@netbank.com.br
-W:	http://cvs.conectiva.com.br/drivers/ZFL-watchdog/
-S:	Maintained
-
 ZR36067 VIDEO FOR LINUX DRIVER
 P:	Ronald Bultje
 M:	rbultje@ronald.bitfreak.net
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 049c918..ca3dc04 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -66,7 +66,10 @@ obj-$(CONFIG_IB700_WDT) += ib700wdt.o
 obj-$(CONFIG_IBMASR) += ibmasr.o
 obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
-obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
+obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o
+ifeq ($(CONFIG_ITCO_VENDOR_SUPPORT),y)
+obj-$(CONFIG_ITCO_WDT) += iTCO_vendor_support.o
+endif
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
 obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index bacd867..d061f0a 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -128,7 +128,7 @@ static struct watchdog_info at91_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static long at91_wdt_ioct(struct file *file,
+static long at91_wdt_ioctl(struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
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
 
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 824125a..cdc7138 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -30,7 +30,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <linux/watchdog.h>
+#include <asm/watchdog.h>
 
 #define PFX "shwdt: "
 
@@ -68,7 +68,7 @@ static int clock_division_ratio = WTCSR_CKS_4096;
 static void sh_wdt_ping(unsigned long data);
 
 static unsigned long shwdt_is_open;
-static struct watchdog_info sh_wdt_info;
+static const struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
 static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
@@ -89,7 +89,7 @@ static void sh_wdt_start(void)
 	__u8 csr;
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 
 	next_heartbeat = jiffies + (heartbeat * HZ);
 	mod_timer(&timer, next_ping_period(clock_division_ratio));
@@ -127,7 +127,7 @@ static void sh_wdt_start(void)
 	csr &= ~RSTCSR_RSTS;
 	sh_wdt_write_rstcsr(csr);
 #endif
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -139,14 +139,14 @@ static void sh_wdt_stop(void)
 	__u8 csr;
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 
 	del_timer(&timer);
 
 	csr = sh_wdt_read_csr();
 	csr &= ~WTCSR_TME;
 	sh_wdt_write_csr(csr);
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -157,9 +157,9 @@ static inline void sh_wdt_keepalive(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	next_heartbeat = jiffies + (heartbeat * HZ);
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -173,9 +173,9 @@ static int sh_wdt_set_heartbeat(int t)
 	if (unlikely(t < 1 || t > 3600)) /* arbitrary upper limit */
 		return -EINVAL;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	heartbeat = t;
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 	return 0;
 }
 
@@ -189,7 +189,7 @@ static void sh_wdt_ping(unsigned long data)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	if (time_before(jiffies, next_heartbeat)) {
 		__u8 csr;
 
@@ -203,7 +203,7 @@ static void sh_wdt_ping(unsigned long data)
 	} else
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping "
 		       "the watchdog\n");
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index dbbc018..6adab77 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -45,7 +45,7 @@ static unsigned long txx9wdt_alive;
 static int expect_close;
 static struct txx9_tmr_reg __iomem *txx9wdt_reg;
 static struct clk *txx9_imclk;
-static DECLARE_LOCK(txx9_lock);
+static DEFINE_SPINLOCK(txx9_lock);
 
 static void txx9wdt_ping(void)
 {
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
