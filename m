Return-Path: <linux-kernel-owner+w=401wt.eu-S1762481AbXHFGw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762481AbXHFGw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXHFGws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:52:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbXHFGwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:52:47 -0400
Date: Mon, 6 Aug 2007 08:52:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: david@lang.hm
Cc: Diego Calleja <diegocg@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       J??rn Engel <joern@logfs.org>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070806065229.GC31321@elte.hu>
References: <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804224834.5187f9b7@the-village.bc.nu> <20070805071320.GC515@elte.hu> <20070805152231.aba9428a.diegocg@gmail.com> <Pine.LNX.4.64.0708051158260.6905@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708051158260.6905@asgard.lang.hm>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* david@lang.hm <david@lang.hm> wrote:

> i've been a linux sysadmin for 10 years, and have known about noatime 
> for at least 7 years, but I always thought of it in the catagory of 
> 'use it only on your performance critical machines where you are 
> trying to extract every ounce of performance, and keep an eye out for 
> things misbehaving'
> 
> I never imagined that itwas the 20%+ hit that is being described, and 
> with so little impact, or I would have switched to it across the board 
> years ago.
> 
> I'll bet there are a lot of admins out there in the same boat.
> 
> adding an option in the kernel to change the default sounds like a 
> very good first step, even if the default isn't changed today.

yep - but note that this was a gradual effect along the years, today the 
assymetry between CPU performance and disk-seek performance is 
proportionally larger than 10 years ago. Today CPUs are nearly 100 times 
faster than 10 years ago, but disk seeks got only 2-3 times faster. (and 
even that only if you have a high rpm disk - most desktops dont.)

10 years ago noatime was a nifty hack that made a difference if you had 
lots of files. But it still was a problem with no immediate easy 
solution and people developed their counter-arguments. Today the same 
counter-arguments are used, but the situation has evolved alot.

and note that often this has a bigger everyday effect than the tweaking 
of CPU scheduling, IO scheduling or swapping behavior (!). My desktop 
systems rarely swap, have plenty of CPU power to spare, but atime 
updates still have a noticeable latency impact, regardless of the memory 
pressure. Linux has _lots_ of "performance reserves", so people dont 
normally notice when comparing it to other OSs, but still we should not 
be so wasteful with our IO performance, for such a fundamental thing as 
reading files.

	Ingo
