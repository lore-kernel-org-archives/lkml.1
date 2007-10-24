Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbXJXMpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbXJXMpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbXJXMpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:45:11 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23434 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbXJXMpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:45:10 -0400
Date: Wed, 24 Oct 2007 14:45:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] Fix asm-avr32/dma-mapping.h breakage
Message-ID: <20071024124506.GX14671@kernel.dk>
References: <20071024132220.14070582@dhcp-255-175.norway.atmel.com> <20071024112453.GP14671@kernel.dk> <20071024112938.GA1770@uranus.ravnborg.org> <Pine.LNX.4.64.0710240814570.31881@localhost.localdomain> <20071024122120.GV14671@kernel.dk> <20071024124123.GD30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024124123.GD30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Adrian Bunk wrote:
> On Wed, Oct 24, 2007 at 02:21:20PM +0200, Jens Axboe wrote:
> > On Wed, Oct 24 2007, Robert P. J. Day wrote:
> > > On Wed, 24 Oct 2007, Sam Ravnborg wrote:
> > > 
> > > > On Wed, Oct 24, 2007 at 01:24:53PM +0200, Jens Axboe wrote:
> > > > > On Wed, Oct 24 2007, Haavard Skinnemoen wrote:
> > > > > > Hi Linus,
> > > > > >
> > > > > > Sorry about sending you pull requests so rapidly, but Jens broke my
> > > > > > dma-mapping.h yesterday. Or you may say the bug was there to begin with
> > > > > > and Jens merely exposed it, but that makes it sound like my fault ;-)
> > > > > >
> > > > > > Anyway, please pull from
> > > > > >
> > > > > >   ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus
> > > > > >
> > > > > > to receive the following update.
> > > > >
> > > > > You should not take the blame :-)
> > > > >
> > > > > I'm collecting these patches, so I'll pull your fix and make sure it
> > > > > gets to Linus today along with the other fixes.
> > > >
> > > > How about doing a "git grep asm/scatterlist"
> > > > and fix all victims to use linux/scatterlist?
> > > > Or you maybe did this already.
> > > 
> > > i was just about to ask -- is this one of those cases where the asm
> > > versions of scatterlist.h should have a warning/error that they should
> > > not be included directly, and to include linux/scatterlist.h instead?
> > 
> > No, using asm/scatterlist.h is perfectly fine. The problem is code using
> > the sg helpers should include linux/scatterlist.h since that is where
> > those are defined.
> > 
> > If you just need the scatterlist structure definition, then
> > asm/scatterlist.h is the correct include.
> 
> But there's also the general question whether it's good practice for 
> not architecture specific code to include asm/ headers.
> 
> For APIs available on all architectures linux/ header are the right 
> thing to use, and what is in the asm/ header and what in the linux/ 
> header becomes an implementation detail that can be changed.

I agree, for non-arch code you almost always want to use
linux/scatterlist.h since you should be using proper accessor methods
anyway.

-- 
Jens Axboe

