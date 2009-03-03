Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZCCDCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZCCDCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZCCDCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:02:35 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44496 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbZCCDCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:02:34 -0500
Date: Tue, 3 Mar 2009 11:02:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Message-ID: <20090303030219.GA26480@gondor.apana.org.au>
References: <20090226095552.GB5811@n2100.arm.linux.org.uk> <20090226121043.GA13749@gondor.apana.org.au> <20090226232025.GE5811@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226232025.GE5811@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 11:20:26PM +0000, Russell King - ARM Linux wrote:
>
> I don't think you can use chained scatterlists unless the architecture
> supports it.  It's not a case that you have to flatten the chaining
> before passing it over to the arch - it seems you're not allowed to
> create a chained scatterlist in the first place:
> 
> static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
>                             struct scatterlist *sgl)
> {
> #ifndef ARCH_HAS_SG_CHAIN
>         BUG();
> #endif

That's why we don't use sg_chain.  The chaining is completely
internal to the crypto API (or at least it's supposed to be).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
