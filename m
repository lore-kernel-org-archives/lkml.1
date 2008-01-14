Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYANK5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYANK5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYANK4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:56:52 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:51543 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbYANK4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:56:51 -0500
Message-ID: <478B31B6.3050406@pengutronix.de>
Date: Mon, 14 Jan 2008 10:56:06 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: pengutronix
User-Agent: Icedove 1.5.0.14pre (X11/20071025)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dmitry Torokhov <dtor@mail.ru>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
References: <1199965870-4629-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1199965870-4629-5-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1199965870-4629-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig98EA1484D7F7B1D50E8E1DA1"
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: mkl@pengutronix.de
Subject: Re: [PATCH 5/6] Driver for WM97xx touchscreens in streaming mode
 on PXA2xx systems
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig98EA1484D7F7B1D50E8E1DA1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

reMark Brown wrote:
> Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
> Signed-off-by: Graeme Gregory <gg@opensource.wolfsonmicro.com>
> Signed-off-by: Mike Arthur <mike.arthur@wolfsonmicro.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Stanley Cai <stanley.cai@intel.com>
> Cc: Rodolfo Giometti <giometti@enneenne.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Marc Kleine-Budde <mkl@penugtronix.de>
                                ^^
it's mkl@pengutronix.de

> Cc: Ian Molton <spyro@f2s.com>
> Cc: Vince Sanders <vince@kyllikki.org>
> Cc: Andrew Zabolotny <zap@homelink.ru>
> ---
>  drivers/input/touchscreen/pxa-wm97xx.c |  298 ++++++++++++++++++++++++=
++++++++
>  1 files changed, 298 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/touchscreen/pxa-wm97xx.c
>=20
> diff --git a/drivers/input/touchscreen/pxa-wm97xx.c b/drivers/input/tou=
chscreen/pxa-wm97xx.c
> new file mode 100644
> index 0000000..870508a
> --- /dev/null
> +++ b/drivers/input/touchscreen/pxa-wm97xx.c
> @@ -0,0 +1,298 @@
> +/*
> + * pxa-wm97xx.c  --  pxa-wm97xx Continuous Touch screen driver for
> + *                   Wolfson WM97xx AC97 Codecs.
> + *
> + * Copyright 2004 Wolfson Microelectronics PLC.
> + * Author: Liam Girdwood
> + *         liam.girdwood@wolfsonmicro.com or linux@wolfsonmicro.com
> + * Parts Copyright : Ian Molton <spyro@f2s.com>
> + *                   Andrew Zabolotny <zap@homelink.ru>
> + *
> + *  This program is free software; you can redistribute  it and/or mod=
ify it
> + *  under  the terms of  the GNU General  Public License as published =
by the
> + *  Free Software Foundation;  either version 2 of the  License, or (a=
t your
> + *  option) any later version.
> + *
> + * Notes:
> + *     This is a wm97xx extended touch driver to capture touch
> + *     data in a continuous manner on the Intel XScale archictecture
> + *
> + *  Features:
> + *       - codecs supported:- WM9705, WM9712, WM9713
> + *       - processors supported:- Intel XScale PXA25x, PXA26x, PXA27x
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/version.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/wm97xx.h>
> +#include <linux/io.h>
> +#include <asm/arch/pxa-regs.h>
> +
> +#define VERSION		"0.13"
> +
> +struct continuous {
> +	u16 id;    /* codec id */
> +	u8 code;   /* continuous code */
> +	u8 reads;  /* number of coord reads per read cycle */
> +	u32 speed; /* number of coords per second */
> +};
> +
> +#define WM_READS(sp) ((sp / HZ) + 1)
> +
> +static const struct continuous cinfo[] =3D {
> +	{WM9705_ID2, 0, WM_READS(94), 94},
> +	{WM9705_ID2, 1, WM_READS(188), 188},
> +	{WM9705_ID2, 2, WM_READS(375), 375},
> +	{WM9705_ID2, 3, WM_READS(750), 750},
> +	{WM9712_ID2, 0, WM_READS(94), 94},
> +	{WM9712_ID2, 1, WM_READS(188), 188},
> +	{WM9712_ID2, 2, WM_READS(375), 375},
> +	{WM9712_ID2, 3, WM_READS(750), 750},
> +	{WM9713_ID2, 0, WM_READS(94), 94},
> +	{WM9713_ID2, 1, WM_READS(120), 120},
> +	{WM9713_ID2, 2, WM_READS(154), 154},
> +	{WM9713_ID2, 3, WM_READS(188), 188},
> +};
> +
> +/* continuous speed index */
> +static int sp_idx;
> +static u16 last, tries;
> +
> +/*
> + * Pen sampling frequency (Hz) in continuous mode.
> + */
> +static int cont_rate =3D 200;
> +module_param(cont_rate, int, 0);
> +MODULE_PARM_DESC(cont_rate, "Sampling rate in continuous mode (Hz)");
> +
> +/*
> + * Pen down detection.
> + *
> + * This driver can either poll or use an interrupt to indicate a pen d=
own
> + * event. If the irq request fails then it will fall back to polling m=
ode.
> + */
> +static int pen_int;
> +module_param(pen_int, int, 0);
> +MODULE_PARM_DESC(pen_int, "Pen down detection (1 =3D interrupt, 0 =3D =
polling)");
> +
> +/*
> + * Pressure readback.
> + *
> + * Set to 1 to read back pen down pressure
> + */
> +static int pressure;
> +module_param(pressure, int, 0);
> +MODULE_PARM_DESC(pressure, "Pressure readback (1 =3D pressure, 0 =3D n=
o pressure)");
> +
> +/*
> + * AC97 touch data slot.
> + *
> + * Touch screen readback data ac97 slot
> + */
> +static int ac97_touch_slot =3D 5;
> +module_param(ac97_touch_slot, int, 0);
> +MODULE_PARM_DESC(ac97_touch_slot, "Touch screen data slot AC97 number"=
);
> +
> +
> +/* flush AC97 slot 5 FIFO on pxa machines */
> +#ifdef CONFIG_PXA27x
> +static void wm97xx_acc_pen_up(struct wm97xx *wm)
> +{
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(1);
> +
> +	while (MISR & (1 << 2))
> +		MODR;
> +}
> +#else
> +static void wm97xx_acc_pen_up(struct wm97xx *wm)
> +{
> +	int count =3D 16;
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(1);
> +
> +	while (count < 16) {
> +		MODR;
> +		count--;
> +	}
> +}
> +#endif
> +
> +static int wm97xx_acc_pen_down(struct wm97xx *wm)
> +{
> +	u16 x, y, p =3D 0x100 | WM97XX_ADCSEL_PRES;
> +	int reads =3D 0;
> +
> +	/* data is never immediately available after pen down irq */
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule_timeout(1);
> +
> +	if (tries > 5) {
> +		tries =3D 0;
> +		return RC_PENUP;
> +	}
> +
> +	x =3D MODR;
> +	if (x =3D=3D last) {
> +		tries++;
> +		return RC_AGAIN;
> +	}
> +	last =3D x;
> +	do {
> +		if (reads)
> +			x =3D MODR;
> +		y =3D MODR;
> +		if (pressure)
> +			p =3D MODR;
> +
> +		/* are samples valid */
> +		if ((x & 0x7000) !=3D WM97XX_ADCSEL_X ||
> +			(y & 0x7000) !=3D WM97XX_ADCSEL_Y ||
> +			(p & 0x7000) !=3D WM97XX_ADCSEL_PRES)
> +			goto up;
> +
> +		/* coordinate is good */
> +		tries =3D 0;
> +		input_report_abs(wm->input_dev, ABS_X, x & 0xfff);
> +		input_report_abs(wm->input_dev, ABS_Y, y & 0xfff);
> +		input_report_abs(wm->input_dev, ABS_PRESSURE, p & 0xfff);
> +		input_sync(wm->input_dev);
> +		reads++;
> +	} while (reads < cinfo[sp_idx].reads);
> +up:
> +	return RC_PENDOWN | RC_AGAIN;
> +}
> +
> +static int wm97xx_acc_startup(struct wm97xx *wm)
> +{
> +	int idx =3D 0;
> +
> +	/* check we have a codec */
> +	if (wm->ac97 =3D=3D NULL)
> +		return -ENODEV;
> +
> +	/* Go you big red fire engine */
> +	for (idx =3D 0; idx < ARRAY_SIZE(cinfo); idx++) {
> +		if (wm->id !=3D cinfo[idx].id)
> +			continue;
> +		sp_idx =3D idx;
> +		if (cont_rate <=3D cinfo[idx].speed)
> +			break;
> +	}
> +	wm->acc_rate =3D cinfo[sp_idx].code;
> +	wm->acc_slot =3D ac97_touch_slot;
> +	dev_info(wm->dev,
> +		 "pxa2xx accelerated touchscreen driver, %d samples/sec\n",
> +		 cinfo[sp_idx].speed);
> +
> +	/* codec specific irq config */
> +	if (pen_int) {
> +		switch (wm->id) {
> +		case WM9705_ID2:
> +			wm->pen_irq =3D IRQ_GPIO(4);
> +			set_irq_type(IRQ_GPIO(4), IRQT_BOTHEDGE);
> +			break;
> +		case WM9712_ID2:
> +		case WM9713_ID2:
> +			/* enable pen down interrupt */
> +			/* use PEN_DOWN GPIO 13 to assert IRQ on GPIO line 2 */
> +			wm->pen_irq =3D MAINSTONE_AC97_IRQ;

I'm missing some kind of abstraction here, what about non mainstone
boards with the pen irq wired to some other gpio?

> +			wm97xx_config_gpio(wm, WM97XX_GPIO_13, WM97XX_GPIO_IN,
> +					   WM97XX_GPIO_POL_HIGH,
> +					   WM97XX_GPIO_STICKY,
> +					   WM97XX_GPIO_WAKE);
> +			wm97xx_config_gpio(wm, WM97XX_GPIO_2, WM97XX_GPIO_OUT,
> +					   WM97XX_GPIO_POL_HIGH,
> +					   WM97XX_GPIO_NOTSTICKY,
> +					   WM97XX_GPIO_NOWAKE);
> +			break;
> +		default:
> +			dev_err(wm->dev,
> +				"pen down irq not supported on this device\n");
> +			pen_int =3D 0;
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void wm97xx_acc_shutdown(struct wm97xx *wm)
> +{
> +	/* codec specific deconfig */
> +	if (pen_int) {
> +		switch (wm->id & 0xffff) {
> +		case WM9705_ID2:
> +			wm->pen_irq =3D 0;
> +			break;
> +		case WM9712_ID2:
> +		case WM9713_ID2:
> +			/* disable interrupt */
> +			wm->pen_irq =3D 0;
> +			break;
> +		}
> +	}
> +}
> +
> +static void wm97xx_irq_enable(struct wm97xx *wm, int enable)
> +{
> +	if (enable)
> +		enable_irq(wm->pen_irq);
> +	else
> +		disable_irq(wm->pen_irq);
> +}
> +
> +static struct wm97xx_mach_ops pxa_mach_ops =3D {
> +	.acc_enabled =3D 1,
> +	.acc_pen_up =3D wm97xx_acc_pen_up,
> +	.acc_pen_down =3D wm97xx_acc_pen_down,
> +	.acc_startup =3D wm97xx_acc_startup,
> +	.acc_shutdown =3D wm97xx_acc_shutdown,
> +	.irq_enable =3D wm97xx_irq_enable,
> +};
> +
> +static int pxa_wm97xx_probe(struct device *dev)
> +{
> +	struct wm97xx *wm =3D dev->driver_data;
> +	return wm97xx_register_mach_ops(wm, &pxa_mach_ops);
> +}
> +
> +static int pxa_wm97xx_remove(struct device *dev)
> +{
> +	struct wm97xx *wm =3D dev->driver_data;
> +	wm97xx_unregister_mach_ops(wm);
> +	return 0;
> +}
> +
> +static struct device_driver pxa_wm97xx_driver =3D {
> +	.name =3D "wm97xx-touchscreen",
> +	.bus =3D &wm97xx_bus_type,
> +	.owner =3D THIS_MODULE,
> +	.probe =3D pxa_wm97xx_probe,
> +	.remove =3D pxa_wm97xx_remove
> +};
> +
> +static int __init pxa_wm97xx_init(void)
> +{
> +	return driver_register(&pxa_wm97xx_driver);
> +}
> +
> +static void __exit pxa_wm97xx_exit(void)
> +{
> +	driver_unregister(&pxa_wm97xx_driver);
> +}
> +
> +module_init(pxa_wm97xx_init);
> +module_exit(pxa_wm97xx_exit);
> +
> +/* Module information */
> +MODULE_AUTHOR("Liam Girdwood <liam.girdwood@wolfsonmicro.com>");
> +MODULE_DESCRIPTION("wm97xx continuous touch driver for pxa2xx");
> +MODULE_LICENSE("GPL");

regards - Marc

--=20
 Marc Kleine-Budde              Phone: +49-231-2826-924
 Pengutronix - Linux Solutions for Science and Industry
 Vertretung West/Dortmund     http://www.pengutronix.de


--------------enig98EA1484D7F7B1D50E8E1DA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHizG8jTAFq1RaXHMRAgEUAJ9J64nHXzG1wAlxWpSjta0CLPH0wACfSx22
AFadkKE9PgKMfXEO0zeHxcg=
=GQfc
-----END PGP SIGNATURE-----

--------------enig98EA1484D7F7B1D50E8E1DA1--

