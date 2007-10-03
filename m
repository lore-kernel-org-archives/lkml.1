Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbXJBXhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbXJBXhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbXJBXhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:37:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48589 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925AbXJBXhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:37:42 -0400
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
From: Mel Gorman <mel@csn.ul.ie>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <4702C1AD.3090701@tmr.com>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	 <1191326858.28962.8.camel@localhost> <20071002121556.GA22864@elte.hu>
	 <20071002172135.GA12182@skynet.ie>  <4702C1AD.3090701@tmr.com>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 01:37:35 +0100
Message-Id: <1191371855.2708.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 18:09 -0400, Bill Davidsen wrote:
> Mel Gorman wrote:
> > On (02/10/07 14:15), Ingo Molnar didst pronounce:
> >> * Mel Gorman <mel@csn.ul.ie> wrote:
> >>
> >>> Dirt. Booting with "profile=sleep,2" is broken in 2.6.23-rc9 and 
> >>> 2.6.23-rc8 but working in 2.6.22. I was checking it out as part of a 
> >>> discussion in another thread and noticed it broken in -mm as well 
> >>> (2.6.23-rc8-mm2). Bisect is in progress but suggestions as to the 
> >>> prime candidates are welcome or preferably, pointing out that I'm an 
> >>> idiot because I missed twiddling some config change.
> >> Mel, does the patch below fix this bug for you? (Note: you will need to 
> >> enable CONFIG_SCHEDSTATS=y too.)
> >>
> > 
> > Nice one Ingo - got it first try. The problem commit was
> > dd41f596cda0d7d6e4a8b139ffdfabcefdd46528 and it's clear that the code removed
> > in this commit is put back by this latest patch.  When applied, profile=sleep
> > works as long as CONFIG_SCHEDSTAT is set.
> > 
> And if it isn't set? I can easily see building a new kernel with stats 
> off and forgetting to change the boot options.
> 

If CONFIG_SCHEDSTAT is off and profile=sleep is set, you see with Ingo's
patch and readprofile;

     0 *unknown*
     0 total                                      0.0000

That is a tad confusing hence my follow-up patch which would say
"/proc/profile" doesn't exist when readprofile is used and the warning
in dmesg.

-- 
Mel Gorman

