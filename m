Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbYHCNIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbYHCNIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYHCNHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:07:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42652 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbYHCNHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:07:54 -0400
Date: Sun, 3 Aug 2008 07:07:38 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from down_trylock()
Message-ID: <20080803130737.GF26461@parisc-linux.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <200807292301.18733.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org> <200808031833.32048.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808031833.32048.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 06:33:30PM +1000, Rusty Russell wrote:
> On Saturday 02 August 2008 03:26:33 Linus Torvalds wrote:
> > Also, all actual _users_ of down_trylock() seem to be prime candidates for
> > turning into mutexes anyway - with the _possible_ exception of the console
> > semaphore which has problems with the mutex debugging code.
> 
> And Willy is working on that.  Still.  Frankly, I gave up waiting.

It's low-priority for me.  SSDs are much more exciting.

> > Guys, some quality control and critical thinking, please.
> 
> Good idea.  If we'd done that we wouldn't have the down_trylock() brain 
> damage.

I believe down_trylock() came first.  spin_trylock() was then the one
that was gratuitously different and mutex_trylock() decided to follow
the spinning semantics rather than the sleeping semantics.  But yeah,
whatever, big mess.  I'm not convinced down_try() is an improvement.

But I bet we could have got rid of most of the users of down_trylock()
in the time that's been spent wanking about down_try().  Hey, let's make
it return bool!  Hey, let's argue about the name!  Hey, let's argue
about the documentation!

Sometimes the bikeshed needs to be bulldozed, not given another lick of
paint.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
