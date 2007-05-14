Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbXENICf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbXENICf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXENICX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:02:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:32731 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXENICU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LrSWP0NFcM1cSs1g6PF9/Jd/Q+3nsmCrwd4xZt/QZHsuFun7FQ5K0WtZcQVQRNsWbb23XfaYCUd/U7CoOSxBq6nJdFwN9aeKpyQ6bxxWpcyUttKD2ieWUIu5KqDrOSprrjf3rdxe/nvr6ipzcLswROgAhDvNmvWyXsxqD62Tv98=
Message-ID: <a781481a0705140102k77803124ofdc12209b3ce301e@mail.gmail.com>
Date: Mon, 14 May 2007 13:32:19 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: Re: [PATCH] Add __vunmap prototype
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1179129407.32247.77.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514070732.B3796DDE44@ozlabs.org>
	 <20070514001632.60421680.akpm@linux-foundation.org>
	 <1179129407.32247.77.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Mon, 2007-05-14 at 00:16 -0700, Andrew Morton wrote:
> > On Mon, 14 May 2007 17:07:03 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >
> > > __vunmap is not static but I couldn't find a prototype for it, so this
> > > adds it. I need to use it in some powerpc patch to come.
> > >
> > > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > >
> > >  include/linux/vmalloc.h |    1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > Index: linux-cell/include/linux/vmalloc.h
> > > ===================================================================
> > > --- linux-cell.orig/include/linux/vmalloc.h 2007-05-14 16:03:42.000000000 +1000
> > > +++ linux-cell/include/linux/vmalloc.h      2007-05-14 16:03:47.000000000 +1000
> > > @@ -50,6 +50,7 @@ extern void vfree(void *addr);
> > >  extern void *vmap(struct page **pages, unsigned int count,
> > >                     unsigned long flags, pgprot_t prot);
> > >  extern void vunmap(void *addr);
> > > +extern void __vunmap(void *addr, int deallocate_pages);
> > >
> > >  extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
> > >                                                     unsigned long pgoff);
> >
> > um, the only possible reason for wanting to access __vunmap() is that you
> > want to do vunmap() from interrupt context, which is deadlockable.
>
> Argh... I'm stupid, ignore it !
>
> I just want to __vunmap(addr, 0); which is just what vunmap() does :-)
>
> Why is __vunmap not static btw ? If there's no reason, I'll send a patch
> to make it so.

Yeah, it has no users outside mm/vmalloc.c and is not
EXPORT_SYMBOL'ed anyway (plus it's a BUG from in_interrupt() as
Andrew says, so must be called as either vfree() or vunmap()), so clearly
it does want to be static.
