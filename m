Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZEIBO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZEIBO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 21:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZEIBOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 21:14:50 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:59431 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZEIBOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 21:14:49 -0400
Date: Fri, 8 May 2009 19:34:15 -0500
From: David Fries <david@fries.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@tglx.de>
Subject: Re: TSC marked unstable on suspend and resume
Message-ID: <20090509003415.GJ4162@spacedout.fries.net>
References: <20090221023943.GA4894@spacedout.fries.net> <20090429232523.GO2862@spacedout.fries.net> <1241062653.7270.44.camel@localhost.localdomain> <200905082353.15962.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905082353.15962.linux@rainbow-software.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 08 May 2009 19:34:21 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 11:53:12PM +0200, Ondrej Zary wrote:
> On Thursday 30 April 2009 05:37:33 john stultz wrote:
> > On Wed, 2009-04-29 at 18:25 -0500, David Fries wrote:
> > > On Wed, Apr 29, 2009 at 09:45:40AM -0700, john stultz wrote:
> > > > On Fri, Feb 20, 2009 at 7:39 PM, David Fries <david@fries.net> wrote:
> > > > > I'm getting TSC marked as unsable on hibernate to disk with
> > > > > 2.6.29-rc3. ?The last kernel I ran 2.6.24.4 ran 300+ days without a
> > > > > problem and does not loose TSC on hibernate.
> > > > >
> > > > > I'm hibernating with `echo disk > /sys/power/state`.
> > > > > These look like the relavant messages,
> > > > >
> > > > > CPU 0 irqstacks, hard=c0379000 soft=c0378000
> > > > > PID hash table entries: 1024 (order: 10, 4096 bytes)
> > > > > Fast TSC calibration using PIT
> > > > > Detected 300.705 MHz processor.
> > > > > Calibrating delay loop (skipped), value calculated using timer
> > > > > frequency.. 601.41 BogoMIPS (lpj=300705) hibernate to disk,
> > > > > Restarting tasks ... done.
> > > > > Clocksource tsc unstable (delta = 499883531 ns)
> > > > >
> > > > > model name      : AMD-K6(tm) 3D processor
> > > > > Host bridge: VIA Technologies, Inc. VT82C598 [Apollo MVP3] (rev 04)
> > > >
> > > > Hmm. Seems like the clocksource watchdog is having some problem
> > > > handling state around hibernate.
> >
> > Yea. This seems to be the case here. There's watchdog code and variables
> > to handle resume properly, but there isn't a corresponding suspend hook,
> > so the resume path doesn't actually change anything.
> >
> > Here's a patch you can try, I only had time to compile test it today, so
> > its untested. Hopefully I didn't miss anything obvious.
> 
> I have the same problem and the patch does not solve it for me too.

What CPU and motherboard chipset?

> I noticed that after resume, ping is unable to measue short time correctly:
> 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.000 ms
> 
> "echo tsc >/sys/devices/system/clocksource/clocksource0/current_clocksource" 
> fixes the problem until next hibernation:
> 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.223 ms

I didn't know about that, thanks for posting the tip.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
