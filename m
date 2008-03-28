Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYC1UZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYC1UZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbYC1UZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:25:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758383AbYC1UZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:25:29 -0400
Date: Fri, 28 Mar 2008 13:24:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <clameter@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <47ED4E33.9070203@cs.helsinki.fi>
Message-ID: <alpine.LFD.1.00.0803281322080.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl>  <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>  <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>  <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org> 
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>  <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org> <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com> <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
 <47ED4E33.9070203@cs.helsinki.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Pekka Enberg wrote:
> 
> Because I didn't spot that we're calling kmalloc_large() in the fallback path
> too. I was referring to the page allocator pass-through kmalloc_large() call
> that happens before we hit __slab_alloc. My bad, sorry.

So this is kind of my point of the whole thing. It's really hard to even 
realize that there are multiple points - unless you do it at the top 
level.

And yeah, the double clearing is just a performance issue in a rare and 
odd case, and if it hadn't been for the very anal debug checks we would 
never have even noticed. But code that is hard to follow and has really 
subtle non-local implications is fundamentally more likely to have these 
kinds of problems. Which is why I'm arguing against code like that.

			Linus
