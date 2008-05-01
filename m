Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbYEACax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbYEACax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbYEACao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:30:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629AbYEACan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:30:43 -0400
Date: Wed, 30 Apr 2008 19:30:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080501021327.GS29330@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804301919080.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
 <20080430154124.7ec08dd4.akpm@linux-foundation.org> <20080501005727.GO29330@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804301821380.5994@woody.linux-foundation.org> <20080501021327.GS29330@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Adrian Bunk wrote:
> 
> I am saying that it was merged too early, and that there are points that 
> should have been addressed before the driver got merged.
> 
> Get it submitted for review to linux-kernel.
> Give the maintainers some time to incorporate all comments.
> Even one month later it could still have made it into 2.6.25.
> 
> The only problem with my suggestion is that it's currently pretty random 
> whether someone takes the time to review such a driver on linux-kernel.

Now, I do agree that we could/should have some more process in general. I 
really _would_ like to have a process in place that basically says:

 - everything must have gone through lkml at least once

 - after that point, it should have been in linux-next or the -mm queue

 - and then it can get merged (and if it didn't get any review by then, 
   maybe it was because nobody was interested, and it simply won't be 
   getting any until it oopses or catches peoples interest some other way)

HOWEVER.

That process doesn't actually work for everything anyway (a lot of trivial 
fixes are really best not being so noisy, and various patches that are 
specific to some subsystem really _are_ better off just discussed on that 
subsystem mailing lists).

And perhaps more pertinently, right now that kind of process is very 
inconvenient (to the point of effectively being impossible) for me to 
check. Obviously, if the patch comes from Andrew, I know it was in -mm, 
and I seldom drop those patches for obvious reasons anyway, but the last 
thing we want is some process that depends even _more_ on Andrew being a 
burnt-out-excuse-for-a-man in a few years (*).

So I could ask for people to always have pointers to "it was discussed 
here" on patches they send (and I'd likely mostly trust them without even 
bothering to verify), the same way -git maintainers often talk about "most 
of this has been in -mm for the last two months".

That might work. But then there would still be the patches that are 
obvious and don't need them.

And then even the obvious patches do break. And people will complain. Even 
though requiring that kind of process for the stupid stuff would just slow 
everybody down, and would be really painful.

So one of my _personal_ reasons I don't want to put too much process in 
place is that I don't think process is appropriate for everything, and yet 
even the stuff that obviously doesn't need or want process (speling fixes 
and build failures) _will_ cause problems, and then people will whine 
about them not being there.

			Linus

(*) Andrew, no offense. I'm sure you'd be a magnificent burnt-out-excuse- 
for-a-man.
