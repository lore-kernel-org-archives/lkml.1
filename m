Return-Path: <linux-kernel-owner+w=401wt.eu-S1765989AbYEATh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765989AbYEATh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764376AbYEAThW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:37:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33785 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762238AbYEAThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:37:20 -0400
Date: Thu, 1 May 2008 20:37:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501193714.GC5882@ZenIV.linux.org.uk>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org> <20080501181157.GB5882@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 11:23:43AM -0700, Linus Torvalds wrote:
> On Thu, 1 May 2008, Al Viro wrote:
> > On Thu, May 01, 2008 at 10:41:21AM -0700, Linus Torvalds wrote:
> > > 
> > > Same goes for "we should all just spend time looking at each others 
> > > patches and trying to find bugs in them". That's not a solution, that's a 
> > > drug-induced dream you're living in.
> > 
> > As one of those obviously drug-addled freaks who _are_ looking for bugs...
> > Thank you so fucking much ;-/
> 
> That's not what I meant, and I think you know it.

FWIW, the way I'd read that had been "face it, normal folks don't *do*
that and if you hope for more people doing code review - put down your
pipe, it's not even worth talking about".  Which managed to get under
my skin, and that's not something that happens often...

Anyway, I'm glad it had been a misparsing; my apologies for the reaction.
 
> So when we're looking at improvement suggestions, they should be real 
> suggestions that have realistic goals, not just wishes. And they 
> shouldn't be the things we *already* do, because then they wouldn't 
> be improvements.
> 
> In other words: do people have realistic ideas for how to make others 
> spend _more_ time looking at patches? And not just _wishing_ people did 
> that?

The obvious answer: amount of areas where one _can_ do that depends on
some things that can be changed.  Namely:
	* one needs to understand enough of the area or know where/how
to get the information needed for that.  I've got some experience with
the latter and I suspect that most of the folks who do active reviews
have their own set of tricks for getting into the unfamiliar area fast.
Moreover, having such set of tricks is probably _the_ thing that makes
us able to do that kind of work.
	Sharing such (i.e. "here's how one wades through unfamiliar
area and gets a sense of what's going on there; here's what one looks
out for; here's how to deal with data structures; here are the signs
of problematic lifetime logics; here's how one formulates hypothesis
about refcounting rules; here's how one verifies such and looks for
possible bugs in that area; etc.) is a Good Idea(tm).
	Having the critical areas documented with easy to review in
mind is another thing that would probably help.  And yes, it won't
happen overnight, it won't happen for all areas and it won't be mandatory
for maintainers, etc.  Previous part (i.e. which questions to ask
about data structures, etc.) would help with that.
	FWIW, I'm trying to do that - right now I'm flipping between
wading through Cthulhu-damned fs/locks.c and its friends and getting
the notes I've got from the last month work into edible form (which
includes translation into something that resembles normal English,
among other things - more than half of that is in... well, let's call
it idiom-rich Russian).
	* patches should be visible *when* *they* *can* *be* *changed*.
If it's "Linus had pulled from linux-foo.git and that included a merge
from linux-foobar.git, which is developed on foobar-wank@hell.knows.where",
it's too late.  It's not just that you don't revert; it's that you _can't_
realistically revert in such situation - not without very massive work.
And I don't know what _can_ be done about that, other than making it
socially discouraged.  To some extent it's OK, but my impression is that
some areas are as bad as CVS-based "communities" had been and switch to
git has simply hidden the obvious signs of trouble...
