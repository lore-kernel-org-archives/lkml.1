Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXEUBnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXEUBnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbXEUBnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:43:33 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4281 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbXEUBnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:43:32 -0400
Date: Mon, 21 May 2007 03:43:45 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - scan all Kconfig files
In-Reply-To: <20070520175203.GA24511@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705210235030.1817@scrub.home>
References: <20070520175203.GA24511@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 20 May 2007, Sam Ravnborg wrote:

> I did a quick hack so kconfig could scan all Kconfig files
> in the kernel tree.
> By scanning all Kconfig files we gain the following:
> 
> -> kconfig can report when a depends on refer to an undefined symbol
> -> kconfig can report when a select refer to an undefined symbol
> 
> Later we can push a lot of common stuff to the top-level Kconfig file.
> And that may in the end result in a better structure overall for
> Kconfig files.

Well, some of that stuff should already happen earlier (and included from 
the arch Kconfig files), but that doesn't work for everything.
I don't think that simply allowing to parse a file multiple times is the 
right answer, as it duplicates a lot of data. A simple example would be 
help texts, right now they are per symbol, but they should really be per 
menu, so archs can provide different help texts for something.
"source" should become a bit more intelligent and parse a file only once 
and link the data into the menu structure.

> All the "choice values currently only support a single prompt" are caused
> by using the same config symbol in a choice list for several architectures.
> That will be the biggest challenge to fix before we can introduce this patch.
> Maybe we can extend kconfig to accept it???

Define "accept".
The basic rule for choice values must not be violated - none of them may 
depend on another value in the same group. The dependency tree allows for 
no loops, these choice groups allow for the only exception, but it has to 
stay within that group.
One option I'm thinking about is to extend that group by naming the choice 
option, so kconfig knows they are related. This won't work for everything, 
so quite some renaming may be needed.

bye, Roman
