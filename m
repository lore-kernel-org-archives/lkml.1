Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbZHQKAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbZHQKAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZHQKAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:00:15 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:58055 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZHQKAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=Lvxf4ULvnk69BdmA7FCvjcmfqtE+2e8Tt5dDw1LA4o2jR7mrcCMV/QSVujK9G7YzgZ
         s2js3/5xNS90koS6fXw+Irc812zCHOTHYsVi0H627AVkVBX9v2DOXP3Eo3DWc0eXBcLS
         18KRyUf6Ta36GdtNXq6CZoKDGxcRa3ywH4cMY=
Message-ID: <4A892A21.2010503@gmail.com>
Date: Mon, 17 Aug 2009 18:00:01 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Add watchdog driver for w90p910
References: <4A69CE00.10401@gmail.com> <20090804201032.GB30892@infomag.iguana.be> <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com> <20090805070822.GC30892@infomag.iguana.be> <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com> <20090805103127.GF30892@infomag.iguana.be> <4A79873A.5010504@gmail.com> <4A88C328.5040706@gmail.com> <20090817091458.GR4302@infomag.iguana.be>
In-Reply-To: <20090817091458.GR4302@infomag.iguana.be>
Content-Type: multipart/mixed;
 boundary="------------000909030903020302000109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000909030903020302000109
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Dear Wim,

Wim Van Sebroeck:
> Hi Wan,
> 
>> At the same time, I renamed this driver name, due to I
>> have changed the corresponding device name in my arch file.
> 
> Isn't it best to rename the driver in drivers/watchdog also to nuc900_wdt.c ?

The attached file is my fix patch relative to w90p910-v2.diff.
Also, I renamed all w90p910 to nuc900, Due to it applies to all
Nuc9xx series SoCs.

Thanks a lot for your help.

> Thanks,
> Wim.
> 
> 


--------------000909030903020302000109
Content-Type: text/x-patch;
 name="0002-fix-again-wim-driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-fix-again-wim-driver.patch"

fix watchdog driver for w90p910 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/watchdog/Kconfig       |    8 +-
 drivers/watchdog/Makefile      |    2 +-
 drivers/watchdog/nuc900_wdt.c  |  353 ++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/w90p910_wdt.c |  353 ----------------------------------------
 4 files changed, 358 insertions(+), 358 deletions(-)
 create mode 100644 drivers/watchdog/nuc900_wdt.c
 delete mode 100644 drivers/watchdog/w90p910_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index fba4b91..352b658 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -266,14 +266,14 @@ config STMP3XXX_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called stmp3xxx_wdt.
 
-config W90P910_WATCHDOG
-	tristate "Nuvoton W90P910 watchdog"
+config NUC900_WATCHDOG
+	tristate "Nuvoton NUC900 watchdog"
 	depends on ARCH_W90X900
 	help
 	  Say Y here if to include support for the watchdog timer
-	  for the Nuvoton W90P910 SoC.
+	  for the Nuvoton NUC900 series SoCs.
 	  To compile this driver as a module, choose M here: the
-	  module will be called w90p910_wdt.
+	  module will be called nuc900_wdt.
 
 # AVR32 Architecture
 
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index ecc05b4..ecad9fa 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -44,7 +44,7 @@ obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
 obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
 obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
