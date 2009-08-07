Return-Path: <linux-kernel-owner+w=401wt.eu-S933850AbZHGUaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850AbZHGUaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933754AbZHGUaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:30:03 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39329 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721AbZHGUaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:30:00 -0400
Subject: Re: [GIT pull] timers fixes for 2.6.31
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090807101847.2ee08c76@skybase>
References: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain>
	 <alpine.LFD.2.01.0907301648540.3161@localhost.localdomain>
	 <20090731123711.GA5421@elte.hu>
	 <1f1b08da0908061536o57cebeb6r2f522cb3c5419e1@mail.gmail.com>
	 <20090807101847.2ee08c76@skybase>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 13:28:55 -0700
Message-Id: <1249676935.7185.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 10:18 +0200, Martin Schwidefsky wrote:
> On Thu, 6 Aug 2009 15:36:36 -0700
> john stultz <johnstul@us.ibm.com> wrote:
>  
> > Splitting this up has been on my list for awhile, but I've never
> > gotten to it. However, Martin Schwidefsky has been doing a great job
> > with his latest patches cleaning up some of uglier parts of the
> > timekeeping/clocksource interactions. There is still lots of  changes
> > I'd like to see, but they will take time as we still haven't gotten
> > all the arches over to GENERIC_TIME, so some cruft has to stick
> > around.   But Martin's patches are a great big step towards it and
> > hopefully his patches will be ready for .32.
> 
> The question what we do with the mult_orig on clocksource
> enable/disable is one of the remaining open issues with my patch set.
> With the NTP adjusted multiplicator in the struct timekeeper we don't
> have a convenient place to keep the NTP adjusted multiplier while a
> clocksource is disabled. My initial thought was: why do we store the
> old multiplier at all? Its not that the clocksource changes all the
> time and NTP will catch up again if it is changed. Just start from
> scratch with the initial multiplicator.

Indeed, we don't need to store the adjusted multiplier while a
clocksource is not in use. We just have to make sure every time it is
used, we start with the same original multiplier, so we have a constant
base from which the NTP freq adjustment can be made upon.

I think you're approach (keeping the clocksource mult untouched, and
keeping the adjusted mult in the timekeeper structure)is fine.

thanks
-john

