Return-Path: <linux-kernel-owner+w=401wt.eu-S934074AbYB2Vg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074AbYB2Vg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760840AbYB2VgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:36:16 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926AbYB2VgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:36:15 -0500
Date: Fri, 29 Feb 2008 13:34:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Kerrisk <michael.kerrisk@googlemail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, carlos@codesourcery.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com, Geoff Clare <gwc@opengroup.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <c49095e30802291243x6087399w4b98ae251f57319b@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802291316000.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>  <1204305244.6243.111.camel@lappy>  <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
  <1204307756.6243.121.camel@lappy> <47C84C6C.2000201@gmail.com>  <alpine.LFD.1.00.0802291032370.17889@woody.linux-foundation.org>  <c49095e30802291149t7ad01f6bl59b9083bfb41c920@mail.gmail.com>  <alpine.LFD.1.00.0802291200580.17889@woody.linux-foundation.org>
 <c49095e30802291243x6087399w4b98ae251f57319b@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Michael Kerrisk wrote:

> On Fri, Feb 29, 2008 at 9:07 PM, Linus Torvalds
> >
> > > >  I agree. And clearly there _are_ relationships and always have been, but
> >  > >  equally clearly they simply haven't been a big issue in practice, and
> >  > >  nobody really cares.
> >  >
> >  > Do we know that for sure?
> >
> >  We *do* know for sure that the relationship has always been there. At
> >  least in Linux, and I bet in 99% of all other Unixes too. The arguments
> >  simply have traditionally been counted as part of the stack size.
> >
> >  Or did you mean the latter part?
> 
> I meant: do we know for sure that no one really cares?

Well, what I have tried to argue is that even if they care, the patch 
won't actually really help. It just moves existing behaviour around a bit, 
but leaves all the fundamental issues totally untouched in that it may 
count the strings, but not the pointers themselves etc.

More importantly, anybody who would depend on any new behaviour would 
still be screwed on all other platforms - including older Linux ones - in 
that they'd depend on some very specific behaviour that simply isn't going 
to be there in other cases.

So yeah, I can see that people could care, but they *shouldn't*.

> The new rlimit is primarily for the (supposed) applications that care
> about knowing (at least approximately) what _SC_ARG_MAX is.  I raised
> the initial bug report against glibc because applications can no
> longer (post 2.6.23) do this, but I haven't done the investigation
> about how many applications actually care.

Very few reasonably can. The thing is, in order to care, you have to count 
things like your own environment space etc, and you have to know that 
there is something you can even *do* about it if the counts go wrong.

So in practice, I think it's just about things like "xargs" and very few 
actual applications. 

I did try to do a google codesearch on "sysconf(_SC_ARG_MAX)" and it 
exists, but there wasn't a whole lot. The most logical one (and the one 
that didn't prefer the ARG_MAX #define) was the built-in xargs in ksh.

But I really didn't look very hard, just a few screenfuls of codesearch.

Realistically, "xargs" really is the main user. *Most* users of execve() 
simply either want all their arguments or none. It's not that common that 
somebody says "ok, I have a ton of arguments, but if you limit them I'll 
just use a fraction of them".

			Linus
