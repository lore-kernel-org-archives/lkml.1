Return-Path: <linux-kernel-owner+w=401wt.eu-S1764817AbZAOLWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764817AbZAOLWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760966AbZAOLWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:22:42 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:54415 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872AbZAOLWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:22:40 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <496F1C7A.5080202@gmail.com>
Date: Thu, 15 Jan 2009 11:22:34 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Mike Rapoport <mike@compulab.co.il>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>,
       Samuel Ortiz <sameo@openedhand.com>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support 
 within mfd driver.
References: <496E2BE5.1050803@cam.ac.uk>	 <f17812d70901141704n1ac3e8a7q56410f175b833ef6@mail.gmail.com>	 <496ED8F6.6030201@compulab.co.il>	 <f17812d70901142302n53953607o124df5601cd037bc@mail.gmail.com>	 <496EE5A4.4010805@compulab.co.il> <f17812d70901150013v2c70047er829b1c884a1d7772@mail.gmail.com>
In-Reply-To: <f17812d70901150013v2c70047er829b1c884a1d7772@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:
> On Thu, Jan 15, 2009 at 3:28 PM, Mike Rapoport <mike@compulab.co.il> wrote:
>   
>> Eric Miao wrote:
>>     
>>> On Thu, Jan 15, 2009 at 2:34 PM, Mike Rapoport <mike@compulab.co.il> wrote:
>>>       
>>>> Eric Miao wrote:
>>>>         
>>>>> On Thu, Jan 15, 2009 at 2:16 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>>>>>           
>>>>>> From: Jonathan Cameron <jic23@cam.ac.uk>
>>>>>>
>>>>>> Add support for changing the mode of the da9030 usb charge pump
>>>>>>
>>>>>>             
>>>>> Well, if it is totally USB charger related, I'd suggest to move this into
>>>>> the dedicated driver. This mfd/da903x.c serves as a common code
>>>>> base for all sub-peripherals.
>>>>>           
>>>> It's not exactly related to the charger, it's rather related to the USB voltage
>>>> supplied to USB devices attached to PXA OHCI.
>>>> Indeed the mfd/da903x.c serves as a common core for sub-peripherals, but IMHO
>>>> adding a subdevice driver because of single method doesn't worth the overhead.
>>>> I'm for the solution Jonathan proposes.
>>>>
>>>>         
>>> Mmm... then who will be the invoker? I'm a bit upset about this
>>> being exported while called out of control. If it works as the
>>> name suggested, setting some mode, maybe we can have a
>>> platform data field specifying this, and hide this totally within
>>> the driver. I didn't look into this too much, just a concern here.
>>>       
>> The USB charge pump should be enabled if DA9030 should supply USB VBUS for USB
>> devices connected to PXA OHCI port. In the most simple case, when the USB port
>> is configured to be host only the platform data can be used to setup the charge
>> pump once and forget about it. However, if the USB port is configured as OTG,
>> the charge pump should be toggled depending on OTG ID.
>> In EM-X270 I have a GPIO connected to OTG ID pin of the connector and according
>> to the GPIO state I toggle the da9030 USB charge pump.
>>
>>     
>
> OK, now I understand the problem. The optimal way would be to invent
> an abstraction for this external charge pump (in terms of PXA27x OTG
> controller) and make DA9030 a derived class of it. But the PXA27x OTG
> solution is really a hybrid one, and the existing OTG code is in a mess
> (without a clear abstraction), the sub-optimal way would let platform code
> do this trick. Yet the platform code is currently suffering from a missed
> API to retreive this dynamically scanned I2C device. Mmm...stumped.
>   
Agreed, that lack of a means to obtain i2c devices in board configs is
beginning to get in the way
of quite a few things.  Perhaps we need to start a proper discussion on
how to sort that out.
(some sort of registered call backs perhaps to allow the right dev
pointers to be set on the i2c
device finally being allocated?)  I'm guessing the i2c guys are going to
have strong views
on any changes to their allocation approach!
> I would expect the final solution to be clean enough, that requires some
> dependent stuffs to be modified, and the final look of this patch may be a
> bit different
>   
Agreed.  This definitely isn't the way to go in the long run (assuming
otg etc get cleaned up)
but would it be an acceptable stop gap?  I'm just keen to get the
functionality available
so as to get a board config (intel stargate 2) sorted.  (some of which
you were kind enough to
review a while back - thanks).

Jonathan
