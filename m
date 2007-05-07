Return-Path: <linux-kernel-owner+w=401wt.eu-S967135AbXEGWgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967135AbXEGWgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967128AbXEGWgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:36:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41403 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967129AbXEGWgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:36:04 -0400
Date: Tue, 8 May 2007 00:36:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig: error out if recursive dependencies are found
Message-ID: <20070507223604.GC4226@stusta.de>
References: <20070502201741.GD9044@uranus.ravnborg.org> <20070506073615.GA6492@uranus.ravnborg.org> <20070506074038.GB6492@uranus.ravnborg.org> <Pine.LNX.4.64.0705070221500.1479@scrub.home> <20070507193707.GA19985@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070507193707.GA19985@uranus.ravnborg.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 09:37:07PM +0200, Sam Ravnborg wrote:
> On Mon, May 07, 2007 at 02:38:36AM +0200, Roman Zippel wrote:
> > Hi,
> > 
> > On Sun, 6 May 2007, Sam Ravnborg wrote:
> > 
> > >  	if (sym->flags & SYMBOL_CHECK) {
> > > -		printf("Warning! Found recursive dependency: %s", sym->name);
> > > +		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
> > > +		        sym->prop->file->name, sym->prop->lineno, sym->name);
> > >  		return sym;
> > >  	}
> > 
> > If it were that simple to print the location, I had done it already. :)
> > Try this:
> > 
> > config FOO
> >         bool
> >         select BAR
> >         depends on BAR
> > 
> > config BAR
> >         bool
> > 
> > I looked into this before, for simple properties one could just remember 
> > the last checked property via a static variable. The problem are the 
> > selects which are checked before that loop, here the information from 
> > where they were selected is not available anymore (at least not easily).
> 
> We need to point out _one_ of the faulty spots only.
> But I see that kconfig records file:line for properties and menu entries
> but not for symbols.
> Any special reason why file:line is omitted for symbols (except size of allocated
> memory)?
> 
> Without looking into details it looks more relevant to have file:line for symbols
> rather than for prompts / properties..

I'm not getting what problem you are trying to solve.

Kconfig has always printed all symbols in the dependency circle, and 
with this information it was never a problem to locate what went wrong.

The only thing that was missing was that the error often wasn't detected 
since it scroled away, so we need to error out.

I have no problem with more information being printed, but at least for 
me it isn't required since grep'ing for it is trivial.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

