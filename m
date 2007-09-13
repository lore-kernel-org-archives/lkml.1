Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXIMMOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXIMMOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbXIMMNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:13:52 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4654 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbXIMMNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:13:52 -0400
Date: Thu, 13 Sep 2007 14:14:25 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
In-Reply-To: <1189683320.21778.213.camel@twins>
Message-ID: <Pine.LNX.4.64.0709131354220.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu>  <Pine.LNX.4.64.0709121405130.1817@scrub.home>
 <1189683320.21778.213.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 13 Sep 2007, Peter Zijlstra wrote:

> >  There's a good reason 
> > I put that much effort into maintaining a good, but still cheap average, 
> > it's needed for a good task placement.
> 
> While I agree that having this average is nice, your particular
> implementation has the problem that it quickly overflows u64 at which
> point it becomes a huge problem (a CPU hog could basically lock up your
> box when that happens).

If you look at the math, you'll see that I took the overflow into account, 
I even expected it. If you see this effect in my implementation, it would 
be a bug.

> >  There is of course more than one 
> > way to implement this, so you'll have good chances to simply reimplement 
> > it somewhat differently, but I'd be surprised if it would be something 
> > completely different.
> 
> Currently we have 2 approximations in place:
> 
>   (leftmost + rightmost) / 2
> 
> and
> 
>   leftmost + period/2   (where period should match the span of the tree)
> 
> neither are perfect but they seem to work quite well.

You need more than two busy loops. 
There's a reason I implemented a simple simulator first, so I could 
actually study the scheduling behaviour of different load situations. That 
doesn't protect from all surprises of course, but it gives me the 
necessary confidence the scheduler will work reasonably even in weird 
situations.
>From these tests I already know that your approximations only work with 
rather simple loads.

bye, Roman
