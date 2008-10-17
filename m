Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYJQAkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYJQAkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYJQAj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:39:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbYJQAj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:39:56 -0400
Date: Thu, 16 Oct 2008 17:38:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: davem@davemloft.net, alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: Make uart_port's ioport "resource_size_t"
Message-Id: <20081016173811.b4fc7ba2.akpm@linux-foundation.org>
In-Reply-To: <20081016194437.14c7604b@zod.rchland.ibm.com>
References: <20081014162621.GA18166@yoda.jdub.homelinux.org>
	<20081016144645.1c868fc0.akpm@linux-foundation.org>
	<20081016194437.14c7604b@zod.rchland.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 19:44:37 -0400 Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:

> On Thu, 16 Oct 2008 14:46:45 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 14 Oct 2008 12:26:21 -0400
> > Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> > 
> > > Recently uart_port's iobase was changed to be an 'unsigned
> > > long' to avoid chopping off the upper 32-bits of the
> > > address on 64-bit CPUs.  However, there are CPUs that are
> > > 32-bit but have a 64-bit address space.  This changes
> > > iobase to be 'resource_size_t' to accommodate those types
> > > of systems.  This also matches what is done for the mapbase
> > > member of uart_port.
> > > 
> > > Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> > > 
> > > ---
> > > 
> > > diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> > > index e27f216..cb0185b 100644
> > > --- a/include/linux/serial_core.h
> > > +++ b/include/linux/serial_core.h
> > > @@ -241,7 +241,7 @@ typedef unsigned int __bitwise__ upf_t;
> > >  
> > >  struct uart_port {
> > >  	spinlock_t		lock;			/* port lock */
> > > -	unsigned long		iobase;			/* in/out[bwl] */
> > > +	resource_size_t		iobase;			/* in/out[bwl] */
> > >  	unsigned char __iomem	*membase;		/* read/write[bwl] */
> > >  	unsigned int		irq;			/* irq number */
> > >  	unsigned int		uartclk;		/* base uart clock */
> > 
> > This will of course require that all now-broken printk()s be unbroken. 
> > I spot two in serial_core.c alone.
> 
> Yes, I know that.  There's a patch, or at least a discussion, floating
> around on how to fix this with a %pX thing right?  We can delay this
> until that comes to fruition if you'd like.
> 

Well.  It just got converted from uint to ulong and we're still fixing
the bugs which that introduced.
