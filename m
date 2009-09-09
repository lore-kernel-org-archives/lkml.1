Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZIIV16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZIIV16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZIIV15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:27:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35738 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZIIV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:27:56 -0400
Date: Wed, 9 Sep 2009 23:27:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, lenb@kernel.org,
       rui.zhang@intel.com, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v3] hwmon driver for ACPI 4.0 power meters
Message-ID: <20090909212752.GA7248@elf.ucw.cz>
References: <20090820211557.GA8431@elf.ucw.cz> <20090820213755.GB10521@tux1.beaverton.ibm.com> <20090821091939.GC21167@elf.ucw.cz> <20090821184718.GD23397@tux1.beaverton.ibm.com> <20090821221705.GA2108@elf.ucw.cz> <20090822011744.GH10521@tux1.beaverton.ibm.com> <20090821140159.GB1328@ucw.cz> <20090908202410.GS10521@tux1.beaverton.ibm.com> <20090909080637.GA28353@elf.ucw.cz> <20090909182051.GA26158@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909182051.GA26158@tux1.beaverton.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-09 11:20:51, Darrick J. Wong wrote:
> On Wed, Sep 09, 2009 at 10:06:38AM +0200, Pavel Machek wrote:
> 
> > > +Description
> > > +-----------
> > > +
> > > +This driver implements sensor reading support for the power meters exposed in
> > > +the ACPI 4.0 spec (Chapter 10.4).  These devices have a simple set of
> > > +features--a power meter that returns average power use over a configurable
> > > +interval, an optional capping mechanism, and a couple of trip points.
> > 
> > So where do we get the average power?
> 
> /sys/class/hwmon/hwmonX/device/powerX_average.  Most of the hwmon driver
> documentation assumes the reader has read the contents of
> Documentation/hwmon/sysfs-interface, but I suppose it wouldn't be too
> difficult to call that out explicitly.

Ok, I did not realize that hwmon/sysfs-interface applies here. Maybe
mention that? Copyring info is probably not good.

> > > +config ACPI_POWER_METER
> > > +	tristate "ACPI 4.0 power meter"
> > > +	depends on HWMON
> > > +	default m
> > 
> > default M is "evil".
> 
> I'll change it to Y, but I wonder why you think default M is evil...?

See the archives. Anyway it should be default to N -- it is new driver
and it is not essential in any way. "default Y" is for features that
were always in and are now optional.

> > > +	  devices.  Say Y (or M) if you have an Intel or AMD computer with
> > > +	  a power meter.
> > 
> > WTF? Neither Intel nor AMD makes _computers_.
> 
> I'll change that to "a computer with ACPI firmware."

I'd add that it only makes sense on very new computers.

> > > +	  To compile this driver as a module, choose M here:
> > > +	  the module will be called power-meter.
> > 
> > .ko.
> 
> The other config options in drivers/acpi/Kconfig omit the .ko; I was trying to
> be consistent with them.

Probably my fault, sorry.

> > > +#define POWER_CAP_NAME		"power1_cap"
> > 
> > I did not see power cap explained.
> 
> I'll add that, thanks for the continued review!

You are welcome.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
