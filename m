Return-Path: <linux-kernel-owner+w=401wt.eu-S1761717AbZE0Q0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbZE0Q0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759566AbZE0Q0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:26:35 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:47127 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903AbZE0Q0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:26:34 -0400
Message-ID: <4A1D6901.2090508@freescale.com>
Date: Wed, 27 May 2009 11:23:29 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb>	<fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>	<20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk>
In-Reply-To: <87vdnm8sec.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard wrote:
>>>>>> "Robert" == Robert Schwebel <r.schwebel@pengutronix.de> writes:
> 
> Hi,
> 
>  Robert> - The whole concept is based on the assumption that bindings
>  Robert> are defined *once*, then never to be changed again. As this
>  Robert> is not true (check MPC5200 to find out what I mean), oftree
>  Robert> wreckage is *the* main cause of new kernels not working on
>  Robert> old bootloaders any more. Is there a solution of this
>  Robert> problem? I have not seen a good idea how to avoid the
>  Robert> constant change in definitions.
> 
> Just bundle the .dtb with the kernel and they'll always be in sync. I
> know this isn't really in the spirit of OF, but currently imho the
> only realistic solution.

That removes the ability to use the device tree to pass information from 
the bootloader, such as MAC addresses and clock frequencies.  On the 
u-boot list, you'll find people trying such hacks (which were rightly 
NACKed) as passing the information in the device's volatile registers 
(which the Linux driver must then not reset) to deal with ARM Linux's 
lack of this ability.

>  Robert> - The oftree layering is fundamentally broken. We already
>  Robert> have a sane abstraction for arbitrary hardware in the kernel:
>  Robert> platform devices.  Why not instanciate platform devices from
>  Robert> a generic oftree core?

You can, if you want.  But you'll need extra glue code that understands 
the individual bindings.  IMHO that logic is usually better off in the 
driver itself, but if you really need platform code to involve itself in 
some way (such as providing callbacks), then exceptions can be made.

-Scott

