Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXFYCvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXFYCvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 22:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXFYCvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 22:51:37 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:28849 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751742AbXFYCvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 22:51:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VlTYnrBDKYKicuhzNdPRwgmnBtzTcznsOJdk+owXgrQBUcfMW7+K1hhBkPrRMNjkpWpS9kHawq5pKJ6mQwPoqM6CpAyxWTwGCQtibW4FAeNDvKw8ZQ5pxropn8j/AMZhiFf3rTW5xLFqgHIjuX7yRsm0Kq2JYT3dy1cmcIAFKUM=  ;
X-YMail-OSG: T6cVGqQVM1lgXKpfJK.6CaGGf3MN95SG3jNV.hcVsUUq0vATcJQAgDOu_hBxe4XMwHQEVGAb0r4v6MFBJe2uu2A3ClzolM4f0DoCTfN1zLEIUn97nLvoxSKWlcKAew--
From: David Brownell <david-b@pacbell.net>
To: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Subject: Re: drivers/mtd/devices/at91_dataflash26.c
Date: Sun, 24 Jun 2007 19:51:36 -0700
User-Agent: KMail/1.9.6
Cc: dwmw2@infradead.org, Andrew Victor <andrew@sanpeople.com>,
       tglx@linutronix.de, Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704271812.26392.david-b@pacbell.net> <200705101307.19794.david-b@pacbell.net> <200705102331.12366.hjk@linutronix.de>
In-Reply-To: <200705102331.12366.hjk@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200706241951.37589.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007, Hans-Jürgen Koch wrote:
> Am Donnerstag 10 Mai 2007 22:07 schrieb David Brownell:
> > On Friday 27 April 2007, David Brownell wrote:
> > > On Friday 27 April 2007, Hans-Jürgen Koch wrote:
> > > 
> > > > > 	 the m25p80 driver
> > > > > was pretty close to working with those Atmel devices too ...
> > > > > most of the commands are identical.
> > > > 
> > > > Thanks for that hint, I'll have a look at the data sheet.
> > 
> > Any progress on that?  I looked again, and yes most commands
> > are identical.

Still true.  :)

For that and a boatload of other SPI flash chips.  I'm
wondering just what that JEDEC standard covers; either
it's got useful command coverage, or vendors of SPI flash
noticed that converging command sets is a Good Thing.


> >  - That driver relies on an AT91-only SPI stack that's not
> >    going upstream, instead of drivers/spi/atmel_spi.c;
> > 
> >  - Driver can't even be selected on kernel.org kernel (!!);
> > 
> >  - The m25p80 driver will need at most minor tweaks to
> >    handle those AT26 (and AT25) series chips;
> > 
> > So 340ea370c2ce89d1c15fbf785460f2f74314ce58 should be reverted.

Also still true...


> > 
> > - Dave
> >
> 
> Dave,
> sorry for not responding earlier, I was busy with lots of other 
> stuff. At the moment, I'm working on this again. I had a bit
> of trouble getting a recent kernel working on my test system,
> but that seems to be OK now.
> 
> You'll hear from me soon.

Ping?  Have a look at

    http://lists.infradead.org/pipermail/linux-mtd/2007-June/018706.html

which depends on the resent mutex conversion patch in the
"previous message" link of that patch.

That should highlight more reasons why at91_dataflash should
be reverted ASAP.  I'd expect you would be able to just drop
that in and have it work ... unless you're seeing that nCS0
issue built out of at91rm9200 errata, in which case there's
an experiment I can forward to you.  :)

- Dave
