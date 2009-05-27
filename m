Return-Path: <linux-kernel-owner+w=401wt.eu-S1763808AbZE0TJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763808AbZE0TJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZE0TJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:09:25 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:43320 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZE0TJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:09:24 -0400
Message-ID: <4A1D8FBA.6040802@freescale.com>
Date: Wed, 27 May 2009 14:08:42 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk>
In-Reply-To: <20090527175609.GB31861@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Wed, May 27, 2009 at 11:23:29AM -0500, Scott Wood wrote:
>> That removes the ability to use the device tree to pass information from  
>> the bootloader, such as MAC addresses and clock frequencies.  On the  
>> u-boot list, you'll find people trying such hacks (which were rightly  
>> NACKed) as passing the information in the device's volatile registers  
>> (which the Linux driver must then not reset) to deal with ARM Linux's  
>> lack of this ability.
> 
> No one has brought that up on the ARM mailing lists - so does this issue
> really exist?  All of the stuff I see on the ARM lists seems to be well
> behaved and following our existing model - even vendor stuff (supplied
> to me under NDA) seems to generally get this kind of stuff right.

I'm just going by what I've seen on the u-boot list lately.  What is the 
existing ARM Linux model for passing MAC addresses, so that we can point 
people to that when they try to get u-boot to do silly things?

>>>  Robert> - The oftree layering is fundamentally broken. We already
>>>  Robert> have a sane abstraction for arbitrary hardware in the kernel:
>>>  Robert> platform devices.  Why not instanciate platform devices from
>>>  Robert> a generic oftree core?
>> You can, if you want.  But you'll need extra glue code that understands  
>> the individual bindings.  IMHO that logic is usually better off in the  
>> driver itself, but if you really need platform code to involve itself in  
>> some way (such as providing callbacks), then exceptions can be made.
> 
> No it is not.  Device drivers are best written to support devices, and
> the platform specific code should not be anywhere near them.  Platform
> specific code to handle oddities of platforms should be totally separate
> from the device driver itself.

I'm not talking about platform specific code, I'm talking about code to 
retrieve information about a device from the device tree.  There would 
not be separate instances of this for "platforms X, Y and Z", just one 
of_platform binding in each driver.  It's no different than having a 
platform bus binding, except in the data structures used.

But to restate, having external glue to create platform devices from the 
device tree is fine if that's what you want to do.  We used to do that, 
but it was a pain compared to keeping everything in one place.  Your 
experience may differ.

> smc91x is a prime example of the kind of information drivers need - base
> address and irq are very much insufficient to describe how this device is
> connected.  There's much more information required to specify this device
> fully, and throwing it into the driver doesn't work.  We've been there
> and proven that point.

The device tree is quite capable of expressing information beyond 
addresses and interrupts.

-Scott
