Return-Path: <linux-kernel-owner+w=401wt.eu-S1765565AbYEAT3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765565AbYEAT3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765449AbYEAT3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:29:37 -0400
Received: from 1wt.eu ([62.212.114.60]:3705 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760340AbYEAT3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:29:36 -0400
Date: Thu, 1 May 2008 21:28:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501192829.GQ8474@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org> <20080501185032.GA30883@1wt.eu> <alpine.DEB.1.10.0805011155520.9847@asgard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0805011155520.9847@asgard>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 12:07:53PM -0700, david@lang.hm wrote:
> On Thu, 1 May 2008, Willy Tarreau wrote:
> 
> >I also proposed to group merges by reduced overlapping areas, and to
> >shorten the merge window and make it (at least) twice as often. Rafael
> >also proposed to merge core first, then archs, which is a refined variation
> >on the same principle. I'm not sure I've seen your opinion on this.
> 
> the problem with trying to make the cycle twice as fast is that it takes 
> time to hunt down the hard bugs, even when you have some idea where they 
> are.

Of course, they'll always be bugs. They'll still slip past the release,
as many are doing today.

> go back through the last few kernels and look at the bugs that were fixed 
> in the last couple of -rc releases (and in final), would they have really 
> been fixed faster if other changes hadn't taken place?

Don't know. However, I think that core bugs have more impact on the rest
than other bugs. Reason to merge core first.

> I suspect that they would not have, and if I'm right the result of merging 
> half as much wouldn't be twice as many releases, but rather approximatly 
> the same release schedule with more piling up for the next release.

no, this is exactly what *not* to do. Linus is right about the risk of
getting more stuff at once. If we merge less things, we *must* be able
to speed up the process. Half the patches to cross-check in half the
time should be easier than all patches in full time. The time to fix
a problem within N patches is O(N^2).

> even individual git trees that do get a fair bit of testing (like 
> networking for example) run into odd and hard to debug problems when 
> exposed to a wider set of hardware and loads. having the networking 
> changes go in every 4 months (with 4 months worth of changes) instead of 
> every 2 months (with 2 months worth of changes) will just mean that there 
> will be more problems in this area, and since they will be more 
> concentrated in that area it will be harder to fix them all fast as the 
> same group of people are needed for all of them.

You're perfectly right and that's exactly not what I'm proposing. BTW,
having two halves will also get more of the merge job done the side of
developers, where testing is being done before submission. So in the
end, we should also get *less* regressions caused by each submission.

> if several maintainers think that you are correct that doing a merge with 
> far fewer changes will be a lot faster, they can test this in the real 
> world by skipping one release. just send Linus a 'no changes this time' 
> instead of a pull request. If you are right the stable release will happen 
> significantly faster and they can say 'I told you so' and in the next 
> release have a fair chance of convincing other maintainers to skip a 
> release.

again, this cannot work because this would result in slowing them down,
and it's not what I'm proposing.

Willy

