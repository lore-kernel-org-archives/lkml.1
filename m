Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZJZIZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZJZIZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbZJZIZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:25:33 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50372 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbZJZIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:25:31 -0400
Date: Mon, 26 Oct 2009 13:55:25 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v9 PATCH 4/9]: x86: refactor x86 idle power management code
	and remove all instances of pm_idle.
Message-ID: <20091026082524.GC17689@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091016093850.GB27350@linux.vnet.ibm.com> <20091016094308.GF27350@linux.vnet.ibm.com> <20091023160711.GB1431@ucw.cz> <20091026075550.GB17689@linux.vnet.ibm.com> <20091026075831.GB22625@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091026075831.GB22625@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [2009-10-26 08:58:31]:

> 
> > > > +static int local_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
> > > > +{
> > > > +	ktime_t t1, t2;
> > > > +	s64 diff;
> > > > +	int ret;
> > > > +
> > > > +	t1 = ktime_get();
> > > > +	local_idle();
> > > > +	t2 = ktime_get();
> > > > +
> > > > +	diff = ktime_to_us(ktime_sub(t2, t1));
> > > > +	if (diff > INT_MAX)
> > > > +		diff = INT_MAX;
> > > > +	ret = (int) diff;
> > > > +
> > > > +	return ret;
> > > > +}
> > > 
> > > So we get this routine essentially 3 times. Is there no way to share
> > > the code?
> > > 
> > 
> > We can move this code to a common place, but that would mean exporting
> > the idle function pointer to be called from within this routine, which
> > is exactly what we wanted to avoid.
> > 
> > Any suggestions are welcome.
> 
> You can just pass idle routine as a parameter...?
> 
> int common_idle_loop(struct cpuidle_device *dev, struct cpuidle_state
> *st, void *idle(void))
> 
> ...?
> 									Pavel

Yes, this should be fine. I was trying to avoid passing the void
function pointer around but i guess this reduces considerable code
size.

thanks!
arun
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
