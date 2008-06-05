Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYFEOZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYFEOZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbYFEOZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:25:09 -0400
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:42083 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbYFEOZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:25:07 -0400
X-Greylist: delayed 1192 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 10:25:07 EDT
Message-ID: <4847F310.7020207@swiss-it.ch>
Date: Thu, 05 Jun 2008 16:07:12 +0200
From: =?UTF-8?B?QWRyaWFuLUtlbiBSw7xlZ3NlZ2dlcg==?= 
	<rueegsegger@swiss-it.ch>
Organization: secunet SwissIT AG
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Martin Willi <martin@strongswan.org>
CC: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26rc5] xfrm: SHA-256/384/512 HMAC support for IPsec
References: <1212671211.6339.58.camel@martin>
In-Reply-To: <1212671211.6339.58.camel@martin>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Willi wrote:
> RFC4868 defines the use of SHA256, SHA384 and SHA512 in HMAC using 128,
> 192 and 256 bits truncation. This patch replaces the outdated SHA256
> algorithm with 96 bits truncation by the 128 bit variant and adds the
> SHA384/512 algorithms.
> 
> ﻿Signed-off-by: Martin Willi <martin@strongswan.org>
> 
> ---
> Replacing the 96 bit truncation SHA256 algorithm might be problematic,
> but it is obsolete in IPsec and I don't see a way to register two
> different truncation lengths in XFRM.

You could register a new SADB algorithm id in pfkeyv2.h and add a new
entry to the aalg_list analogous to how GCM is doing that in the aead_list.

Adrian

> --- a/net/xfrm/xfrm_algo.c 2008-06-05 14:01:01.000000000 +0200
> +++ b/net/xfrm/xfrm_algo.c 2008-06-05 14:39:31.000000000 +0200
> @@ -187,7 +187,7 @@
>  
>  	.uinfo = {
>  		.auth = {
> -			.icv_truncbits = 96,
> +			.icv_truncbits = 128,
>  			.icv_fullbits = 256,
>  		}
>  	},
> @@ -200,6 +200,42 @@
>  	}
>  },
>  {
> +	.name = "hmac(sha384)",
> +	.compat = "sha384",
> +
> +	.uinfo = {
> +		.auth = {
> +			.icv_truncbits = 192,
> +			.icv_fullbits = 384,
> +		}
> +	},
> +
> +	.desc = {
> +		.sadb_alg_id = SADB_X_AALG_SHA2_384HMAC,
> +		.sadb_alg_ivlen = 0,
> +		.sadb_alg_minbits = 384,
> +		.sadb_alg_maxbits = 384
> +	}
> +},
> +{
> +	.name = "hmac(sha512)",
> +	.compat = "sha512",
> +
> +	.uinfo = {
> +		.auth = {
> +			.icv_truncbits = 256,
> +			.icv_fullbits = 512,
> +		}
> +	},
> +
> +	.desc = {
> +		.sadb_alg_id = SADB_X_AALG_SHA2_512HMAC,
> +		.sadb_alg_ivlen = 0,
> +		.sadb_alg_minbits = 512,
> +		.sadb_alg_maxbits = 512
> +	}
> +},
> +{
>  	.name = "hmac(rmd160)",
>  	.compat = "rmd160",
> 
