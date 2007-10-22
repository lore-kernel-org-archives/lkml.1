Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbXJVXra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbXJVXra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXJVXrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:47:19 -0400
Received: from waste.org ([66.93.16.53]:35007 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbXJVXrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:47:18 -0400
Date: Mon, 22 Oct 2007 18:46:23 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071022234622.GT19691@waste.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <471D145A.40904@garzik.org> <20071022214707.GJ17536@waste.org> <20071022235251.656b9cad@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022235251.656b9cad@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 11:52:51PM +0100, Alan Cox wrote:
> On Mon, 22 Oct 2007 16:47:07 -0500
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > On Mon, Oct 22, 2007 at 05:21:30PM -0400, Jeff Garzik wrote:
> > > Alan Cox wrote:
> > > >Why can't we just make the list one item longer than the entry count and
> > > >stick a NULL on the end of it like normal people ?
> > > 
> > > Certainly seems safer than the current "let's run off the end of the 
> > > list if anything bad happens" setup...  And I do not think allocating 
> > > n+1 scatterlist entries will have much of a negative impact.
> > 
> > It'll mean m-1 scatterlists fit on a slab.
> 
> Is that really a credible space issue ?

Yes. Especially if m is 2 or 1. A scatterlist on 64-bit x86 looks like
it takes 32 bytes, which means 128 elements fit on a page. One more
spills - ouch!

But maybe chaining means this doesn't matter any more. Maybe we can
even pick a nice moderate sg size and reduce the number of mempools we
need for these things.

-- 
Mathematics is the supreme nostalgia of our time.
