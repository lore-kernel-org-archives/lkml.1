Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbZD2NTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbZD2NTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761133AbZD2NSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:18:21 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48811 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761124AbZD2NST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:18:19 -0400
Date: Wed, 29 Apr 2009 21:18:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: print self-test pass notices in fips mode
Message-ID: <20090429131817.GB17254@gondor.apana.org.au>
References: <200904282121.35300.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904282121.35300.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:21:35PM -0400, Jarod Wilson wrote:
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 39ffa69..d0cc85c 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2149,6 +2149,10 @@ notest:
>  test_done:
>  	if (fips_enabled && rc)
>  		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
> +	/* fips mode requires we print out self-test success notices */
> +	if (fips_enabled && !rc && strncmp(alg, "ctr(aes", 7))
> +		printk(KERN_INFO "alg: self-tests for %s (%s) passed\n",
> +		       driver, alg);

What is this strncmp crap for?
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
