Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbXFYFIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbXFYFIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 01:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXFYFH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 01:07:59 -0400
Received: from 1wt.eu ([62.212.114.60]:3154 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXFYFH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 01:07:59 -0400
Date: Mon, 25 Jun 2007 07:04:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Benjamin LaHaise <bcrl@kvack.org>, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
Message-ID: <20070625050424.GZ943@1wt.eu>
References: <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm> <1182734240.26621.2.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 06:33:15PM -0700, david@lang.hm wrote:
> On Sun, 24 Jun 2007, Arjan van de Ven wrote:
> 
> >On Sun, 2007-06-24 at 18:08 -0700, david@lang.hm wrote:
> >>>
> >>>on a system level, size can help performance because you have more
> >>>memory available for other things.  It also reduces download size and
> >>>gives you more space on the live CD....
> >>>
> >>>if you want to make things bigger again, please do this OUTSIDE the
> >>>"optimize for size" option. Because that TELLS you to go for size.
> >>
> >>then do we need a new option 'optimize for best overall performance' that
> >>goes for size (and the corresponding wins there) most of the time, but is
> >>ignored where it makes a huge difference?
> >
> >that isn't so easy. Anything which doesn't have a performance tradeoff
> >is in -O2 already. So every single thing in -Os costs you performance on
> >a micro level.
> 
> this has not been true in the past (assuming that it's true today)
> 
> ok, if you look at a micro-enough level this may be true, but completely 
> ignoring things like download times, the optimizations almost always boil 
> down to trying to avoid jumps, loops, and decision logic at the expense of 
> space.
> 
> however recent cpu's are significantly better as handling jumps and loops, 
> and the cost of cache misses is significantly worse.
> 
> is the list of what's included in -O2 vs -Os different for different 
> CPU's? what about within a single family of processors? (even in the x86 
> family the costs of jumps, loops, and cache misses varies drasticly)
> 
> my understanding was that the optimizations for O2 were pretty fixed.
> 
> >The translation to macro level depends greatly on how things are used
> >(you even have to factor in download times etc)... so that is a fair
> >question to leave up to the user... which is what there is today.
> 
> ignore things like download time for the moment. it's not significant to 
> most people as they don't download things that often, and when they do 
> they are almost always downloading lots of stuff they don't need (drivers 
> for example)
> 
> users are trying to get better performance 90+% of the time when they 
> select -Os. That's why it got moved out of CONFIG_EMBEDDED.

In my experience, -Os produced faster code on gcc-2.95 than -O2 or -O3.
It was not only because of cache considerations, but because gcc used
different tricks to avoid poor optimizations, and at the end, the CPU
ended executing the alternative code faster.

With gcc-3.3, -Os show roughly the same performance as -O2 for me on
various programs. However, with gcc-3.4, I noticed a slow down with
-Os. And with gcc-4, using -Os optimizes only for size, even if the
output code is slow as hell. I've had programs whose speed dropped
by 70% using -Os on gcc-4. But their size was smaller than with older
versions.

But in some situtations, it's desirable to have the smallest possible
kernel whatever its performance. This goes for installation CDs for
instance.

Willy

