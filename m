Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbYEKVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbYEKVUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbYEKVU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:20:26 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46218 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbYEKVUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:20:25 -0400
Date: Mon, 12 May 2008 00:19:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511211902.GI1645@cs181133002.pp.htv.fi>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511175222.GA31729@uranus.ravnborg.org> <20080511184952.GG1645@cs181133002.pp.htv.fi> <20080511194248.GA514@uranus.ravnborg.org> <20080511200016.GH1645@cs181133002.pp.htv.fi> <20080511203827.GA850@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080511203827.GA850@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 10:38:27PM +0200, Sam Ravnborg wrote:
> > > 
> > > You continue to fail to acknowledge that it is valueable information
> > > that we pass gcc a _hint_ that it is a good idea to inline certain
> > > functions.
> > > 
> > > The inline hint is there to tell gcc that it shall inline this function
> > > in cases where it usual think it should not do so. Which invietably
> > > will result in a larger codesize in some cases.
> > 
> > We also give gcc an explicit "Optimize for size.".
> 
> gcc was asked to optimize for size in general as per the commandline option.
> But on a much more fine grained level gcc is given a hint that
> this function would be a good idea to inline.
> 
> And I really expect gcc to pay most attention to the more specific
> information provided for a single function than a general commandline option.

Can you try to get from expectations back to reality?

gcc 4.3 even ignores the unlikely() hint in timespec_add_ns()
(we now have a workaround for this in the kernel).

>...
> > All the "optimized inlining" does is to allow gcc to no longer inline 
> > functions marked as "inline" if it prefers not to do so.
> The "optimized inlining" allows gcc (if gcc > 4.0) to make an educated
> guess if it is worhtwhile to inline a function or not. And when deciding
> to do so or not gcc may include many different factors inlcuding
> but not limited to -s.
> And this is certainly optimized compared to the situation where
> inline equals to always_inline.
> Keep in mind that we often perfer to have _less_ inlining than we have
> today for debugging ease. And this is what we get with optimized inlining
> compared to farced inlining.
> 
> > 
> > And what exactly is your problem with my patch if you consider the 
> > general "optimized inlining" approach correct?
> 
> I've already listed two things:
> -> It is no longer a simple kconfig change to try with or without.
> -> It is independent on gcc version

I already asked you previously in this thread:

Do we have any hard data that gcc < 4.0 has a "broken inline algorithm" 
and all gcc versions >= 4.0 have a "working inline algorithm"?

> And for fast path code like sched.c I would much assume a proper analysis
> when it is acceptable to remove the inline hint is almost mandatory.
>...

Why didn't you request a proper analysis before the "optimized inlining" 
stuff hit Linus' tree?

After all, the "default y" option that went into the tree didn't have 
any indication to the user that there might be problems caused by it.

Currently it's marked as BROKEN, but it might resurface.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

