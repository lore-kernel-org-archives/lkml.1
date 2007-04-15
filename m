Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXDOT6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXDOT6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXDOT6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:58:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3849 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753537AbXDOT5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:57:41 -0400
Date: Sun, 15 Apr 2007 19:56:56 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070415195655.GG10097@ucw.cz>
References: <20070411232503.GC20095@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411232503.GC20095@zarina>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * It insists on reusing its predefined attributes *and* their units.
>   So, userspace getting expected values for any battery.
>   
>   Also common units is required for APM/ACPI emulation.
>   
>   Though our battery class insisting on re-usage, but not forces it. If some
>   battery driver can't convert its own raw values (can't imagine why), then
>   driver is free to implement its own attributes *and* additional _units
>   attribute. Though, this scheme is discouraged.
> 
> * LEDs support. Each battery register its trigger, and gadgets with LEDs
>   can quickly bind to battery-charging / battery-full triggers.
> 
> Here how it looks like from user space:
> 
> # ls /sys/class/battery/main-battery/
> capacity  max_capacity  max_voltage   min_current  power   subsystem  uevent
> current   max_current   min_capacity  min_voltage  status  temp       voltage
> # cat /sys/class/battery/main-battery/status
> Full
> # cat /sys/class/leds/h5400\:green-right/trigger
> none h5400-radio timer hwtimer main-battery-charging [main-battery-full]
> # cat /sys/class/leds/h5400\:green-right/brightness
> 255

Can we get few lines in Documentation? I guess min_capacity is
shutdown capacity at current temperature, but its surely non-obvious.

Will min_capacity increase as batery gets old? Or will max_capacity
decrease? (Should we introduce design_capacity for ACPI systems that
know the difference?)

What is min_current? Granularity of amper meter?

And min_voltage is shutdown voltage?

Otherwise it looks good to me. Something like this is really needed.

> + * All voltages, currents, capacities and temperatures in mV, mA, mAh and
> + * tenths of a degree unless otherwise stated. It's driver's job to convert

tenths of degree Celsius?

							Pavel

> +#define BATTERY_STATUS_UNKNOWN      0
> +#define BATTERY_STATUS_CHARGING     1
> +#define BATTERY_STATUS_DISCHARGING  2
> +#define BATTERY_STATUS_NOT_CHARGING 3
> +#define BATTERY_STATUS_FULL         4

Perhaps we need STATUS_ERROR? At least on some machines it is
different from STATUS_NOT_CHARGING.

> +	/* private */
> +	struct power_supplicant pst;
> +
> +	#ifdef CONFIG_LEDS_TRIGGERS
> +	struct led_trigger *charging_trig;
> +	char *charging_trig_name;
> +	struct led_trigger *full_trig;
> +	char *full_trig_name;
> +	#endif
> +};

#ifdefs need to be at column 0?

> +/* 
> + * This is recommended structure to specify static battery parameters.
> + * Generic one, parametrizable for different batteries. Battery device
> + * itself does bot use it, but that's what implementing most drivers,

'does not'?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
