Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbXHVIOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbXHVIOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbXHVIMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:12:37 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3149 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758597AbXHVIMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:12:35 -0400
Date: Wed, 22 Aug 2007 16:12:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nick Bowler <nbowler@ellipticsemi.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [PATCH] AH4: Update IPv4 options handling to conform to RFC 4302.
Message-ID: <20070822081210.GA608@gondor.apana.org.au>
References: <20070821144433.GA5015@totient.ellipticsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821144433.GA5015@totient.ellipticsemi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 02:44:33PM +0000, Nick Bowler wrote:
> In testing our ESP/AH offload hardware, I discovered an issue with how AH
> handles mutable fields in IPv4.  RFC 4302 (AH) states the following on the
> subject:
> 
>         For IPv4, the entire option is viewed as a unit; so even
>         though the type and length fields within most options are immutable
>         in transit, if an option is classified as mutable, the entire option
>         is zeroed for ICV computation purposes.

Good catch! Very few people test IP options so this one slipped
through.  Fortunately by the same token we can change this
without anybody noticing.

This requirement isn't new with 4302, 2402 says exactly the
same thing.

Please resend your patch to davem@davemloft.net with a cc to
netdev@vger.kernel.org.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
