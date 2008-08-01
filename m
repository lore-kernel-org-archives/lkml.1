Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYHAR1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYHAR1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYHAR1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:27:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYHAR1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:27:13 -0400
Date: Fri, 1 Aug 2008 10:26:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from
 down_trylock()
In-Reply-To: <200807292301.18733.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <6599ad830807281727r63a57a1g11972c5395828aae@mail.gmail.com> <200807292301.18733.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Rusty Russell wrote:
> 
> Introduce down_try()

I hate that name. Everybody else uses "xxx_trylock()", now you introduce a 
short version of that that just has the same return value as everybody 
else except for semaphores that admittedly were odd.

Also, all actual _users_ of down_trylock() seem to be prime candidates for 
turning into mutexes anyway - with the _possible_ exception of the console 
semaphore which has problems with the mutex debugging code.

> I planned on removing the much-disliked down_trylock() (with its
> backwards return codes) in 2.6.27, but it's creating something of a
> logjam with other patches in -mm and linux-next.
> 
> Andrew suggested introducing "down_try" as a wrapper now, to make
> the transition easier.

The transition to WHAT? To crap?

There is no need to introduce yet another temporary thing just to make 
things even _more_ confusing.

Yeah, I'm grumpy. I'm always pretty grumpy, but I'm trying to go through 
some backlog where I had been going "hmm, why would I do this", and this 
one wasn't the only one where my reaction was "if I pull/apply this, the 
end result is worse".

Guys, some quality control and critical thinking, please.

			Linus
