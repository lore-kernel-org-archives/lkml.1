Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYCHVOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYCHVOH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYCHVNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:13:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43347 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751371AbYCHVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:13:54 -0500
Subject: Re: [UPDATED v3][PATCH 5/7] regulator: sysfs ABI
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200803071713.57795.david-b@pacbell.net>
References: <1204827125.15360.151.camel@a10323.wolfsonmicro.main>
	 <200803071713.57795.david-b@pacbell.net>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 21:13:51 +0000
Message-Id: <1205010831.13653.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 17:13 -0800, David Brownell wrote:
> On Thursday 06 March 2008, Liam Girdwood wrote:
> 
> > +What:		/sys/class/regulator/.../microvolts
> > +	...
> > +
> > +What:		/sys/class/regulator/.../microamps
> > +	...
> 
> Versus Documentation/hwmon/sysfs-interface which uses
> millivolts and milliamperes respectively.
> 
> Why not adopt the same convention?  (This applies to
> many attributes, not just these two.)
> 

I originally had milli but changed to micro to conform with
power_supply.h (as our PMIC uses this interface to export it input
supplies to userspace).

> 
> Also, I'm kind of curious what you've thought about
> power budgeting.  Example, a power supply ("regulator")
> may be able to supply a voltage within a given range,
> but only up to a maximum of 200 mA worth.
> 
> The model visible through these sysfs attributes seems to
> be an either/or thing ... either regulating voltage, or
> current, but not addressing the corresponding constraints
> on the other one.
> 

In general it's up to the system hardware designer to ensure each
regulator can supply all the consumers on the domain - hence we don't
have power budgeting in software atm. However, I don't think it would be
too difficult to add in the future.

I'll also add support for a regulator that will do both voltage and
current (although I'm not aware of any in the market atm).

> 
> > +               NOTE: this will return the string 'constraint not defined'
> 
> How about just "undefined" for all those min/max values?
> 

Agreed.

> 
> > +What:		/sys/class/regulator/.../requested_microamps
> > +	...
> 
> Ditto re "milli" vs "micro".  Also, "requested" seems a bit opaque.
> As a sum, maybe "total_mi{lli,cro}amps" would be more explanatory.
> 

Ok, total_ sounds good.

Liam

