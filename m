Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYEKTm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYEKTm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYEKTmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:42:14 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60326 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbYEKTmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:42:12 -0400
Date: Sun, 11 May 2008 21:42:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511194248.GA514@uranus.ravnborg.org>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511175222.GA31729@uranus.ravnborg.org> <20080511184952.GG1645@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511184952.GG1645@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 09:49:52PM +0300, Adrian Bunk wrote:
> On Sun, May 11, 2008 at 07:52:22PM +0200, Sam Ravnborg wrote:
> > On Sun, May 11, 2008 at 12:21:32PM +0300, Adrian Bunk wrote:
> > > kernel/sched* contained tons of inline's, and the result of removing 
> > > them all is impressing (with x86_64_defconfig)
> > >    text    data     bss     dec     hex filename
> > >   39557    8234     280   48071    bbc7 kernel/sched.o
> > >   41792    8234     280   50306    c482 kernel/sched.o.old
> > > 
> > > That's a 5.3% text size reduction (!), which is more than twice as much 
> > > as the 2.3% the "optimized inlining" achieves on average for the whole 
> > > kernel.
> > 
> > If we compare the size of sched.o in the three cases we see a clear effect:
> > 
> >                   text	   data	    bss	    dec	    hex	filename
> > forced inline:    31257	   2702	    200	  34159	   856f	kernel/sched.o
> > inline hint:      31105	   2702	    200	  34007	   84d7	kernel/sched.o
> > no inline (hint): 30704	   2702	    200	  33606	   8346	kernel/sched.o
> 
> Is this with CONFIG_CC_OPTIMIZE_FOR_SIZE=y?
Yes.
And gcc is:
gcc (GCC) 4.1.1 20070105 (Red Hat 4.1.1-51)
on a i386 box (and built for i386).

> > The last line "no inline(hint)" is with Adrians patch applied.
> > So what is obvious from the above is that with the arch/gcc combination
> > I use here the inline hint has a clear effect and gcc inlines more
> > when we have given it a hint to do so than without the hint.
> > I conclude this solely on the cide size change between the line
> > "inline hint" and "no inline(hint)".
> > 
> > With adrians patch there were no difference in size with or
> > without the OPTIMIZE_INLINING enabled.
> > 
> > Or in other words the config option "OPTIMIZE_INLINING" is NOT
> > equal to removing all the inline annotations.
> 
> Both do the same with the same justification:
> 
> Both give the decision whether or not to inline completely into the 
> hands of gcc, which can make different inlining decisions depending on 
> e.g. the gcc version and the CONFIG_CC_OPTIMIZE_FOR_SIZE setting, and
> the only thing benchmarked is the code size.

You continue to fail to acknowledge that it is valueable information
that we pass gcc a _hint_ that it is a good idea to inline certain
functions.

The inline hint is there to tell gcc that it shall inline this function
in cases where it usual think it should not do so. Which invietably
will result in a larger codesize in some cases.

	Sam
