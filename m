Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZDUCSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZDUCSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 22:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZDUCSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 22:18:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:6385 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZDUCSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 22:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-kmail-identity
         :x-kmail-transport:user-agent:x-kmail-quoteprefix
         :x-kmail-link-message:x-kmail-link-type
         :x-kmail-signatureactionenabled:x-kmail-encryptactionenabled
         :x-kmail-cryptomessageformat:x-kmail-recipients;
        b=PBqnhT4Z2G/3Ty18pDIFlFU+EipmblSpUNHMurYYO26NsKwnzAXvZENefyBZcQ0XWZ
         FwHXb1+G966i/Eg9by29wlEpt2ItitqI4tpAFUGaGYKpjcRIJKjaU0uX2CunyFlsClbI
         rDRfYQXQ9p9tx8EGjslfLubQzUPTUK/y+tGa4=
Date: Mon, 20 Apr 2009 19:18:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: eric.y.miao@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Ribeiro <drwyrm@gmail.com>, ao2@openezx.org
Subject: Re: [patch 08/14] input: PCAP2 based touchscreen driver
Message-ID: <20090421021811.GD13617@dtor-d630.eng.vmware.com>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <20081121170518.GA4416@USFSHXP-002051> <20081122000047.GB28067@dodger.lab.datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081122000047.GB28067@dodger.lab.datenfreihafen.org>
X-KMail-Identity: 579597780
X-KMail-Transport: Mialhub
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1;
	x86_64; ; )
X-KMail-QuotePrefix: >
X-KMail-Link-Message: 312335
X-KMail-Link-Type: reply
X-KMail-SignatureActionEnabled: false
X-KMail-EncryptActionEnabled: false
X-KMail-CryptoMessageFormat: 15
X-KMail-Recipients: Stefan Schmidt <stefan@datenfreihafen.org>,
	eric.y.miao@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Daniel
	Ribeiro <drwyrm@gmail.com>, ao2@openezx.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Friday 21 November 2008 16:00:47 Stefan Schmidt wrote:
> Hello.
>
> Thanks for the fast review. I hope we could address all your points with a
> new patch below.

What is the status of PCAP support? Is it going to be merged in
mainline? I am holding the touchscreen driver in my queue because
it requires linux/mfd/ezx-pcap.h which is not in mainline yet...

Should I drop the driver? Is it going to be merged through some
other tree?

Thanks!

-- 
Dmitry

P.S. Just in case here is what I have in my tree at the moment:

Input: add PCAP2 based touchscreen driver

From: Daniel Ribeiro <drwyrm@gmail.com>

This is touchscreen driver based on the PCAP2 multi function device.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/Kconfig   |    9 +
 drivers/input/touchscreen/Makefile  |    1 
 drivers/input/touchscreen/pcap_ts.c |  264 +++++++++++++++++++++++++++++++++++
 3 files changed, 274 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/pcap_ts.c


diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 82c388e..761e256 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -481,4 +481,13 @@ config TOUCHSCREEN_TSC2007
 	  To compile this driver as a module, choose M here: the
 	  module will be called tsc2007.
 
+config TOUCHSCREEN_PCAP
+	tristate "Motorola PCAP touchscreen"
+	depends on EZX_PCAP
+	help
+	  Say Y here if you have a Motorola EZX telephone and
+	  want to support the built-in touchscreen.
+
+	  If unsure, say N.
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index bef7415..20b009f 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
 obj-$(CONFIG_TOUCHSCREEN_HTCPEN)	+= htcpen.o
 obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
+obj-$(CONFIG_TOUCHSCREEN_PCAP)		+= pcap_ts.o
 obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
