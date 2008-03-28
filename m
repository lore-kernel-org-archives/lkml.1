Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbYC1SVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbYC1SVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbYC1SVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:21:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757525AbYC1SV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:21:29 -0400
Date: Fri, 28 Mar 2008 11:20:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <clameter@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl>  <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>  <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>  <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org> 
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>  <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org> <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Pekka Enberg wrote:
> 
> On Fri, Mar 28, 2008 at 7:27 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >  So the *last* thing we want to do is to clear GFP_ZERO in multiple subtle
> >  places based on new random code being added. We want to clear it at the
> >  top level, so that no other code never ever even has to _think_ about it!
> 
> We are clearing it in one place, just before calling alloc_pages.

BUT THAT IS TOTALLY IRRELEVANT.

We're not clearing it in kmalloc_large()!

What's so hard to understand?

> [Yes, it's hard to spot, it's in new_slab() where we call
> allocate_slab().] I'm okay with moving it to top level but I don't see
> how that fixes any of the bugs mentioned here.

That stupid clearing in new_slab() is totally and utterly irrelevant (in 
addition to the fact that it's hard to spot).

The point was never new_slab(). So why do you even mention it?

The code in question is __slab_alloc(). It did *not* clear it correctly 
before its uses (__slab_alloc -> kmalloc_large -> __get_free_pages).

			Linus
