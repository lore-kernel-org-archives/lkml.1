Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbXENH5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbXENH5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 03:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbXENH4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 03:56:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:41827 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758331AbXENH4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 03:56:54 -0400
Subject: Re: [PATCH] Add __vunmap prototype
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070514001632.60421680.akpm@linux-foundation.org>
References: <20070514070732.B3796DDE44@ozlabs.org>
	 <20070514001632.60421680.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 17:56:47 +1000
Message-Id: <1179129407.32247.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 00:16 -0700, Andrew Morton wrote:
> On Mon, 14 May 2007 17:07:03 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > __vunmap is not static but I couldn't find a prototype for it, so this
> > adds it. I need to use it in some powerpc patch to come.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> >  include/linux/vmalloc.h |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-cell/include/linux/vmalloc.h
> > ===================================================================
> > --- linux-cell.orig/include/linux/vmalloc.h	2007-05-14 16:03:42.000000000 +1000
> > +++ linux-cell/include/linux/vmalloc.h	2007-05-14 16:03:47.000000000 +1000
> > @@ -50,6 +50,7 @@ extern void vfree(void *addr);
> >  extern void *vmap(struct page **pages, unsigned int count,
> >  			unsigned long flags, pgprot_t prot);
> >  extern void vunmap(void *addr);
> > +extern void __vunmap(void *addr, int deallocate_pages);
> >  
> >  extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
> >  							unsigned long pgoff);
> 
> um, the only possible reason for wanting to access __vunmap() is that you
> want to do vunmap() from interrupt context, which is deadlockable.

Argh... I'm stupid, ignore it !

I just want to __vunmap(addr, 0); which is just what vunmap() does :-)

Why is __vunmap not static btw ? If there's no reason, I'll send a patch
to make it so.

Ben.