diff --git a/drivers/input/touchscreen/pcap_ts.c b/drivers/input/touchscreen/pcap_ts.c
new file mode 100644
index 0000000..122cd09
--- /dev/null
+++ b/drivers/input/touchscreen/pcap_ts.c
@@ -0,0 +1,264 @@
+/*
+ * pcap_ts.c - Touchscreen driver for Motorola PCAP2 based touchscreen as found
+ *	       in the EZX phone platform.
+ *
+ *  Copyright (C) 2006 Harald Welte <laforge@openezx.org>
+ *  Copyright (C) 2007-2008 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ *  Based on information found in the original Motorola 2.4.x ezx-ts.c driver.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/pm.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/mfd/ezx-pcap.h>
+
+struct pcap_ts {
+	struct input_dev *input;
+	struct timer_list timer;
+	struct work_struct work;
+	u16 x, y;
+	u16 pressure;
+	u8 read_state;
+};
+
+struct pcap_ts *pcap_ts;
+
+#define X_AXIS_MIN	0
+#define X_AXIS_MAX	1023
+
+#define Y_AXIS_MAX	X_AXIS_MAX
+#define Y_AXIS_MIN	X_AXIS_MIN
+
+#define PRESSURE_MAX	X_AXIS_MAX
+#define PRESSURE_MIN	X_AXIS_MIN
+
+/* if we try to read faster, pressure reading becomes unreliable */
+#define SAMPLE_INTERVAL		(HZ/50)
+
+static void pcap_ts_read_xy(void)
+{
+	u32 res[2];
+
+	ezx_pcap_get_adc_channel_result(PCAP_ADC_CH_TS_X1,
+					PCAP_ADC_CH_TS_Y1,
+					res);
+	ezx_pcap_disable_adc();
+
+	switch (pcap_ts->read_state) {
+	case PCAP_ADC_TS_M_PRESSURE:
+		/* save pressure, start xy read */
+		pcap_ts->pressure = res[0];
+		pcap_ts->read_state = PCAP_ADC_TS_M_XY;
+		schedule_work(&pcap_ts->work);
+		break;
+
+	case PCAP_ADC_TS_M_XY:
+		pcap_ts->y = res[0];
+		pcap_ts->x = res[1];
+		if (pcap_ts->x <= X_AXIS_MIN || pcap_ts->x >= X_AXIS_MAX ||
+		    pcap_ts->y <= Y_AXIS_MIN || pcap_ts->y >= Y_AXIS_MAX ||
+		    pcap_ts->pressure <= PRESSURE_MIN ||
+		    pcap_ts->pressure >= PRESSURE_MAX) {
+			/* pen has been released */
+			input_report_key(pcap_ts->input, BTN_TOUCH, 0);
+			input_report_abs(pcap_ts->input, ABS_PRESSURE, 0);
+
+			/* no need for timer, we'll get interrupted with
+			 * next touch down event */
+			del_timer(&pcap_ts->timer);
+
+			/* ask PCAP2 to interrupt us if touch event happens
+			 * again */
+			pcap_ts->read_state = PCAP_ADC_TS_M_STANDBY;
+			ezx_pcap_unmask_event(PCAP_IRQ_TS);
+			schedule_work(&pcap_ts->work);
+		} else {
+			/* pen is touching the screen*/
+			input_report_abs(pcap_ts->input, ABS_X, pcap_ts->x);
+			input_report_abs(pcap_ts->input, ABS_Y, pcap_ts->y);
+			input_report_key(pcap_ts->input, BTN_TOUCH, 1);
+			input_report_abs(pcap_ts->input, ABS_PRESSURE,
+						pcap_ts->pressure);
+
+			/* switch back to pressure read mode */
+			pcap_ts->read_state = PCAP_ADC_TS_M_PRESSURE;
+			mod_timer(&pcap_ts->timer,
+					jiffies + SAMPLE_INTERVAL);
+		}
+		input_sync(pcap_ts->input);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static void pcap_ts_work(struct work_struct *unused)
+{
+	u32 tmp;
+
+	switch (pcap_ts->read_state) {
+	case PCAP_ADC_TS_M_STANDBY:
+		/* set TS to standby */
+		ezx_pcap_read(PCAP_REG_ADC, &tmp);
+		tmp &= ~PCAP_ADC_TS_M_MASK;
+		tmp |= (PCAP_ADC_TS_M_STANDBY << PCAP_ADC_TS_M_SHIFT);
+		ezx_pcap_write(PCAP_REG_ADC, tmp);
+		break;
+
+	case PCAP_ADC_TS_M_PRESSURE:
+	case PCAP_ADC_TS_M_XY:
+		/* start adc conversion */
+		ezx_pcap_start_adc(PCAP_ADC_BANK_1, PCAP_ADC_T_NOW,
+			(pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT),
+						pcap_ts_read_xy, NULL);
+		break;
+	}
+}
+
+static void pcap_ts_event_touch(u32 events, void *unused)
+{
+	/* pen touch down, mask touch event and start reading pressure */
+	ezx_pcap_mask_event(PCAP_IRQ_TS);
+	pcap_ts->read_state = PCAP_ADC_TS_M_PRESSURE;
+	schedule_work(&pcap_ts->work);
+}
+
+static void pcap_ts_timer_fn(unsigned long data)
+{
+	schedule_work(&pcap_ts->work);
+}
+
+static int __devinit pcap_ts_probe(struct platform_device *pdev)
+{
+	struct input_dev *input_dev;
+	int err = -ENOMEM;
+
+	pcap_ts = kzalloc(sizeof(*pcap_ts), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!pcap_ts || !input_dev)
+		goto fail;
+
+	INIT_WORK(&pcap_ts->work, pcap_ts_work);
+
+	pcap_ts->read_state = PCAP_ADC_TS_M_STANDBY;
+
+	init_timer(&pcap_ts->timer);
+	pcap_ts->timer.data = (unsigned long) pcap_ts;
+	pcap_ts->timer.function = &pcap_ts_timer_fn;
+
+	pcap_ts->input = input_dev;
+
+	input_dev->name = "pcap-touchscreen";
+	input_dev->phys = "pcap_ts/input0";
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->id.vendor = 0x0001;
+	input_dev->id.product = 0x0002;
+	input_dev->id.version = 0x0100;
+	input_dev->dev.parent = &pdev->dev;
+
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+	input_set_abs_params(input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE, PRESSURE_MIN,
+			     PRESSURE_MAX, 0, 0);
+
+	ezx_pcap_register_event(PCAP_IRQ_TS, pcap_ts_event_touch,
+				NULL, "Touch Screen");
+
+	err = input_register_device(pcap_ts->input);
+	if (err)
+		goto fail_touch;
+
+	schedule_work(&pcap_ts->work);
+
+	return 0;
+
+fail_touch:
+	ezx_pcap_unregister_event(PCAP_IRQ_TS);
+fail:
+	input_free_device(input_dev);
+	kfree(pcap_ts);
+
+	return err;
+}
+
+static int __devexit pcap_ts_remove(struct platform_device *pdev)
+{
+	ezx_pcap_unregister_event(PCAP_IRQ_TS);
+
+	del_timer_sync(&pcap_ts->timer);
+	cancel_work_sync(&pcap_ts->work);
+
+	input_unregister_device(pcap_ts->input);
+	kfree(pcap_ts);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int pcap_ts_suspend(struct platform_device *dev, pm_message_t state)
+{
+	u32 tmp;
+
+	ezx_pcap_read(PCAP_REG_ADC, &tmp);
+	tmp |= PCAP_ADC_TS_REF_LOWPWR;
+	ezx_pcap_write(PCAP_REG_ADC, tmp);
+
+	return 0;
+}
+
+static int pcap_ts_resume(struct platform_device *dev)
+{
+	u32 tmp;
+
+	ezx_pcap_read(PCAP_REG_ADC, &tmp);
+	tmp &= ~PCAP_ADC_TS_REF_LOWPWR;
+	ezx_pcap_write(PCAP_REG_ADC, tmp);
+
+	return 0;
+}
+#endif
+
+static struct platform_driver pcap_ts_driver = {
+	.probe		= pcap_ts_probe,
+	.remove		= __devexit_p(pcap_ts_remove),
+#ifdef CONFIG_PM
+	.suspend	= pcap_ts_suspend,
+	.resume		= pcap_ts_resume,
+#endif
+	.driver		= {
+		.name	= "pcap-ts",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init pcap_ts_init(void)
+{
+	return platform_driver_register(&pcap_ts_driver);
+}
+
+static void __exit pcap_ts_exit(void)
+{
+	platform_driver_unregister(&pcap_ts_driver);
+}
+
+module_init(pcap_ts_init);
+module_exit(pcap_ts_exit);
+
+MODULE_DESCRIPTION("Motorola PCAP2 touchscreen driver");
+MODULE_AUTHOR("Daniel Ribeiro / Harald Welte");
+MODULE_LICENSE("GPL");
