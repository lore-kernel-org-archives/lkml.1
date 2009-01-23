Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZAWWcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZAWWcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbZAWWb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:31:57 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:36087 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757366AbZAWWb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:31:57 -0500
Date: Sat, 24 Jan 2009 09:31:50 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clarification of allowed context for crypto routines
Message-ID: <20090123223150.GA1264@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901232229.47885.arvidjaar@mail.ru>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov <arvidjaar@mail.ru> wrote:
>
> As I can understand, user context requirement is due to potential for 
> setkey to sleep (although it appears, that currently the only module 
> that can sleep is shash which is calling kmalloc with GFP_KERNEL). Is it 
> correct?

Yep.

> But where is the difference between hard and softirq contexts? I fail to 
> see any technical reason for this requirement.

The reasons are two-fold:

1) Crypto operations are so slow in general that if you did them
in hard IRQ context it would just be wrong;

2) The highmem primitives we use are currently softirq only.  We
could make them work for hardirq as well, but because of 1) we
didn't.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
