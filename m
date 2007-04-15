Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXDOPOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXDOPOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 11:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXDOPOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 11:14:06 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:29763 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752449AbXDOPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 11:14:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tx6G1+Ja+viN+CbTHfqgckBZoLHK+yT0UFK1Of3DQ2ggA+KrYXhuVvAyZC6L9vShBatNu3Bd+hTwMM6HFbp2iw74+geRkj5+SM63dpJhCIRCHh32gghVyxSMjNm+swEdhz6E6C0xuFv2j+s3+MO++ph9hX0SJmP/4f5jpHHpBMk=  ;
X-YMail-OSG: yUofaCAVM1nPH4bQH2YAiKzBMqpl7FoJeamJu9UkWOmxgVTNh4ikY4Uid623g1xxTLCZYEqLUA--
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Linux 2.6.21-rc6
Date: Sun, 15 Apr 2007 08:14:00 -0700
User-Agent: KMail/1.7.1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>, pavel@suse.cz,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070415080258.GA2716@melchior.yamamaya.is-a-geek.org> <200704151316.26136.rjw@sisk.pl>
In-Reply-To: <200704151316.26136.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704150814.01747.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 4:16 am, Rafael J. Wysocki wrote:
> On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:

> > > > > Yes, it's a Asus M2N-SLI-Deluxe Mainboard with a Athlon64 3200+
> > > > > single core CPU.

And NVidia southbridge, so OHCI not UHCI (plus EHCI) ... one experiment
would be to disable the EHCI (high speed USB) support in BIOS, to make
for a simpler hardware configuration, and see if that makes BIOS happier.
(Or better, just take EHCI out of your Linux config.)  Likewise, taking
the 8042 drivers out of Linux.

I wouldn't be surprised if those factors didn't matter, but it'd be good
to rule them out.


> > > With CONFIG_PM_DEBUG=y and CONFIG_DISABLE_CONSOLE_SUSPEND=y I see
> > > that the second suspend hangs at "i8042 i8042: EARLY resume".
> > > This is kinda interesting because I'm normally using a USB keyboard
> > > and sure enough, if I hook up a normal keyboard and disable USB
> > > legacy support in the BIOS, then suspend to disk works multiple
> > > times. I'd still rather like to use my USB keyboard though. ;)
> 
> Well, I think that when you're using the USB keyboard and the USB legacy
> support, the i8042 driver thinks it has a keyboard to handle and tries to
> handle it during the suspend, which fails.  I don't know why it fails during
> the second suspend, though.

The "legacy" support in at least some cases involves BIOS having a
small USB stack -- enough to handle a keyboard or mouse in "boot mode"
(plus sometimes a USB disk or CDROM) -- and poking the i8042 chip to
act as if *IT* received the data bytes that really came over USB.

I sure don't know the ins-and-outs of such schemes (ISTR there are
others), but my guess is that either the 8042 or OHCI got confused,
at least in conjunction with the lowlevel magic ACPI was doing.

That's all black magic though, as far as I can understand it ...


> Dmitry, could you please have a look?
> 
> > And I can now confirm that unpatched 2.6.21-rc6 works fine as long
> > as USB legacy support is disabled (however without legacy support I
> > can't use the USB keyboard to control grub).
> 
> I think using the 'shutdown' mode of suspend would be better.  There's a little
> point in using 'platform' on desktop systems anyway.
> 
> Frankly, I don't know what to do about it.  If we move platform_finish() after
> device_resume(), some systems may be broken ...

What I'm curious about is exactly why the patch matters.  What ACPI
magic is being invoked to confuse, or unconfuse, those controllers?

- Dave



