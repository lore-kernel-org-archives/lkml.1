Return-Path: <linux-kernel-owner+w=401wt.eu-S1422916AbXDTGd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422916AbXDTGd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422941AbXDTGd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:33:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47792 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422916AbXDTGd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:33:58 -0400
Date: Fri, 20 Apr 2007 08:32:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-ID: <20070420063257.GB6525@kernel.dk>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419224225.GJ32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419224225.GJ32602149@melbourne.sgi.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20 2007, David Chinner wrote:
> > - Higher order pages in the block layer etc.
> 
> It's more drivers that we have to worry about, I think.  We don't need to
> modify bios to explicitly support compound pages. From bio.h:
> 
> /*
>  * was unsigned short, but we might as well be ready for > 64kB I/O pages
>  */
> struct bio_vec {
>         struct page     *bv_page;
>         unsigned int    bv_len;
>         unsigned int    bv_offset;
> };
> 
> So compound pages should be transparent to anything that doesn't
> look at the contents of bio_vecs....

That just means you don't have to modify the bio_vec, there's still some
work to be done. But it should not be too hard, it's mainly updating the
merging checks. And grep for where PAGE_SIZE or PAGE_CACHE_SIZE is used
in fs/bio.c include/linux/bio.h block/ll_rw_blk.c

> > The ramfs driver can be used to test higher order page cache functionality
> > (and may help troubleshoot the VM support until we get some real filesystem
> > and real devices supporting higher order pages).
> 
> I don't think it will take much to get XFS to work with a high order
> page cache and we can probably insulate the block layer initially with some
> kind of bio_add_compound_page() wrapper and some similar
> wrapper on the io completion side.

Eh no way, at least not if you want it merged. Lets not repeat the XFS
kiobuf IO disaster :-). If this is to be done and merged, it needs to be
integrated nicely with the current framework, not attached to the side.

-- 
Jens Axboe

