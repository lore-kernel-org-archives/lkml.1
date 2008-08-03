Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYHCIdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYHCIdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 04:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYHCIdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 04:33:45 -0400
Received: from ozlabs.org ([203.10.76.45]:57490 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYHCIdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 04:33:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from down_trylock()
Date: Sun, 3 Aug 2008 18:33:30 +1000
User-Agent: KMail/1.9.9
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <200807292301.18733.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808031833.32048.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 August 2008 03:26:33 Linus Torvalds wrote:
> On Tue, 29 Jul 2008, Rusty Russell wrote:
> > Introduce down_try()
>
> I hate that name. Everybody else uses "xxx_trylock()", now you introduce a
> short version of that that just has the same return value as everybody
> else except for semaphores that admittedly were odd.

spin_lock => spin_trylock, so down => trydown.  But everyone hated that, too.

I love your suggestion tho.  Oh wait, you didn't make one...

> Also, all actual _users_ of down_trylock() seem to be prime candidates for
> turning into mutexes anyway - with the _possible_ exception of the console
> semaphore which has problems with the mutex debugging code.

And Willy is working on that.  Still.  Frankly, I gave up waiting.

> > Andrew suggested introducing "down_try" as a wrapper now, to make
> > the transition easier.
>
> The transition to WHAT? To crap?
>
> There is no need to introduce yet another temporary thing just to make
> things even _more_ confusing.

And so my patch series replaces all 21 of them.  It's a trivial replace, 
unlike sem -> mutex.

> Guys, some quality control and critical thinking, please.

Good idea.  If we'd done that we wouldn't have the down_trylock() brain 
damage.

Rusty.
