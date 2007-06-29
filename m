Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbXF2JCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbXF2JCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXF2JCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:02:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3477 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbXF2JCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Idoh39T93FoM/PrjwsKfF32xrjpE3tX04+s4y0OH6+TrdpcLQtEOqYjB3tyL/dgPELhkF2k/PT2MtC75ynzLs2mPv26N+7Ok+e+zE7wyLa9OgVkUwh+tFK5M8Ptv98E68TxJ/1Dfcgw0qcvqXohRPy4CxL64FVK1ujwecxF3Pys=
Message-ID: <4684CAF7.9050201@gmail.com>
Date: Fri, 29 Jun 2007 13:03:51 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [linux-usb-devel] [PATCH] PXA27x UDC driver.
References: <20070628103619.GW13886@enneenne.com>	<989B956029373F45A0B8AF0297081890D834FA@zch01exm26.fsl.freescale.net>	<20070628141205.GA13886@enneenne.com> <200706281453.23414.david-b@pacbell.net>
In-Reply-To: <200706281453.23414.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Thursday 28 June 2007, Rodolfo Giometti wrote:
>
>> As suggest by Leo let me propose to you my new patch for PXA27x UDC
>> support.
>>
>> Please, let me know what I have to do for kernel inclusion. :)
>
> Let's start with *JUST* a driver, not trying to update everything
> else in the USB Gadget stack so that it looks like it's designed
> specifically to handle all of Intel's design botches related to
> endpoint config ... and work worse for essentially everything else.
>
> (Unlike pretty much every other vendor, Intel wanted hardware config
> management. It was unusably buggy in pxa21x/25x/26x, and not much
> better in pxa27x.)
>
>
> So in technical terms, and to repeat what I've said before: just
> configure it to act more like a PXA 25x chip (no altsettings) and
> get it so it passes all the tests [1], modulo errata which have no
> workarounds

Other options are:

    1. pre-program endpoints so the setting covers all gadget
       configurations, it seems it's feasible. The only appreciable
       change is, CDC Ethernet config number should be 3 instead of 1.
       It should not break anything.

    2. Implement a FAKE call of GET_CONFIGURATION command so upon
       gadget binding you can issue the command and program endpoints
       according to the received gadget configuration.

Also, considering that PXA3XX processors include PXA27x-compatible
USB device controller it makes sense to develop a driver that
will support both processor families. Hopefully PXA3XX arch
support will be merged some day (the arch support has been already
submitted here, but I don't know about its current status).


Regards,
Dmitry

> ... then submit that. No epautoconfig updates, no
> patches to every gadget driver to cope with updated autoconfig.
>
> Once there's a basic working no-frills version merged, then we can
> talk about whether things in the rest of the stack should change
> to accomodate the bizarre concepts of this controller.
>
> - Dave
>
>
> [1] http://www.linux-usb.org/usbtest/
>

