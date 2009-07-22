Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbZGVVPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbZGVVPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZGVVPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:15:31 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34749 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbZGVVP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:message-id;
        b=Hr5IwoQu8aJN7T4Gi19WURxPcNxUHl3LT849YRpe/3kd+EJlRO9Nbj86dWD09k29PI
         iTJN6goJwPUlt7R4ZWMZzGxxBchLq8hGO9puHgS0AbroKiXCxIEdUv0Qq3J/tDlNR9nU
         huuBdibNmwvCSKe3bOFCNY5mGC1zqjE+tBdZE=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] SPI driver for LMS283GF05 LCD
Date: Wed, 22 Jul 2009 23:15:00 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-1-amd64; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
References: <200907161004.02552.marek.vasut@gmail.com> <20090722135243.ac1accfb.akpm@linux-foundation.org>
In-Reply-To: <20090722135243.ac1accfb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_UF4ZKqLHacmZL8g"
Message-Id: <200907222315.00946.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_UF4ZKqLHacmZL8g
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Dne St 22. =C4=8Dervence 2009 22:52:43 Andrew Morton napsal(a):
> On Thu, 16 Jul 2009 10:04:02 +0200
>
> Marek Vasut <marek.vasut@gmail.com> wrote:
> > >From b7077676a3016327ca1010d3bbc80a0b9f2742e5 Mon Sep 17 00:00:00 2001
> >
> > From: Marek Vasut <marek.vasut@gmail.com>
> > Date: Thu, 16 Jul 2009 04:49:47 +0200
> > Subject: [PATCH] Samsung LMS283GF05 LCD SPI support
> >
> > This patch adds support for the SPI part of LMS283GF05 LCD. The LCD uses
> > SPI for initialization and powerdown sequences. No further defails are
> > specified in the datasheet about the initialization/powerdown sequence,
> > just the magic numbers that have to be sent over SPI bus. This LCD can
> > be found in the Aeronix Zipit Z2 handheld.
>
> The patch is wordwrapped and has all its tabs replaced with spaces.

I noticed this too, it's because I copy-pasted it from Konsole, sorry :-/
>
> > diff --git a/drivers/video/backlight/Kconfig
> > b/drivers/video/backlight/Kconfig index f9d19be..3f9cce3 100644
> > --- a/drivers/video/backlight/Kconfig
> > +++ b/drivers/video/backlight/Kconfig
> > @@ -31,6 +31,13 @@ config LCD_CORGI
> >           Say y here to support the LCD panels usually found on SHARP
> >           corgi (C7x0) and spitz (Cxx00) models.
> >
> > +config LCD_LMS283GF05
> > +       tristate "Samsung LMS283GF05 LCD"
> > +       depends on LCD_CLASS_DEVICE && SPI_MASTER
> > +       help
> > +         SPI driver for Samsung LMS283GF05. This provides basic support
> > +         for powering the LCD up/down through a sysfs interface.
> > +
>
> It generally looks OK to me.  Should it have a Kconfig dependency for
> its use of the GPIO layer?

Im sending fixed patch, yes. Thanks for pointing it out.

--Boundary-00=_UF4ZKqLHacmZL8g
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0002-Samsung-LMS283GF05-LCD-SPI-support.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-Samsung-LMS283GF05-LCD-SPI-support.patch"

=46rom b7077676a3016327ca1010d3bbc80a0b9f2742e5 Mon Sep 17 00:00:00 2001
=46rom: Marek Vasut <marek.vasut@gmail.com>
Date: Thu, 16 Jul 2009 04:49:47 +0200
Subject: [PATCH 2/8] Samsung LMS283GF05 LCD SPI support

This patch adds support for the SPI part of LMS283GF05 LCD. The LCD uses
SPI for initialization and powerdown sequences. No further defails are
specified in the datasheet about the initialization/powerdown sequence,
just the magic numbers that have to be sent over SPI bus. This LCD can
be found in the Aeronix Zipit Z2 handheld.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
=2D--
 drivers/video/backlight/Kconfig      |    7 +
 drivers/video/backlight/Makefile     |    1 +
 drivers/video/backlight/lms283gf05.c |  242 ++++++++++++++++++++++++++++++=
++
 include/linux/spi/lms283gf05.h       |   28 ++++
 5 files changed, 535 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/lms283gf05.c
 create mode 100644 include/linux/spi/lms283gf05.h

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kcon=
fig
index f9d19be..3f9cce3 100644
=2D-- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -31,6 +31,13 @@ config LCD_CORGI
 	  Say y here to support the LCD panels usually found on SHARP
 	  corgi (C7x0) and spitz (Cxx00) models.
