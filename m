Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZE0WPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZE0WPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZE0WPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:15:03 -0400
Received: from main.gmane.org ([80.91.229.2]:57582 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZE0WPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:15:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Date: Wed, 27 May 2009 22:32:33 +0100
Message-ID: <h4o0f6-k5o.ln1@woodchuck.wormnet.eu>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> <2ve0f6-8fn.ln1@woodchuck.wormnet.eu> <fa686aa40905271346l737cb0e5x7d62c581b40c2d4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-1-sparc64 (sparc64))
Cc: devicetree-discuss@ozlabs.org, linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.kernel Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, May 27, 2009 at 12:56 PM, Alexander Clouter <alex@digriz.org.uk> wrote:
>> In gmane.linux.kernel Grant Likely <grant.likely@secretlab.ca> wrote:
>>> On Wed, May 27, 2009 at 9:05 AM, Robert Schwebel
>>>
>>> [snipped]
>>>
>> Although I have no input of value here, I'm hoping I do not become the
>> next posterchild for "pain++".
>>
>> I'm working through redo'ing the FPGA support in the TS-7800[1] into a
>> new bus rather than just continuing the messy direction I have been
>> going to date[2].
>>
>> My current approach is that the bus handles the 'hotplug'ing of the FPGA
>> bitstream by unregistering all the devices and then when it's informed
>> the new bitstream is ready it prods all the registered drivers if any
>> devices need bringing up (obviously drivers can be modprobe'd as and
>> when).
>>
>> The 'magic' is that the FPGA code has some special value[3] that what it
>> is and the drivers (outside the platform code) have a list of FPGA magic
>> values (with a mask) that they are willing to service.  The *bus*
>> (platform code) is what installs the devices effectively and only does
>> so if the loaded driver says it can drive a particular loaded bitstream
>> (in the bus driver struct is a array of ID's it checks).
>>
>> Does this sound sane?  Is it an approach that could be ACKed one day?
>> Currently the bit that might be considered sinful is there is for some
>> of the drivers (rtc-m48t86, timeriomem-rng and plat_nand) the FPGA bus
>> 'driver' is a light wrapper around the platform device driver.  This is
>> so that the hooks still exist so the bus know what to load and unload as
>> and when.
> 
> Personally, I'd not write a separate bus.  I'd write a platform driver
> which turns around and registers more platform devices with the
> original device as the parent in the _probe routine, and unregisters
> them in _remove.  Should have the same affect with less complex code.
> However, someone with more device-model-foo may have better advice.
> 
That's a thought, but this 'bus' does not just drive platform devices, 
there are other drivers that will live outside the scope.

I have a half completed GPIO expander for the 'factory' FPGA bitstream 
that could not be done as a platform device.  The GPIO pin's also 
multiplex as an ISA (PC/104) bus and chip select's a SPI bus too.

Another driver is a DMA engine provisioned by the factory bitstream too 
as well as AVR+ADC+watchdog system too.

What would make sense for this approach would be if it was to drive 
bit's from the opencores.org website.

Because there is a mix of platform devices and 'awkward' bit's, this is 
why I was thinking about a seperate bus.

Cheers for the suggestion, it's got me thinkingthat there still has to 
be a better way :)

Cheers

-- 
Alexander Clouter
.sigmonster says: Who goeth a-borrowing goeth a-sorrowing.


