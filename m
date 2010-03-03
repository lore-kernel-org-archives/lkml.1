Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0CCTnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:43:23 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:33502 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab0CCTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:43:17 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8EBC48.8060701@jic23.retrosnub.co.uk>
Date: Wed, 03 Mar 2010 19:45:12 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-iio@vger.kernel.org
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk>	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>	 <20100303184132.GA11471@core.coreip.homeip.net>	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>	 <4B8EB685.1060302@jic23.retrosnub.co.uk> <1a297b361003031129y6c19ad9cqe8658c2d85d8764@mail.gmail.com>
In-Reply-To: <1a297b361003031129y6c19ad9cqe8658c2d85d8764@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manu,

...
> Maybe it make sense to put all Generic sensors into one whole lot,
> where an application can
> 
> - read the value from the driver (eg: 0 - 65535)
> 
> - read from device static information (to identify how the application
> should treat the values read back.)
> 
>    - report what type of device it is (Light, Voltage, Acceleration
> and what not, simple enumeration will help, mayeb you can even have
> bitwise OR the types, so that you can have a driver with multiple
> capabilities)
>    - the max value it can go
>    - the min value it can go
>    - the number of steps (gradient) that the driver can do.
> 
> 
> Maybe such a simplistic interface does help ?
> 
> The application can simply read the static information from the driver
> and decide whether it should really handle that driver class.

The more generic sensors are covered by IIO (in staging)
There is a lot more there as well as an equivalent of what you describe.

The simplest equivalent to this is the hwmon subsystem (from which IIO
has borrowed a lot of interfaces, as has ALS).

You have a sysfs file per channel, so taking als api as an example:

illuminance0 - Value of illuminance in lux.

If you want your other elements (though no driver provides them at the moment).

illuminance0_max
illuminance0_min
illuminance0_values

For slow devices this is all you need.
If you are interested in fast devices, take a look at the recently posted IIO ABI spec.
That uses sysfs files to describe the data that can be read from a character device
that is fed from a buffer (either hardware or software). It also supports fairly
advanced event handling (similar to input, but without cross device aggregation)
and triggering of data capture from various 'interrupt' sources.

It is still somewhat unclear how exactly to marry the high speed data acquisition
requirements with other 'client' subsystems such as input. All suggestions on that
are welcome! 

Jonathan

(cc'd linux-iio)
