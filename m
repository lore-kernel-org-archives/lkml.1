Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYEADsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYEADsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbYEADru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:47:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758937AbYEADrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:47:49 -0400
Date: Wed, 30 Apr 2008 20:47:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <18457.219.995207.136771@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.1.10.0804302034180.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <18457.219.995207.136771@cargo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Paul Mackerras wrote:
> 
> Having things ready by the time the merge window opens is difficult
> when you don't know when the merge window is going to open.  OK, after
> you release a -rc6 or -rc7, we know it's close, but it could still be
> three weeks off at that point.  Or it could be tomorrow.

Well, if the tree is ready, you shouldn't need to care ;)

That said:

> By the way, if you do want to make that rule, then there's a really
> easy way to do it - just pull linux-next, and make that one pull be
> the entire merge window. :)  But please give us at least a week's
> notice that you're going to do that.

I'm not going to pull linux-next, because I hate how it gets rebuilt every 
time it gets done, so I would basically have to pick one at random, and 
then that would be it.

I also do actually try to spread the early pulls out a _bit_, so that 
if/when problems happen, there's some amount of information in the fact 
that something started showing up between -git2 and -git3.

HOWEVER.

One thing that was discussed when linux-next was starting up was whether I 
would maintain a next branch myself, that people could actually depend on 
(unlike linux-next, which gets rebuilt).

And while I could do that for really core infrastructure changes, I really 
would hate to see something like that become part of the flow - because 
I'd hope things that really require it should be so rare that it's not 
worth it for me to maintain a separate branch for it.

But there could be some kind of carrot here - maybe I could maintain a 
"next" branch myself, not for core infrastructure, but for stuff where the 
maintainer says "hey, I'm ready early, you can pull me into 'next' 
already".

In other words, it wouldn't be "core infrastructure", it would simply be 
stuff that you already know you'd send to me on the first day of the merge 
window. And if by maintaining a "next" branch I could encourage people to 
go early, _and_ let others perhaps build on it and sort out merge 
conflicts (which you can't do well on linux-next, exactly because it's a 
bit of a quick-sand and you cannot depend on merging the same order or 
even the same base in the end), maybe me having a 'next' branch would be 
worth it.

But it would have to be low-maintenance. Something I might open after 
-rc4, say, and something where I'd expect people to only ask me to pull 
_once_ (because they really are mostly ready, and can sort out the rest 
after the merge window), and if they have no open regressions (again, the 
"carrot" for good behaviour).

I'm not saying it's a great idea, but if that kind of flow makes sense to 
people, maybe it should be on the table as an idea or at least see if it 
might work.

But let's see how linux-next works out. Maybe all the subsystem 
maintainers can just get their tree in shape, see that it merges in 
linux-next, and not even need anything else. Then, when the merge window 
opens, if you're ready, just let me know.

			Linus
