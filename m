Return-Path: <linux-kernel-owner+w=401wt.eu-S965548AbXCQN6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965548AbXCQN6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 09:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965562AbXCQN6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 09:58:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:27406 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965548AbXCQN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 09:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q2Y5cqw8VvHiwK/7Ksq9KQi+xpfAQLQefGfW7jrMAEqZXlX2/cbaz/EYwWxKS1WytGVc8fla37pLHylZqZaei0ifAygWks2rimdyr/xxyc4RY31sg17Mm7+I7fpdH8b26YWM2qqfpNZdkGRJpi8SA+4ppvMNKe5reK+R95LV+1Q=
Message-ID: <b14e81f00703170658x2b61155frfdf78439fc197bfa@mail.gmail.com>
Date: Sat, 17 Mar 2007 09:58:09 -0400
From: "michael chang" <thenewme91@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: [ck] Re: RSDL v0.31
Cc: "Con Kolivas" <kernel@kolivas.org>, "Al Boldi" <a1426z@gawab.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nicholas Miell" <nmiell@comcast.net>
In-Reply-To: <1174125534.7734.2.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/17/07, Mike Galbraith <efault@gmx.de> wrote:
> On Sat, 2007-03-17 at 20:48 +1100, Con Kolivas wrote:
>
> > The most frustrating part of a discussion of this nature on lkml is that
> > earlier information in a thread seems to be long forgotten after a few days
> > and all that is left is the one reporter having a problem.
>
> One?  I'm not the only person who reported regression.
>

Con is over-simplifying here -- he is saying the number of
regression-reporters is dwarfed by the number of positive responses.
One regression in particular, though, is rather persistent, and we are
unsure of how to solve it in a way that fits the ideals of RSDL.

There has been one class of problems that have been reported against
RSDL (problems with X or some X+GL-based app in the context of
CPU-intensive programs) that has yet to be "resolved", AFAICS. The
possible solutions being brought up (e.g. auto-nice in the kernel) go
against the fundamental reasons and logic behind RSDL.

The latest (RSDL 0.31) is supposed to help with relatively-niced
latency-sensitive programs (which were reported earlier) and there is
some progress, although I believe maybe one or two people are still
reporting issues here. We are making progress in this circumstance
that Con feels is acceptable. (Again, the remaining potential
solutions being proposed so far go against RSDL's fundamental ideals.
If we actually have to use these solutions, then basically we're just
doing the vanilla scheduler all over again -- defeating the purpose of
RSDL in the first place.)

akpm, IIRC, reported an issue on PPC with an early version of RSDL
(presumably a broken one) when he tried to build the first public
release with -mm; we have yet to hear negative feedback from him (on
the -ck list at least) saying this problem persisted with future
releases.

I think the idea is that Con has seen much greater positive response
(particularly with earlier releases, i.e. a week ago), and a lack of
thorough, viable solutions (particularly ones that either come with a
patch or fit in with the current ideal of RSDL) for the complaints
being brought up that he is feeling frustrated. (Con's neck problem is
preventing him from spending too much time coding solutions himself,
and I feel the discussion that is going on here is starting to become
counterproductive in consideration of that.)

I've also seen no one mention the possibility of slowdowns on RSDL
being a placebo effect type thing.  That said, this "regression" on
the "broken code" in X is probably an issue that we do need to at
least watch for. The "average" desktop user, I would assume, is
probably running X. (The question is, whether they would be running
"too many" CPU-intensive programs at the same time. If so, then I
would imagine they're not "average" any more, but I could some
misunderstandings about this.) I think many of us have certain ideals
about the performance of graphical user interfaces (we'd like X to be
super-responsive, all the time, regardless of what processes are
running, with as little impact on the CPU-intensive processes as
possible) although I don't think we're at the level where we can get
there yet. The question is (for the time being) how we're willing to
assign things in this circumstance.

And, as far as I can see, no one appears to have even attempted to
answer Con's question of how much CPU a nice 5 process should get
relative to nice 0, etc., apart from maybe Con himself.

Personally, I think a nice 5 process should get 50% of the CPU time of
a nice 0, but I'm not sure how that would scale to nice 19 or nice
-19.

-- 
-- Michael Chang
~Just the crazy copy cat~
