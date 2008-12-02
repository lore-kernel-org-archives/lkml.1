Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYLBCzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYLBCzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 21:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYLBCzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 21:55:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbYLBCzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 21:55:32 -0500
Date: Mon, 1 Dec 2008 18:54:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       randy.dunlap@oracle.com, greg@kroah.com, adobriyan@gmail.com,
       remi.colinet@gmail.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
In-Reply-To: <84144f020812011402v3cb3ab24pf5cb6310f2d00c5b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0812011843340.3256@nehalem.linux-foundation.org>
References: <1227980689.6354.24.camel@localhost.localdomain>  <20081129214207.GA6747@x200.localdomain>  <20081129234907.GA2340@kroah.com>  <20081201101245.0a2f3123.randy.dunlap@oracle.com>  <1228158811.3196.88.camel@calx>  <20081201120210.1ed16bd5.akpm@linux-foundation.org>
  <84144f020812011207q29fe4b3fq11a9e55f171cf743@mail.gmail.com>  <alpine.LFD.2.00.0812011210030.3256@nehalem.linux-foundation.org> <84144f020812011402v3cb3ab24pf5cb6310f2d00c5b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Pekka Enberg wrote:
> 
> OK, but why do we have those different ABI "stages" in
> Documentation/ABI then? The README file there seems to contradict what
> you say. Or maybe I'm reading it wrong...

I think that whole Documentation/ABI stuff is utter tosh, and should just 
be thrown out, whenever it talks about interfaces that are _not_ ABI's.

IOW, it's fine to document things that are actually supposed to be stable, 
but:

 - assuming that non-documentation means that it's not an ABI is bogus
   and wrong.

 - explicitly documenting something as "not an ABI" is wrongheaded and 
   stupid, because it's meaningless and only sets people up for being 
   disappointed later.

So yeah, I think we might as well remove the "testing" one. Right now it 
can act in two ways:

 - as documentation on how to use it (ie as "stable").

   This is fine, but then it shouldn't be called "testing", should it?

 - as an excuse for whining later when it _did_ get used, and people break 
   exported ABI's, and we need to revert the breakage.

   And this is the one that I don't think is valid. No amount of 
   documentation will ever make something less stable.

So as far as I'm concerned, "testing" should either go away (as a way to 
discourage people from even _knowing_ about the things, and hoping that 
they never get used), or it should be moved to "stable".

And in the end, nothing is ever totally black-and-white or quite that 
simple, but that's the mindset you should have.

Finally, when it comes to documentation as a bigger issue:

 - wrong documentation is irrelevant. It doesn't matter if the 
   documentation says "X", when the code does "Y".

   If people rely on "Y", then pointing at the docs and saying "but you 
   should never have relied on it, because teh docs say X" is totally and 
   utterly bogus. The _documentation_ was wrong. Don't ever use incorrect 
   documentation as an excuse. 

Too many people seem to think that documentation is the "final" argument. 
It's not. Not even close. It's a hint and a help, but it's _secondary_ to 
code. Anybody who doesn't understand that should never be allowed to write 
code (or documentation, for that matte).

[ The same is true of assert()'s in code too - I've seen too many damn 
  asserts that were simply _wrong_, and then when they triggered, people 
  would always blindly assume that the assert() was right, and try to 
  change the code to suit. For some reason people have a hard time asking 
  themselves whether perhaps the bug was in the assertion itself. ]

			Linus
