Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZANGyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZANGyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZANGyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:54:05 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:42245 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104AbZANGyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:54:04 -0500
Date: Wed, 14 Jan 2009 17:53:59 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Use cryptd(%s) as cryptd-ed algorithm name instead of %s
Message-ID: <20090114065359.GA16044@gondor.apana.org.au>
References: <1231915448.5937.145.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231915448.5937.145.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:44:08PM +0800, Huang Ying wrote:
> Because:
> 
> 1. if use %s, you can only request cryptd(<driver name>), not
>    cryptd(<alg name>), because generated new algorithm instance has
>    algorithm name: <alg name> and driver name cryptd(<driver name>).

This is intentional.  For the purposes we talked about we should
be requesting cryptd(<driver name>), as otherwise you may end up
with someone else's AES algorithm as the base.

> 2. Generated cryptd-ed algorithm will have the same algorithm name and
>    higher priority, but some user may not want to use cryptd-ed
>    version.

The priority shouldn't be an issue in our case since the AES-NI
algorithm should register itself as an ablkcipher with an even
higher priority.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
