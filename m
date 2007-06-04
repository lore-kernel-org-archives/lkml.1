Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbXFDSE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbXFDSE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbXFDSEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:04:52 -0400
Received: from holomorphy.com ([66.93.40.71]:41400 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004AbXFDSEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:04:51 -0400
Date: Mon, 4 Jun 2007 11:05:19 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <20070604180519.GF15426@holomorphy.com>
References: <20070601204141.f84ad72f.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com> <20070601213117.1178e8e0.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com> <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com> <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com> <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com> <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org> <20070604182025.558a8d10@the-village.bc.nu> <alpine.LFD.0.98.0706041043330.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706041043330.23741@woody.linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 10:50:41AM -0700, Linus Torvalds wrote:
> The exception is if you use the memory allocator as a "ID allocator", but 
> quite frankly, if you use a size of zero, it's your own damn problem. 
> Insane code is not an argument for insane behaviour.
> If people can't be bothered to create a "random ID generator" themselves, 
> they had damn well better use "kmalloc(1)" rather than "kmalloc(0)" to get 
> a unique cookie. Asking the allocator to do something idiotic because some 
> idiot thinks a memory allocator is a cookie allocator is just crazy.

It's not such a great idea in general. Maybe it's a dumb device to cut
down on lines of code for merging or some such.


On Mon, Jun 04, 2007 at 10:50:41AM -0700, Linus Torvalds wrote:
> I can understand that things like user-level libraries have to take crazy 
> people into account, but the kernel internal libraries definitely do not.
> (Right now we warn once for zero-sized allocations anyway, and all the 
> cases we've found so far are either bugs that would have been found with 
> ZERO_ALLOC_PTR or would have been perfectly fine with it, so I don't think 
> anybody really _is_ that insane in the kernel)

There are always drivers for that, but I doubt any were sufficiently
creative to pick up on this. At least I've not see any.


-- wli
