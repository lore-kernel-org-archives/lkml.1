Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYEKUiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYEKUiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYEKUhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:37:55 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36931 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYEKUhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:37:54 -0400
Date: Sun, 11 May 2008 22:38:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511203827.GA850@uranus.ravnborg.org>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511175222.GA31729@uranus.ravnborg.org> <20080511184952.GG1645@cs181133002.pp.htv.fi> <20080511194248.GA514@uranus.ravnborg.org> <20080511200016.GH1645@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511200016.GH1645@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > You continue to fail to acknowledge that it is valueable information
> > that we pass gcc a _hint_ that it is a good idea to inline certain
> > functions.
> > 
> > The inline hint is there to tell gcc that it shall inline this function
> > in cases where it usual think it should not do so. Which invietably
> > will result in a larger codesize in some cases.
> 
> We also give gcc an explicit "Optimize for size.".

gcc was asked to optimize for size in general as per the commandline option.
But on a much more fine grained level gcc is given a hint that
this function would be a good idea to inline.

And I really expect gcc to pay most attention to the more specific
information provided for a single function than a general commandline option.

> 
> If gcc would decide to ignore all hints that increase code size with -Os 
> that would be perfectly fine behaviour.
No - see above.

> 
> All the "optimized inlining" does is to allow gcc to no longer inline 
> functions marked as "inline" if it prefers not to do so.
The "optimized inlining" allows gcc (if gcc > 4.0) to make an educated
guess if it is worhtwhile to inline a function or not. And when deciding
to do so or not gcc may include many different factors inlcuding
but not limited to -s.
And this is certainly optimized compared to the situation where
inline equals to always_inline.
Keep in mind that we often perfer to have _less_ inlining than we have
today for debugging ease. And this is what we get with optimized inlining
compared to farced inlining.

> 
> And what exactly is your problem with my patch if you consider the 
> general "optimized inlining" approach correct?

I've already listed two things:
-> It is no longer a simple kconfig change to try with or without.
-> It is independent on gcc version

And for fast path code like sched.c I would much assume a proper analysis
when it is acceptable to remove the inline hint is almost mandatory.
Your patch looks much more like a simple s/ inline//g.
Especially since removing the inline hint is not configurable and
thus it is not an easy task to ask some to try with or without this
patch in two weeks from now where a clean revert is not possible.

	Sam
