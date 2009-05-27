Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZE0T3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZE0T3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZE0T3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:29:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57198 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZE0T3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:29:38 -0400
Date: Wed, 27 May 2009 20:29:10 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Scott Wood <scottwood@freescale.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527192909.GA32398@flint.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D8FBA.6040802@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 02:08:42PM -0500, Scott Wood wrote:
> Russell King wrote:
>> No one has brought that up on the ARM mailing lists - so does this issue
>> really exist?  All of the stuff I see on the ARM lists seems to be well
>> behaved and following our existing model - even vendor stuff (supplied
>> to me under NDA) seems to generally get this kind of stuff right.
>
> I'm just going by what I've seen on the u-boot list lately.  What is the  
> existing ARM Linux model for passing MAC addresses, so that we can point  
> people to that when they try to get u-boot to do silly things?

To program them into the hardware registers, which is not what we in
the ARM community say, but it's what the _network_ guys tell people
they should be doing.

I've suggested in the past having a standard kernel parameter such
that you can specify a mac address on a per-device basis in a totally
platform independent way, but the network folk don't like that idea.

>>> You can, if you want.  But you'll need extra glue code that 
>>> understands  the individual bindings.  IMHO that logic is usually 
>>> better off in the  driver itself, but if you really need platform 
>>> code to involve itself in  some way (such as providing callbacks), 
>>> then exceptions can be made.
>>
>> No it is not.  Device drivers are best written to support devices, and
>> the platform specific code should not be anywhere near them.  Platform
>> specific code to handle oddities of platforms should be totally separate
>> from the device driver itself.
>
> I'm not talking about platform specific code, I'm talking about code to  
> retrieve information about a device from the device tree.  There would  
> not be separate instances of this for "platforms X, Y and Z", just one  
> of_platform binding in each driver.  It's no different than having a  
> platform bus binding, except in the data structures used.

I really don't see what OF buys us then, apart from additional dependencies
that have to be correct for the kernel to work.  I can only see disadvantages
if all OF is, is a way to pass some file to the kernel to (effectively) tell
it which drivers to use.

>> smc91x is a prime example of the kind of information drivers need - base
>> address and irq are very much insufficient to describe how this device is
>> connected.  There's much more information required to specify this device
>> fully, and throwing it into the driver doesn't work.  We've been there
>> and proven that point.
>
> The device tree is quite capable of expressing information beyond  
> addresses and interrupts.

Bus width?  Register offset spacing?  SMC LED configuration?  Whether
to use the hardware wait signal from the SMC?

If you're going to say yes to all that, I'm going to start asking how
you cope with verifying that the data for ethernet driver A doesn't
get accidentally used for ethernet driver B.

I assume you have some kind of compiler, which needs a set of specification
files to tell it what's required for each driver which is OF compatible.
If not, I can see no way for OF trees to ever be safe and correct.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
