Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbXGKGU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbXGKGU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbXGKGUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:20:15 -0400
Received: from brick.kernel.dk ([80.160.20.94]:14896 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbXGKGUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:20:14 -0400
Date: Wed, 11 Jul 2007 08:20:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hugh@veritas.com
Subject: Re: shmem: convert to using splice instead of sendfile()
Message-ID: <20070711062021.GF4587@kernel.dk>
References: <200707102300.l6AN0xM4026841@hera.kernel.org> <20070710184347.037b6b3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710184347.037b6b3e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10 2007, Andrew Morton wrote:
> On Tue, 10 Jul 2007 23:00:59 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > +static int shmem_readpage(struct file *file, struct page *page)
> > +{
> > +	struct inode *inode = page->mapping->host;
> > +	int error = shmem_getpage(inode, page->index, &page, SGP_CACHE, NULL);
> > +	unlock_page(page);
> > +	return error;
> > +}
> 
> Worried.  shmem_getpage() does
> 
> done:
> 	if (*pagep != filepage) {
> 		unlock_page(filepage);
> 		*pagep = filepage;
> 	}
> 	return 0;
> 
> so we end up unlocking an unlocked page?

It certainly looks like it - Hugh?

-- 
Jens Axboe

