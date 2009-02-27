Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZB0Au7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZB0Au7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZB0Aut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:50:49 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:52402 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753128AbZB0Aus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:50:48 -0500
Date: Fri, 27 Feb 2009 08:50:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Message-ID: <20090227005033.GA20046@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226232025.GE5811@n2100.arm.linux.org.uk>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
> I don't think you can use chained scatterlists unless the architecture
> supports it.  It's not a case that you have to flatten the chaining
> before passing it over to the arch - it seems you're not allowed to
> create a chained scatterlist in the first place:
> 
> static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
>                            struct scatterlist *sgl)
> {
> #ifndef ARCH_HAS_SG_CHAIN
>        BUG();
> #endif

The crypto layer does its own chaining.  However, this chaining
is not meant to be exposed to any external entities until generic
chaining has been ported everywhere.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
