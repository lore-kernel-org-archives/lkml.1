Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbYEKUBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbYEKUBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbYEKUBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:01:39 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48688 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503AbYEKUBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:01:38 -0400
Date: Sun, 11 May 2008 23:00:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511200016.GH1645@cs181133002.pp.htv.fi>
References: <20080511092132.GE1645@cs181133002.pp.htv.fi> <20080511175222.GA31729@uranus.ravnborg.org> <20080511184952.GG1645@cs181133002.pp.htv.fi> <20080511194248.GA514@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080511194248.GA514@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 09:42:48PM +0200, Sam Ravnborg wrote:
> On Sun, May 11, 2008 at 09:49:52PM +0300, Adrian Bunk wrote:
> > On Sun, May 11, 2008 at 07:52:22PM +0200, Sam Ravnborg wrote:
>...
> > > The last line "no inline(hint)" is with Adrians patch applied.
> > > So what is obvious from the above is that with the arch/gcc combination
> > > I use here the inline hint has a clear effect and gcc inlines more
> > > when we have given it a hint to do so than without the hint.
> > > I conclude this solely on the cide size change between the line
> > > "inline hint" and "no inline(hint)".
> > > 
> > > With adrians patch there were no difference in size with or
> > > without the OPTIMIZE_INLINING enabled.
> > > 
> > > Or in other words the config option "OPTIMIZE_INLINING" is NOT
> > > equal to removing all the inline annotations.
> > 
> > Both do the same with the same justification:
> > 
> > Both give the decision whether or not to inline completely into the 
> > hands of gcc, which can make different inlining decisions depending on 
> > e.g. the gcc version and the CONFIG_CC_OPTIMIZE_FOR_SIZE setting, and
> > the only thing benchmarked is the code size.
> 
> You continue to fail to acknowledge that it is valueable information
> that we pass gcc a _hint_ that it is a good idea to inline certain
> functions.
> 
> The inline hint is there to tell gcc that it shall inline this function
> in cases where it usual think it should not do so. Which invietably
> will result in a larger codesize in some cases.

We also give gcc an explicit "Optimize for size.".

Do you expect any well-defined behaviour across different gcc versions  
when giving gcc such conflicting information?

If gcc would decide to ignore all hints that increase code size with -Os 
that would be perfectly fine behaviour.

All the "optimized inlining" does is to allow gcc to no longer inline 
functions marked as "inline" if it prefers not to do so.

And what exactly is your problem with my patch if you consider the 
general "optimized inlining" approach correct?

After all, the 2.3% textsize reduction that justified the "optimized 
inlining" comes exactly from the cases where gcc does no longer obey
the "it shall inline this function" hint.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

