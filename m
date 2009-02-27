Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbZB0Uub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbZB0Uub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZB0UuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:50:22 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53041 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbZB0UuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:50:21 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <20090227073321.GB13850@elte.hu>
References: <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
	 <1235687483.6811.26.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902261434390.3111@localhost.localdomain>
	 <1235689182.6811.34.camel@localhost.localdomain>
	 <20090227073321.GB13850@elte.hu>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 12:50:00 -0800
Message-Id: <1235767800.7402.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 08:33 +0100, Ingo Molnar wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Thu, 2009-02-26 at 14:40 -0800, Linus Torvalds wrote:
> > > 
> > > On Thu, 26 Feb 2009, john stultz wrote:
> > > > 
> > > > I'll kick up some of my own testing between these two releases to see if
> > > > I can't find something similar.
> > > 
> > > Since the PIT timer read is possibly hw-dependent, it might be that you 
> > > can't necessarily reproduce it on some random hardware.
> > > 
> > > How sensitive is ntpd to (stable) drift? IOW, if we get the calibration 
> > > wrong, the TSC should still hopefully be very _stable_, it's just that the 
> > > initial guesstimate for the frequency is off and ntp would have to correct 
> > > for that.
> >
> > NTP can adjust the clock about +/-500ppm (so a 1000ppm range). 
> > Past that it starts throwing errors.
> 
> Well, it will start throwing errors but still it will correct 
> the clock and find the frequency delta between the host clock 
> and the reference clock just fine, and converge in a couple of 
> hours, correct?

No  NTP spec limits the freq correction to ~+/-500ppm. Once NTPd hits
that 500ppm wall, it will throw an error and stop trying to sync the
clock.

> 500ppm is 0.05% of a frequency drift which is awfully small - 
> thermal effects alone can cause such differences so it should 
> not be anything out of the ordinary for ntpd.

Practically I've not seen boxes that vary that much. I've seen very poor
systems who's crystals are off by ~280ppm, but those don't vary that
much over time much.


> > Part of the issue is that if the drift value changes in 
> > between boots, NTPd can take a while to settle down on the 
> > right freq. I suspect that's whats happening here, and should 
> > the box be left alone for a few hours (maybe overnight) NTPd 
> > will find the new drift correction the issue will go away.
> 
> If the default poll interval of 64 seconds is used then it can 
> take that much time - so i'd sugges to decrease that to below 10 
> seconds.

Indeed. Shortening the maxpoll value in the ntp.conf greatly improves
how fast and how close the client will sync to the server, but take
caution, as that can cause undue load on public time servers.  

thanks
-john


