Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZCAOkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZCAOkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZCAOkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:40:31 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:54926 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZCAOk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:40:29 -0500
Date: Sun, 1 Mar 2009 16:40:19 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-ID: <20090301144018.GA23581@frodo>
Reply-To: me@felipebalbi.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090228141725.ZZRA012@mailhub.coreip.homeip.net> <20090301003014.GA22673@frodo> <20090228165156.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228165156.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 04:58:01PM -0800, Dmitry Torokhov wrote:
> On Sun, Mar 01, 2009 at 02:30:18AM +0200, Felipe Balbi wrote:
> > On Sat, Feb 28, 2009 at 02:23:03PM -0800, Dmitry Torokhov wrote:
> > > Hi Felipe,
> > > 
> > > On Fri, Feb 27, 2009 at 09:28:02PM +0200, Felipe Balbi wrote:
> > > > From: Felipe Balbi <felipe.balbi@nokia.com>
> > > > 
> > > > This is part of the twl4030 multifunction device driver.
> > > > 
> > > > With this driver we add support for reporting KEY_POWER
> > > > events via the input layer.
> > > 
> > > ...
> > 
> > thanks for reviewing, how about the version below:
> > 
> 
> Looks good, couple more items...

Fixed the extra comments and also got rid of the global input_dev
structure. It could be fetched by passing it to request_irq() and
platform_set/get_drvdata():

==================== cut here ======================

>From 8d424e1775a5c7a1d76bf2ce4907c3d416ff2fb9 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@nokia.com>
Date: Fri, 27 Feb 2009 21:18:15 +0200
Subject: [PATCH] input: misc: add twl4030-pwrbutton driver

This is part of the twl4030 multifunction device driver.

With this driver we add support for reporting KEY_POWER
events via the input layer.

Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
Thanks to Andrew Morton and Dmitry Torokhov for reviewing this driver.

 drivers/input/misc/Kconfig             |   10 ++
 drivers/input/misc/Makefile            |    1 +
 drivers/input/misc/twl4030-pwrbutton.c |  146 ++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/twl4030-pwrbutton.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 67e5553..6fa9e38 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -193,6 +193,16 @@ config INPUT_CM109
 	  To compile this driver as a module, choose M here: the module will be
 	  called cm109.
 
+config INPUT_TWL4030_PWRBUTTON
+	tristate "TWL4030 Power button Driver"
+	depends on TWL4030_CORE
+	help
+	  Say Y here if you want to enable power key reporting via the
+	  TWL4030 family of chips.
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called twl4030_pwrbutton.
+
 config INPUT_UINPUT
 	tristate "User level driver support"
 	help
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index bb62e6e..2fabcdb 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
 obj-$(CONFIG_INPUT_CM109)		+= cm109.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
+obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+= twl4030-pwrbutton.o
 obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
 obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
new file mode 100644
index 0000000..7150830
--- /dev/null
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -0,0 +1,146 @@
+/**
+ * twl4030-pwrbutton.c - TWL4030 Power Button Input Driver
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Written by Peter De Schrijver <peter.de-schrijver@nokia.com>
+ * Several fixes by Felipe Balbi <felipe.balbi@nokia.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/i2c/twl4030.h>
+
+#define PWR_PWRON_IRQ (1 << 0)
+
+#define STS_HW_CONDITIONS 0xf
+
+static irqreturn_t powerbutton_irq(int irq, void *_pwr)
+{
+	struct input_dev *pwr = _pwr;
+	int err;
+	u8 value;
+
+#ifdef CONFIG_LOCKDEP
+	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
+	 * we don't want and can't tolerate since this is a threaded
+	 * IRQ and can sleep due to the i2c reads it has to issue.
+	 * Although it might be friendlier not to borrow this thread
+	 * context...
+	 */
+	local_irq_enable();
+#endif
+
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
+				  STS_HW_CONDITIONS);
+	if (!err)  {
+		input_report_key(pwr, KEY_POWER, value & PWR_PWRON_IRQ);
+		input_sync(pwr);
+	} else {
+		dev_err(pwr->dev.parent, "twl4030: i2c error %d while reading"
+			" TWL4030 PM_MASTER STS_HW_CONDITIONS register\n", err);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit twl4030_pwrbutton_probe(struct platform_device *pdev)
+{
+	struct input_dev *pwr;
+	int irq = platform_get_irq(pdev, 0);
+	int err;
+
+	pwr = input_allocate_device();
+	if (!pwr) {
+		dev_dbg(&pdev->dev, "Can't allocate power button\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = request_irq(irq, powerbutton_irq,
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			"twl4030_pwrbutton", pwr);
+	if (err < 0) {
+		dev_dbg(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
+		goto free_input_dev;
+	}
+
+	pwr->evbit[0] = BIT_MASK(EV_KEY);
+	pwr->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
+	pwr->name = "twl4030_pwrbutton";
+	pwr->phys = "twl4030_pwrbutton/input0";
+	pwr->dev.parent = &pdev->dev;
+	platform_set_drvdata(pdev, pwr);
+
+	err = input_register_device(pwr);
+	if (err) {
+		dev_dbg(&pdev->dev, "Can't register power button: %d\n", err);
+		goto free_irq_and_out;
+	}
+
+	return 0;
+
+free_irq_and_out:
+	free_irq(irq, NULL);
+free_input_dev:
+	input_free_device(pwr);
+out:
+	return err;
+}
+
+static int __devexit twl4030_pwrbutton_remove(struct platform_device *pdev)
+{
+	struct input_dev *pwr = platform_get_drvdata(pdev);
+	int irq = platform_get_irq(pdev, 0);
+
+	free_irq(irq, pwr);
+	input_unregister_device(pwr);
+
+	return 0;
+}
+
+struct platform_driver twl4030_pwrbutton_driver = {
+	.probe		= twl4030_pwrbutton_probe,
+	.remove		= __devexit_p(twl4030_pwrbutton_remove),
+	.driver		= {
+		.name	= "twl4030_pwrbutton",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init twl4030_pwrbutton_init(void)
+{
+	return platform_driver_register(&twl4030_pwrbutton_driver);
+}
+module_init(twl4030_pwrbutton_init);
+
+static void __exit twl4030_pwrbutton_exit(void)
+{
+	platform_driver_unregister(&twl4030_pwrbutton_driver);
+}
+module_exit(twl4030_pwrbutton_exit);
+
+MODULE_ALIAS("platform:twl4030_pwrbutton");
+MODULE_DESCRIPTION("Triton2 Power Button");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Peter De Schrijver <peter.de-schrijver@nokia.com>");
+MODULE_AUTHOR("Felipe Balbi <felipe.balbi@nokia.com>");
+
-- 
1.6.2.rc0.61.g5cd12


-- 
balbi
