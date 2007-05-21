Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbXEUKk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbXEUKk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbXEUKks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:40:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60346 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbXEUKkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:40:47 -0400
Date: Mon, 21 May 2007 12:41:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - scan all Kconfig files
Message-ID: <20070521104143.GA32716@uranus.ravnborg.org>
References: <20070520175203.GA24511@uranus.ravnborg.org> <Pine.LNX.4.64.0705210235030.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705210235030.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 03:43:45AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Sun, 20 May 2007, Sam Ravnborg wrote:
> 
> > I did a quick hack so kconfig could scan all Kconfig files
> > in the kernel tree.
> > By scanning all Kconfig files we gain the following:
> > 
> > -> kconfig can report when a depends on refer to an undefined symbol
> > -> kconfig can report when a select refer to an undefined symbol
> > 
> > Later we can push a lot of common stuff to the top-level Kconfig file.
> > And that may in the end result in a better structure overall for
> > Kconfig files.
> 
> Well, some of that stuff should already happen earlier (and included from 
> the arch Kconfig files), but that doesn't work for everything.
Agreed - but it seems that cleaning up Kconfig files are not sexy enough.

> I don't think that simply allowing to parse a file multiple times is the 
> right answer, as it duplicates a lot of data. A simple example would be 
> help texts, right now they are per symbol, but they should really be per 
> menu, so archs can provide different help texts for something.
> "source" should become a bit more intelligent and parse a file only once 
> and link the data into the menu structure.
My quick hack was to parse the files only once which is obviously wrong.

I do not get the part about help text pr. menu??

I was more considering that we could share as much as possible between two symbols
that are identical except for their dependencies.

> > All the "choice values currently only support a single prompt" are caused
> > by using the same config symbol in a choice list for several architectures.
> > That will be the biggest challenge to fix before we can introduce this patch.
> > Maybe we can extend kconfig to accept it???
> 
> Define "accept".
> The basic rule for choice values must not be violated - none of them may 
> depend on another value in the same group. The dependency tree allows for 
> no loops, these choice groups allow for the only exception, but it has to 
> stay within that group.
> One option I'm thinking about is to extend that group by naming the choice 
> option, so kconfig knows they are related. This won't work for everything, 
> so quite some renaming may be needed.
I do not follow you completely here.

Anyway - the main purpose was to say that there are other ways to deal with
select than just ignoring an otherwise good warning.

	Sam
