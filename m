Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbYGQSpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbYGQSpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbYGQSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:45:04 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4660 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758239AbYGQSpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:45:03 -0400
Subject: Re: [PATCH] crypto: Cleaning some more minor nits in prng
From: Joe Perches <joe@perches.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       davem@davemloft.net, herbert@gondor.apana.org.au
In-Reply-To: <20080717183012.GF17892@hmsendeavour.rdu.redhat.com>
References: <20080717183012.GF17892@hmsendeavour.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 11:43:33 -0700
Message-Id: <1216320213.8292.105.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 14:30 -0400, Neil Horman wrote:
> diff --git a/crypto/prng.c b/crypto/prng.c
> index 9e2d277..0b1831e 100644
>  {
>  	int ret;
> @@ -313,6 +313,9 @@ int reset_prng_context(struct prng_context *ctx,
>  
>  	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
>  
> +	if (!key)
> +		klen = DEFAULT_PRNG_KSZ;
> +
>  	if (V)
>  		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
>  	else

Perhaps more readable as:

	if (key)
		prng_key = key;
	else {
		prng_key = DEFAULT_PRNG_KEY;		
		klen = DEFAULT_PRNG_KSZ;
	}


