Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZGTNdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZGTNdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZGTNdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:33:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59464 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZGTNdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:33:04 -0400
From: balajitk@ti.com
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Balaji T K <balajitk@ti.com>,
       Nayak Rajendra <rnayak@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 3/4] ARM: OMAP: Rename twl4030_ in rtc-twl.c to make it generic rtc
Date: Mon, 20 Jul 2009 19:02:31 +0530
Message-Id: <1248096751-14256-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

 This patch renames all twl4030_ functions to twl_ so that RTC driver can be
 shared between Triton and Phoenix.  Register addresses which have changed will
 be selected with COMPILATION FLAG

Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Nayak Rajendra <rnayak@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/mfd/twl-core.c |    2 +-
 drivers/rtc/rtc-twl.c  |  124 ++++++++++++++++++++++++------------------------
 2 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 7cd1b01..95d92db 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -528,7 +528,7 @@ add_children(struct twl_platform_data *pdata, unsigned long features)
 		 * Eventually, Linux might become more aware of such
 		 * HW security concerns, and "least privilege".
 		 */
-		child = add_child(RTC_SUB_CHIP_ID, "twl4030_rtc",
+		child = add_child(RTC_SUB_CHIP_ID, "twl_rtc",
 				NULL, 0,
 				true, pdata->irq_base + RTC_INTR_OFFSET, 0);
 		if (IS_ERR(child))
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 6119712..630acb7 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -88,13 +88,13 @@
 /*
  * Supports 1 byte read from TWL4030 RTC register.
  */
-static int twl4030_rtc_read_u8(u8 *data, u8 reg)
+static int twl_rtc_read_u8(u8 *data, u8 reg)
 {
 	int ret;
 
-	ret = twl_i2c_read_u8(TWL4030_MODULE_RTC, data, reg);
+	ret = twl_i2c_read_u8(TWL_MODULE_RTC, data, reg);
 	if (ret < 0)
-		pr_err("twl4030_rtc: Could not read TWL4030"
+		pr_err("twl_rtc: Could not read TWL4030"
 		       "register %X - error %d\n", reg, ret);
 	return ret;
 }
@@ -102,13 +102,13 @@ static int twl4030_rtc_read_u8(u8 *data, u8 reg)
 /*
  * Supports 1 byte write to TWL4030 RTC registers.
  */
-static int twl4030_rtc_write_u8(u8 data, u8 reg)
+static int twl_rtc_write_u8(u8 data, u8 reg)
 {
 	int ret;
 
-	ret = twl_i2c_write_u8(TWL4030_MODULE_RTC, data, reg);
+	ret = twl_i2c_write_u8(TWL_MODULE_RTC, data, reg);
 	if (ret < 0)
-		pr_err("twl4030_rtc: Could not write TWL4030"
+		pr_err("twl_rtc: Could not write TWL4030"
 		       "register %X - error %d\n", reg, ret);
 	return ret;
 }
@@ -129,7 +129,7 @@ static int set_rtc_irq_bit(unsigned char bit)
 
 	val = rtc_irq_bits | bit;
 	val &= ~BIT_RTC_INTERRUPTS_REG_EVERY_M;
-	ret = twl4030_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
+	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
 	if (ret == 0)
 		rtc_irq_bits = val;
 
@@ -145,14 +145,14 @@ static int mask_rtc_irq_bit(unsigned char bit)
 	int ret;
 
 	val = rtc_irq_bits & ~bit;
-	ret = twl4030_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
+	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
 	if (ret == 0)
 		rtc_irq_bits = val;
 
 	return ret;
 }
 
-static int twl4030_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
+static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
 {
 	int ret;
 
@@ -164,7 +164,7 @@ static int twl4030_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
 	return ret;
 }
 
-static int twl4030_rtc_update_irq_enable(struct device *dev, unsigned enabled)
+static int twl_rtc_update_irq_enable(struct device *dev, unsigned enabled)
 {
 	int ret;
 
@@ -185,23 +185,23 @@ static int twl4030_rtc_update_irq_enable(struct device *dev, unsigned enabled)
  *  - Months are 1..12 vs Linux 0-11
  *  - Years are 0..99 vs Linux 1900..N (we assume 21st century)
  */
-static int twl4030_rtc_read_time(struct device *dev, struct rtc_time *tm)
+static int twl_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned char rtc_data[ALL_TIME_REGS + 1];
 	int ret;
 	u8 save_control;
 
-	ret = twl4030_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
+	ret = twl_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		return ret;
 
 	save_control |= BIT_RTC_CTRL_REG_GET_TIME_M;
 
-	ret = twl4030_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		return ret;
 
-	ret = twl_i2c_read(TWL4030_MODULE_RTC, rtc_data,
+	ret = twl_i2c_read(TWL_MODULE_RTC, rtc_data,
 			       REG_SECONDS_REG, ALL_TIME_REGS);
 
 	if (ret < 0) {
@@ -219,7 +219,7 @@ static int twl4030_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-static int twl4030_rtc_set_time(struct device *dev, struct rtc_time *tm)
+static int twl_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned char save_control;
 	unsigned char rtc_data[ALL_TIME_REGS + 1];
@@ -233,17 +233,17 @@ static int twl4030_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	rtc_data[6] = bin2bcd(tm->tm_year - 100);
 
 	/* Stop RTC while updating the TC registers */
-	ret = twl4030_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
+	ret = twl_rtc_read_u8(&save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out;
 
 	save_control &= ~BIT_RTC_CTRL_REG_STOP_RTC_M;
-	twl4030_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out;
 
 	/* update all the time registers in one shot */
-	ret = twl_i2c_write(TWL4030_MODULE_RTC, rtc_data,
+	ret = twl_i2c_write(TWL_MODULE_RTC, rtc_data,
 			REG_SECONDS_REG, ALL_TIME_REGS);
 	if (ret < 0) {
 		dev_err(dev, "rtc_set_time error %d\n", ret);
@@ -252,7 +252,7 @@ static int twl4030_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	/* Start back RTC */
 	save_control |= BIT_RTC_CTRL_REG_STOP_RTC_M;
-	ret = twl4030_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
 
 out:
 	return ret;
@@ -261,12 +261,12 @@ out:
 /*
  * Gets current TWL4030 RTC alarm time.
  */
-static int twl4030_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
+static int twl_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	unsigned char rtc_data[ALL_TIME_REGS + 1];
 	int ret;
 
-	ret = twl_i2c_read(TWL4030_MODULE_RTC, rtc_data,
+	ret = twl_i2c_read(TWL_MODULE_RTC, rtc_data,
 			       REG_ALARM_SECONDS_REG, ALL_TIME_REGS);
 	if (ret < 0) {
 		dev_err(dev, "rtc_read_alarm error %d\n", ret);
@@ -288,12 +288,12 @@ static int twl4030_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	return ret;
 }
 
-static int twl4030_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
+static int twl_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	unsigned char alarm_data[ALL_TIME_REGS + 1];
 	int ret;
 
-	ret = twl4030_rtc_alarm_irq_enable(dev, 0);
+	ret = twl_rtc_alarm_irq_enable(dev, 0);
 	if (ret)
 		goto out;
 
@@ -305,7 +305,7 @@ static int twl4030_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	alarm_data[6] = bin2bcd(alm->time.tm_year - 100);
 
 	/* update all the alarm registers in one shot */
-	ret = twl_i2c_write(TWL4030_MODULE_RTC, alarm_data,
+	ret = twl_i2c_write(TWL_MODULE_RTC, alarm_data,
 			REG_ALARM_SECONDS_REG, ALL_TIME_REGS);
 	if (ret) {
 		dev_err(dev, "rtc_set_alarm error %d\n", ret);
@@ -313,12 +313,12 @@ static int twl4030_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	}
 
 	if (alm->enabled)
-		ret = twl4030_rtc_alarm_irq_enable(dev, 1);
+		ret = twl_rtc_alarm_irq_enable(dev, 1);
 out:
 	return ret;
 }
 
-static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
+static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 {
 	unsigned long events = 0;
 	int ret = IRQ_NONE;
@@ -333,7 +333,7 @@ static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
 	local_irq_enable();
 #endif
 
-	res = twl4030_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
+	res = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
 	/*
@@ -347,14 +347,14 @@ static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
 	else
 		events |= RTC_IRQF | RTC_UF;
 
-	res = twl4030_rtc_write_u8(rd_reg | BIT_RTC_STATUS_REG_ALARM_M,
+	res = twl_rtc_write_u8(rd_reg | BIT_RTC_STATUS_REG_ALARM_M,
 				   REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
 
 	/* Clear on Read enabled. RTC_IT bit of TWL4030_INT_PWR_ISR1
 	 * needs 2 reads to clear the interrupt. One read is done in
-	 * do_twl4030_pwrirq(). Doing the second read, to clear
+	 * do_twl_pwrirq(). Doing the second read, to clear
 	 * the bit.
 	 *
 	 * FIXME the reason PWR_ISR1 needs an extra read is that
@@ -363,7 +363,7 @@ static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
 	 * risk wrongly clearing status for some other IRQ (losing
 	 * the interrupt).  Be smarter about handling RTC_UF ...
 	 */
-	res = twl_i2c_read_u8(TWL4030_MODULE_INT,
+	res = twl_i2c_read_u8(TWL_MODULE_INT,
 			&rd_reg, TWL4030_INT_PWR_ISR1);
 	if (res)
 		goto out;
@@ -376,18 +376,18 @@ out:
 	return ret;
 }
 
-static struct rtc_class_ops twl4030_rtc_ops = {
-	.read_time	= twl4030_rtc_read_time,
-	.set_time	= twl4030_rtc_set_time,
-	.read_alarm	= twl4030_rtc_read_alarm,
-	.set_alarm	= twl4030_rtc_set_alarm,
-	.alarm_irq_enable = twl4030_rtc_alarm_irq_enable,
-	.update_irq_enable = twl4030_rtc_update_irq_enable,
+static struct rtc_class_ops twl_rtc_ops = {
+	.read_time	= twl_rtc_read_time,
+	.set_time	= twl_rtc_set_time,
+	.read_alarm	= twl_rtc_read_alarm,
+	.set_alarm	= twl_rtc_set_alarm,
+	.alarm_irq_enable = twl_rtc_alarm_irq_enable,
+	.update_irq_enable = twl_rtc_update_irq_enable,
 };
 
 /*----------------------------------------------------------------------*/
 
-static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
+static int __devinit twl_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	int ret = 0;
@@ -398,7 +398,7 @@ static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	rtc = rtc_device_register(pdev->name,
-				  &pdev->dev, &twl4030_rtc_ops, THIS_MODULE);
+				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		ret = PTR_ERR(rtc);
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
@@ -409,7 +409,7 @@ static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
-	ret = twl4030_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
+	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
 		goto out1;
 
@@ -420,11 +420,11 @@ static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "Pending Alarm interrupt detected.\n");
 
 	/* Clear RTC Power up reset and pending alarm interrupts */
-	ret = twl4030_rtc_write_u8(rd_reg, REG_RTC_STATUS_REG);
+	ret = twl_rtc_write_u8(rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
 		goto out1;
 
-	ret = request_irq(irq, twl4030_rtc_interrupt,
+	ret = request_irq(irq, twl_rtc_interrupt,
 				IRQF_TRIGGER_RISING,
 				dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
@@ -433,20 +433,20 @@ static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
 	}
 
 	/* Check RTC module status, Enable if it is off */
-	ret = twl4030_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
+	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out2;
 
 	if (!(rd_reg & BIT_RTC_CTRL_REG_STOP_RTC_M)) {
 		dev_info(&pdev->dev, "Enabling TWL4030-RTC.\n");
 		rd_reg = BIT_RTC_CTRL_REG_STOP_RTC_M;
-		ret = twl4030_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
+		ret = twl_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
 		if (ret < 0)
 			goto out2;
 	}
 
 	/* init cached IRQ enable bits */
-	ret = twl4030_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
+	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
 		goto out2;
 
@@ -464,7 +464,7 @@ out0:
  * Disable all TWL4030 RTC module interrupts.
  * Sets status flag to free.
  */
-static int __devexit twl4030_rtc_remove(struct platform_device *pdev)
+static int __devexit twl_rtc_remove(struct platform_device *pdev)
 {
 	/* leave rtc running, but disable irqs */
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
@@ -480,7 +480,7 @@ static int __devexit twl4030_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static void twl4030_rtc_shutdown(struct platform_device *pdev)
+static void twl_rtc_shutdown(struct platform_device *pdev)
 {
 	/* mask timer interrupts, but leave alarm interrupts on to enable
 	   power-on when alarm is triggered */
@@ -491,7 +491,7 @@ static void twl4030_rtc_shutdown(struct platform_device *pdev)
 
 static unsigned char irqstat;
 
-static int twl4030_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int twl_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	irqstat = rtc_irq_bits;
 
@@ -499,42 +499,42 @@ static int twl4030_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int twl4030_rtc_resume(struct platform_device *pdev)
+static int twl_rtc_resume(struct platform_device *pdev)
 {
 	set_rtc_irq_bit(irqstat);
 	return 0;
 }
 
 #else
-#define twl4030_rtc_suspend NULL
-#define twl4030_rtc_resume  NULL
+#define twl_rtc_suspend NULL
+#define twl_rtc_resume  NULL
 #endif
 
-MODULE_ALIAS("platform:twl4030_rtc");
+MODULE_ALIAS("platform:twl_rtc");
 
 static struct platform_driver twl4030rtc_driver = {
-	.probe		= twl4030_rtc_probe,
-	.remove		= __devexit_p(twl4030_rtc_remove),
-	.shutdown	= twl4030_rtc_shutdown,
-	.suspend	= twl4030_rtc_suspend,
-	.resume		= twl4030_rtc_resume,
+	.probe		= twl_rtc_probe,
+	.remove		= __devexit_p(twl_rtc_remove),
+	.shutdown	= twl_rtc_shutdown,
+	.suspend	= twl_rtc_suspend,
+	.resume		= twl_rtc_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
-		.name	= "twl4030_rtc",
+		.name	= "twl_rtc",
 	},
 };
 
-static int __init twl4030_rtc_init(void)
+static int __init twl_rtc_init(void)
 {
 	return platform_driver_register(&twl4030rtc_driver);
 }
-module_init(twl4030_rtc_init);
+module_init(twl_rtc_init);
 
-static void __exit twl4030_rtc_exit(void)
+static void __exit twl_rtc_exit(void)
 {
 	platform_driver_unregister(&twl4030rtc_driver);
 }
-module_exit(twl4030_rtc_exit);
+module_exit(twl_rtc_exit);
 
 MODULE_AUTHOR("Texas Instruments, MontaVista Software");
 MODULE_LICENSE("GPL");
-- 
1.5.4.7

