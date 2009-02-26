Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZBZVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZBZVz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZBZVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:55:13 -0500
Received: from www.tglx.de ([62.245.132.106]:49977 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbZBZVzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:55:11 -0500
Date: Thu, 26 Feb 2009 22:54:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <1235684809.6811.5.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902262249390.9135@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc> <1235684809.6811.5.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, john stultz wrote:
> On Thu, 2009-02-26 at 22:35 +0100, Jesper Krogh wrote:
> > john stultz wrote:
> > > On Thu, Feb 26, 2009 at 12:43 PM, Jesper Krogh <jesper@krogh.cc> wrote:
> > >> Linus Torvalds wrote:
> > >>> On Thu, 26 Feb 2009, Jesper Krogh wrote:
> > >>>> 2.6.26.8 doesnt have this problem.
> > >>>>
> > >>>> The "current_clocsource" is the same on both systems.
> > >>>>
> > >>>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> > >>>> tsc
> > >>> What does the frequency calibrate to? It should be in the dmesg. Does it
> > >>> differ by a big amount?
> > >> Non-working:
> > >> $ dmesg | grep -i freq
> > >> [    0.004007] Calibrating delay loop (skipped), value calculated using
> > >> timer frequency.. 4620.05 BogoMIPS (lpj=9240104)
> > >>
> > >> 2.6.26.8 doesn't have that information.
> > > 
> > > I'm surprised the clocksource watchdog isn't catching it.
> > > 
> > > What's the output from:
> > > cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > 
> > $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > tsc acpi_pm jiffies
> 
> Hmm. Does booting w/ "clocksourc=acpi_pm" also show the severe (~550ppm,
> which NTP can't handle) drift?
> 
> >From the dmesg, I don't see any major calibration difference right off. 
> 
> So I'd suspect something like TSC halting in idle could be causing
> problems, but the watchdog should catch that as well. My only guess at
> this point is that the ACPI PM is halting in idle along with the TSC. 

But why would it do that on 29-rc6 and not on 2.6.28.8 ? I'm not aware
of changes which might cause that.

Thanks,

	tglx
