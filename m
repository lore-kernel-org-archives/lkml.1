Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbXEIKdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbXEIKdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbXEIKdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:33:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62021 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615AbXEIKdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:33:35 -0400
Date: Wed, 9 May 2007 12:30:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] i386 sg: add support for chaining scatterlists
Message-ID: <20070509103007.GS4163@kernel.dk>
References: <11786975641488-git-send-email-jens.axboe@oracle.com> <E1Hlj17-0001CJ-00@gondolin.me.apana.org.au> <20070509031915.6e934f35.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509031915.6e934f35.akpm@linux-foundation.org>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09 2007, Andrew Morton wrote:
> On Wed, 09 May 2007 20:03:29 +1000 Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
> > > index d7e45a8..794b68c 100644
> > > --- a/include/asm-i386/scatterlist.h
> > > +++ b/include/asm-i386/scatterlist.h
> > > @@ -8,8 +8,11 @@ struct scatterlist {
> > >     unsigned int       offset;
> > >     dma_addr_t         dma_address;
> > >     unsigned int       length;
> > > +    struct scatterlist *next;
> > > };
> > 
> > BTW, the crypto layer's scatterlist already has a chaining mechanism
> > using the existing structure.  The only difference is that the chained
> > pointer is stored inside the 'struct page *' rather than a new pointer.
> 
> <greps-and-fails>
> 
> Which field in the page is it using?

crypto/scatterwalk.h:

static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist
*sg)
{
        return (++sg)->length ? sg : (void *)sg->page;
}

it's just using the page pointer, not a pointer in the page structure.

-- 
Jens Axboe

