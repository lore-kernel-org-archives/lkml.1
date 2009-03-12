Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZCLJKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZCLJKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbZCLJKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:10:36 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:26104 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750845AbZCLJKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:10:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=l2gqEvvADh4j0KSE/JtlJvjTGj1gEW7bqi/ffRXoz6sPrBoW+cDQE+C5U9vOGvnJ8uOxMdUwCbIfJLcxPQ74YQ/nIOpIqGNCT8+am2dCt+8h+YmmOMt7Cl39FpxRAu+MgizGFwSfNtKFRm5nOho1X4YTGjH8Kyosa3EE1tG3mhg=  ;
X-YMail-OSG: u7.G3l8VM1ndU_ESP498zarpclu7TYlENfj_TV2u5prAyG7G96BurYaKS2.1_CmXB0zfRMuIV.E3vePXvlvaCGbA5Plkdq_A5RwVxprN9qdLmgUJxFOC6bVnuq6rShHPQsMv6X4oVSY5mwh6UWO9eTdfKXneNSLwl_0Wi8Cd94RRhN7Yu2Jg1LEuqH7wWQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 20:10:30 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903121947.58367.nickpiggin@yahoo.com.au> <200903120200.18910.phillips@phunq.net>
In-Reply-To: <200903120200.18910.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903122010.31282.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 20:00:18 Daniel Phillips wrote:
> Hi Nick,
>
> On Thursday 12 March 2009, Nick Piggin wrote:
> > On Thursday 12 March 2009 19:33:02 Daniel Phillips wrote:
> > > On Wednesday 11 March 2009, Andrew Morton wrote:
> > > > > Obviously, that raises the question of whether C99 syntax is banned
> > > > > in kernel.
> > > >
> > > > It is banned ;)
> > > >
> > > > I'm not sure why, really - I have vague memories of Linus having an
> > > > episode...  It seems an OK construct if used tastefully.  Although it
> > > > does make it easy to hide nasty surprises.
> > > > ...
> > > > Well.  As I say, it doesn't bother me much (but I like C++, so ignore
> > > > me).  But it will make merge/review life harder for you at the
> > > > outset. How much harder I cannot predict.  People will fixate on this
> > > > issue at the expense of everything else..
> > >
> > > Well, I suppose we will do something in the middle for now: change some
> > > to K&R, and leave some of it as is where we expect it to be developed
> > > heavily, like dleaf.c which is going to see whole bunch of work to
> > > integrate versioning, so it really makes little sense to make it harder
> > > to factor just before starting that work.  Anyway, the C++ comments are
> > > on their way out and after all that is the one people love to hate.
> >
> > I think they need to be fixed before merge. If the function is easier
> > to follow when you use this feature, IMO it indicates the function is
> > too big or badly written anyway.
>
> It's not about being easier to follow as being easier to factor.  Putting
> the variables far away from point of use increases the busy work in
> moving code around significantly, with a corresponding reduction in code
> quality in the long run, because time is spent fiddling with declarations
> instead of improving structure.  That said, it no doubt will be changed

Again, I would say if it takes so much more work to maintain, then the
functions are too big or badly written. But I guess it is a matter of
opinion, so...


> before merge.  Not that I think there is a sensible reason for it, but
> because it makes little sense to dig in over a cosmetic issue.

... how about because it follows agreed convention?


> > > There are a couple of issues, one is u64 being (long) instead of
> > > (long long) as you say, and the other is variable type sizes like
> > > loff_t.  That specific one isn't actually a problem, we can just refuse
> > > to support 32 bit libc file ops, but there may be others.  We had a
> > > world of pain before (L) arrived, then with (L) it was easy.  Maybe
> > > just edit them all to (long long) for now, and damn the line length.
> >
> > Yes please do this. A significant style change like this that lots of
> > code already does I think is best first discussed as a standalone
> > change to kernel rather than everyone developing their own convention.
>
> That will be in the next batch of changes.  So... we offered our shiny
> new convention, and I consider it voted down.  All in a days work :)

Cool. Maybe if you offer it as a standalone patch to the kernel, it
will get more attention? It's just not appropriate to put in with a
new filesystem.

