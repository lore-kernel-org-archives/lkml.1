Return-Path: <linux-kernel-owner+w=401wt.eu-S965316AbXCAQKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316AbXCAQKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965317AbXCAQKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:10:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965316AbXCAQKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:10:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Date: Thu, 1 Mar 2007 17:12:35 +0100
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu>
In-Reply-To: <20070301145204.GA25304@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011712.36896.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 March 2007 15:52, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > hm. There's some weird bisection artifact here. Here are the commits i 
> > tested, in git-log order:
> > 
> > #1 commit 01363220f5d23ef68276db8974e46a502e43d01d bad
> > #2 commit ee404566f97f9254433399fbbcfa05390c7c55f7 bad
> > #3 commit f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 good
> > #4 commit c827ba4cb49a30ce581201fd0ba2be77cde412c7 bad
> > 
> > if i tell git-bisect that #1 is bad and #3 is good, then it offers me 
> > #2 - that's OK. But when i tell it that #2 is bad, it offers #4 - 
> > which is out of order! The bisection goes off into la-la land after 
> > that and never gets back to a commit that is /after/ the good commit. 
> > How is this possible? (I upgraded from git-1.4.4 to 1.5.0 to make sure 
> > this isnt some git bug that's already fixed.)
> > 
> > i'll try to straighten this out manually, perhaps #3 is in some merge 
> > branch that confuses bisection. Or maybe i misunderstood how 
> > git-bisect works.
> 
> git-bisect gets royally confused on those ACPI merge branches around 
> commit c0cd79d11412969b6b8fa1624cdc1277db82e2fe. Here are my test 
> results so far:
> 
>  commit 01363220f5d23ef68276db8974e46a502e43d01d: bad
>  commit 255f0385c8e0d6b9005c0e09fffb5bd852f3b506: bad
>  commit c0cd79d11412969b6b8fa1624cdc1277db82e2fe: bad
>  commit c24e912b61b1ab2301c59777134194066b06465c: good
>  commit e9e2cdb412412326c4827fc78ba27f410d837e6e: bad
>  commit 79bf2bb335b85db25d27421c798595a2fa2a0e82: bad
>  commit fc955f670c0a66aca965605dae797e747b2bef7d: good
>  commit 70c0846e430881967776582e13aefb81407919f1: good
>  commit 414f827c46973ba39320cfb43feb55a0eeb9b4e8: bad
>  commit f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38: good
>  commit 5f0b1437e0708772b6fecae5900c01c3b5f9b512: bad
>  commit b878ca5d37953ad1c4578b225a13a3c3e7e743b7: bad
>  commit c2902c8ae06762d941fab64198467f78cab6f8cd: bad
>  commit 12e74f7d430655f541b85018ea62bcd669094bd7: bad
>  commit 3388c37e04ec0e35ebc1b4c732fdefc9ea938f3b: bad
>  commit 9f4bd5dde81b5cb94e4f52f2f05825aa0422f1ff: bad
> 
> the results are totally reproducible (i re-tried a few of both the good 
> and the bad commits), i.e. it's not a sporadic condition. Also, a number 
> of the 'bad' commits have no dynticks stuff in them at all, so i'd 
> exclude dynticks.
> 
> could someone suggest a sane way to go with this? Perhaps suggest 
> specific commit IDs to test?

Hm, does 2.6.20-mm2 work?  If not, you can bisect the broken-out sereis
with quilt.

Rafael
