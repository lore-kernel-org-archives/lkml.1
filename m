Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXEKHbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXEKHbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXEKHbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:31:25 -0400
Received: from ozlabs.org ([203.10.76.45]:34401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbXEKHbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:31:24 -0400
Subject: Re: [PATCH 2/5] lguest guest feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20070511065613.GB25182@infradead.org>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
	 <1178846490.23513.27.camel@localhost.localdomain>
	 <20070511065613.GB25182@infradead.org>
Content-Type: text/plain
Date: Fri, 11 May 2007 17:31:06 +1000
Message-Id: <1178868666.23513.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 07:56 +0100, Christoph Hellwig wrote:
> On Fri, May 11, 2007 at 11:21:30AM +1000, Rusty Russell wrote:
> > 1) send-dma and bind-dma hypercall wrappers for drivers to use,
> > 2) formalization of the convention that devices can use the irq
> >    corresponding to their index on the lguest_bus.
> > 3) ___force to shut up sparse: guests *can* use ioremap as virtual mem.
> 
> No, they can't.  Even if in your case the underlying address spaces
> happen to be the same anything returned by ioremap must use the proper
> accessors.  That's the whole point of having this separation, otherwise
> you wouldn't need to use ioremap at all.

Hi Christoph!

	Well, without ioremap, the memory wouldn't normally be mapped.  Is
there something better to use?

> So instead of sprinkling cast
> around add lguest_read*/lguest_write* accessors that do the __force cast
> once and make sure the ioremap return value is always accessed using those.

And that's nothing to do with iremap.  They're required because guest
"physical" == host virtual, and casting a long to a "__user void *"
seems to require a __force.

I enjoy a good Hellwigging as much as anyone, but your aim is off.

Cheers,
Rusty.

