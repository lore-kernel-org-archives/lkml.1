Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYDVGdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYDVGdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 02:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYDVGdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 02:33:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15227 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbYDVGdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 02:33:37 -0400
Date: Tue, 22 Apr 2008 08:33:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cdrom: use kmalloced buffers instead of buffers on stack
Message-ID: <20080422063332.GQ12774@kernel.dk>
References: <200804220100.m3M10sva024025@hera.kernel.org> <480D46F6.3080305@garzik.org> <20080422054857.GA5940@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422054857.GA5940@alpha.franken.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Thomas Bogendoerfer wrote:
> On Mon, Apr 21, 2008 at 10:01:26PM -0400, Jeff Garzik wrote:
> > >    cdrom: use kmalloced buffers instead of buffers on stack
> > >    
> > >    If cdrom commands are issued to a scsi drive in most cases the buffer 
> > >    will be
> > >    filled via dma.  This leads to bad stack corruption on non coherent 
> > >    platforms,
> > >    because the buffers are neither cache line aligned nor is the size a 
> > >    multiple
> > >    of the cache line size.  Using kmalloced buffers avoids this.
> > >    
> > >    Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > >    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > >---
> > > drivers/cdrom/cdrom.c |  274 
> > > ++++++++++++++++++++++++++++++++-----------------
> > > 1 files changed, 181 insertions(+), 93 deletions(-)
> > 
> > Eh... AFAICS this is only really useful in two of the cases converted.
> > 
> > For all the other cases (<= 32 bytes), it is _far_ less complex, far 
> > less code to simply communicate the additional alignment requirements to 
> > the compiler.
> > 
> > What about __attribute__ __aligned__?  Was that tried?
> 
> I used that while narrowing down the bug. But not only the alignment is
> important, but also size needs to be a multiple of the cache line size.
> Which means it needs to be 128 bytes for most SGI machines. That
> and the following in DMA-mapping.txt
> 
> "This rule also means that you may use neither kernel image addresses
> (items in data/text/bss segments), nor module image addresses, nor
> stack addresses for DMA."
> 
> let me choose the kmalloc() solution.

Which is good, the patch has been due for years :-)

-- 
Jens Axboe

