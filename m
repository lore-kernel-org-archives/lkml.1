Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXEUDSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXEUDSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 23:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXEUDSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 23:18:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46904 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXEUDSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 23:18:06 -0400
Date: Sun, 20 May 2007 20:22:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - scan all Kconfig files
Message-Id: <20070520202247.762e398c.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705210235030.1817@scrub.home>
References: <20070520175203.GA24511@uranus.ravnborg.org>
	<Pine.LNX.4.64.0705210235030.1817@scrub.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 03:43:45 +0200 (CEST) Roman Zippel wrote:

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
> I don't think that simply allowing to parse a file multiple times is the 
> right answer, as it duplicates a lot of data. A simple example would be 
> help texts, right now they are per symbol, but they should really be per 
> menu, so archs can provide different help texts for something.
> "source" should become a bit more intelligent and parse a file only once 
> and link the data into the menu structure.
> 
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

how about something that I mentioned a few days ago (in another
mail thread):

Make this work:  (-ENOPATCH)

if S390
include "some s390-specific Kconfig file"
endif

and if ARCH!=S390, don't read that file.

Actually it should be any kconfig-language statements inside
the if-block /methinks.


I understand that *conf treats all kconfig symbols as variable,
but ARCH=blah isn't really variable after it has been set.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
