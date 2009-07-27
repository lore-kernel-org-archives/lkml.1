Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZG0UqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZG0UqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZG0UqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:46:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50474 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbZG0UqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:46:22 -0400
Date: Mon, 27 Jul 2009 21:46:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Message-ID: <20090727204614.GA4386@sirena.org.uk>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
 <1248702372-29534-12-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090727214419.5a503821@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727214419.5a503821@hyperion.delvare>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [lm-sensors] [PATCH 12/22] hwmon: WM831x PMIC hardware
 monitoring  driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 09:44:19PM +0200, Jean Delvare wrote:
> On Mon, 27 Jul 2009 14:46:02 +0100, Mark Brown wrote:

> > +Temperatures are sampled by a 12 bit ADC.  Chip and battery temperatures
> > +are available.  The chip temperature is calculated as:

> > +	Degrees celsius = (512.8 - data) / 1.0983

> The driver code says 512.18.

The code is correct, will update.

> >  obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
> > +obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o

> FWIW, I tend to dislike "x" for digits in driver names. What if a

Neither naming convention is entirely satisfactory; whatever is chosen
will cause hassle or confusion or some point.  It's one of those things
where I do find myself wishing for code names.

> Additionally it is inconsistent with the naming of the WM8350 driver
> below.

Yes, the WM8350 drivers (well, most of it) predate the WM8351 and
WM8352.

> > +	/* The conversion depends on the battery, leave to userspace */
> > +	return sprintf(buf, "%d\n", ret);
> > +}

> This is a problem. You are not supposed to return raw register values through
> the sysfs interface. Returning the voltage reading at the chip's pin is
> OK because you still return a voltage value. But a raw register value is
> not something the user should see. I agree that technically speaking, a
> good sensors.conf configuration file would work it out, but
> conceptually this is wrong.

Hrm, OK.  There's a potential small loss of accuracy from converting to
a voltage since the voltages are reported as milivolts but it is just a
simple multiplier.

> Can you say more about these batteries and how temperature measurement
> is different between them? If you can export a voltage reading to
> userspace than that would be OK (as I recall, we have at least one
> driver doing that already.)

Not really; it's intended to be a NTC thermistor but the driver is
rather at the mercy of the battery and any other external components
that the board has added.  I'll convert to reporting as a voltage for
consistency with the ABI.

> > +#define WM831X_NAMED_VOLTAGE(id, name) \
> > +	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, show_voltage,\
> > +				  NULL, name);		\
> 
> I guess you could just call WM831X_VOLTAGE(id, name).

That clashes with the unnamed voltage above.  I could also call them
_NAMED and _UNNAMED, I suppose.

I've fixed all your other issues, will repost tomorrow.
