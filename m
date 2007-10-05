Return-Path: <linux-kernel-owner+w=401wt.eu-S1762401AbXJECI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762401AbXJECI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 22:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759766AbXJECIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 22:08:49 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4454 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759201AbXJECIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 22:08:49 -0400
Date: Fri, 5 Oct 2007 04:08:45 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Shlomi Fish <shlomif-lkml@freehackers.org>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2.6.23-rc4] qconf ("make xconfig") Search Dialog Enhancement
 (rev8)
In-Reply-To: <200709201350.43553.shlomif-lkml@freehackers.org>
Message-ID: <Pine.LNX.4.64.0710050359021.1817@scrub.home>
References: <200709132252.20719.shlomif@freehackers.org>
 <Pine.LNX.4.64.0709160043430.1817@scrub.home> <200709201350.43553.shlomif-lkml@freehackers.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 20 Sep 2007, Shlomi Fish wrote:

> Which specific problems do you see with the coding style of the patch? Can you 
> comment on it?

Mostly whitespace around any braces, please keep it close to the other 
source.

> > I would also prefer to move more of the search functionality into the
> > generic code, so it can be used by other front ends as well, otherwise a
> > lot of this had to be duplicated.
> 
> That would be a good idea, but I cannot use Qt there, which makes my job 
> harder.

Where is the problem with implementing it in C? Just try to keep it a 
simple at first.

> > I think a filter function makes it maybe a bit to flexible, if a front
> > end wants to do some weird filtering, it can still access the symbol
> > data base directly. 
> 
> A filter function would still be convenient in this context, as the symbol 
> data base API may change, and the filter function has a little logic in it.

This API is not really fixed at the moment, so it's not really a problem.

> > So what I have in mind is something like this: 
> >
> > struct symbol **sym_generic_search(const char *pattern, unsigned int
> > flags);
> >
> > This means the back end provides a basic search facility for the most
> > common search operations. The flags would specify what to search (e.g.
> > symbol name, help text, prompts) and how to do it.
> 
> I suggest we don't call it sym_generic_search, as generic implies it is a 
> generic filter. We can call it "sym_string_search" or whatever. Then, I 
> suggest we have separate arguments for every parameter (i.e: search type, 
> case sensitivity, what to search, etc.).

I don't care much about the name, but please keep it as a simple flag, 
which is a lot easier to extend.

bye, Roman

