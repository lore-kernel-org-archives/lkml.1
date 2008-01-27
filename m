Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYA0CK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYA0CK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYA0CKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:10:51 -0500
Received: from smtp3.Stanford.EDU ([171.67.20.26]:58431 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYA0CKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:10:50 -0500
X-Greylist: delayed 652 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jan 2008 21:10:50 EST
Subject: Re: 2.6.24-rt1: timing problems (was [git pull] x86/hrtimer/acpi
	fixes)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>
In-Reply-To: <20071208091706.GB20516@elte.hu>
References: <20071207183633.GC26778@elte.hu>
	 <1197053386.32023.13.camel@cmn3.stanford.edu>
	 <20071207185920.GA3006@elte.hu>
	 <1197055769.32023.22.camel@cmn3.stanford.edu>
	 <1197056910.32023.25.camel@cmn3.stanford.edu>
	 <20071207195958.GA12529@elte.hu>
	 <1197076100.32023.67.camel@cmn3.stanford.edu>
	 <20071208091706.GB20516@elte.hu>
Content-Type: text/plain
Date: Sat, 26 Jan 2008 17:59:53 -0800
Message-Id: <1201399193.18590.11.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-08 at 10:17 +0100, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > On Fri, 2007-12-07 at 20:59 +0100, Ingo Molnar wrote:
> > > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > > 
> > > > > Nope, it doesn't still getting "delay" and "xrun" messages galore.
> > > > 
> > > > Attached: configuration and dmesg output booting with idle=poll, 
> > > > reconfirmed that that makes the delay and xrun messages go away.
> > > 
> > > could you try the rolled up patch of various fixlets, ontop of 
> > > current -git? (it might even apply to -rc4) It includes some more 
> > > stuff beyond the ones in the pull request. (still being 
> > > tested/reviewed)
> > 
> > I'll try but it will take me a while to figure git and do a package 
> > build of it...
> 
> if you want to try a vanilla kernel package then pick up the kernel 
> package from Fedora rawhide - this fixlet should show up there within a 
> couple of days, Dave Jones is doing a really nice job of keeping up with 
> latest -git. (and the Fedora kernel has hrtimers and dynticks enabled.)

Hi Ingo... back to testing. 
History:

2.6.23.x + rt has not been very usable for audio applications. 
2.6.24-rt1: same so far. 

Why: Jack keeps printing "delayed..." messages and has xruns which means
that somehow the timing is delayed more than what jack would think
reasonable. As in the case with an old timing bug, the problem
dissapears when booting the kernel with idle=poll. Other users of Planet
CCRMA are able to replicate the behavior, which goes away with idle=poll
or booting the machine with only one core. As a workaround I have been
packaging 2.6.22.x but now I'm not able to use that as the old rt14
patch, suitably tweaked results in a non working kernel. 

So it looks like, again, timing is getting skewed when the jack process
jumps between cpus and thus jack sees timing jumps that are just not
happenning. 

This is with a build based on 2.6.24 using as a base the latest Fedora
rawhide source package plus 2.6.24-rt1. 

-- Fernando


