Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYAGMRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYAGMRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYAGMRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:17:31 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1404 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753998AbYAGMR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:17:29 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: htejun@gmail.com (Tejun Heo)
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Cc: rusty@rustcorp.com.au, James.Bottomley@hansenpartnership.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Organization: Core
In-Reply-To: <4781E6BB.2010900@gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.scsi
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JBqum-0006wC-00@gondolin.me.apana.org.au>
Date: Mon, 07 Jan 2008 23:17:12 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
>
> /me agrees.  As long as this can be made sane using one unified
> interface, I don't care whether it's sg_ring, table or dish.

Give us sg_annulus :)

On a more serious note, having played with SG chaining for a couple
of years in the crypto layer, I must say Rusty's proposal is a great
improvement for me.  The reason is that if the crypto layer gets an
SG list from its user, it is not at liberty to just modify it.  As
such chaining at the end is cumbersome with the current interface
because we have to duplicate the whole list in order to add just a
single block at the end.

While with sg_ring we could just put the original list along with the
new one in a new list.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
