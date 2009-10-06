Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbZJFL4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbZJFL4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbZJFL4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:56:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47776 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZJFL4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:56:24 -0400
Date: Tue, 6 Oct 2009 12:55:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and Keypad
	Input Device Driver
Message-ID: <20091006115543.GH27168@sirena.org.uk>
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org> <1254815071-15822-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254815071-15822-1-git-send-email-vapier@gentoo.org>
X-Cookie: RADIO SHACK LEVEL II BASIC
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 03:44:31AM -0400, Mike Frysinger wrote:

> +int adp5520_register_notifier(struct device *dev, struct notifier_block *nb,
> +				unsigned int events)
> +{

This notifier stuff looks an awful lot like an interrupt controller
driver.  Now that it's possible to implement support for an I2C/SPI
driven interrupt controller it'd be good to use that rather than having
a custom API if that's possible.

> +#define GPIO_R3		(1 << 3)	/* LED3 or GPIO3 aka R3 */
> +#define GPIO_R2		(1 << 2)
> +#define GPIO_R1		(1 << 1)
> +#define GPIO_R0		(1 << 0)

> +struct adp5520_gpio_platfrom_data {
> +	unsigned gpio_start;
> +	u8 gpio_en_mask;
> +	u8 gpio_pullup_mask;
> +};

Since there's platform data in here it'd probably be better to namespace
the #defines or put them in a separate header in case there are
collisions with some other chip used on a board.

> +struct adp5520_leds_platfrom_data {

There's some 'platfrom' rather than 'platform' typos.

> +	int num_leds;
> +	struct led_info	*leds;
> +	u8 fade_in;		/* Backlight Fade-In Timer */
> +	u8 fade_out;		/* Backlight Fade-Out Timer */
> +	u8 led_on_time;

I don't know exactly what the on_time option does but if it controls
hardware-implemented blinking there's actually a callback function the
LED driver can implement to allow triggers to use the hardware assisted
blinking at runtime.  If it returns an error or isn't implemented
there's a software fallback.
