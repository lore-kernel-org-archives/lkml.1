Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015Ab0ASBpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0ASBpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257Ab0ASBpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:45:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1274 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab0ASBpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:45:39 -0500
Subject: [PATCH] watchdogs: constify struct watchdog_info
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 17:45:37 -0800
Message-ID: <1263865537.18117.23.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/watchdog/acquirewdt.c     |    2 +-
 drivers/watchdog/advantechwdt.c   |    2 +-
 drivers/watchdog/adx_wdt.c        |    2 +-
 drivers/watchdog/alim1535_wdt.c   |    2 +-
 drivers/watchdog/alim7101_wdt.c   |    2 +-
 drivers/watchdog/ar7_wdt.c        |    2 +-
 drivers/watchdog/at32ap700x_wdt.c |    2 +-
 drivers/watchdog/at91rm9200_wdt.c |    2 +-
 drivers/watchdog/bcm47xx_wdt.c    |    2 +-
 drivers/watchdog/bfin_wdt.c       |    4 ++--
 drivers/watchdog/booke_wdt.c      |    2 +-
 drivers/watchdog/coh901327_wdt.c  |    2 +-
 drivers/watchdog/cpu5wdt.c        |    2 +-
 drivers/watchdog/cpwd.c           |    2 +-
 drivers/watchdog/davinci_wdt.c    |    2 +-
 drivers/watchdog/ep93xx_wdt.c     |    2 +-
 drivers/watchdog/eurotechwdt.c    |    2 +-
 drivers/watchdog/gef_wdt.c        |    2 +-
 drivers/watchdog/geodewdt.c       |    2 +-
 drivers/watchdog/hpwdt.c          |    2 +-
 drivers/watchdog/i6300esb.c       |    2 +-
 drivers/watchdog/iTCO_wdt.c       |    2 +-
 drivers/watchdog/ib700wdt.c       |    2 +-
 drivers/watchdog/indydog.c        |    2 +-
 drivers/watchdog/it8712f_wdt.c    |    2 +-
 drivers/watchdog/it87_wdt.c       |    2 +-
 drivers/watchdog/ixp2000_wdt.c    |    2 +-
 drivers/watchdog/ixp4xx_wdt.c     |    2 +-
 drivers/watchdog/ks8695_wdt.c     |    2 +-
 drivers/watchdog/machzwd.c        |    2 +-
 drivers/watchdog/mixcomwd.c       |    2 +-
 drivers/watchdog/mpc8xxx_wdt.c    |    2 +-
 drivers/watchdog/mpcore_wdt.c     |    2 +-
 drivers/watchdog/mv64x60_wdt.c    |    2 +-
 drivers/watchdog/pc87413_wdt.c    |    2 +-
 drivers/watchdog/pcwd.c           |    2 +-
 drivers/watchdog/pcwd_pci.c       |    2 +-
 drivers/watchdog/pcwd_usb.c       |    2 +-
 drivers/watchdog/pika_wdt.c       |    2 +-
 drivers/watchdog/pnx833x_wdt.c    |    2 +-
 drivers/watchdog/rc32434_wdt.c    |    2 +-
 drivers/watchdog/rdc321x_wdt.c    |    2 +-
 drivers/watchdog/riowd.c          |    2 +-
 drivers/watchdog/sbc_fitpc2_wdt.c |    2 +-
 drivers/watchdog/sch311x_wdt.c    |    2 +-
 drivers/watchdog/stmp3xxx_wdt.c   |    2 +-
 drivers/watchdog/w83627hf_wdt.c   |    2 +-
 drivers/watchdog/w83977f_wdt.c    |    2 +-
 drivers/watchdog/wdrtas.c         |    2 +-
 drivers/watchdog/wm831x_wdt.c     |    2 +-
 drivers/watchdog/wm8350_wdt.c     |    2 +-
 51 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 4d18c87..2ffce4d 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -150,7 +150,7 @@ static long acq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int options, retval = -EINVAL;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = WATCHDOG_NAME,
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 824d076..4d40965 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -137,7 +137,7 @@ static long advwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING |
 			   WDIOF_SETTIMEOUT |
 			   WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/adx_wdt.c b/drivers/watchdog/adx_wdt.c
