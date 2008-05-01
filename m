Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbYEAAjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbYEAAjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYEAAiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:38:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbYEAAiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:38:54 -0400
Date: Wed, 30 Apr 2008 17:38:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Chris Shoemaker <c.shoemaker@cox.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <alpine.DEB.1.10.0804301713040.7807@asgard>
Message-ID: <alpine.LFD.1.10.0804301715560.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200805010023.32213.rjw@sisk.pl> <alpine.DEB.1.10.0804301528250.7807@asgard> <200805010145.39373.rjw@sisk.pl> <alpine.DEB.1.10.0804301654200.7807@asgard> <20080501000131.GB1559@pe.Belkin>
 <alpine.DEB.1.10.0804301713040.7807@asgard>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, david@lang.hm wrote:
> 
> look at the mess of the distro kernels in the 2.5 and earlier days. having
> them maintain a large body of patches didn't work for them or for the mainline
> kernel.

Exactly. 

I do think Rafael's TCP analogy is somewhat germane, but it misses the 
point that the longer the queue gets, the *worse* the quality gets. It 
gets worse because the queued-up patches don't actually get tested any 
more during their queueing, and because everybody else who isn't 
intimately involved with production of said patches just gets *less* 
inclined to look at big patch-queue than a small one.

So having a long queue and trying to manage it (by some kind of negative 
feedback) is counter-productive, because by the time that situation 
happens, you're basically screwed already.

That's what we largely had with the Xen merge, for example. A lot of the 
code had been around for basically _forever_, and the people involved in 
reviewing it got really tired of it, and there was no way in *hell* a new 
person would ever start reviewing the huge backlog. Once it is massive, 
it's just too massive.

So trying to push back from the destination is really painful. It's also 
aggravating for everybody else. When people were complaining about me not 
scaling (remember those flame-wars? Now the complaint is basically the 
reverse), it was very painful for everybody, and most of all me. 

So I really really hope that if we need throttling (and I do want to point 
out that I'm not entirely sure we do - I think the issue is not "number of 
commits", but "quality of code", and I do _not_ agree that the two are 
directly related in any way), it should be source-based.

Trying to make sure that the source throttles, and not by making 
developers feel unproductive. And quite frankly, most things that throttle 
the source are of the annoying and non-productive kind. The classic source 
throttle tends to be to make it very "expensive" to do development, by 
introducing various barriers.

The barriers are usually "you need to have <n> other people look at it", 
or "you need to pass this five-hour test-suite", and almost invariably, 
the big issue is not code quality, but literally to slow things down. And 
call me crazy, but I think that a process that is designed to not 
primarily get quality, but slow things down, is likely to generate not 
just bad feelings, but actually much worse code too!

And the thing is, I don't even think our main problem is "lots of 
changes". I think we've actually been very successful at managing lots of 
change. Our problems are elsewhere.

So I think our primary problems are:

 - making mistakes is inevitable and cannot be avoided, but we can still 
   add more layers to make it less likely. But these should *not* be aimed 
   at being cumbersome to slow things down - they should basically 
   pipeline perfectly, so that there is no frustrating ping-pong latency.

   And linux-next falls into this kind of category: it doesn't really slow
   down development, but it would be another "pipeline stage" in the 
   process.

   (In contrast, requiring every patch to have <n> reviewed-by etc would 
   add huge latencies and slow down things hugely, and just generally be 
   make-believe work once everybody started gaming the system because it's 
   so irritating)

 - we do want more testing as part of the pipeline (but again, not 
   synchronously - but to speed up feedback for when things go wrong. So 
   it wouldn't get rid of the errors, but if it happens quickly enough, 
   maybe we'd catch things early in the development pipeline before it 
   even hits my tree)

   Having more linux-next testing would be great.

 - Regular *user* debuggability and reporting.

   Quite frankly, I think the reason a lot of people really like being 
   able to bisect bugs is not that "git bisect" is such an inherently cool 
   program, but because it is a really great tool for *users* to 
   participate in the debugging, in ways oops reports etc were not.

   Similarly, I love the oops/warning report statistics that Arjan sends 
   out. With vendor support users help debugging and reporting without 
   even necessarily knowing about it. Things like *that* matter a lot.

Notice how none of the above are about slowing down development.  I don't 
think quality and speed of development are related. In fact, I think 
quality and speed often go hand-in-hand: the same way some of the best 
programmers are also the most productive, I think some of the most 
productive flows are likely to generate the best code!

		Linus
