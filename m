Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbYD3Vij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbYD3Vij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762682AbYD3ViM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:38:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762285AbYD3ViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:38:11 -0400
Date: Wed, 30 Apr 2008 14:37:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200804302245.50817.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <200804302245.50817.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, Rafael J. Wysocki wrote:
> > 
> >    Long merge windows don't work - because rather than test more, it just 
> >    means that people will use them to make more changes!
> 
> And what do you think is happening _after_ the merge window closes, when
> we're supposed to be fixing bugs?  People work on new code.  And, in fact, they
> have to, if they want to be ready for the next merge window.

Oh, I agree. But at that point, the issue you brought up - of testing and 
then having the code change under you wildly - has at least gone away.

And I think you are missing a big issue:

> Sorry to say that, but I don't think this is realistic.  What happens after the merge
> window is people go and develop new stuff.

>From a testing standpoint, the *developers* aren't ever even the main 
issue. Yes, we get test coverage that way too, but we should really aim 
for getting most of the non-obvious issues from the user community, and 
not primarily from developers.

So the whole point of the merge window is *not* to have developers testing 
their code during the six subsequent weeks, but to have *users* able to 
use -rc1 and report issues!

That's why the distro "testing" trees are so important. And that's why 
it's so important that -rc1 be timely. 

> My point is, given the width of the merge windown, there's too much stuff
> going in during it.  As far as I'm concerned, the window can be a week long
> or whatever, but let's make fewer commits over a unit of time.

I'm not following that logic. 

A single merge will bring in easily thousands of commits. It doesn't 
matter if the merge window is a day or a week or two weeks, the merge will 
be one event.

And there's no way to avoid the fact that during the merge window, we will 
get something on the order of ten thousand commits (eg 2.6.24->25-rc1 was 
9629 commits).

So your "fewer commits over a unit of time" doesn't make sense. We have 
those ten thousand commits. They need to go in. They cannot take forever. 
Ergo, you *will* have a thousand commits a day during the merge window.

We can spread it out a bit (and I do to some degree), but in many ways 
that is just going to be more painful. So it's actually easier if we can 
get about half of the merges done early, so that people like Andrew then 
has at least most of the base set for him by the first few days of the 
merge window.

So here's the math: 3,500 commits per month. That's just the *average* 
speed, it's sometimes more. And we *cannot* merge them continuously, 
because we need to have a stabler period for testing. And remember: those 
3,500 commits don't stop happening just because they aren't merged. You 
should think of them as a constant pressure.

So 3,500 commits per month, but with a stable period (that is *longer* 
than the merge window) that means that the merge window needs to merge 
that constant stream of commits *faster* than they happen, so that we can 
then have that breather when we try to get users to test it. Let's say 
that we have a 1:3 ratio (which is fairly close to what we have), and that 
means that we need to merge 3,500 commits in a week. 

That's just simple *math*. So when you say "let's make fewer commits over 
a unit of time" I can onyl shake my head and wonder what the hell you are 
talking about. The merge window _needs_ to do those 3,500 commits per 
week. Otherwise they don't get merged!

			Linus
