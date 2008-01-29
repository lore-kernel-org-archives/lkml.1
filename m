Return-Path: <linux-kernel-owner+w=401wt.eu-S1762477AbYA2A43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762477AbYA2A43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYA2A4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:56:21 -0500
Received: from smtp1.Stanford.EDU ([171.67.22.28]:38085 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYA2A4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:56:20 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 19:56:20 EST
Subject: Re: 2.6.24-rt1: timing problems (was [git pull] x86/hrtimer/acpi
	fixes)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>
In-Reply-To: <1201544775.9506.1.camel@cmn3.stanford.edu>
References: <20071207183633.GC26778@elte.hu>
	 <1197053386.32023.13.camel@cmn3.stanford.edu>
	 <20071207185920.GA3006@elte.hu>
	 <1197055769.32023.22.camel@cmn3.stanford.edu>
	 <1197056910.32023.25.camel@cmn3.stanford.edu>
	 <20071207195958.GA12529@elte.hu>
	 <1197076100.32023.67.camel@cmn3.stanford.edu>
	 <20071208091706.GB20516@elte.hu>
	 <1201399193.18590.11.camel@cmn3.stanford.edu>
	 <1201409168.5295.26.camel@homer.simson.net>
	 <1201544775.9506.1.camel@cmn3.stanford.edu>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 16:47:07 -0800
Message-Id: <1201567627.9506.29.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-28 at 10:26 -0800, Fernando Lopez-Lezcano wrote:
> On Sun, 2008-01-27 at 05:46 +0100, Mike Galbraith wrote:
> > On Sat, 2008-01-26 at 17:59 -0800, Fernando Lopez-Lezcano wrote:
> > 
> > > Hi Ingo... back to testing. 
> > > History:
> > > 
> > > 2.6.23.x + rt has not been very usable for audio applications. 
> > > 2.6.24-rt1: same so far. 
> > > 
> > > Why: Jack keeps printing "delayed..." messages and has xruns which means
> > > that somehow the timing is delayed more than what jack would think
> > > reasonable. As in the case with an old timing bug, the problem
> > > dissapears when booting the kernel with idle=poll. Other users of Planet
> > > CCRMA are able to replicate the behavior, which goes away with idle=poll
> > > or booting the machine with only one core. As a workaround I have been
> > > packaging 2.6.22.x but now I'm not able to use that as the old rt14
> > > patch, suitably tweaked results in a non working kernel. 
> > > 
> > > So it looks like, again, timing is getting skewed when the jack process
> > > jumps between cpus and thus jack sees timing jumps that are just not
> > > happenning. 
> > > 
> > > This is with a build based on 2.6.24 using as a base the latest Fedora
> > > rawhide source package plus 2.6.24-rt1. 
> > 
> > Do you have a simple testcase?  (one which doesn't entail installing
> > ccrma and becoming an audiophile)
> 
> No, I don't at this point. 
> I'll see if I can cook something simple today... (naively thinking that
> some short C code could test for the clock being actually monotonic
> across cpus). 

Sorry, no luck so far in writing something simple that will fail. I
tried testing for the results from repeated calls to clock_gettime (what
jack uses for timing by default) to actually be monotonic, while a
script uses taskset to force a cpu switch and of course got no errors. 

2.6.24-rt1 with idle=poll works fine, without it I get multiple problems
with the jack internal timing, or least that is what it seems to me from
the symptoms. 

-- Fernando


