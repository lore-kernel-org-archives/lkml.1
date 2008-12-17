Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758155AbYLQF5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYLQF5I (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYLQF4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:56:53 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38463 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750817AbYLQF4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:56:53 -0500
Date: Wed, 17 Dec 2008 16:56:46 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] crypto: salsa20 use endian access helpers
Message-ID: <20081217055646.GC14432@gondor.apana.org.au>
References: <1228785996.4353.12.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228785996.4353.12.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 05:26:36PM -0800, Harvey Harrison wrote:
>
> @@ -98,40 +91,51 @@ static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
>  	for (i = 0; i < 16; ++i)
>  		x[i] += input[i];
>  	for (i = 0; i < 16; ++i)
> -		U32TO8_LITTLE(output + 4 * i,x[i]);
> +		store_le32((__le32 *)(output + 4 * i), x[i]);
>  }

We need to mark output (i.e., buf) as aligned in the caller.

Otherwise the patch looks good to me.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
