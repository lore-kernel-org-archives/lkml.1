Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbZBZW75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbZBZW75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZBZW7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:59:48 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39796 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZBZW7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:59:47 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <alpine.LFD.2.00.0902261434390.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
	 <1235687483.6811.26.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902261434390.3111@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 14:59:42 -0800
Message-Id: <1235689182.6811.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 14:40 -0800, Linus Torvalds wrote:
> 
> On Thu, 26 Feb 2009, john stultz wrote:
> > 
> > I'll kick up some of my own testing between these two releases to see if
> > I can't find something similar.
> 
> Since the PIT timer read is possibly hw-dependent, it might be that you 
> can't necessarily reproduce it on some random hardware.
> 
> How sensitive is ntpd to (stable) drift? IOW, if we get the calibration 
> wrong, the TSC should still hopefully be very _stable_, it's just that the 
> initial guesstimate for the frequency is off and ntp would have to correct 
> for that.

NTP can adjust the clock about +/-500ppm (so a 1000ppm range). Past that
it starts throwing errors.

Part of the issue is that if the drift value changes in between boots,
NTPd can take a while to settle down on the right freq. I suspect that's
whats happening here, and should the box be left alone for a few hours
(maybe overnight) NTPd will find the new drift correction the issue will
go away.

Thomas tripped over this a little while back when the
NTP_INTERVAL_LENGTH change landed, but I think that was prior to 2.6.26,
so its probably the calibration changes discussed, but I wanted to see
if there were any other slight changes that might be contributing to the
issue as well.

thanks
-john


