Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbXISIKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbXISIKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXISIKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:10:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXISIKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:10:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=g6gV+jmw8TqoLPr/Cdac/Ll9FYgoOhCzd7Vj1KNfQstpotIMwOEB3llYSDT7TYQbS
	HU5YhCimigFx5dGL9CqaQ==
Date: Wed, 19 Sep 2007 01:09:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the
 vmalloc boundaries
In-Reply-To: <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk>
Message-ID: <alpine.DEB.0.9999.0709190103560.12827@chino.kir.corp.google.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com> <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com> <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Anton Altaparmakov wrote:

> > > Index: linux-2.6/include/linux/mm.h
> > > ===================================================================
> > > --- linux-2.6.orig/include/linux/mm.h	2007-09-17 21:46:06.000000000
> > > -0700
> > > +++ linux-2.6/include/linux/mm.h	2007-09-17 23:56:54.000000000 -0700
> > > @@ -1158,6 +1158,14 @@ static inline unsigned long vma_pages(st
> > > 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> > > }
> > > 
> > > +/* Determine if an address is within the vmalloc range */
> > > +static inline int is_vmalloc_addr(const void *x)
> > > +{
> > > +	unsigned long addr = (unsigned long)x;
> > > +
> > > +	return addr >= VMALLOC_START && addr < VMALLOC_END;
> > > +}
> > 
> > This breaks on i386 because VMALLOC_END is defined in terms of PKMAP_BASE
> > in the CONFIG_HIGHMEM case.
> 
> That is incorrect.  This works perfectly on i386 and on ALL architectures
> supported by Linux.  A lot of places in the kernel already do this today
> (mostly hand coded though, eg XFS and NTFS)...
> 

Hmm, really?

After applying patches 1-3 in this series and compiling on my i386 with 
defconfig, I get this:

In file included from include/linux/suspend.h:11,
                 from arch/i386/kernel/asm-offsets.c:11:
include/linux/mm.h: In function 'is_vmalloc_addr':
include/linux/mm.h:1166: error: 'PKMAP_BASE' undeclared (first use in this function)
include/linux/mm.h:1166: error: (Each undeclared identifier is reported only once
include/linux/mm.h:1166: error: for each function it appears in.)

so I don't know what you're talking about.
