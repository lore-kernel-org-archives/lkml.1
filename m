Return-Path: <linux-kernel-owner+w=401wt.eu-S1030323AbXDPKDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbXDPKDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030339AbXDPKDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:03:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:11281 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030325AbXDPKDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GldD1Z5Q1lSpktsXueZaiWe9BPiVkqCGB5XiIzCUzkumIfaxB7As+AofDPHDZGwN320XfuRJpBJFDwhDZv2rAWMK6/rjMeRtM56vSJ+uvMU1dWomLTpulqXFOnwQE9ogIRmWrab27mF+As9E840IhZ1XNRWiq9M70S5tJJ7wHx4=
Message-ID: <38b2ab8a0704160303l7c550c2dq3b700b2e93d01a7@mail.gmail.com>
Date: Mon, 16 Apr 2007 12:03:11 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: question on generic gpio interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200704131543.32976.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com>
	 <200704131543.32976.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for your detailed answer, it helps a lot !

On 4/14/07, David Brownell <david-b@pacbell.net> wrote:
> On Friday 13 April 2007 1:51 pm, Francis Moreau wrote:
> > Hi,
> >
> > I'm trying to port my old gpio code to the generic one to see if it
> > can fit my needs.
>
> Good .. this is more like an IRQ question though.
>

yeah now it appears to me so...

>
> > The gpio controller is a home made one and has a really weird
> > interface. It has several registers to read the gpio status, to
> > configure gpio directions, or to configure if a gpio can trigger an
> > interrupt and on which event (level or edge). All gpios use the same
> > IRQ and a gpio controller register allows to read which gpio has
> > triggered the interrupt.
>
> I'll trust you on "weird", but that sounds quite typical in
> terms of functionality.  You'll find that most system-on-chip
> GPIO controllers act the same way.
>
> IRQ logic on that platform must do a few things, like:
>
>  - NR_IRQS includes the N interrupts triggered from that chip,
>    and their numbers probably fit right sometimes after the
>    core set of IRQs (which might include SOC GPIO irqs);
>
>  - You'll provide an irq_chip for this controller, and it will
>    handle the relevant irq operations (set trigger type, mask,
>    unmask etc);
>
>  - When configuring the IRQ handler for that "same IRQ", you'll
>    set it up to use a chained handler that you provide, which
>    reads the register to see which gpio(s) triggered the IRQ,
>    maybe acks it (if just reading that register isn't enough),
>    and then calls whatever handler was instaled for that GPIO.
>
> If that's not familiar to you, look at arch/arm/mach-at91/gpio.c
> or arch/arm/mach-pxa/irq.c or arch/arm/plat-omap/gpio.c or a
> number of other similar files showing how the "toplevel" IRQ
> logic will demux from a "one of these N GPIOs" interrupt down
> to the handler for that particular IRQ.
>

I think I got the picture now, thanks again.

Just to be sure I understand, it seems to me that your point 2) and 3)
are 2 different approaches to do the same thing, aren't they ?

If so I can only implement 2) since it seems to me better than the
last one (it better uses genirq layer).

Thanks !
-- 
Francis
