Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYFZRoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYFZRoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYFZRos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:44:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59128 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYFZRor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:44:47 -0400
Date: Thu, 26 Jun 2008 19:35:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alok Kataria <akataria@vmware.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080626173536.GA16783@elf.ucw.cz>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com> <20080603182014.79a38d03@infradead.org> <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com> <20080604061637.6bab3f67@infradead.org> <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080620113922.GG7439@elte.hu> <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080624175753.GG5642@ucw.cz> <1214500831.3351.10.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214500831.3351.10.camel@promb-2n-dhcp368.eng.vmware.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-26 10:20:31, Alok Kataria wrote:
> On Tue, 2008-06-24 at 10:57 -0700, Pavel Machek wrote:
> > Hi!
> > 
> > > On X86 platform we can use the value of tsc_khz computed during tsc calibration
> > > to calculate the loops_per_jiffy value. Its very important to keep the error in
> > > lpj values to minimum as any error in that may result in kernel panic in
> > > check_timer.
> > > In virtualization environment, On a highly overloaded host the guest delay
> > > calibration may sometimes result in errors beyond the ~50% that timer_irq_works
> > > can handle, resulting in the guest panicking.
> > 
> > How did you adress 'khz has nothing to do with loops per jiffie'
> > comment?
> > 
> > Some cpus can do loop in cycle , some need two cycles, some need half.
> 
> Hi Pavel, 
> 
> When you say loops per jiffies has nothing to do with khz, by khz you
> mean the cpu frequency, right ?

Yes.

> AFAIU in calibrate_delay_direct too we measure the amount by which timer
> has ticked until DELAY_CALIBRATION_TICKS amount of jiffies has passed.
> So IMO the code there too assumes that there is one loop per timer
> cycle ?

On my machine, it reports:

delay using timer specific routine.. 3661.98 BogoMIPS (lpj=7323971)
...
Detected 1828.828 MHz processor.

(/proc/cpuinfo)
model name	: Genuine Intel(R) CPU           T2400  @ 1.83GHz
...
cpu MHz		: 1000.000
...
bogomips	: 3657.54

So you'd break it by setting lpj (aka bogomips) to cpu_khz, right?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
