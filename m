Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYDOVOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYDOVOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763112AbYDOVO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:14:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762256AbYDOVO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:14:28 -0400
Date: Tue, 15 Apr 2008 23:13:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415211359.GA1531@elte.hu>
References: <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > quite. Here are all the successfull bootups from my (failed) 
> > bisection attempt:
> > 
> >  0773769191d943358a8392fa86abd756d004c4b6
> >  21af0297c7e56024a5ccc4d8ad2a590f9ec371ba
> >  26b8256e2bb930a8e4d4d10aa74950d8921376b8
> >  2a10e7c41254941cac87be1eccdcb6379ce097f5
> >  3aa88cdf6bcc9e510c0707581131b821a7d3b7cb
> >  49914084e797530d9baaf51df9eda77babc98fa8
> >  53a6e2342d73d509318836e320f70cd286acd69c
> >  5be3bda8987b12a87863c89b74b136fdb1f072db
> >  6d5f718a497375f853d90247f5f6963368e89803
> >  7272dcd31d56580dee7693c21e369fd167e137fe
> >  77de2c590ec72828156d85fa13a96db87301cc68
> >  82cfbb008572b1a953091ef78f767aa3ca213092
> >  b75f53dba8a4a61fda1ff7e0fb0fe3b0d80e0c64
> >  c087567d3ffb2c7c61e091982e6ca45478394f1a
> >  d4b37ff73540ab90bee57b882a10b21e2f97939f
> >  fde1b3fa947c2512e3715962ebb1d3a6a9b9bb7d
> 
> Ok, can you try this script
> 
> 	git bisect start
> 	git bisect bad 7fa2ac3728ce828070fa3d5846c08157fe5ef431
> 	git bisect good 0773769191d943358a8392fa86abd756d004c4b6
> 	git bisect good 21af0297c7e56024a5ccc4d8ad2a590f9ec371ba
> 	git bisect good 26b8256e2bb930a8e4d4d10aa74950d8921376b8
> 	git bisect good 2a10e7c41254941cac87be1eccdcb6379ce097f5
> 	git bisect good 3aa88cdf6bcc9e510c0707581131b821a7d3b7cb
> 	git bisect good 49914084e797530d9baaf51df9eda77babc98fa8
> 	git bisect good 53a6e2342d73d509318836e320f70cd286acd69c
> 	git bisect good 5be3bda8987b12a87863c89b74b136fdb1f072db
> 	git bisect good 6d5f718a497375f853d90247f5f6963368e89803
> 	git bisect good 7272dcd31d56580dee7693c21e369fd167e137fe
> 	git bisect good 77de2c590ec72828156d85fa13a96db87301cc68
> 	git bisect good 82cfbb008572b1a953091ef78f767aa3ca213092
> 	git bisect good b75f53dba8a4a61fda1ff7e0fb0fe3b0d80e0c64
> 	git bisect good c087567d3ffb2c7c61e091982e6ca45478394f1a
> 	git bisect good d4b37ff73540ab90bee57b882a10b21e2f97939f
> 	git bisect good fde1b3fa947c2512e3715962ebb1d3a6a9b9bb7d
> 
> and then you'll apparently hit that commit you had compile problems 
> with.  HOWEVER, at that point, just do
> 
> 	git bisect visualize
> 
> and pick a commit somewhere roughly half-way that you suspect is a 
> good point of testing, but not near the range that you had problems 
> with.  If you have compile problems in the middle, pick something that 
> is just one third down, for example. It will make the bisection 
> slower, but considering how unable we've been to make much progress 
> other ways, if we can narrow it down from 1874 commits to something 
> smaller, I suspect we'll be much happier.
> 
> Then you just do
> 
> 	git checkout <sha-you-picked-out-here>
> 
> and compile that one, and check. 
> 
> Besides, while the _optimal_ point is half-way, even if you only 
> remove a third or a quarter of the commits at each stage, it's still 
> going to be an exponential thing.

ok, will try that now.

The 'bad' points i posted are definitely well-established as i 
post-validated them them by looking for the slab.c crash pattern in the 
serial logs and looking at the git commit in the bootup signature. (this 
is more reliable than looking at bisection logs - i tried 4 different 
bisection runs and not all were reliable.)

	Ingo
