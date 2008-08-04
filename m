Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbYHDFyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbYHDFyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 01:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYHDFyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 01:54:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916AbYHDFyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 01:54:14 -0400
Date: Sun, 3 Aug 2008 22:53:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from
 down_trylock()
In-Reply-To: <200808041328.45773.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0808032251050.3668@nehalem.linux-foundation.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808031031380.3668@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808031034400.3668@nehalem.linux-foundation.org> <200808041328.45773.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Aug 2008, Rusty Russell wrote:
> 
> Someone sent me a patch documenting the illogic of down_trylock().  I decided 
> to try to fix it rather than just bitch and moan.

I do agree that it is illogical. I just think your solution is worse than 
the problem - turning one illogical function into a redundant one seems 
the worse problem.

We could just fix the return value, since it's not used very much, but 
we'd obviously never know what out-of-tree users there might be, so that's 
not really a good solution either. But that's obviously why we'd then have 
to rename it to something else, so whichever way we turn, we'd just be 
screwed.

I'm much happier telling people to "just don't use semaphores any more".
The _legacy_ users get down_trylock() right. 

		Linus
