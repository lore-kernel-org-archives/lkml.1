Return-Path: <linux-kernel-owner+w=401wt.eu-S1765587AbXF1Sis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765587AbXF1Sis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763579AbXF1Sil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:38:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757585AbXF1Sik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:38:40 -0400
Date: Thu, 28 Jun 2007 11:38:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
Message-Id: <20070628113819.c24e592d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706282017450.30789@anakin>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
	<20070628110644.a530cfef.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282017450.30789@anakin>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 20:27:22 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > >  endif
> > >  
> > >  obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
> > > -obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
> > > +obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o check_signature.o
> > >  obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
> > >  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
> > >  lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
> > 
> > We didn't think of that.
> > 
> > Alas, m68k `make allmodconfig' creates CONFIG_ISA=n, CONFIG_PCI=n,
> > CONFIG_HAS_IOMEM=y, so it will still be busted.
> > 
> > But this seems to be the correct fix.  Perhaps m68k config needs
> > attention?
> 
> Euh, I don't think this is the correct fix.
> 
> CONFIG_HAS_IOMEM is apparently used in two meanings:
>   1. The architecture has support for memory mapped I/O (s390 obviously
>      hasn't)
>   2. The architecture has ISA/PCI-style memory mapped I/O (readb() and
>      friends)
> 
> check_signature() falls under the second category.
> 
> Setting NO_IOMEM on m68k will make us loose some drivers (e.g.
> drivers/video/Kconfig depends on HAS_IOMEM).
>  
> Apart from many Kconfig dependencies on HAS_IOMEM, CONFIG_HAS_IOMEM is
> further only used to control the build of lib/iomap_copy.c, which
> doesn't use readb() and friends, but the __raw*() operations.
> 

Well this is fun.

How to fix? Should we add a new CONFIG_HAS_IO?  (IOPORTS?)
