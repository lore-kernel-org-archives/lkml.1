Return-Path: <linux-kernel-owner+w=401wt.eu-S935602AbXGQWkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935602AbXGQWkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbXGQWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:40:15 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34082 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbXGQWkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:40:13 -0400
Subject: Re: clocksource change of behavior in 2.6.22 compared to 2.6.20
	causes massive system clock slowdown
From: john stultz <johnstul@us.ibm.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <5a4c581d0707171531y7d4be4a2re66493e5cd28785f@mail.gmail.com>
References: <5a4c581d0707090727q15eff62ax1fdb1271754cc2d2@mail.gmail.com>
	 <20070710002935.f082b7c3.akpm@linux-foundation.org>
	 <1184088500.30575.9.camel@localhost>
	 <5a4c581d0707101631g40fcdcd2m3d6b2f448a4c8cee@mail.gmail.com>
	 <1184187980.1513.5.camel@localhost>
	 <5a4c581d0707171531y7d4be4a2re66493e5cd28785f@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 15:40:06 -0700
Message-Id: <1184712006.5836.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 00:31 +0200, Alessandro Suardi wrote:
> On 7/11/07, john stultz <johnstul@us.ibm.com> wrote:
> > On Wed, 2007-07-11 at 01:31 +0200, Alessandro Suardi wrote:
> > > On 7/10/07, john stultz <johnstul@us.ibm.com> wrote:
> > > > On Tue, 2007-07-10 at 00:29 -0700, Andrew Morton wrote:
> > > > > On Mon, 9 Jul 2007 16:27:59 +0200 "Alessandro Suardi" <alessandro.suardi@gmail.com> wrote:
> > > > >
> > > > > > My oldish AMD K7-800's clock began falling behind after
> > > > > >  rebooting from 2.6.20 (and 109 days uptime with a spotless
> > > > > >  clock) into 2.6.22; time lost is about four minutes each hour.
> > > > > >
> > > > > > Turns out that 2.6.22 marks my TSC as unstable and starts
> > > > > >  using PIT instead. Rebooting 2.6.22 with clocksource=tsc
> > > > > >  gets the original stable system time back.
> > > >
> > > > Alessandro,
> > > > Can you send me dmesg output for 2.6.20 and 2.6.22 (without
> > > > clocksource=tsc)?
> > >
> > > Actually, I lied a little bit - it was 2.6.22 with clock=tsc (which
> > >  warns on boot about clock= being deprecated in favor of
> > >  clocksource= ). I assume behavior is identical for now.
> > >
> > > Please find attached the dmesg ring (incomplete, as the
> > >  kernel ring size I have seems too small to hold the full
> > >  buffer, but it seems to have all the interesting stuff) of
> > >  2.6.20, 2.6.22, 2.6.22 with clock=tsc.
> > >
> > > If you need more info, just ask. I'll be out of the country
> > >  from July 12 to the morning of July 16, and again from
> > >  July 17 to July 20, so if you'd rather get at this later on,
> > >  it's okay for me ;)
> >
> > You're dmesg output got chopped at the top. Please increase the kernel
> > log buffer size.
> 
> Done, please find attached both 2620 and 2622 full dmesg output,
>  with no clock= or clocksource= parameters.
> 
> > Sounds like your PIT frequency is out of whack, and I'm guessing the
> > generic clocksource watchdog blames the TSC and disqualifies it.
> >
> > Few things to check:
> > 1) Make sure you're running the latest BIOS.
> 
> I'm probably not, though I'm not sure I'd flash anything on such
>  an old machine - been running it since RedHat 9 with the
>  current BIOS. Plus, I removed the floppy drive to make room
>  for an extra IDE disk... it'd take me a little bit to find out whether
>  I still have the floppy drive around.
> 
> > 2) See if booting w/ noapic changes anything
> 
> Nope, 2622+noapic => PIT is still used and clock very quickly
>  lags behind.
> 
> For the moment being I'll keep booting with clocksource=tsc.
> Let me know whether you want me to test anything more...

Hmm. One other thing to check: If you boot 2.6.20 w/ clocksource=pit, is
it consistent w/ 2.6.22 and same slow timekeeping issue shows up?

thanks
-john


