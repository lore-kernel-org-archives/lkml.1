Return-Path: <linux-kernel-owner+w=401wt.eu-S936121AbXGMSqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936121AbXGMSqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbXGMSp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:45:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492AbXGMSp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:45:58 -0400
Date: Fri, 13 Jul 2007 11:45:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] slob: improvements
Message-Id: <20070713114532.07f9fd53.akpm@linux-foundation.org>
In-Reply-To: <20070713183506.GN11115@waste.org>
References: <20070515084305.GA28631@wotan.suse.de>
	<20070515151731.GO11115@waste.org>
	<20070515233347.GA20468@wotan.suse.de>
	<20070713112725.d75acf1d.randy.dunlap@oracle.com>
	<20070713183506.GN11115@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 13:35:06 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Fri, Jul 13, 2007 at 11:27:25AM -0700, Randy Dunlap wrote:
> > > Index: linux-2.6/init/Kconfig
> > > ===================================================================
> > > --- linux-2.6.orig/init/Kconfig
> > > +++ linux-2.6/init/Kconfig
> > > @@ -529,7 +529,7 @@ config SLUB
> > >  	   way and has enhanced diagnostics.
> > >  
> > >  config SLOB
> > > -	depends on EMBEDDED && !SPARSEMEM
> > > +	depends on EMBEDDED && !SPARSEMEM && !ARCH_USES_SLAB_PAGE_STRUCT
> > >  	bool "SLOB (Simple Allocator)"
> > >  	help
> > >  	   SLOB replaces the SLAB allocator with a drastically simpler
> > 
> > Is this patch going in?  I have a randconfig (2.6.22) with
> > CONFIG_SLOB=y
> > CONFIG_NUMA=y
> > CONFIG_SMP=y
> > The kernel build fails with these config symbols set like that.
> > It looks like SLOB needs that additional
> > 	&& !ARCH_USES_SLAB_PAGE_STRUCT
> > (or 	&& !SMP)
> 
> I think Andrew intends to push it to 2.6.23, yes.
> 

Yup.

I had to hunt for it though.  Turns out I renamed the patch to
slob-rework-freelist-handling.  Please don't give patches dopey titles like
"slob improvements".

