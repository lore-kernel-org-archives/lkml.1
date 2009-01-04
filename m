Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZADDI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZADDI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZADDIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:08:50 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:31635 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751567AbZADDIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:08:48 -0500
Date: Sun, 4 Jan 2009 12:06:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rob Landley <rob@landley.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090104030619.GA21466@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
	Leon Woestenberg <leon.woestenberg@gmail.com>,
	Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com> <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901032006.47652.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 08:06:47PM -0600, Rob Landley wrote:
> On Saturday 03 January 2009 17:03:11 H. Peter Anvin wrote:
> > Leon Woestenberg wrote:
> > > I agree with Rob that the amount of required dependencies should be
> > > kept to a minimum.
> > >
> > > If we only use 0.5% of a certain language (or: dependent package),
> > > then rather implement that 0.5% in the existing language.
> > >
> > > Dependencies very quickly become dependency hell. If A requires B,
> > > then A also inherits all (future) requirements of B, etc. etc.
> > >
> > > In my daily software development work with Linux and GNU software in
> > > general, 10% of it is spent fighting/removing these extremely "thin"
> > > or false depencies, so that it is usuable in embedded devices.
> >
> > First of all, I largely consider this a joke.
> 
> Yes, I've noticed this.  The fact multiple other people do _not_ consider this 
> a joke doesn't seem to have sunk in yet.
> 
Let's look at the rationale presented so far in this thread:

	1 - Being able to build the kernel natively on a constrained
	target is useful, regardless of whether it is being used for
	regression/stress testing or for headers installation or whatever
	else.

	2 - Cross-compiling perl is hard.

	3 - Some oddly constrained target distributions manage to ship
	with an entire toolchain yet fail to provide any implementation
	of perl.

	4 - It wasn't required before.

If there is anything I missed, feel free to add it to the list. It was
difficult to extract even those 4 from the ranting.

#1 is a logical fallacy. If you have enough space and CPU power and
complete build environment to crunch away at the kernel for stress
testing natively, you can do the same with building perl and negating
point #2. This is especially true for NFS root filesystems where one is
not space constrained during the development phase.

#2 is another byproduct of your environment and generally a non-issue.
There are plenty of options around having to cross-compile perl, and for
those that still insist on doing so, people have been doing it long
enough to be aware of the pitfalls involved. It is not a pleasant
experience, but that is again entire your problem and entirely
constrained to your environment.

#3 seems to have come up a surprising number of times, and again seems to
originate from the fact that no one wants to be bothered with #2 whilst
putting together their oddly constrained rootfs. So far no one has
actually posted any coherent rationale as to why these distributions are
shipping with a full gcc/binutils/etc. environment yet are unable to
supply perl. Obviously size is not a factor if it ships with a full build
environment otherwise, so this suggests that the only logical objection
to fixing up the distributions stems from #4.

As far as #4 goes, I have a hard time seeing why this should be anyone's
problem. Progress is not made by restricting people to the way things
were, progress is made by adapting to new things as they come along. In
the case of the perl scripts provided, perl was picked by the developer
in question as the right tool for the job, and things generally went
along pretty smoothly. Given that one has a reasonable expectation of
perl being available on the vast majority of systems today, this is
hardly an unrealistic tool to leverage for use within the kernel scripts.

The perl dependency has never been an issue for me on any of the
platforms I routinely work on, ranging from tiny microcontrollers to
multi-node NUMA and SMP configurations and everything in between. In
places where the target is capable of building natively, I have no qualms
with building a reasonable development environment. And in places where
builds are unrealistic, I will do them on the host instead. This has
always been the way things were, and I find the implication that the
majority of the embedded development community sits fixedly on #3 to be
completely ridiculous. I will repeat again that no one has provided a
_single_ reason for why they are unable to provide perl within their
constrained environment. Until that happens, this entire thread is a
joke.
