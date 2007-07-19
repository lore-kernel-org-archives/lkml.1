Return-Path: <linux-kernel-owner+w=401wt.eu-S936435AbXGSB3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936435AbXGSB3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762223AbXGSB3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:29:16 -0400
Received: from waste.org ([66.93.16.53]:53695 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759301AbXGSB3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:29:15 -0400
Date: Wed, 18 Jul 2007 20:28:48 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Andrea Arcangeli <andrea@suse.de>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070719012848.GO11115@waste.org>
References: <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org> <20070719001539.GC29728@v2.random> <20070719004129.GN11115@waste.org> <469EB4E5.2040300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469EB4E5.2040300@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 02:48:37AM +0200, Rene Herman wrote:
> On 07/19/2007 02:41 AM, Matt Mackall wrote:
> 
> >On Thu, Jul 19, 2007 at 02:15:39AM +0200, Andrea Arcangeli wrote:
> 
> >>Using kmalloc(8k) instead of alloc_page() doesn't sound a too big deal
> >>and that will solve the problem.
> >
> >How do you figure?
> >
> >If you're saying that soft pages helps our 8k stack allocations, it
> >doesn't. The memory overhead of soft pages will be higher (5-15%,
> >mostly due to file tails in pagecache) than the level at which 8k
> >stacks currently run into trouble (1-2% free?).
> >
> >Not helpful.
> 
> With tail-packing it is.

Tail packing is a whole new can of worms. Especially as it's very
likely to make performance suffer on small files (the common case).

On the other hand, if someone can demonstrate that tail-packed page
cache doesn't suck, we should put it in mainline pronto. The poor
architectures that are stuck with real 64k pages are sure to
appreciate it.

-- 
Mathematics is the supreme nostalgia of our time.
