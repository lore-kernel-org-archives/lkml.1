Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbXDPNrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbXDPNrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 09:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbXDPNrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 09:47:05 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:30070 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752795AbXDPNrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 09:47:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uSENwj29RHCr1Y/Bgzf/41/6QIFxJ/sllznX2PjG6Vd+0rzDGjsZDZnCOs7YaAB7mj2llggh3jUwuvYLn/LvUaafcYuDvsjUfZa7NPM0wecQMzD7U97qPSsSZJ6W+Tqd1/L6ts+7wgJaSzTrAV4cSzQXLqsZLolx1ewOj5veoBE=  ;
X-YMail-OSG: EAgbCzQVM1nqWW0ZVwsHU10BJmGNcCmG.bL7jiwbmYC3JKCDe2Xaa.QYZNzvMGuupGGJgGLZXg--
From: David Brownell <david-b@pacbell.net>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: question on generic gpio interface
Date: Mon, 16 Apr 2007 06:46:59 -0700
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org
References: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com> <200704131543.32976.david-b@pacbell.net> <38b2ab8a0704160303l7c550c2dq3b700b2e93d01a7@mail.gmail.com>
In-Reply-To: <38b2ab8a0704160303l7c550c2dq3b700b2e93d01a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704160646.59407.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 3:03 am, Francis Moreau wrote:

> > Good .. this is more like an IRQ question though.
> 
> ...
> 
> > IRQ logic on that platform must do a few things, like:
> >
> >  - NR_IRQS includes the N interrupts triggered from that chip,
> >    and their numbers probably fit right sometime after the
> >    core set of IRQs (which might include SOC GPIO irqs);
> >
> >  - You'll provide an irq_chip for this controller, and it will
> >    handle the relevant irq operations (set trigger type, mask,
> >    unmask etc);
> >
> >  - When configuring the IRQ handler for that "same IRQ", you'll
> >    set it up to use a chained handler that you provide, which
> >    reads the register to see which gpio(s) triggered the IRQ,
> >    maybe acks it (if just reading that register isn't enough),
> >    and then calls whatever handler was instaled for that GPIO.
> >
> > If that's not familiar to you, look at arch/arm/mach-at91/gpio.c
> > or arch/arm/mach-pxa/irq.c or arch/arm/plat-omap/gpio.c or a
> > number of other similar files showing how the "toplevel" IRQ
> > logic will demux from a "one of these N GPIOs" interrupt down
> > to the handler for that particular IRQ.
> >
> 
> I think I got the picture now, thanks again.
> 
> Just to be sure I understand, it seems to me that your point 2) and 3)
> are 2 different approaches to do the same thing, aren't they ?

No, all of those need to be done.  (Plus maybe a few more things,
I wasn't trying to be exhaustive.)  That last point is what makes
the other ones take effect ... without it, the top level IRQ will
never get dispatched to the GPIO-specific IRQ.

Look at the examples I referenced.


> If so I can only implement 2) since it seems to me better than the
> last one (it better uses genirq layer).

No, implementing all of those points is required.  That's how
the relevant parts of the IRQ layer connect to each other.

- Dave
