Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab0CBLeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:34:16 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33952 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752163Ab0CBLeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:34:11 -0500
Date: Tue, 2 Mar 2010 19:34:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto, Speed testing support for ghash
Message-ID: <20100302113408.GA1824@gondor.apana.org.au>
References: <1267430804.1640.85.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267430804.1640.85.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 04:06:44PM +0800, Huang Ying wrote:
> Because ghash needs setkey, the setkey and keysize template support
> for test_hash_speed is added.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  crypto/tcrypt.c |  122 +++++++++++++++++++++++++++++++++++---------------------
>  crypto/tcrypt.h |    1 
>  2 files changed, 78 insertions(+), 45 deletions(-)
> 
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -395,12 +395,13 @@ out:
>  }
>  
>  static void test_hash_speed(const char *algo, unsigned int sec,
> -			    struct hash_speed *speed)
> +			    struct hash_speed *speed, u8 *keysize)

Can we possibly move keysize into struct hash_speed to reduce
the churn?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
