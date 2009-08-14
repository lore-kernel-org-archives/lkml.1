Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZHNNuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZHNNuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbZHNNu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:50:27 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39191 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbZHNNuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:50:23 -0400
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090814130241.GA7068@gondor.apana.org.au>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
	 <20090805094506.GA12528@gondor.apana.org.au>
	 <1249524767.24238.318.camel@yhuang-dev.sh.intel.com>
	 <1250044020.5337.214.camel@yhuang-dev.sh.intel.com>
	 <20090813045300.GA19993@gondor.apana.org.au>
	 <20090813073910.GA21784@gondor.apana.org.au>
	 <20090813131253.GA27289@gondor.apana.org.au>
	 <20090814130241.GA7068@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Aug 2009 16:47:27 +0300
Message-Id: <1250257647.25202.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Aug 2009 13:49:20.0403 (UTC) FILETIME=[061BEE30:01CA1CE6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 23:02 +1000, Herbert Xu wrote:
> diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
> index 03fb5fa..f6f0833 100644
> --- a/crypto/ablkcipher.c
> +++ b/crypto/ablkcipher.c
> @@ -183,6 +183,12 @@ EXPORT_SYMBOL_GPL(crypto_givcipher_type);
>  
>  const char *crypto_default_geniv(const struct crypto_alg *alg)
>  {
> +	if (((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> +	     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
> +					 alg->cra_ablkcipher.ivsize) !=
> +	    alg->cra_blocksize)
> +		return "chainiv";

I guess you used this cryptic construct instead of something more
readable because this is about a crypto algorithms? ;-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

