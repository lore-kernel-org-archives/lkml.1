Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXDDUxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXDDUxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXDDUxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:53:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46590 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXDDUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:53:50 -0400
Subject: Re: [PATCH -mm] fix jiffies clocksource inittime
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>
In-Reply-To: <20070404134310.12ad3ab8.akpm@linux-foundation.org>
References: <1175716216.17711.59.camel@localhost>
	 <20070404134310.12ad3ab8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 13:53:47 -0700
Message-Id: <1175720027.17711.69.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 13:43 -0700, Andrew Morton wrote:
> On Wed, 04 Apr 2007 12:50:15 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > 	In debugging a problem w/ the -rt tree, I noticed that on systems that
> > mark the tsc as unstable before it is registered, the TSC would still be
> > selected and used for a short period of time. Digging in it looks to be
> > a result of the mix of the clocksource list changes and my clocksource
> > initialization changes.
> > 
> > With the -rt tree, using a bad TSC, even for a short period of time can
> > results in a hang at boot. I was not able to reproduce this hang w/
> > mainline, but I'm not completely certain that someone won't trip on it.
> > 
> > This patch resolves the issue by initializing the jiffies clocksource
> > earlier so a bad TSC won't get selected just because nothing else is yet
> > registered.
> > 
> > thanks
> > -john
> > 
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> > 
> > diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> > index 3be8da8..4c256fd 100644
> > --- a/kernel/time/jiffies.c
> > +++ b/kernel/time/jiffies.c
> > @@ -69,4 +69,4 @@ static int __init init_jiffies_clocksour
> >  	return clocksource_register(&clocksource_jiffies);
> >  }
> >  
> > -module_init(init_jiffies_clocksource);
> > +core_initcall(init_jiffies_clocksource);
> 
> Do you think this is needed in 2.6.21?
> 
> If so: worrisome.  Startup ordering issues are fragile and tricky.  Time
> management is fragile and tricky.  The combination of the two doesn't get
> any better ;)

Its likely low-risk, however I'm pretty cautious this close to release.

> An option would be to test it in 2.6.22-rcX for a while, then backport to
> 2.6.21.x.

I'm fine with this (also getting it into the next -mm would help). But
I'd defer to others with stronger opinions.

thanks
-john

