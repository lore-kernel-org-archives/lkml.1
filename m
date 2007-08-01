Return-Path: <linux-kernel-owner+w=401wt.eu-S1763886AbXHAMVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763886AbXHAMVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXHAMVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:21:01 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1862 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbXHAMVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:21:00 -0400
Date: Wed, 1 Aug 2007 14:21:21 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070801112229.GA11710@elte.hu>
Message-ID: <Pine.LNX.4.64.0708011346510.1817@scrub.home>
References: <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801112229.GA11710@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Ingo Molnar wrote:

> > [...] e.g. in this example there are three tasks that run only for 
> > about 1ms every 3ms, but they get far more time than should have 
> > gotten fairly:
> > 
> >  4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
> >  4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
> >  4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
> >  4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l
> 
> Mike and me have managed to reproduce similarly looking 'top' output, 
> but it takes some effort: we had to deliberately run a non-TSC 
> sched_clock(), CONFIG_HZ=100, !CONFIG_NO_HZ and !CONFIG_HIGH_RES_TIMERS.

I used my old laptop for these tests, where tsc is indeed disabled due to 
instability. Otherwise the kernel was configured with CONFIG_HZ=1000.

> in that case 'top' accounting symptoms similar to the above are not due 
> to the scheduler starvation you suspected, but due the effect of a 
> low-resolution scheduler clock and a tightly coupled timer/scheduler 
> tick to it.

Well, it magnifies the rounding problems in CFS.
I mainly wanted to test a little the behaviour of CFS and I thought a saw 
patch which enabled the use of TSC in these cases, so I didn't check 
sched_clock().

Anyway, I want to point out that this wasn't the main focus of what I 
wrote.

bye, Roman
