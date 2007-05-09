Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXEIKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXEIKcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXEIKcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:32:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61774 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbXEIKcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:32:09 -0400
Date: Wed, 9 May 2007 12:28:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] i386 sg: add support for chaining scatterlists
Message-ID: <20070509102835.GQ4163@kernel.dk>
References: <11786975641488-git-send-email-jens.axboe@oracle.com> <E1Hlj17-0001CJ-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hlj17-0001CJ-00@gondolin.me.apana.org.au>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09 2007, Herbert Xu wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
> > index d7e45a8..794b68c 100644
> > --- a/include/asm-i386/scatterlist.h
> > +++ b/include/asm-i386/scatterlist.h
> > @@ -8,8 +8,11 @@ struct scatterlist {
> >     unsigned int       offset;
> >     dma_addr_t         dma_address;
> >     unsigned int       length;
> > +    struct scatterlist *next;
> > };
> 
> BTW, the crypto layer's scatterlist already has a chaining mechanism
> using the existing structure.  The only difference is that the chained
> pointer is stored inside the 'struct page *' rather than a new pointer.
> Its existence is flagged by a zero value in the length field.
> 
> Now I'm not super-religious about this but we should at least consider
> whether forking out 4 bytes in every scatterlist member is worthwhile
> investment when we can use 12 bytes at the end instead.

>From a memory consumption POV, it's definitely a win to reuse the ->page
member as a pointer to the next sgtable. I didn't do that originally to
avoid complications in allocating and setting up the sg table, but I may
very well reconsider that decision soonish.

We can easily change this without disturbing the upper layers, so it's
not a big deal to change now or later.

-- 
Jens Axboe

