Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYJOSoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYJOSoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYJOSnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:43:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbYJOSnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:43:52 -0400
Date: Wed, 15 Oct 2008 11:43:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] SLOB memory ordering issue
In-Reply-To: <200810160535.51586.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0810151139320.3288@nehalem.linux-foundation.org>
References: <200810160334.13082.nickpiggin@yahoo.com.au> <200810160512.28443.nickpiggin@yahoo.com.au> <1224094753.3316.266.camel@calx> <200810160535.51586.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, Nick Piggin wrote:
>
> Actually, there are surprisingly huge number of them. What I would be
> most comfortable doing, if I was making a kernel to run my life support
> system on an SMP powerpc box, would be to spend zero time on all the
> drivers and whacky things with ctors and just add smp_wmb() after them
> if they are not _totally_ obvious.

WHY?

THIS HAS NOTHING TO DO WITH CONSTRUCTORS!

If the driver is using locking, there is no memory ordering issues 
what-so-ever.

And if the driver isn't using locking, IT IS BROKEN.

It's that simple. Why do you keep bringing up non-issues?

What matters is not constructors. Never has been. Constructors are 
actually very rare, it's much more common to do

	ptr = kmalloc(..)
	.. initialize it by hand ..

and why do you think constructors are somehow different? They're not.

What matter is how you look things up on the other CPU's. If you don't use 
locking, you use some lockless thing, and then you need to be careful 
about memory ordering.

And quite frankly, if you're a driver, and you're trying to do lockless 
algorithms, you're just being crazy. You're going to have much worse bugs, 
and again, whether you use constructors or pink elephants is going to be 
totally irrelevant. 

So why do you bring up these totally pointless things? Why do you bring up 
drivers? Why do you bring up constructors? Why, why, why?

			Linus
