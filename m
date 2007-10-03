Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbXJCIWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbXJCIWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXJCIWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:22:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48265 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbXJCIWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:22:09 -0400
Date: Wed, 3 Oct 2007 10:21:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071003082157.GB32218@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <1191326858.28962.8.camel@localhost> <20071002121556.GA22864@elte.hu> <20071002172135.GA12182@skynet.ie> <4702C1AD.3090701@tmr.com> <1191371855.2708.26.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191371855.2708.26.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> > > Nice one Ingo - got it first try. The problem commit was 
> > > dd41f596cda0d7d6e4a8b139ffdfabcefdd46528 and it's clear that the 
> > > code removed in this commit is put back by this latest patch.  
> > > When applied, profile=sleep works as long as CONFIG_SCHEDSTAT is 
> > > set.
> > > 
> > And if it isn't set? I can easily see building a new kernel with 
> > stats off and forgetting to change the boot options.
> 
> If CONFIG_SCHEDSTAT is off and profile=sleep is set, you see with 
> Ingo's patch and readprofile;
> 
>      0 *unknown*
>      0 total                                      0.0000
> 
> That is a tad confusing hence my follow-up patch which would say 
> "/proc/profile" doesn't exist when readprofile is used and the warning 
> in dmesg.

yep - that's the best we can do for the stable release.

We could improve quality of behavior here by not offering /proc/profile 
in that case and by printk-ing something if profile=sleep is specified 
on a !CONFIG_SCHEDSTATS kernel. I'm willing to apply patches that do 
that :)

	Ingo
