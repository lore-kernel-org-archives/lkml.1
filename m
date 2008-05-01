Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbYEATyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbYEATyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYEATyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:54:37 -0400
Received: from 1wt.eu ([62.212.114.60]:3712 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYEATyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:54:37 -0400
Date: Thu, 1 May 2008 21:53:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501195344.GB32322@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org> <20080501185032.GA30883@1wt.eu> <alpine.DEB.1.10.0805011155520.9847@asgard> <20080501192829.GQ8474@1wt.eu> <alpine.DEB.1.10.0805011239040.9847@asgard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0805011239040.9847@asgard>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 12:46:41PM -0700, david@lang.hm wrote:
> On Thu, 1 May 2008, Willy Tarreau wrote:
> 
> >On Thu, May 01, 2008 at 12:07:53PM -0700, david@lang.hm wrote:
> >>On Thu, 1 May 2008, Willy Tarreau wrote:
> >>
> >>I suspect that they would not have, and if I'm right the result of merging
> >>half as much wouldn't be twice as many releases, but rather approximatly
> >>the same release schedule with more piling up for the next release.
> >
> >no, this is exactly what *not* to do. Linus is right about the risk of
> >getting more stuff at once. If we merge less things, we *must* be able
> >to speed up the process. Half the patches to cross-check in half the
> >time should be easier than all patches in full time. The time to fix
> >a problem within N patches is O(N^2).
> 
> in general you are correct, however I don't think that it's the general 
> bugs that end up delaying the releases, think it's the nasty, hard to 
> identify and understand bugs that delay the releases, and I don't think 
> that the debugging of those will speed up much.

Indirectly yes it should. Who do you think is chasing those nasty bugs ?
More people than should be. While those people spend time on bugs caused
revealed by associating several trees, they don't work on fixing their
own bugs.

> >>even individual git trees that do get a fair bit of testing (like
> >>networking for example) run into odd and hard to debug problems when
> >>exposed to a wider set of hardware and loads. having the networking
> >>changes go in every 4 months (with 4 months worth of changes) instead of
> >>every 2 months (with 2 months worth of changes) will just mean that there
> >>will be more problems in this area, and since they will be more
> >>concentrated in that area it will be harder to fix them all fast as the
> >>same group of people are needed for all of them.
> >
> >You're perfectly right and that's exactly not what I'm proposing. BTW,
> >having two halves will also get more of the merge job done the side of
> >developers, where testing is being done before submission. So in the
> >end, we should also get *less* regressions caused by each submission.
> 
> Ok, I guess I don't understand what you are proposing then.
> 
> I thought that you were proposing going from 2 week merge + 6 week 
> stabilize = release to 1 week merge half + 3 week stabilize = release
> 
> it now sounds as if you are saying 1 week merge + x week stabilize + 1 
> week merge + x week stabilize = release
> 
> can you clarify?

The later : 1 week merge for core, 2-4 weeks to stabilize depending on the
amount of changes and complexity of some bugs, release or not at this point
(probably not), then 1 week merge for the rest, and 2-4 weeks stabilize.

Drivers are different. Maybe we'll find it's better to merge them with the
rest, maybe we'll find it wise to merge them all along, I don't know.

> >>if several maintainers think that you are correct that doing a merge with
> >>far fewer changes will be a lot faster, they can test this in the real
> >>world by skipping one release. just send Linus a 'no changes this time'
> >>instead of a pull request. If you are right the stable release will happen
> >>significantly faster and they can say 'I told you so' and in the next
> >>release have a fair chance of convincing other maintainers to skip a
> >>release.
> >
> >again, this cannot work because this would result in slowing them down,
> >and it's not what I'm proposing.
> 
> if merging fewer catagoies of stuff doesn't speed up the release cycle 
> then you are right, it would just slow things down. however I thought you 
> were arguing that if we merged fewer catagories of stuff each cycle we 
> could speed up the cycle. I'm saying that maintainers can choose to test 
> this experimentally and see if it works. if it works we can shift to doing 
> more of it, if it doesn't they only delay things by a couple of months one 
> time.

we should not delay too much IMHO, especially for core changes. We risk to
get huge piles of code which break a lot of other things. Also, core changes
sometimes involve adjustments in every driver or so. So they should not get
additional delay (unless we're really bore by the maintainer not respecting
the process).

> you would need to have several maintainers decide to participate in the 
> experiment or the difference in cycle time may not be noticable.

But it would require Linus to drive it first.

Willy

