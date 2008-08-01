Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYHASWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYHASWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYHASW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:22:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbYHASW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:22:27 -0400
Date: Fri, 1 Aug 2008 11:22:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from
 down_trylock()
In-Reply-To: <20080801104046.e9e8d6fd.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808011118560.3277@nehalem.linux-foundation.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <6599ad830807281727r63a57a1g11972c5395828aae@mail.gmail.com> <200807292301.18733.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org>
 <20080801104046.e9e8d6fd.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, Andrew Morton wrote:

> > 
> 
> The naming is pretty sad, but the inconsistent return value from
> down_trylock() drives me batshit.  It means that every time I ever look
> at any sort of trylock call I need to go back to the definition site to
> work out if it's the one which returns true or if it's the one which
> returns false.
> 
> It would be good to get that fixed.  And if we _do_ want to fix it, I
> don't see any alternative to creating a new function.

The alternative is to just get rid of "down_trylock()" entirely. Creatign 
a shadow function with a different return value is just going to confuse 
people even more than the current situation.

That's why I pointed out that all the current users (apart from the 
special console usage) really do look like prime candidates to just 
convert to mutexes.

Of course, regardless, _some_ of those have actually taken the 
down_trylock semantics. See

	#define usb_trylock_device(udev)    down_trylock(&(udev)->dev.sem)

so nothing gets rid of that ;)

But at least it should be possible to replace something like half the 
current users of down_trylock() by just teh trivial conversion to mutexes. 
Which would be a good thing regardless.

			Linus
