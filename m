Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZEIKDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZEIKDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbZEIKC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:02:59 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:40050 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZEIKC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:02:58 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: David Fries <david@fries.net>
Subject: Re: TSC marked unstable on suspend and resume
Date: Sat, 9 May 2009 12:02:42 +0200
User-Agent: KMail/1.9.10
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@tglx.de>
References: <20090221023943.GA4894@spacedout.fries.net> <200905082353.15962.linux@rainbow-software.org> <20090509003415.GJ4162@spacedout.fries.net>
In-Reply-To: <20090509003415.GJ4162@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905091202.46244.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009 02:34:15 David Fries wrote:
> On Fri, May 08, 2009 at 11:53:12PM +0200, Ondrej Zary wrote:
> > On Thursday 30 April 2009 05:37:33 john stultz wrote:
> > > On Wed, 2009-04-29 at 18:25 -0500, David Fries wrote:
> > > > On Wed, Apr 29, 2009 at 09:45:40AM -0700, john stultz wrote:
> > > > > On Fri, Feb 20, 2009 at 7:39 PM, David Fries <david@fries.net> wrote:
> > > > > > I'm getting TSC marked as unsable on hibernate to disk with
> > > > > > 2.6.29-rc3. ?The last kernel I ran 2.6.24.4 ran 300+ days without
> > > > > > a problem and does not loose TSC on hibernate.
> > > > > >
> > > > > > I'm hibernating with `echo disk > /sys/power/state`.
> > > > > > These look like the relavant messages,
> > > > > >
> > > > > > CPU 0 irqstacks, hard=c0379000 soft=c0378000
> > > > > > PID hash table entries: 1024 (order: 10, 4096 bytes)
> > > > > > Fast TSC calibration using PIT
> > > > > > Detected 300.705 MHz processor.
> > > > > > Calibrating delay loop (skipped), value calculated using timer
> > > > > > frequency.. 601.41 BogoMIPS (lpj=300705) hibernate to disk,
> > > > > > Restarting tasks ... done.
> > > > > > Clocksource tsc unstable (delta = 499883531 ns)
> > > > > >
> > > > > > model name      : AMD-K6(tm) 3D processor
> > > > > > Host bridge: VIA Technologies, Inc. VT82C598 [Apollo MVP3] (rev
> > > > > > 04)
> > > > >
> > > > > Hmm. Seems like the clocksource watchdog is having some problem
> > > > > handling state around hibernate.
> > >
> > > Yea. This seems to be the case here. There's watchdog code and
> > > variables to handle resume properly, but there isn't a corresponding
> > > suspend hook, so the resume path doesn't actually change anything.
> > >
> > > Here's a patch you can try, I only had time to compile test it today,
> > > so its untested. Hopefully I didn't miss anything obvious.
> >
> > I have the same problem and the patch does not solve it for me too.
>
> What CPU and motherboard chipset?

Cyrix MII PR300 225MHz
PCPartner TXB820DS (i430TX)

> > I noticed that after resume, ping is unable to measue short time
> > correctly: 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.000 ms
> >
> > "echo tsc
> > >/sys/devices/system/clocksource/clocksource0/current_clocksource" fixes
> > the problem until next hibernation:
> > 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.223 ms
>
> I didn't know about that, thanks for posting the tip.



-- 
Ondrej Zary
