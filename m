Return-Path: <linux-kernel-owner+w=401wt.eu-S932505AbXIFDEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbXIFDEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 23:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbXIFDEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 23:04:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:45197 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757373AbXIFDEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 23:04:00 -0400
X-Authenticated: #4011369
X-Provags-ID: V01U2FsdGVkX1+B6DIeFQuBnG8U+478M0u/c8A8YzbRDEqVGrEL+e
	/Vf+JPLxj8gEOY
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
From: Syren Baran <sbaran@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0709021940241.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
	 <20070831105447.GA17956@elte.hu>
	 <Pine.LNX.4.64.0708311341510.1817@scrub.home>
	 <20070902092611.GA14783@elte.hu>
	 <Pine.LNX.4.64.0709021940241.1817@scrub.home>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Sep 2007 05:03:57 +0200
Message-Id: <1189047837.6521.37.camel@excalibur>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 03.09.2007, 04:58 +0200 schrieb Roman Zippel:
> Hi,
> 
> On Sun, 2 Sep 2007, Ingo Molnar wrote:
> 
> > > Did you even try to understand what I wrote? I didn't say that it's a 
> > > "common problem", it's a conceptual problem. The rounding has been 
> > > improved lately, so it's not as easy to trigger with some simple busy 
> > > loops.
> > 
> > As i mentioned it in my first reply to you i really welcome your changes 
> > and your interest in the Linux scheduler, but i'm still somewhat 
> > surprised why you focus on rounding so much (and why you attack CFS's 
> > math implementation so vehemently and IMO so unfairly) - and we had this 
> > discussion before in the "CFS review" thread that you started.
> 
> The rounding is insofar a problem as it makes it very difficult to produce 
> a correct mathematical model of CFS, which can be used to verify the 
> working of code.
> With the recent rounding changes they have indeed little effect in the 
> short term, especially as the error is distributed equally to the task, so 
> every task gets relatively the same time, the error still exists 
> nonetheless and adds up over time (although with the rounding changes it 
> doesn't grow into one direction anymore).
So, its like i roll a dice repeatedly and subtract 3.5 every time? Even
in the long run the the result should be close to zero.
>  The problem is now the limiting, 
> which you can't remove as long as the error exists. Part of this problem
> is that CFS doesn't really maintain a balanced sum of the available 
> runtime, i.e. the sum of all updated wait_runtime values of all active 
> tasks should be zero. This means under complex loads it's possible to hit 
> the wait_runtime limits and the overflow/underflow time is lost in the 
> calculation and this value can be easily in the millisecond range.
> To be honest I have no idea how real this problem in the praxis is right 
> now, quite possibly people will only see it as a small glitch and in most 
> cases they won't even notice.
So, given the above example, if the result of the dice rolls ever
exceeds +/- 1,000,000 i´ll get some ugly timing glitches? As the number
of dice rolls grows towards infinity the chance of remaining within this
boundary goes steadily towards 0%.
What does this equate to in the real world? Weeks, month, years,
milennia?

>  Previously it had been rather easy to 
> trigger these problems due to the rounding problems. The main problem for 
> me here is now that with any substantial change in CFS I'm running risk of 
> making this worse and noticable again somehow. For example CFS relies on 
> the 64bit math to have enough resolution so that the errors aren't 
> noticable.
> That's why I needed a mathematical model I can work with and with it for 
> example I can easily downscale the math to 32bit and I know exactly the 
> limits within it will work correctly.

If i understand the problem correctly these errors occur due to the fact
that delta-values are used instead of recalculating the "fair" process
time every "dice" roll?
Somehow the dead simple solution would seem to "reset" or "reinitialise"
the "dice" roll every million rolls or so.
Or, to put this into context again, figure out how large the accumulated
error would have to be to be noticable. Then figure out how long it
would take for such an error occur in the real world and just
reinitialise the damn thing. Should´nt be too complicated stochastics.

Greetings,
Syren

