Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbYAGWDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbYAGWDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYAGWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:02:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59320 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413AbYAGWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:02:53 -0500
Date: Mon, 7 Jan 2008 23:02:35 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: 7eggert@gmx.de, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
In-Reply-To: <478281A6.1000704@zytor.com>
Message-ID: <alpine.LSU.0.999.0801072226060.16143@be1.lrz>
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it>
 <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it>
 <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it>
 <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it>
 <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it>
 <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it>
 <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18dcqCtsem9xDxHXQZCeP8F6aootBhwGmREZMm
 +4lZHn0UQaYNC38wE4YwJjcxYQpmlFoYyg+wu+wcKhV0+jRmCM
 VpMWEQsp9qc9QzvEmtOCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, H. Peter Anvin wrote:
> Bodo Eggert wrote:
> > Christer Weinigel <christer@weinigel.se> wrote:

> > > How do you find out the speed of the ISA bus?  AFAIK there is no
> > > standardized way to do that.  On the Geode SC2200 the ISA bus speed is
> > > usually the PCI clock divided by 4 giving 33MHz/4=8.3MHz or
> > > 30/4=7.5MHz, but with no external ISA devices it's possible to
> > > overclock the ISA bus to /3 to run it at 11MHz or so.  But without
> > > poking at some CPU and southbridge specific registers to find out the
> > > PCI bus speed and the ISA bus divisor you can't really tell.
> > 
> > If you overclock, you are on your own. IIRC I've used 13,3 MHz for some time
> > and used a lower PIO mode to compensate.
> > 
> > > So if you do udelay based on a 6MHz clock (I think you can safely
> > > assume that any 386 based system runs the ISA bus at least that fast)
> > > you'll waste at least 30% and maybe even 100% more time for the delay
> > > after every _p call.
> > 
> > Defaulting to 8 MHz and offering an option to set another clock speed
> > (like idebus=) should be OK.
> > 
> 
> The formalization of the ISA bus which was part of the EISA specification
> settled on 8.33 MHz maximum nominal frequency.  There were, however, some
> earlier designs which used up to 12 MHz nominal; I'm not sure if that applied
> to 386s though.

I've used up to 13,3 MHz on my 386DX40, but it was way out of spec and
I had to use a lower PIO mode to compensate. IIRC, one of my cards forced
me to settle for 10 MHz. Wikipedia claims there were systems having
16 MHz ISA bus, and systems underclocking themselves when accessing ISA.
I remember having optional and mandatory waitstates, too, but I'm not
100 % sure it was on ISA. I think they were ...

But overclocking is not the problem for udelay, it would err to the safe 
side. The problem would be a BUS having < 8 MHz, and since the days of 
80286, they are hard to find. IMO having an option to set the bus speed
for those systems should be enough.

-- 
knghtbrd:<JHM> AIX - the Unix from the universe where Spock has a beard.
