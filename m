Return-Path: <linux-kernel-owner+w=401wt.eu-S965498AbXCLK2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965498AbXCLK2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965506AbXCLK2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:28:12 -0400
Received: from mail13.syd.optusnet.com.au ([211.29.132.194]:59199 "EHLO
	mail13.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965498AbXCLK2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:28:11 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Mon, 12 Mar 2007 21:27:41 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <200703122022.43021.kernel@kolivas.org> <1173692286.20540.12.camel@Homer.simpson.net>
In-Reply-To: <1173692286.20540.12.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122127.41942.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 20:38, Mike Galbraith wrote:
> On Mon, 2007-03-12 at 20:22 +1100, Con Kolivas wrote:
> > On Monday 12 March 2007 19:55, Mike Galbraith wrote:
> > > On Mon, 2007-03-12 at 19:29 +1100, Con Kolivas wrote:
> > > > I'll save you the trouble. I just checked myself and indeed the load
> > > > is only 1. What this means is that although there are 2 tasks
> > > > running, only one is running at any time making a total load of 1.
> > > > So, if we add two other tasks that add 2 more to the load the total
> > > > load is 3. However if we weight the other two tasks at nice 5, they
> > > > only add .75 each to the load making a weighted total of 2.5. This
> > > > means that X+Gforce together should get a total of 1/2.5 or 40% of
> > > > the overall cpu. That sounds like exactly what you're describing is
> > > > happening.
> > >
> > > Hmm.  So... anything that's client/server is going to suffer horribly
> > > unless niced tasks are niced all the way down to 19?
> >
> > Fortunately most client server models dont usually have mutually
> > exclusive cpu use like this X case. There are many things about X that
> > are still a little (/me tries to think of a relatively neutral term)...
> > wanting. :(
>
> But the reality of X is what we have to deal with.

And unix.

> This scheduler seems to close the corner cases of the interactivity
> estimator, but this "any background load is palpable" thing is decidedly
> detrimental to interactive feel.

Now I think you're getting carried away because of your expectations from the 
previous scheduler and its woefully unfair treatment towards interactive 
tasks. Look at how you're loading up your poor P4 even with HT. You throw 2 
cpu hogs only gently niced at it on top of your interactive tasks. If you're 
happy to nice them +5, why not more? And you know as well as anyone that the 
2nd logical core only gives you ~25% more cpu power overall so you're asking 
too much of it. Let's not even talk about how lovely this will (not) be once 
SMT nice gets killed off come 2.6.21 and nice does less if "buyer beware" you 
chose to enable HT in your own words.

> When I looked into keeping interactive tasks responsive, I came to the
> conclusion that I just couldn't get there from here across the full
> spectrum of cpu usage without a scheduler hint.  Interactive feel is
> absolutely dependent upon unfairness in many cases, and targeting that
> unfairness gets it right where heuristics sometimes can't.

See above. Your expectations of what you should be able to do are simply 
skewed. Find what cpu balance you loved in the old one (and I believe it 
wasn't that much more cpu in favour of X if I recall correctly) and simply 
change the nice setting on your lame encoder - since you're already setting 
one anyway.

We simply cannot continue arguing that we should dish out unfairness in any 
manner any more. It will always come back and bite us where we don't want it. 
We are getting good interactive response with a fair scheduler yet you seem 
intent on overloading it to find fault with it.

> 	-Mike

-- 
-ck
