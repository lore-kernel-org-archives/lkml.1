Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZALVLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZALVLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZALVL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:11:29 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38573 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752088AbZALVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:11:28 -0500
Date: Tue, 13 Jan 2009 08:11:08 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090112211108.GA11134@gondor.apana.org.au>
References: <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124946.GA9677@ff.dom.local> <20090107125217.GA26235@gondor.apana.org.au> <20090112120257.GA5697@gondor.apana.org.au> <20090112124545.GA10893@ioremap.net> <20090112125607.GA6370@gondor.apana.org.au> <20090112125914.GA12142@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112125914.GA12142@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:59:14PM +0300, Evgeniy Polyakov wrote:
>
> That's the part I referred to as a network own allocator. We can have
> multiple kmem_caches though for the popular MTUs and round up the
> requested size otherwise.

No we can't use kmem_caches because we're relying on using the
page refereounce count to free the page.  It has to be naked
pages.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
