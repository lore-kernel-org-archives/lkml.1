Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbXHEHOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbXHEHOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 03:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbXHEHNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 03:13:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbXHEHNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 03:13:50 -0400
Date: Sun, 5 Aug 2007 09:13:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: J??rn Engel <joern@logfs.org>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805071320.GC515@elte.hu>
References: <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804224834.5187f9b7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804224834.5187f9b7@the-village.bc.nu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > People just need to know about the performance differences - very 
> > > few realise its more than a fraction of a percent. I'm sure Gentoo 
> > > will use relatime the moment anyone knows its > 5% 8)
> > 
> > noatime,nodiratime gave 50% of wall-clock kernel rpm build 
> > performance improvement for Dave Jones, on a beefy box. Unless i 
> > misunderstood what you meant under 'fraction of a percent' your 
> > numbers are _WAY_ off.
> 
> What numbers - I didn't quote any performance numbers ?

ok, i misunderstood your "very few realise its more than a fraction of a 
percent" sentence, i thought you were saying it's a fraction of a 
percent.

Measurements show that noatime helps 20-30% on regular desktop 
workloads, easily 50% for kernel builds and much more than that (in 
excess of 100%) for file-read-intense workloads. We cannot just walk 
past such a _huge_ performance impact so easily without even reacting to 
the performance arguments, and i'm happy Ubuntu picked up 
noatime,nodiratime and is whipping up the floor with Fedora on the 
desktop.

just look at the spontaneous feedback this thread prompted:

| ...For me, I would say 50% is not enough to describe the _visible_ 
| benefits... Not talking any specific number but past 10sec-1min+ 
| lagging in X is history, it's gone and I really don't miss it that 
| much... :-) Cannot reproduce even a second long delay anymore in 
| window focusing under considerable load as it's basically 
| instantaneous (I can see that it's loaded but doesn't affect the 
| feeling of responsiveness I'm now getting), even on some loads that I 
| couldn't previously even dream of... I still can get drawing lag a bit 
| by pushing enough stuff to swap but still it's definately quite well 
| under control, though rare 1-2 sec spikes in drawing appear due to 
| swap loads I think. ...And this is 2.6.21.5 so no fancies ala Ingo's 
| CFS or so yet...
|
| ...Thanks about this hint. :-)

much of the hard performance work we put into the kernel and into 
userspace is basically masked by the atime stupidity. How many man-years 
did it take to implement prelink? It has less of an impact than noatime! 
How much effort did we put into smart readahead and bootup 
optimizations? It has less of an impact than noatime.

	Ingo
