Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0AOWFS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 17:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085Ab0AOWFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 17:05:17 -0500
Received: from www84.your-server.de ([213.133.104.84]:55338 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0AOWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 17:05:16 -0500
Subject: Re: [PATCH] enhanced reimplemented of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>
In-Reply-To: <20100115220153.GE10591@ovro.caltech.edu>
References: <1263546418.9732.11.camel@wall-e>
	 <20100115192029.GC10591@ovro.caltech.edu> <1263591001.7531.1.camel@wall-e>
	 <20100115220153.GE10591@ovro.caltech.edu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Jan 2010 23:05:07 +0100
Message-ID: <1263593107.8935.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 15.01.2010, 14:01 -0800 schrieb Ira W. Snyder:
> On Fri, Jan 15, 2010 at 10:30:01PM +0100, Stefani Seibold wrote:
> > 
> > > I'm glad to see this example, it really illustrates how to use the new
> > > DMA functionality of the kfifo API.
> > > 
> > > Is there any reason why a very large scatterlist could not be used? I
> > > have a driver that uses a large scatterlist (~4000 entries, allocated as
> > > a struct sg_table). I implemented my own copy_from_user() functionality
> > > into this scatterlist, but I'd love to use the kfifo DMA API instead.
> > > After filling the scatterlist, I use the usual DMA API's to transfer it
> > > to my device.
> > > 
> > 
> > No, but the API will only return max. two entries.
> > 
> 
> Ah, I see. __kfifo_alloc() uses kmalloc() internally. The kfifo API will
> not work for my purposes then, since I want to allocate a 16MB chunk of
> memory, and I'm very uncomfortable doing that with kmalloc(). I'll stick
> with my custom scatterlist code, which uses alloc_page() to fill in the
> scatterlist with order-0 allocations.
> 

I think you can use vmalloc() instead and assign this buffer with
kfifo_init().

> Another nitpick in the code: I've noticed that you use sgl++ in the
> setup_sgl() function. That should become "sgl = sg_next(sgl);" so that
> this code can work with an struct sg_table as well.

No, its by definition an array. You cannot pass as struct sg_table to
the kfifo_dma_* functions.

Stefani


