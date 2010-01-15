Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab0AOWB4 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 17:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230Ab0AOWBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 17:01:55 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:46405 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0AOWBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 17:01:55 -0500
Date: Fri, 15 Jan 2010 14:01:53 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] enhanced reimplemented of the kfifo API
Message-ID: <20100115220153.GE10591@ovro.caltech.edu>
References: <1263546418.9732.11.camel@wall-e>
 <20100115192029.GC10591@ovro.caltech.edu>
 <1263591001.7531.1.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263591001.7531.1.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 15 Jan 2010 14:01:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 10:30:01PM +0100, Stefani Seibold wrote:
> 
> > I'm glad to see this example, it really illustrates how to use the new
> > DMA functionality of the kfifo API.
> > 
> > Is there any reason why a very large scatterlist could not be used? I
> > have a driver that uses a large scatterlist (~4000 entries, allocated as
> > a struct sg_table). I implemented my own copy_from_user() functionality
> > into this scatterlist, but I'd love to use the kfifo DMA API instead.
> > After filling the scatterlist, I use the usual DMA API's to transfer it
> > to my device.
> > 
> 
> No, but the API will only return max. two entries.
> 

Ah, I see. __kfifo_alloc() uses kmalloc() internally. The kfifo API will
not work for my purposes then, since I want to allocate a 16MB chunk of
memory, and I'm very uncomfortable doing that with kmalloc(). I'll stick
with my custom scatterlist code, which uses alloc_page() to fill in the
scatterlist with order-0 allocations.

Another nitpick in the code: I've noticed that you use sgl++ in the
setup_sgl() function. That should become "sgl = sg_next(sgl);" so that
this code can work with an struct sg_table as well.

Thanks,
Ira