=20
+config LCD_LMS283GF05
+	tristate "Samsung LMS283GF05 LCD"
+	depends on LCD_CLASS_DEVICE && SPI_MASTER && GENERIC_GPIO
+	help
+	  SPI driver for Samsung LMS283GF05. This provides basic support
+	  for powering the LCD up/down through a sysfs interface.
+
 config LCD_LTV350QV
 	tristate "Samsung LTV350QV LCD Panel"
 	depends on LCD_CLASS_DEVICE && SPI_MASTER
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Mak=
efile
index 4eb178c..8156f6a 100644
=2D-- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_LCD_CLASS_DEVICE)     +=3D lcd.o
 obj-$(CONFIG_LCD_CORGI)		   +=3D corgi_lcd.o
 obj-$(CONFIG_LCD_HP700)		   +=3D jornada720_lcd.o
+obj-$(CONFIG_LCD_LMS283GF05)	   +=3D lms283gf05.o
 obj-$(CONFIG_LCD_LTV350QV)	   +=3D ltv350qv.o
 obj-$(CONFIG_LCD_ILI9320)	   +=3D ili9320.o
 obj-$(CONFIG_LCD_PLATFORM)	   +=3D platform_lcd.o
diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight=
/lms283gf05.c
new file mode 100644
index 0000000..447b542
=2D-- /dev/null
+++ b/drivers/video/backlight/lms283gf05.c
@@ -0,0 +1,242 @@
+/*
+ * lms283gf05.c -- support for Samsung LMS283GF05 LCD
+ *
+ * Copyright (c) 2009 Marek Vasut <marek.vasut@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/lcd.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/lms283gf05.h>
+
+struct lms283gf05_state {
+	struct spi_device	*spi;
+	struct lcd_device	*ld;
+};
+
+struct lms283gf05_seq {
+	unsigned char		reg;
+	unsigned short		value;
+	unsigned char		delay;
+};
+
+/* Magic sequences supplied by manufacturer, for details refer to datashee=
t */
+static struct lms283gf05_seq disp_initseq[] =3D {
+	/* REG, VALUE, DELAY */
+	{ 0x07, 0x0000, 0 },
+	{ 0x13, 0x0000, 10 },
+
+	{ 0x11, 0x3004, 0 },
+	{ 0x14, 0x200F, 0 },
+	{ 0x10, 0x1a20, 0 },
+	{ 0x13, 0x0040, 50 },
+
+	{ 0x13, 0x0060, 0 },
+	{ 0x13, 0x0070, 200 },
+
+	{ 0x01, 0x0127, 0 },
+	{ 0x02,	0x0700, 0 },
+	{ 0x03, 0x1030, 0 },
+	{ 0x08, 0x0208, 0 },
+	{ 0x0B, 0x0620, 0 },
+	{ 0x0C, 0x0110, 0 },
+	{ 0x30, 0x0120, 0 },
+	{ 0x31, 0x0127, 0 },
+	{ 0x32, 0x0000, 0 },
+	{ 0x33, 0x0503, 0 },
+	{ 0x34, 0x0727, 0 },
+	{ 0x35, 0x0124, 0 },
+	{ 0x36, 0x0706, 0 },
+	{ 0x37, 0x0701, 0 },
+	{ 0x38, 0x0F00, 0 },
+	{ 0x39, 0x0F00, 0 },
+	{ 0x40, 0x0000, 0 },
+	{ 0x41, 0x0000, 0 },
+	{ 0x42, 0x013f, 0 },
+	{ 0x43, 0x0000, 0 },
+	{ 0x44, 0x013f, 0 },
+	{ 0x45, 0x0000, 0 },
+	{ 0x46, 0xef00, 0 },
+	{ 0x47, 0x013f, 0 },
+	{ 0x48, 0x0000, 0 },
+	{ 0x07, 0x0015, 30 },
+
+	{ 0x07, 0x0017, 0 },
+
+	{ 0x20, 0x0000, 0 },
+	{ 0x21, 0x0000, 0 },
+	{ 0x22, 0x0000, 0 }
+};
+
+static struct lms283gf05_seq disp_pdwnseq[] =3D {
+	{ 0x07, 0x0016, 30 },
+
+	{ 0x07, 0x0004, 0 },
+	{ 0x10, 0x0220, 20 },
+
+	{ 0x13, 0x0060, 50 },
+
+	{ 0x13, 0x0040, 50 },
+
+	{ 0x13, 0x0000, 0 },
+	{ 0x10, 0x0000, 0 }
+};
+
+
+static void lms283gf05_reset(unsigned long gpio, bool inverted)
+{
+	gpio_set_value(gpio, !inverted);
+	mdelay(100);
+	gpio_set_value(gpio, inverted);
+	mdelay(20);
+	gpio_set_value(gpio, !inverted);
+	mdelay(20);
+}
+
+static void lms283gf05_toggle(struct spi_device *spi,
+			struct lms283gf05_seq *seq, int sz)
+{
+	char buf[3];
+	int i;
+
+	for (i =3D 0; i < sz; i++) {
+		buf[0] =3D 0x74;
+		buf[1] =3D 0x00;
+		buf[2] =3D seq[i].reg;
+		spi_write(spi, buf, 3);
+
+		buf[0] =3D 0x76;
+		buf[1] =3D seq[i].value >> 8;
+		buf[2] =3D seq[i].value & 0xff;
+		spi_write(spi, buf, 3);
+
+		mdelay(seq[i].delay);
+	}
+}
+
+static int lms283gf05_power_set(struct lcd_device *ld, int power)
+{
+	struct lms283gf05_state *st =3D lcd_get_data(ld);
+	struct spi_device *spi =3D st->spi;
+	struct lms283gf05_pdata *pdata =3D spi->dev.platform_data;
+
+	if (power) {
+		if (pdata)
+			lms283gf05_reset(pdata->reset_gpio,
+					pdata->reset_inverted);
+		lms283gf05_toggle(spi, disp_initseq, ARRAY_SIZE(disp_initseq));
+	} else {
+		lms283gf05_toggle(spi, disp_pdwnseq, ARRAY_SIZE(disp_pdwnseq));
+		if (pdata)
+			gpio_set_value(pdata->reset_gpio,
+					pdata->reset_inverted);
+	}
+
+	return 0;
+}
+
+static struct lcd_ops lms_ops =3D {
+	.set_power	=3D lms283gf05_power_set,
+	.get_power	=3D NULL,
+};
+
+static int __devinit lms283gf05_probe(struct spi_device *spi)
+{
+	struct lms283gf05_state *st;
+	struct lms283gf05_pdata *pdata =3D spi->dev.platform_data;
+	struct lcd_device *ld;
+	int ret =3D 0;
+
+	if (pdata !=3D NULL) {
+		ret =3D gpio_request(pdata->reset_gpio, "LMS285GF05 RESET");
+		if (ret)
+			return ret;
+
+		ret =3D gpio_direction_output(pdata->reset_gpio,
+						!pdata->reset_inverted);
+		if (ret)
+			goto err;
+	}
+
+	st =3D kzalloc(sizeof(struct lms283gf05_state), GFP_KERNEL);
+	if (st =3D=3D NULL) {
+		dev_err(&spi->dev, "No memory for device state\n");
+		ret =3D -ENOMEM;
+		goto err;
+	}
+
+	ld =3D lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
+	if (IS_ERR(ld)) {
+		ret =3D PTR_ERR(ld);
+		goto err2;
+	}
+
+	st->spi =3D spi;
+	st->ld =3D ld;
+
+	dev_set_drvdata(&spi->dev, st);
+
+	/* kick in the LCD */
+	if (pdata)
+		lms283gf05_reset(pdata->reset_gpio, pdata->reset_inverted);
+	lms283gf05_toggle(spi, disp_initseq, ARRAY_SIZE(disp_initseq));
+
+	return 0;
+
+err2:
+	kfree(st);
+err:
+	if (pdata !=3D NULL)
+		gpio_free(pdata->reset_gpio);
+
+	return ret;
+}
+
+static int __devexit lms283gf05_remove(struct spi_device *spi)
+{
+	struct lms283gf05_state *st =3D dev_get_drvdata(&spi->dev);
+	struct lms283gf05_pdata *pdata =3D st->spi->dev.platform_data;
+
+	lcd_device_unregister(st->ld);
+
+	if (pdata !=3D NULL)
+		gpio_free(pdata->reset_gpio);
+
+	kfree(st);
+
+	return 0;
+}
+
+static struct spi_driver lms283gf05_driver =3D {
+	.driver =3D {
+		.name	=3D "lms283gf05",
+		.owner	=3D THIS_MODULE,
+	},
+	.probe		=3D lms283gf05_probe,
+	.remove		=3D __devexit_p(lms283gf05_remove),
+};
+
+static __init int lms283gf05_init(void)
+{
+	return spi_register_driver(&lms283gf05_driver);
+}
+
+static __exit void lms283gf05_exit(void)
+{
+	spi_unregister_driver(&lms283gf05_driver);
+}
+
+module_init(lms283gf05_init);
+module_exit(lms283gf05_exit);
+
+MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
+MODULE_DESCRIPTION("LCD283GF05 LCD");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/spi/lms283gf05.h b/include/linux/spi/lms283gf05.h
new file mode 100644
index 0000000..02e7228
=2D-- /dev/null
+++ b/include/linux/spi/lms283gf05.h
@@ -0,0 +1,28 @@
+/*
+ * lms283gf05.h - Platform glue for Samsung LMS283GF05 LCD
+ *
+ * Copyright (C) 2009 Marek Vasut <marek.vasut@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U=
SA
+*/
+
+#ifndef _INCLUDE_LINUX_SPI_LMS283GF05_H_
+#define _INCLUDE_LINUX_SPI_LMS283GF05_H_
+
+struct lms283gf05_pdata {
+	unsigned long	reset_gpio;
+	bool		reset_inverted;
+};
+
+#endif /* _INCLUDE_LINUX_SPI_LMS283GF05_H_ */
=2D-=20
1.6.3.3


--Boundary-00=_UF4ZKqLHacmZL8g--
