Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZHHXr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZHHXr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 19:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZHHXr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 19:47:28 -0400
Received: from phunq.net ([64.81.85.152]:44833 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753226AbZHHXr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 19:47:27 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Tux3] Current Activities?
Date: Sat, 8 Aug 2009 16:47:21 -0700
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jgarzik@pobox.com>, debian developer <debiandev@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, tux3@tux3.org,
       LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net
References: <6dcc37b30904291901m7abdd6d7q6f44b2c248ec48c4@mail.gmail.com> <200908010942.52623.phillips@phunq.net> <20090806075246.GA6860@elte.hu>
In-Reply-To: <20090806075246.GA6860@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908081647.21279.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009, Ingo Molnar wrote:
> 
> * Daniel Phillips <phillips@phunq.net> wrote:
> 
> > [...]  I will say this now: if we are invited to merge in the next 
> > major release, or in -mm or whatever, we will happily do it. If we 
> > are not invited to merge, nobody has any cause to complain about 
> > progress slowing down. [...]
> 
> The thing is, if you are waiting for an 'invite to upstream Linux 
> merge' that could be a _very_ long wait: i've yet to see a single 
> one ever since i started hacking Linux ~14 years ago ;-)

Hi Ingo,

We were already sorta-kinda invited to merge, as I read it, having received advice to merge early while the code base remains small
instead of adding more features and risking premature bloat.  I seem to
recall there was a dissenter at that time on the basis of lack of
atomic commit, and we chose to follow the latter advice instead of the
former, arguably a mistake.

> The model that Linux has been following for the past 10+ years is 
> for new kernel projects to request inclusion. I.e. you push your 
> patches upstream: you send patches and a pull request to the 
> appropriate people/lists such as lkml.
> 
> This is done so because merging patches is a fundamentally 
> hierarchical process, and the people merging _your_ patches are the 
> real maintenance bottleneck, not you.
> 
> So it is not Linus and other maintainers who are searching the web 
> for projects to merge and sending out 'invites' but the other way 
> around: projects try to get upstream by submitting patches (which 
> get reviewed and accepted or rejected).

With 20-20 hindsight, we should have gone for a merge immediately after
the SCALE 7X demo, at which time Tux3 was reliably but without
atomic commit.  Instead, we decided to heed those asking for atomic
commit before merge.  This turned out to be a bad idea, because my
available time soon became severely constrained.  Work on atomic commit
has progressed over the last few months, but slowly.  If we had merged
back in February this work would have progressed faster and been done
by now.  As it is, we will probably forge on with the atomic commit work
rather than changing course and looking for a merge right away, because
there has been considerable progress in that direction.  Also, my time
is not quite as constrained as it was - still constrained, but not quite
as severely as recently.

Meanwhile Hirofumi has dauntlessly forged on, extracting design details
from me, adding some of his own, generally subjecting everything to
minute scrutiny, and in the process turning out a significant volume of
high quality code.  If I had to state what the best thing that could
happen to Tux3 is, it would be: somebody steps up to sponsor Hirofumi.
He has done all that work strictly as a volunteer without support of any
kind, and he could use some.  Not to mention the fact that as FAT
maintainer we would be well served to have Hirofumi in a comfort zone,
given recent developments on that front.

> So if you'd like your code to be merged upstream you better start 
> this process now - this alone can take a lot of time: months (or 
> years in certain cases). But it is still a much shorter time-span 
> than an 'invite to merge' ;-)
> 
> 	Ingo

My "invite to merge" comment was made in the context of various comments
about insufficiently rapid progress, and should not be taken out of
context.  We are well aware of the traditional merging procedure.  We
certainly are not waiting for any maintainer action, but rather for more
progress from ourselves.  There are various possibilities to speed that
up.  See "sponsor Hirofumi" above.  I myself do not need sponsorship at
this point, what I need is more time on my hands, and only I can do
anything about that.  (As of today, I do have a little more time
available, hence this post.)

In fact, our merge process has been in progress since February.  As we
see it, it goes like this:

  1) Implement and verify atomic commit correctness at least for a
     large subset of filesystem operations.

  2) Clean the kernel part of the code base to a respectable state.

  3) Commence our post-address-repost cycle with intent to merge.

We are at step 1 and I can't say how long it will take to get to step 2.
It is on the way.  Any help we get will hurry it along.

I will very briefly address Ted's question, which amounts to: "why
do we want Tux3?"  I think Tux3 fills an empty niche in our filesystem
ecology where a simple, clean and modern general purpose filesystem
should exist and there is none.  In concrete terms, Tux3 implements a
single-pointer-per-extent model that Btrfs and ZFS do not.  This allows
a very simple *physical* design, with much complexity pushed to the
*logical* level where things generally behave better.  A simple physical
design offers many benefits, including making it easier to take a run at
that holiest of holy grails, online check and repair.

In even more concrete terms, Tux3 already demonstrates a tiny memory
footprint, unlike Btrfs or ZFS.  Its CPU footprint is also tiny.  As
such, Tux3 could easily run on a cellphone or smaller device, while
offering a full range of "big filesystem" capabilities.  (Note that
Zumastor already proves we know how to do replication properly:
http://zumastor.org/.)

Regards,

Daniel
