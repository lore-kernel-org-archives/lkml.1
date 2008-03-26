Return-Path: <linux-kernel-owner+w=401wt.eu-S1762798AbYCZSzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbYCZSzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbYCZSz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:55:26 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44631 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760003AbYCZSzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:55:24 -0400
Date: Wed, 26 Mar 2008 13:55:23 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Mayer <ajm@sgi.com>, mingo@elte.hu,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines
In-Reply-To: <alpine.LFD.1.00.0803260920020.2775@woody.linux-foundation.org>
Message-ID: <Pine.SGI.3.96.1080326134915.7873204Z-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Linus Torvalds wrote:

> 
> 
> On Wed, 26 Mar 2008, Pavel Machek wrote:
> > 
> > This is very ugly. Why not include it unconditionally -- with guard in
> > apicdef.h?
> 
> I do agree that it's ugly, but I think the ugliness is more serious than 
> that.
> 
> What I think we should do is to make NR_IRQS no longer be a compile-time 
> constant, but instead just do something like
> 
> 	unsigned int NR_IRQS __read_mostly;
> 
> and then just set it early in the boot sequence depending on the real CPU 
> numbers etc.
> 
> I realize that this will require some changes to a few arrays that are 
> statically allocated and depend on NR_IRQ's (notably "irq_desc"), but 
> don't you guys think that this would be a cleaner thing?
> 
> [ I suspect that irq_desc[] itself could quite reasonably be a rather much 
>   smaller __read_mostly hash-table of dynamically allocated entries - the 
>   thing would be only modified at boot, so it should cache beautifully 
>   even across hundreds of CPU's ]
> 
> Whatever. I'm not opposed to this whole static thing, but I do wonder if 
> it's worth doing that way. There *may* be performance reasons for doing it 
> the way we're doing it, but quite frankly, I think the #define is mostly 
> purely historical, from when it was just a fixed number (originally 16!) 
> and it made sense to think of it as a small static array.
> 
> 			Linus
> 

Well, I was looking at it from that point of view.  But, when I found myself
looking at code, particularly in drivers, that indexed into the irq_desc array
and started modifying the descriptor in place and then calling setup_irq(),
I realized that what was needed was a redesign of the whole mess from first
principals.  I still think that's what needs to be done, but by some one with
more experience and credibility than me.  Maybe in a year I'd be willing
to attempt it, but not today.

		--ajm


--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

