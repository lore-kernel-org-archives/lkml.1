Return-Path: <linux-kernel-owner+w=401wt.eu-S1751249AbXJVUkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbXJVUkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbXJVUjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:39:55 -0400
Received: from waste.org ([66.93.16.53]:52470 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbXJVUjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:39:53 -0400
Date: Mon, 22 Oct 2007 15:38:48 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071022203848.GI17536@waste.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022211617.31f5c63d@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 09:16:17PM +0100, Alan Cox wrote:
> On Mon, 22 Oct 2007 12:49:40 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Mon, 22 Oct 2007, Geert Uytterhoeven wrote:
> > >
> > > Better safe than sorry...
> > > 
> > > Is it possible that a chain entry pointer has bit 1 set on architectures
> > > (e.g. m68k) where the natural alignment of 32-bit quantities is _2_ bytes,
> > > not 4?
> > 
> > Better make sure that such alignment never happens... But no, I don't 
> > think it will, since these things would generally always have to be 
> > allocated with an allocator, and the *allocator* won't return 2-byte 
> > aligned data structures.
> 
> No - but a structure which has other objects in it before the object
> being written out may well be 2 byte aligned on M68K and some of the
> other externally 16bit platforms - ditto local dynamic objects.

Also, the current version of SLOB will return objects aligned at 2 bytes if the
architecture allows it.
 
> Why can't we just make the list one item longer than the entry count and
> stick a NULL on the end of it like normal people ? Then you need one bit
> which ought to be safe for everyone (and if the bit is a macro any CPU
> warped enough to have byte alignment is surely going to have top bits
> spare...)

I'm guessing the extra entry makes slab-like allocators unhappy.

-- 
Mathematics is the supreme nostalgia of our time.