-obj-$(CONFIG_W90P910_WATCHDOG) += w90p910_wdt.o
+obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
new file mode 100644
index 0000000..adefe3a
--- /dev/null
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -0,0 +1,353 @@
+/*
+ * Copyright (c) 2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+
+#define REG_WTCR		0x1c
+#define WTCLK			(0x01 << 10)
+#define WTE			(0x01 << 7)	/*wdt enable*/
+#define WTIS			(0x03 << 4)
+#define WTIF			(0x01 << 3)
+#define WTRF			(0x01 << 2)
+#define WTRE			(0x01 << 1)
+#define WTR			(0x01 << 0)
+/*
+ * The watchdog time interval can be calculated via following formula:
+ * WTIS		real time interval (formula)
+ * 0x00		((2^ 14 ) * ((external crystal freq) / 256))seconds
+ * 0x01		((2^ 16 ) * ((external crystal freq) / 256))seconds
+ * 0x02		((2^ 18 ) * ((external crystal freq) / 256))seconds
+ * 0x03		((2^ 20 ) * ((external crystal freq) / 256))seconds
+ *
+ * The external crystal freq is 15Mhz in the nuc900 evaluation board.
+ * So 0x00 = +-0.28 seconds, 0x01 = +-1.12 seconds, 0x02 = +-4.48 seconds,
+ * 0x03 = +- 16.92 seconds..
+ */
+#define WDT_HW_TIMEOUT		0x02
+#define WDT_TIMEOUT		(HZ/2)
+#define WDT_HEARTBEAT		15
+
+static int heartbeat = WDT_HEARTBEAT;
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
+	"(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+struct nuc900_wdt {
+	struct resource  *res;
+	struct clk	 *wdt_clock;
+	struct platform_device *pdev;
+	void __iomem	 *wdt_base;
+	char		 expect_close;
+	struct timer_list timer;
+	spinlock_t       wdt_lock;
+	unsigned long next_heartbeat;
+};
+
+static unsigned long nuc900wdt_busy;
+struct nuc900_wdt *nuc900_wdt;
+
+static inline void nuc900_wdt_keepalive(void)
+{
+	unsigned int val;
+
+	spin_lock(&nuc900_wdt->wdt_lock);
+
+	val = __raw_readl(nuc900_wdt->wdt_base + REG_WTCR);
+	val |= (WTR | WTIF);
+	__raw_writel(val, nuc900_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&nuc900_wdt->wdt_lock);
+}
+
+static inline void nuc900_wdt_start(void)
+{
+	unsigned int val;
+
+	spin_lock(&nuc900_wdt->wdt_lock);
+
+	val = __raw_readl(nuc900_wdt->wdt_base + REG_WTCR);
+	val |= (WTRE | WTE | WTR | WTCLK | WTIF);
+	val &= ~WTIS;
+	val |= (WDT_HW_TIMEOUT << 0x04);
+	__raw_writel(val, nuc900_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&nuc900_wdt->wdt_lock);
+
+	nuc900_wdt->next_heartbeat = jiffies + heartbeat * HZ;
+	mod_timer(&nuc900_wdt->timer, jiffies + WDT_TIMEOUT);
+}
+
+static inline void nuc900_wdt_stop(void)
+{
+	unsigned int val;
+
+	del_timer(&nuc900_wdt->timer);
+
+	spin_lock(&nuc900_wdt->wdt_lock);
+
+	val = __raw_readl(nuc900_wdt->wdt_base + REG_WTCR);
+	val &= ~WTE;
+	__raw_writel(val, nuc900_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&nuc900_wdt->wdt_lock);
+}
+
+static inline void nuc900_wdt_ping(void)
+{
+	nuc900_wdt->next_heartbeat = jiffies + heartbeat * HZ;
+}
+
+static int nuc900_wdt_open(struct inode *inode, struct file *file)
+{
+
+	if (test_and_set_bit(0, &nuc900wdt_busy))
+		return -EBUSY;
+
+	nuc900_wdt_start();
+
+	return nonseekable_open(inode, file);
+}
+
+static int nuc900_wdt_close(struct inode *inode, struct file *file)
+{
+	if (nuc900_wdt->expect_close == 42)
+		nuc900_wdt_stop();
+	else {
+		dev_crit(&nuc900_wdt->pdev->dev,
+			"Unexpected close, not stopping watchdog!\n");
+		nuc900_wdt_ping();
+	}
+
+	nuc900_wdt->expect_close = 0;
+	clear_bit(0, &nuc900wdt_busy);
+	return 0;
+}
+
+static const struct watchdog_info nuc900_wdt_info = {
+	.identity	= "nuc900 watchdog",
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+						WDIOF_MAGICCLOSE,
+};
+
+static long nuc900_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_value;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &nuc900_wdt_info,
+				sizeof(nuc900_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		nuc900_wdt_ping();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		heartbeat = new_value;
+		nuc900_wdt_ping();
+
+		return put_user(new_value, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static ssize_t nuc900_wdt_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
+{
+	if (!len)
+		return 0;
+
+	/* Scan for magic character */
+	if (!nowayout) {
+		size_t i;
+
+		nuc900_wdt->expect_close = 0;
+
+		for (i = 0; i < len; i++) {
+			char c;
+			if (get_user(c, data + i))
+				return -EFAULT;
+			if (c == 'V') {
+				nuc900_wdt->expect_close = 42;
+				break;
+			}
+		}
+	}
+
+	nuc900_wdt_ping();
+	return len;
+}
+
+static void nuc900_wdt_timer_ping(unsigned long data)
+{
+	if (time_before(jiffies, nuc900_wdt->next_heartbeat)) {
+		nuc900_wdt_keepalive();
+		mod_timer(&nuc900_wdt->timer, jiffies + WDT_TIMEOUT);
+	} else
+		dev_warn(&nuc900_wdt->pdev->dev, "Will reset the machine !\n");
+}
+
+static const struct file_operations nuc900wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.unlocked_ioctl	= nuc900_wdt_ioctl,
+	.open		= nuc900_wdt_open,
+	.release	= nuc900_wdt_close,
+	.write		= nuc900_wdt_write,
+};
+
+static struct miscdevice nuc900wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &nuc900wdt_fops,
+};
+
+static int __devinit nuc900wdt_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+
+	nuc900_wdt = kzalloc(sizeof(struct nuc900_wdt), GFP_KERNEL);
+	if (!nuc900_wdt)
+		return -ENOMEM;
+
+	nuc900_wdt->pdev = pdev;
+
+	spin_lock_init(&nuc900_wdt->wdt_lock);
+
+	nuc900_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (nuc900_wdt->res == NULL) {
+		dev_err(&pdev->dev, "no memory resource specified\n");
+		ret = -ENOENT;
+		goto err_get;
+	}
+
+	if (!request_mem_region(nuc900_wdt->res->start,
+				resource_size(nuc900_wdt->res), pdev->name)) {
+		dev_err(&pdev->dev, "failed to get memory region\n");
+		ret = -ENOENT;
+		goto err_get;
+	}
+
+	nuc900_wdt->wdt_base = ioremap(nuc900_wdt->res->start,
+					resource_size(nuc900_wdt->res));
+	if (nuc900_wdt->wdt_base == NULL) {
+		dev_err(&pdev->dev, "failed to ioremap() region\n");
+		ret = -EINVAL;
+		goto err_req;
+	}
+
+	nuc900_wdt->wdt_clock = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(nuc900_wdt->wdt_clock)) {
+		dev_err(&pdev->dev, "failed to find watchdog clock source\n");
+		ret = PTR_ERR(nuc900_wdt->wdt_clock);
+		goto err_map;
+	}
+
+	clk_enable(nuc900_wdt->wdt_clock);
+
+	setup_timer(&nuc900_wdt->timer, nuc900_wdt_timer_ping, 0);
+
+	if (misc_register(&nuc900wdt_miscdev)) {
+		dev_err(&pdev->dev, "err register miscdev on minor=%d (%d)\n",
+			WATCHDOG_MINOR, ret);
+		goto err_clk;
+	}
+
+	return 0;
+
+err_clk:
+	clk_disable(nuc900_wdt->wdt_clock);
+	clk_put(nuc900_wdt->wdt_clock);
+err_map:
+	iounmap(nuc900_wdt->wdt_base);
+err_req:
+	release_mem_region(nuc900_wdt->res->start,
+					resource_size(nuc900_wdt->res));
+err_get:
+	kfree(nuc900_wdt);
+	return ret;
+}
+
+static int __devexit nuc900wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&nuc900wdt_miscdev);
+
+	clk_disable(nuc900_wdt->wdt_clock);
+	clk_put(nuc900_wdt->wdt_clock);
+
+	iounmap(nuc900_wdt->wdt_base);
+
+	release_mem_region(nuc900_wdt->res->start,
+					resource_size(nuc900_wdt->res));
+
+	kfree(nuc900_wdt);
+
+	return 0;
+}
+
+static struct platform_driver nuc900wdt_driver = {
+	.probe		= nuc900wdt_probe,
+	.remove		= __devexit_p(nuc900wdt_remove),
+	.driver		= {
+		.name	= "nuc900-wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init nuc900_wdt_init(void)
+{
+	return platform_driver_register(&nuc900wdt_driver);
+}
+
+static void __exit nuc900_wdt_exit(void)
+{
+	platform_driver_unregister(&nuc900wdt_driver);
+}
+
+module_init(nuc900_wdt_init);
+module_exit(nuc900_wdt_exit);
+
+MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
+MODULE_DESCRIPTION("Watchdog driver for NUC900");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:nuc900-wdt");
diff --git a/drivers/watchdog/w90p910_wdt.c b/drivers/watchdog/w90p910_wdt.c
deleted file mode 100644
index 3cb8972..0000000
--- a/drivers/watchdog/w90p910_wdt.c
+++ /dev/null
@@ -1,353 +0,0 @@
-/*
- * Copyright (c) 2009 Nuvoton technology corporation.
- *
- * Wan ZongShun <mcuos.com@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation;version 2 of the License.
- *
- */
-
-#include <linux/bitops.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/clk.h>
-#include <linux/kernel.h>
-#include <linux/miscdevice.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/types.h>
-#include <linux/watchdog.h>
-#include <linux/uaccess.h>
-
-#define REG_WTCR		0x1c
-#define WTCLK			(0x01 << 10)
-#define WTE			(0x01 << 7)	/*wdt enable*/
-#define WTIS			(0x03 << 4)
-#define WTIF			(0x01 << 3)
-#define WTRF			(0x01 << 2)
-#define WTRE			(0x01 << 1)
-#define WTR			(0x01 << 0)
-/*
- * The watchdog time interval can be calculated via following formula:
- * WTIS		real time interval (formula)
- * 0x00		((2^ 14 ) * ((external crystal freq) / 256))seconds
- * 0x01		((2^ 16 ) * ((external crystal freq) / 256))seconds
- * 0x02		((2^ 18 ) * ((external crystal freq) / 256))seconds
- * 0x03		((2^ 20 ) * ((external crystal freq) / 256))seconds
- *
- * The external crystal freq is 15Mhz in the w90p910 evaluation board.
- * So 0x00 = +-0.28 seconds, 0x01 = +-1.12 seconds, 0x02 = +-4.48 seconds,
- * 0x03 = +- 16.92 seconds..
- */
-#define WDT_HW_TIMEOUT		0x02
-#define WDT_TIMEOUT		(HZ/2)
-#define WDT_HEARTBEAT		15
-
-static int heartbeat = WDT_HEARTBEAT;
-module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
-	"(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");
-
-static int nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
-	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-struct w90p910_wdt {
-	struct resource  *res;
-	struct clk	 *wdt_clock;
-	struct platform_device *pdev;
-	void __iomem	 *wdt_base;
-	char		 expect_close;
-	struct timer_list timer;
-	spinlock_t       wdt_lock;
-	unsigned long next_heartbeat;
-};
-
-static unsigned long w90p910wdt_busy;
-struct w90p910_wdt *w90p910_wdt;
-
-static inline void w90p910_wdt_keepalive(void)
-{
-	unsigned int val;
-
-	spin_lock(&w90p910_wdt->wdt_lock);
-
-	val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
-	val |= (WTR | WTIF);
-	__raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
-
-	spin_unlock(&w90p910_wdt->wdt_lock);
-}
-
-static inline void w90p910_wdt_start(void)
-{
-	unsigned int val;
-
-	spin_lock(&w90p910_wdt->wdt_lock);
-
-	val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
-	val |= (WTRE | WTE | WTR | WTCLK | WTIF);
-	val &= ~WTIS;
-	val |= (WDT_HW_TIMEOUT << 0x04);
-	__raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
-
-	spin_unlock(&w90p910_wdt->wdt_lock);
-
-	w90p910_wdt->next_heartbeat = jiffies + heartbeat * HZ;
-	mod_timer(&w90p910_wdt->timer, jiffies + WDT_TIMEOUT);
-}
-
-static inline void w90p910_wdt_stop(void)
-{
-	unsigned int val;
-
-	del_timer(&w90p910_wdt->timer);
-
-	spin_lock(&w90p910_wdt->wdt_lock);
-
-	val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
-	val &= ~WTE;
-	__raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
-
-	spin_unlock(&w90p910_wdt->wdt_lock);
-}
-
-static inline void w90p910_wdt_ping(void)
-{
-	w90p910_wdt->next_heartbeat = jiffies + heartbeat * HZ;
-}
-
-static int w90p910_wdt_open(struct inode *inode, struct file *file)
-{
-
-	if (test_and_set_bit(0, &w90p910wdt_busy))
-		return -EBUSY;
-
-	w90p910_wdt_start();
-
-	return nonseekable_open(inode, file);
-}
-
-static int w90p910_wdt_close(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42)
-		w90p910_wdt_stop();
-	else {
-		dev_crit(&w90p910_wdt->pdev->dev,
-			"Unexpected close, not stopping watchdog!\n");
-		w90p910_wdt_ping();
-	}
-
-	w90p910_wdt->expect_close = 0;
-	clear_bit(0, &w90p910wdt_busy);
-	return 0;
-}
-
-static const struct watchdog_info w90p910_wdt_info = {
-	.identity	= "w90p910 watchdog",
-	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
-						WDIOF_MAGICCLOSE,
-};
-
-static long w90p910_wdt_ioctl(struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_value;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &w90p910_wdt_info,
-				sizeof(w90p910_wdt_info)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-		w90p910_wdt_ping();
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_value, p))
-			return -EFAULT;
-
-		heartbeat = new_value;
-		w90p910_wdt_ping();
-
-		return put_user(new_value, p);
-	case WDIOC_GETTIMEOUT:
-		return put_user(heartbeat, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-static ssize_t w90p910_wdt_write(struct file *file, const char __user *data,
-						size_t len, loff_t *ppos)
-{
-	if (!len)
-		return 0;
-
-	/* Scan for magic character */
-	if (!nowayout) {
-		size_t i;
-
-		w90p910_wdt->expect_close = 0;
-
-		for (i = 0; i < len; i++) {
-			char c;
-			if (get_user(c, data + i))
-				return -EFAULT;
-			if (c == 'V') {
-				w90p910_wdt->expect_close = 42;
-				break;
-			}
-		}
-	}
-
-	w90p910_wdt_ping();
-	return len;
-}
-
-static void w90p910_wdt_timer_ping(unsigned long data)
-{
-	if (time_before(jiffies, w90p910_wdt->next_heartbeat)) {
-		w90p910_wdt_keepalive();
-		mod_timer(&w90p910_wdt->timer, jiffies + WDT_TIMEOUT);
-	} else
-		dev_warn(&w90p910_wdt->pdev->dev, "Will reset the machine !\n");
-}
-
-static const struct file_operations w90p910wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.unlocked_ioctl	= w90p910_wdt_ioctl,
-	.open		= w90p910_wdt_open,
-	.release	= w90p910_wdt_close,
-	.write		= w90p910_wdt_write,
-};
-
-static struct miscdevice w90p910wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &w90p910wdt_fops,
-};
-
-static int __devinit w90p910wdt_probe(struct platform_device *pdev)
-{
-	int ret = 0;
-
-	w90p910_wdt = kzalloc(sizeof(struct w90p910_wdt), GFP_KERNEL);
-	if (!w90p910_wdt)
-		return -ENOMEM;
-
-	w90p910_wdt->pdev = pdev;
-
-	spin_lock_init(&w90p910_wdt->wdt_lock);
-
-	w90p910_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (w90p910_wdt->res == NULL) {
-		dev_err(&pdev->dev, "no memory resource specified\n");
-		ret = -ENOENT;
-		goto err_get;
-	}
-
-	if (!request_mem_region(w90p910_wdt->res->start,
-				resource_size(w90p910_wdt->res), pdev->name)) {
-		dev_err(&pdev->dev, "failed to get memory region\n");
-		ret = -ENOENT;
-		goto err_get;
-	}
-
-	w90p910_wdt->wdt_base = ioremap(w90p910_wdt->res->start,
-					resource_size(w90p910_wdt->res));
-	if (w90p910_wdt->wdt_base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap() region\n");
-		ret = -EINVAL;
-		goto err_req;
-	}
-
-	w90p910_wdt->wdt_clock = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(w90p910_wdt->wdt_clock)) {
-		dev_err(&pdev->dev, "failed to find watchdog clock source\n");
-		ret = PTR_ERR(w90p910_wdt->wdt_clock);
-		goto err_map;
-	}
-
-	clk_enable(w90p910_wdt->wdt_clock);
-
-	setup_timer(&w90p910_wdt->timer, w90p910_wdt_timer_ping, 0);
-
-	if (misc_register(&w90p910wdt_miscdev)) {
-		dev_err(&pdev->dev, "err register miscdev on minor=%d (%d)\n",
-			WATCHDOG_MINOR, ret);
-		goto err_clk;
-	}
-
-	return 0;
-
-err_clk:
-	clk_disable(w90p910_wdt->wdt_clock);
-	clk_put(w90p910_wdt->wdt_clock);
-err_map:
-	iounmap(w90p910_wdt->wdt_base);
-err_req:
-	release_mem_region(w90p910_wdt->res->start,
-					resource_size(w90p910_wdt->res));
-err_get:
-	kfree(w90p910_wdt);
-	return ret;
-}
-
-static int __devexit w90p910wdt_remove(struct platform_device *pdev)
-{
-	misc_deregister(&w90p910wdt_miscdev);
-
-	clk_disable(w90p910_wdt->wdt_clock);
-	clk_put(w90p910_wdt->wdt_clock);
-
-	iounmap(w90p910_wdt->wdt_base);
-
-	release_mem_region(w90p910_wdt->res->start,
-					resource_size(w90p910_wdt->res));
-
-	kfree(w90p910_wdt);
-
-	return 0;
-}
-
-static struct platform_driver w90p910wdt_driver = {
-	.probe		= w90p910wdt_probe,
-	.remove		= __devexit_p(w90p910wdt_remove),
-	.driver		= {
-		.name	= "w90p910-wdt",
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init w90p910_wdt_init(void)
-{
-	return platform_driver_register(&w90p910wdt_driver);
-}
-
-static void __exit w90p910_wdt_exit(void)
-{
-	platform_driver_unregister(&w90p910wdt_driver);
-}
-
-module_init(w90p910_wdt_init);
-module_exit(w90p910_wdt_exit);
-
-MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
-MODULE_DESCRIPTION("Watchdog driver for W90P910");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS("platform:w90p910-wdt");
-- 
1.5.6.3


--------------000909030903020302000109--