index 9d7d155..a5ca7a6 100644
--- a/drivers/watchdog/adx_wdt.c
+++ b/drivers/watchdog/adx_wdt.c
@@ -37,7 +37,7 @@ struct adx_wdt {
 	spinlock_t lock;
 };
 
-static struct watchdog_info adx_wdt_info = {
+static const struct watchdog_info adx_wdt_info = {
 	.identity = "Avionic Design Xanthos Watchdog",
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 937a80f..1e9caea 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -180,7 +180,7 @@ static long ali_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_KEEPALIVEPING |
 					WDIOF_SETTIMEOUT |
 					WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index f90afdb..d8d4da9 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -238,7 +238,7 @@ static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
 							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 2e94b71..31423dd 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -214,7 +214,7 @@ static ssize_t ar7_wdt_write(struct file *file, const char *data,
 static long ar7_wdt_ioctl(struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = LONGNAME,
 		.firmware_version = 1,
 		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 0378479..6873376 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -202,7 +202,7 @@ static int at32_wdt_get_status(void)
 	return status;
 }
 
-static struct watchdog_info at32_wdt_info = {
+static const struct watchdog_info at32_wdt_info = {
 	.identity	= "at32ap700x watchdog",
 	.options	= WDIOF_SETTIMEOUT |
 			  WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index b185daf..b3046dc 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -121,7 +121,7 @@ static int at91_wdt_settimeout(int new_time)
 	return 0;
 }
 
-static struct watchdog_info at91_wdt_info = {
+static const struct watchdog_info at91_wdt_info = {
 	.identity	= "at91 watchdog",
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 751c003..5f24552 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -149,7 +149,7 @@ static ssize_t bcm47xx_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info bcm47xx_wdt_info = {
+static const struct watchdog_info bcm47xx_wdt_info = {
 	.identity 	= DRV_NAME,
 	.options 	= WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index c7b3f9d..6ce2022 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -75,7 +75,7 @@
 
 static unsigned int timeout = WATCHDOG_TIMEOUT;
 static int nowayout = WATCHDOG_NOWAYOUT;
-static struct watchdog_info bfin_wdt_info;
+static const struct watchdog_info bfin_wdt_info;
 static unsigned long open_check;
 static char expect_close;
 static DEFINE_SPINLOCK(bfin_wdt_spinlock);
@@ -387,7 +387,7 @@ static struct miscdevice bfin_wdt_miscdev = {
 	.fops     = &bfin_wdt_fops,
 };
 
-static struct watchdog_info bfin_wdt_info = {
+static const struct watchdog_info bfin_wdt_info = {
 	.identity = "Blackfin Watchdog",
 	.options  = WDIOF_SETTIMEOUT |
 		    WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index e8380ef..8b724aa 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -121,7 +121,7 @@ static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity = "PowerPC Book-E Watchdog",
 };
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 923cc68..9291506 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -257,7 +257,7 @@ static long coh901327_ioctl(struct file *file, unsigned int cmd,
 		struct watchdog_info __user *ident;
 		int __user *i;
 	} uarg;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_CARDRESET |
 					  WDIOF_SETTIMEOUT |
 					  WDIOF_KEEPALIVEPING,
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 71f6d7e..edd3475 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -154,7 +154,7 @@ static long cpu5wdt_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	unsigned int value;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "CPU5 WDT",
 	};
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 081f295..37ea052 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -403,7 +403,7 @@ static int cpwd_release(struct inode *inode, struct file *file)
 
 static long cpwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info info = {
+	static const struct watchdog_info info = {
 		.options		= WDIOF_SETTIMEOUT,
 		.firmware_version	= 1,
 		.identity		= DRIVER_NAME,
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 887136d..56162c8 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -142,7 +142,7 @@ davinci_wdt_write(struct file *file, const char *data, size_t len,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_KEEPALIVEPING,
 	.identity = "DaVinci Watchdog",
 };
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index cdd55e0..88ed54e 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -131,7 +131,7 @@ ep93xx_wdt_write(struct file *file, const char __user *data, size_t len,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE,
 	.identity = "EP93xx Watchdog",
 };
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 9add354..d1c4e55 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -238,7 +238,7 @@ static long eurwdt_ioctl(struct file *file,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
 							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index 734d980..c0e130b 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -161,7 +161,7 @@ static long gef_wdt_ioctl(struct file *file, unsigned int cmd,
 	int timeout;
 	int options;
 	void __user *argp = (void __user *)arg;
-	static struct watchdog_info info = {
+	static const struct watchdog_info info = {
 		.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
 				WDIOF_KEEPALIVEPING,
 		.firmware_version = 0,
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 38252ff..9b49b12 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -142,7 +142,7 @@ static long geodewdt_ioctl(struct file *file, unsigned int cmd,
 	int __user *p = argp;
 	int interval;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING
 		| WDIOF_MAGICCLOSE,
 		.firmware_version =     1,
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a6c5674..70c2c24 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -554,7 +554,7 @@ static ssize_t hpwdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT |
 		   WDIOF_KEEPALIVEPING |
 		   WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 7ba0b11..2fbe7fe 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -256,7 +256,7 @@ static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int new_heartbeat;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 4bdb7f1..a6396f6 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -584,7 +584,7 @@ static long iTCO_wdt_ioctl(struct file *file, unsigned int cmd,
 	int new_heartbeat;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 4bef3dd..0149d8d 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -174,7 +174,7 @@ static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
 							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index bea8a12..1cc5609 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -111,7 +111,7 @@ static long indydog_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int options, retval = -EINVAL;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_KEEPALIVEPING,
 		.firmware_version	= 0,
 		.identity		= "Hardware Watchdog for SGI IP22",
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index daed48d..f52c162 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -236,7 +236,7 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = "IT8712F Watchdog",
 		.firmware_version = 1,
 		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index cc133c5..b709b3b 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -421,7 +421,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.firmware_version =	1,
 	.identity = WATCHDOG_NAME,
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 4f4b35a..0f504cd 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -99,7 +99,7 @@ static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
 }
 
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING,
 	.identity	= "IXP2000 Watchdog",
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 147b4d5..e02c0ec 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -89,7 +89,7 @@ ixp4xx_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_CARDRESET | WDIOF_MAGICCLOSE |
 			  WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= "IXP4xx Watchdog",
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index e1c8276..2852bb2 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -145,7 +145,7 @@ static int ks8695_wdt_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct watchdog_info ks8695_wdt_info = {
+static const struct watchdog_info ks8695_wdt_info = {
 	.identity	= "ks8695 watchdog",
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 };
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 47d7197..2d118cf 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -101,7 +101,7 @@ MODULE_PARM_DESC(nowayout,
 
 #define PFX "machzwd"
 
-static struct watchdog_info zf_info = {
+static const struct watchdog_info zf_info = {
 	.options		= WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.firmware_version	= 1,
 	.identity		= "ZF-Logic watchdog",
diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index 407b025..bc820d1 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -201,7 +201,7 @@ static long mixcomwd_ioctl(struct file *file,
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int status;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "MixCOM watchdog",
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 38c588e..4e3941c 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -148,7 +148,7 @@ static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING,
 		.firmware_version = 1,
 		.identity = "MPC8xxx",
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index a2dc07c..b0646da 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -213,7 +213,7 @@ static ssize_t mpcore_wdt_write(struct file *file, const char *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options		= WDIOF_SETTIMEOUT |
 				  WDIOF_KEEPALIVEPING |
 				  WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index a51dbe4..97f8a48 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -179,7 +179,7 @@ static long mv64x60_wdt_ioctl(struct file *file,
 	int timeout;
 	int options;
 	void __user *argp = (void __user *)arg;
-	static struct watchdog_info info = {
+	static const struct watchdog_info info = {
 		.options =	WDIOF_SETTIMEOUT	|
 				WDIOF_MAGICCLOSE	|
 				WDIOF_KEEPALIVEPING,
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 1a2b916..d3aa2f1 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -407,7 +407,7 @@ static long pc87413_ioctl(struct file *file, unsigned int cmd,
 		int __user *i;
 	} uarg;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options          = WDIOF_KEEPALIVEPING |
 				    WDIOF_SETTIMEOUT |
 				    WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index aa95123..06f7922 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -606,7 +606,7 @@ static long pcwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	int temperature;
 	int new_heartbeat;
 	int __user *argp = (int __user *)arg;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_OVERHEAT |
 					WDIOF_CARDRESET |
 					WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 698f51b..64374d6 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -481,7 +481,7 @@ static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_OVERHEAT |
 					WDIOF_CARDRESET |
 					WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 052fe45..8e4eacc 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -404,7 +404,7 @@ static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_KEEPALIVEPING |
 					WDIOF_SETTIMEOUT |
 					WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/pika_wdt.c b/drivers/watchdog/pika_wdt.c
index 2d22e99..435ec2a 100644
--- a/drivers/watchdog/pika_wdt.c
+++ b/drivers/watchdog/pika_wdt.c
@@ -52,7 +52,7 @@ static struct {
 	struct timer_list timer;	/* The timer that pings the watchdog */
 } pikawdt_private;
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.identity	= DRV_NAME,
 	.options	= WDIOF_CARDRESET |
 			  WDIOF_SETTIMEOUT |
diff --git a/drivers/watchdog/pnx833x_wdt.c b/drivers/watchdog/pnx833x_wdt.c
index 538ec2c..09102f0 100644
--- a/drivers/watchdog/pnx833x_wdt.c
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -141,7 +141,7 @@ static long pnx833x_wdt_ioctl(struct file *file, unsigned int cmd,
 	int options, new_timeout = 0;
 	uint32_t timeout, timeout_left = 0;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
 		.firmware_version = 0,
 		.identity = "Hardware Watchdog for PNX833x",
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index bf12d06..d4c29b5 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -198,7 +198,7 @@ static long rc32434_wdt_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = (void __user *)arg;
 	int new_timeout;
 	unsigned int value;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 4976bfd..69c6adb 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -149,7 +149,7 @@ static long rdc321x_wdt_ioctl(struct file *file, unsigned int cmd,
 {
 	void __user *argp = (void __user *)arg;
 	unsigned int value;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "RDC321x WDT",
 	};
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index c14ae86..ae57bf9 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -85,7 +85,7 @@ static int riowd_release(struct inode *inode, struct file *filp)
 
 static long riowd_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	static struct watchdog_info info = {
+	static const struct watchdog_info info = {
 		.options		= WDIOF_SETTIMEOUT,
 		.firmware_version	= 1,
 		.identity		= DRIVER_NAME,
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 91430a8..a5638be 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -111,7 +111,7 @@ out:
 }
 
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING,
 	.identity	= WATCHDOG_NAME,
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 569eb29..9c40f48 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -250,7 +250,7 @@ static long sch311x_wdt_ioctl(struct file *file, unsigned int cmd,
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_KEEPALIVEPING |
 					  WDIOF_SETTIMEOUT |
 					  WDIOF_MAGICCLOSE,
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index 5dd9526..b3421fd 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -94,7 +94,7 @@ static ssize_t stmp3xxx_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_CARDRESET |
 			  WDIOF_MAGICCLOSE |
 			  WDIOF_SETTIMEOUT |
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index f201acc..0f5288d 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -201,7 +201,7 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
 							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 0560182..6e6743d 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -371,7 +371,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
  *      according to their available features.
  */
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.firmware_version =	1,
 	.identity = WATCHDOG_NAME,
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 5bfb1f2..94ec22b 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -312,7 +312,7 @@ static long wdrtas_ioctl(struct file *file, unsigned int cmd,
 {
 	int __user *argp = (void __user *)arg;
 	int i;
-	static struct watchdog_info wdinfo = {
+	static const struct watchdog_info wdinfo = {
 		.options = WDRTAS_SUPPORTED_MASK,
 		.firmware_version = 0,
 		.identity = "wdrtas",
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 775bcd8..8c4b2d5 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -213,7 +213,7 @@ static ssize_t wm831x_wdt_write(struct file *file,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM831x Watchdog",
 };
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index a2d2e8e..89dd7b0 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -177,7 +177,7 @@ static ssize_t wm8350_wdt_write(struct file *file,
 	return count;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM8350 Watchdog",
 };


