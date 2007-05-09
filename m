Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbXEIKUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbXEIKUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbXEIKUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:20:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694AbXEIKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:20:36 -0400
Date: Wed, 9 May 2007 03:19:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: jens.axboe@oracle.com (Jens Axboe), linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] i386 sg: add support for chaining scatterlists
Message-Id: <20070509031915.6e934f35.akpm@linux-foundation.org>
In-Reply-To: <E1Hlj17-0001CJ-00@gondolin.me.apana.org.au>
References: <11786975641488-git-send-email-jens.axboe@oracle.com>
	<E1Hlj17-0001CJ-00@gondolin.me.apana.org.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 20:03:29 +1000 Herbert Xu <herbert@gondor.apana.org.au> wrote:

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

<greps-and-fails>

Which field in the page is it using?
