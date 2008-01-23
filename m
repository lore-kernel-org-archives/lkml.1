Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbYAWIKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbYAWIKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbYAWIJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:09:59 -0500
Received: from ns1.suse.de ([195.135.220.2]:47619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYAWIJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:09:58 -0500
Date: Wed, 23 Jan 2008 09:09:54 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3)
Message-ID: <20080123080953.GA28855@wotan.suse.de>
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de> <20080121164052.GA11364@elte.hu> <200801211813.45102.ak@suse.de> <alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de> <20080122132355.GA24320@wotan.suse.de> <alpine.LFD.1.00.0801221439520.3199@apollo.tec.linutronix.de> <20080122142147.GD19936@wotan.suse.de> <alpine.LFD.1.00.0801221623210.3199@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801221623210.3199@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your patches just shove another extra into the existing code base
> without doing any consolidation work and without any consideration of
> problems we need to urgently solve in this area.

I fixed the problems in CPA I was aware of -- I'm not aware of 
any other current ones (urgent or not). 

> Your only care is to get stuff merged which is interesting for you. 

Very true -- by definition I'm not interested in things I'm not interested 
in. Thanks for reminding me of that :-) However it would surprise 
me if that was different for you or anybody else.

> can understand that, but it should be entirely clear to you as an
> engineer that ignoring the existing problems and adding more (even

Can you elaborate on the existing problems in the CPA code? 
(excluding issues already fixed in my CPA patch series) 
I'm truly curious what these are.

> PAT is high on the requirements list, not because it's not complex (it
> definitely is), but simply because Linux has a years long of backlog
> (it's the only modern OS on the planet still not using PAT) and
> hardware makers are stepping beyond the limits of MTRRs. There is an
> increasing number of systems which don't work under Linux properly due
> to the MTRR limitations, but work perfectly fine with other
> OSs. 

Actually I'm not aware of any shipping box that doesn't work currently on Linux
because of no PAT or MTRRs. Do you have an example? I know BIOS 
people have been grumbling about it, but I don't think there were
any real show stoppers so far.

It is pretty hard to imagine that ever being the case anyways. We already
did non caching mappings for quite some time using the page tables
(although admittedly not fully correct and a little unsafe, but probably 
well enough in practice). The only value add that you get from
true PAT support is write-combining and write combining over uncacheable
is always only an optimization; nothing required to make 
boxes work.

Admittedly it is helpful for 3d graphics, but the current state
is that the big out of tree 3d stuff reprograms the PAT registers
on its own. While replacing that with an in tree solution
will be a good idea it is not really all that urgent.

But I'm not saying that that PAT shouldn't be merged 
anyways -- i wouldn't have worked on these patches earlier
if that was the case -- i'm just disagreeing on you
saying it is more important than anything else. I also think
it will take longer to make it really stable enough to be mergeable 
(.26 target would be probably ambitious) so I don't think other patches 
should be delayed for such a long time just because of it.

> While PAT is a 10 years old hardware feature, gbpages is a feature for
> a brand new chip, which is not even available to mere mortals in a
> useable form. And there is no real problem with not having gbpages for

AMD shipped over 400k of them last quarter and they are perfectly usable 
if you run them with an uptodate BIOS.

> some time. So where is the pressure to get that in? 

For me it's mostly that I was sitting too long on that patch
(ok that's my own fault) so I finally want to get it out. 

Also I don't know of any real reason to delay it much longer -- it is 
not particularly tricky and contrary to your claims it does not actually 
interact in a great way with with PAT or anything else pretty much.
Ok there are some changes to CPA, but they're IMNSHO quite
straight forward extensions of already existing code in there.

> Just because it
> can be done and happens to work on some test machine?

When a patch kit works and does not cause any big risks and is 
clean code and there are no fundamental design problems 
what use is there in delaying it unnecessarily? 

-Andi

