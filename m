Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbZIIIGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbZIIIGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZIIIGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:06:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40658 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZIIIGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:06:43 -0400
Date: Wed, 9 Sep 2009 10:06:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, lenb@kernel.org,
       rui.zhang@intel.com, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v3] hwmon driver for ACPI 4.0 power meters
Message-ID: <20090909080637.GA28353@elf.ucw.cz>
References: <200908202049.n7KKnKO7015060@imap1.linux-foundation.org> <20090820211557.GA8431@elf.ucw.cz> <20090820213755.GB10521@tux1.beaverton.ibm.com> <20090821091939.GC21167@elf.ucw.cz> <20090821184718.GD23397@tux1.beaverton.ibm.com> <20090821221705.GA2108@elf.ucw.cz> <20090822011744.GH10521@tux1.beaverton.ibm.com> <20090821140159.GB1328@ucw.cz> <20090908202410.GS10521@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908202410.GS10521@tux1.beaverton.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> diff --git a/Documentation/hwmon/acpi_power_meter b/Documentation/hwmon/acpi_power_meter
> new file mode 100644
> index 0000000..b02ddaa
> --- /dev/null
> +++ b/Documentation/hwmon/acpi_power_meter
> @@ -0,0 +1,31 @@
> +Kernel driver power_meter
> +=========================
> +
> +This driver talks to ACPI 4.0 power meters.
> +
> +Supported systems:
> +  * Any recent system with ACPI 4.0.
> +    Prefix: 'power_meter'
> +    Datasheet: http://acpi.info/, section 10.4.
> +
> +Author: Darrick J. Wong
> +
> +Description
> +-----------
> +
> +This driver implements sensor reading support for the power meters exposed in
> +the ACPI 4.0 spec (Chapter 10.4).  These devices have a simple set of
> +features--a power meter that returns average power use over a configurable
> +interval, an optional capping mechanism, and a couple of trip points.

So where do we get the average power?

> +Special Features
> +----------------
> +
> +The power[1-*]_is_battery knob indicates if the power supply is a battery.
> +Both power[1-*]_average_{min,max} must be set before the trip
> points will work.

How do trip points work? It is not explained here.


> +config ACPI_POWER_METER
> +	tristate "ACPI 4.0 power meter"
> +	depends on HWMON
> +	default m

default M is "evil".

> +	  devices.  Say Y (or M) if you have an Intel or AMD computer with
> +	  a power meter.

WTF? Neither Intel nor AMD makes _computers_.

> +	  To compile this driver as a module, choose M here:
> +	  the module will be called power-meter.

.ko.

> +#define POWER_CAP_NAME		"power1_cap"

I did not see power cap explained.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
