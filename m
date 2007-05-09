Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbXEIKDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbXEIKDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbXEIKDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:03:38 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1881 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754861AbXEIKDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:03:37 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jens.axboe@oracle.com (Jens Axboe)
Subject: Re: [PATCH 7/10] i386 sg: add support for chaining scatterlists
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Organization: Core
In-Reply-To: <11786975641488-git-send-email-jens.axboe@oracle.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Hlj17-0001CJ-00@gondolin.me.apana.org.au>
Date: Wed, 09 May 2007 20:03:29 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
> index d7e45a8..794b68c 100644
> --- a/include/asm-i386/scatterlist.h
> +++ b/include/asm-i386/scatterlist.h
> @@ -8,8 +8,11 @@ struct scatterlist {
>     unsigned int       offset;
>     dma_addr_t         dma_address;
>     unsigned int       length;
> +    struct scatterlist *next;
> };

BTW, the crypto layer's scatterlist already has a chaining mechanism
using the existing structure.  The only difference is that the chained
pointer is stored inside the 'struct page *' rather than a new pointer.
Its existence is flagged by a zero value in the length field.

Now I'm not super-religious about this but we should at least consider
whether forking out 4 bytes in every scatterlist member is worthwhile
investment when we can use 12 bytes at the end instead.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
