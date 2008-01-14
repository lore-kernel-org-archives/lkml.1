Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYANJbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYANJbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYANJbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:31:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56354 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752996AbYANJbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:31:43 -0500
Date: Mon, 14 Jan 2008 09:29:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Marc Pignat" <marc.pignat@hevs.ch>, wim@iguana.be,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] watchdog on gpio
Message-ID: <20080114092905.227c5a38@lxorguk.ukuu.org.uk>
In-Reply-To: <8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
References: <200801101611.08867.marc.pignat@hevs.ch>
	<8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	<20080114090329.6efa2921@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Saves memory - you can't make inlined strings __initdata without breaking
> > some compilers. So it is correct.
> 
> you could make the same argument about all strings used in all __init
> functions.  making a special case for this one string is just
> confusing.  this is also used from the *platfrom driver probe*
> function, not the *module init* function, which means it should be
> __devinitdata (see below) ... which quickly adds to the
> confusion/craziness.

Not neccessarily see below. For strings there is a tricky tradeoff
between space on embedded boxes and simplicity. On a 2GB desktop PC the
decision is fairly trivial, on a PDA it gets a bit more important.

> > > > +static int __init gpio_wdt_probe(struct platform_device *pdev)
> > >
> > > shouldnt this be __devinit ?
> >
> > IFF the device can be found/removed dynamically.
> 
> wont __init get freed once the module has finished loading ?  

If your platform creates the device statically (as a lot of embedded
platforms do) then the __init is fine. The platform register in
init_module will call back the driver probe method and attach the device
before the init_module exits.

Alan
