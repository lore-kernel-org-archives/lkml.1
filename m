Return-Path: <linux-kernel-owner+w=401wt.eu-S966345AbXEGTgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966345AbXEGTgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966299AbXEGTgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:36:13 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44923 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966259AbXEGTgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:36:13 -0400
Date: Mon, 7 May 2007 21:37:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: kconfig: error out if recursive dependencies are found
Message-ID: <20070507193707.GA19985@uranus.ravnborg.org>
References: <20070502201741.GD9044@uranus.ravnborg.org> <20070506073615.GA6492@uranus.ravnborg.org> <20070506074038.GB6492@uranus.ravnborg.org> <Pine.LNX.4.64.0705070221500.1479@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705070221500.1479@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 02:38:36AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Sun, 6 May 2007, Sam Ravnborg wrote:
> 
> >  	if (sym->flags & SYMBOL_CHECK) {
> > -		printf("Warning! Found recursive dependency: %s", sym->name);
> > +		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
> > +		        sym->prop->file->name, sym->prop->lineno, sym->name);
> >  		return sym;
> >  	}
> 
> If it were that simple to print the location, I had done it already. :)
> Try this:
> 
> config FOO
>         bool
>         select BAR
>         depends on BAR
> 
> config BAR
>         bool
> 
> I looked into this before, for simple properties one could just remember 
> the last checked property via a static variable. The problem are the 
> selects which are checked before that loop, here the information from 
> where they were selected is not available anymore (at least not easily).

We need to point out _one_ of the faulty spots only.
But I see that kconfig records file:line for properties and menu entries
but not for symbols.
Any special reason why file:line is omitted for symbols (except size of allocated
memory)?

Without looking into details it looks more relevant to have file:line for symbols
rather than for prompts / properties..

	Sam
