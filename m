Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYF0IL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYF0IL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYF0ILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:11:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:32830 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYF0ILG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:11:06 -0400
Date: Fri, 27 Jun 2008 10:12:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alok Kataria <akataria@vmware.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080627081202.GA26613@elf.ucw.cz>
References: <20080604061637.6bab3f67@infradead.org> <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080620113922.GG7439@elte.hu> <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080624175753.GG5642@ucw.cz> <1214500831.3351.10.camel@promb-2n-dhcp368.eng.vmware.com> <20080626173536.GA16783@elf.ucw.cz> <1214503849.3351.35.camel@promb-2n-dhcp368.eng.vmware.com> <20080626221634.GE18719@elf.ucw.cz> <1214521834.3351.54.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214521834.3351.54.camel@promb-2n-dhcp368.eng.vmware.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > AFAIU in calibrate_delay_direct too we measure the amount by which timer
> > > > > has ticked until DELAY_CALIBRATION_TICKS amount of jiffies has passed.
> > > > > So IMO the code there too assumes that there is one loop per timer
> > > > > cycle ?
> > > >
> > > > On my machine, it reports:
> > > >
> > > > delay using timer specific routine.. 3661.98 BogoMIPS (lpj=7323971)
> > > > ...
> > > > Detected 1828.828 MHz processor.
> > > >
> > > > (/proc/cpuinfo)
> > > > model name      : Genuine Intel(R) CPU           T2400  @ 1.83GHz
> > > > ...
> > > > cpu MHz         : 1000.000
> > > How is it 1000 here ? shouldn't this be 1830.xx
> > 
> > cpufreq effect, I believe.
> > 
> > > > bogomips        : 3657.54
> > > >
> > > > So you'd break it by setting lpj (aka bogomips) to cpu_khz, right?
> > >
> > > We are not setting it to cpu_khz but to tsc_khz, i am assuming that in
> > > this case tsc_khz will be different than cpu_khz. Can you please mail me
> > > the full dmesg log.
> > 
> > Yes, but neither cpu_khz nor tsc_khz will be 3657 bogoMips, right?
> 
> Hi Pavel,
> 
> Thanks for the dmesg. The HZ value that you are using on this system is
> 250, right ?
> 
> If you note the calculations
> > +     lpj = ((u64)tsc_khz * 1000);
> > +     do_div(lpj, HZ);
> 
> We are dividing by HZ over here. So you are right in saying that tsc_khz
> wont be equal to bogoMips but lpj_fine will surely be computed correct
> since we do consider the HZ value.

Ok.

> Please let me know if you still have any doubts.
> Or can i safely assume that you will ACK the patch ;-)

Well, I'm not expert-enough in this subsystem (nor comfortable enough
with your code) to ACK it, sorry.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
