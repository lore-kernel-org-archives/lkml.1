Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbZAOH27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbZAOH27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbZAOH2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:28:50 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:55434 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbZAOH2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:28:49 -0500
Message-ID: <496EE5A4.4010805@compulab.co.il>
Date: Thu, 15 Jan 2009 09:28:36 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@sirena.org.uk>, Samuel Ortiz <sameo@openedhand.com>,
       felipe.balbi@nokia.com, Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support 
 within mfd driver.
References: <496E2BE5.1050803@cam.ac.uk>	 <f17812d70901141704n1ac3e8a7q56410f175b833ef6@mail.gmail.com>	 <496ED8F6.6030201@compulab.co.il> <f17812d70901142302n53953607o124df5601cd037bc@mail.gmail.com>
In-Reply-To: <f17812d70901142302n53953607o124df5601cd037bc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric Miao wrote:
> On Thu, Jan 15, 2009 at 2:34 PM, Mike Rapoport <mike@compulab.co.il> wrote:
>>
>> Eric Miao wrote:
>>> On Thu, Jan 15, 2009 at 2:16 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>>>> From: Jonathan Cameron <jic23@cam.ac.uk>
>>>>
>>>> Add support for changing the mode of the da9030 usb charge pump
>>>>
>>> Well, if it is totally USB charger related, I'd suggest to move this into
>>> the dedicated driver. This mfd/da903x.c serves as a common code
>>> base for all sub-peripherals.
>> It's not exactly related to the charger, it's rather related to the USB voltage
>> supplied to USB devices attached to PXA OHCI.
>> Indeed the mfd/da903x.c serves as a common core for sub-peripherals, but IMHO
>> adding a subdevice driver because of single method doesn't worth the overhead.
>> I'm for the solution Jonathan proposes.
>>
> 
> Mmm... then who will be the invoker? I'm a bit upset about this
> being exported while called out of control. If it works as the
> name suggested, setting some mode, maybe we can have a
> platform data field specifying this, and hide this totally within
> the driver. I didn't look into this too much, just a concern here.

The USB charge pump should be enabled if DA9030 should supply USB VBUS for USB
devices connected to PXA OHCI port. In the most simple case, when the USB port
is configured to be host only the platform data can be used to setup the charge
pump once and forget about it. However, if the USB port is configured as OTG,
the charge pump should be toggled depending on OTG ID.
In EM-X270 I have a GPIO connected to OTG ID pin of the connector and according
to the GPIO state I toggle the da9030 USB charge pump.

-- 
Sincerely yours,
Mike.

