Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZCLJAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZCLJAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZCLJAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:00:23 -0400
Received: from phunq.net ([64.81.85.152]:41428 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751785AbZCLJAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:00:22 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 02:00:18 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903120133.02645.phillips@phunq.net> <200903121947.58367.nickpiggin@yahoo.com.au>
In-Reply-To: <200903121947.58367.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120200.18910.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thursday 12 March 2009, Nick Piggin wrote:
> On Thursday 12 March 2009 19:33:02 Daniel Phillips wrote:
> > On Wednesday 11 March 2009, Andrew Morton wrote:
> 
> > > > Obviously, that raises the question of whether C99 syntax is banned in
> > > > kernel.
> > >
> > > It is banned ;)
> > >
> > > I'm not sure why, really - I have vague memories of Linus having an
> > > episode...  It seems an OK construct if used tastefully.  Although it
> > > does make it easy to hide nasty surprises.
> > > ...
> > > Well.  As I say, it doesn't bother me much (but I like C++, so ignore
> > > me).  But it will make merge/review life harder for you at the outset.
> > > How much harder I cannot predict.  People will fixate on this issue
> > > at the expense of everything else..
> >
> > Well, I suppose we will do something in the middle for now: change some
> > to K&R, and leave some of it as is where we expect it to be developed
> > heavily, like dleaf.c which is going to see whole bunch of work to
> > integrate versioning, so it really makes little sense to make it harder
> > to factor just before starting that work.  Anyway, the C++ comments are
> > on their way out and after all that is the one people love to hate.
> 
> I think they need to be fixed before merge. If the function is easier
> to follow when you use this feature, IMO it indicates the function is
> too big or badly written anyway.

It's not about being easier to follow as being easier to factor.  Putting
the variables far away from point of use increases the busy work in
moving code around significantly, with a corresponding reduction in code
quality in the long run, because time is spent fiddling with declarations
instead of improving structure.  That said, it no doubt will be changed
before merge.  Not that I think there is a sensible reason for it, but
because it makes little sense to dig in over a cosmetic issue.

> > There are a couple of issues, one is u64 being (long) instead of
> > (long long) as you say, and the other is variable type sizes like
> > loff_t.  That specific one isn't actually a problem, we can just refuse
> > to support 32 bit libc file ops, but there may be others.  We had a
> > world of pain before (L) arrived, then with (L) it was easy.  Maybe
> > just edit them all to (long long) for now, and damn the line length.
> 
> Yes please do this. A significant style change like this that lots of
> code already does I think is best first discussed as a standalone
> change to kernel rather than everyone developing their own convention.

That will be in the next batch of changes.  So... we offered our shiny
new convention, and I consider it voted down.  All in a days work :)

Regards,

Daniel
