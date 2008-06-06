Return-Path: <linux-kernel-owner+w=401wt.eu-S1764540AbYFFHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764540AbYFFHyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbYFFHx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:53:58 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:37667 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755963AbYFFHx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:53:57 -0400
Date: Fri, 6 Jun 2008 17:53:47 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adrian-Ken =?iso-8859-1?Q?R=FCegsegger?= <rueegsegger@swiss-it.ch>
Cc: Martin Willi <martin@strongswan.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26rc5] xfrm: SHA-256/384/512 HMAC support for IPsec
Message-ID: <20080606075347.GA2184@gondor.apana.org.au>
References: <1212671211.6339.58.camel@martin> <4847F310.7020207@swiss-it.ch> <1212677101.6339.75.camel@martin> <4847FF29.20500@swiss-it.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4847FF29.20500@swiss-it.ch>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 04:58:49PM +0200, Adrian-Ken Rüegsegger wrote:
>
> I agree that 96bit truncation is obsolete and 128 bit should be used.
> However people might be using the current implementation and this patch
> could cause trouble for them. The question is if anybody really depends
> on the current behavior.

I think the way we're currently representing the truncation length
is not ideal.  We should move over to the way it's done for AEAD
algorithms, i.e., let user-space supply us with the truncation
length.  That way the problem lies with them :) More importantly,
this would allows us to support multiple truncation lengths.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
